class HealthCheckController < ActionController::Base
  session(:off) if Rails::VERSION::STRING < '2.3'
  layout nil

  def index
    do_check('standard')
  end

  def check
    do_check(params[:checks])
  end

  private

  def do_check(checks)
    begin
      errors = process_checks(checks)
    rescue Exception => e
      errors = e.message
    end     
    if errors.blank?
      render :text => HealthCheck.success, :content_type => 'text/plain'
    else
      msg = "health_check failed: #{errors}"
      render :text => msg, :status => 500, :content_type => 'text/plain'
      # Log a single line as some uptime checkers only record that it failed, not the text returned
      silence_level, logger.level = logger.level, @old_logger_level
      logger.info msg
      logger.level = silence_level
    end
  end

  def process_checks(checks)
    errors = ''
    checks.split('_').each do |check|
      case check
      when 'and', 'site'
        # do nothing
      when "database"
        HealthCheck.get_database_version
      when "email"
        errors << HealthCheck.check_email
      when "migrations", "migration"
        database_version = HealthCheck.get_database_version
        migration_version = HealthCheck.get_migration_version
        if database_version.to_i != migration_version.to_i
          errors << "Current database version (#{database_version}) does not match latest migration (#{migration_version}). "
        end
      when "standard"
        errors << process_checks("database_migrations")
        errors << process_checks("email") unless HealthCheck.default_action_mailer_configuration?
      when "all", "full"
        errors << process_checks("database_migrations_email")
      else
        return "invalid argument to health_test. "
      end
    end
    return errors
  end


  def process_with_silence(*args)
    @old_logger_level = logger.level
    logger.silence do
      process_without_silence(*args)
    end
  end

  alias_method_chain :process, :silence
end
