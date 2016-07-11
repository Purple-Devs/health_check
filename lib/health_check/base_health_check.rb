module BaseHealthCheck
  def create_error(check_type, error_message)
    "[#{check_type} - #{error_message}] "
  end
end
