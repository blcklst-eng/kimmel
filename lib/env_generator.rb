class ConfigGenerator
  def initialize(application:, database:)
    @application = application
    @database = database
  end

  def call
    if env_file_exists?
      Rails.logger.info "Old .env found. Moving to .env.old... "
      move_current_env
    end
    parse_env_example
    write_env_file
  end

  def parse_env_example
    contents = `cat #{APP_ROOT}/.env.example`
    template = ERB.new(contents)
    @output = template.result(binding)
  end

  def env_file_exists?
    File.file? "#{APP_ROOT}/.env"
  end

  def write_env_file
    File.open("#{APP_ROOT}/.env", "w+") { |f| f.write(output) }
  end

  def move_current_env
    if File.file? "#{APP_ROOT}/.env"
      `mv #{APP_ROOT}/.env #{APP_ROOT}/.env.old`
      true
    else
      false
    end
  end

  private

  attr_reader :output, :application, :database
end
