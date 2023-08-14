require 'logger'

class LoggerUtil
  LOGS_PREFIX = ENV.fetch('LOGS_PREFIX', '').freeze
  LOG_MESSAGES_DELIMITER = '|'.freeze
  attr_reader :_logger

  def self.logger()
    _logger = Logger.new($stdout) if _logger.nil?
  end

  def self.info(*args)
    message = prepare_message(*args)
    logger.info(message)
  end

  def self.error(*args)
    message = prepare_message(*args)
    logger.error(message)
  end

  def self.warn(*args)
    message = prepare_message(*args)
    logger.warn(message)
  end

  def self.prepare_message(*args)
    args.unshift(LOGS_PREFIX)

    args&.map { |item| item }&.join(" #{LOG_MESSAGES_DELIMITER} ") || ''
  end
end
