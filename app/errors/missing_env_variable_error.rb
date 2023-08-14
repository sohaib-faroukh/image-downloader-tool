class MissingEnvVariableError < StandardError
  def initialize(env_variable_name)
    message = "Missing environment variable value for #{env_variable_name}"
    super(message)
  end
end
