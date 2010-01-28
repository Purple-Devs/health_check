class HealthCheck

  @@success = "success"

  cattr_accessor :success

  @@smtp_timeout = 30.0

  cattr_accessor :smtp_timeout

  @@default_smtp_settings =
    {
    :address              => "localhost",
    :port                 => 25,
    :domain               => 'localhost.localdomain',
    :user_name            => nil,
    :password             => nil,
    :authentication       => nil,
    :enable_starttls_auto => true,
  }

  cattr_accessor :default_smtp_settings

  def self.db_migrate_path
    # Lazy initialisation so RAILS_ROOT will be defined
    @@db_migrate_path ||= File.join(RAILS_ROOT, 'db', 'migrate')
  end

  def self.db_migrate_path=(value)
    @@db_migrate_path = value
  end

  def self.default_action_mailer_configuration?
    ActionMailer::Base.delivery_method == :smtp && HealthCheck.default_smtp_settings == ActionMailer::Base.smtp_settings
  end

  def self.get_database_version
    ActiveRecord::Migrator.current_version
  end

  def self.get_migration_version(dir = self.db_migrate_path)
    latest_migration = nil
    Dir[File.join(dir, "[0-9]*_*.rb")].each do |f|
      l = f.scan(/0*([0-9]+)_[_a-zA-Z0-9]*.rb/).first.first
      latest_migration = l if !latest_migration || l.to_i > latest_migration.to_i
    end
    latest_migration
  end

  def self.check_email
    case ActionMailer::Base.delivery_method
    when :smtp
      HealthCheck.check_smtp(ActionMailer::Base.smtp_settings, HealthCheck.smtp_timeout)
    when :sendmail
      HealthCheck.check_sendmail(ActionMailer::Base.sendmail_settings)
    else
      ''
    end
  end


  def self.check_sendmail(settings)
    File.executable?(settings[:location]) ? '' : 'no sendmail executable found. '
  end

  def self.check_smtp(settings, timeout)
    status = ''
    begin
      if @skip_external_checks
        status = '221'
      else
        Timeout::timeout(timeout) do |timeout_length|
          t = TCPSocket.new(settings[:address], settings[:port])
          begin
            status = t.gets
            while status != nil && status !~ /^2/
              status = t.gets
            end
            t.puts "HELO #{settings[:domain]}"
            while status != nil && status !~ /^250/
              status = t.gets
            end
            t.puts "QUIT"
            status = t.gets
          ensure
            t.close
          end
        end
      end
    rescue  Errno::EBADF => ex
      status = "Unable to connect to service"
    rescue Exception => ex
      status = ex.to_s
    end
    (status =~ /^221/) ? '' : "SMTP: #{status || 'unexpected EOF on socket'}. "
  end


end
