require_relative 'severity'

class Logger

  include Severity

  attr_reader :level
  LOG_LEVEL = %w(DEBUG INFO WARNING ERROR)

  def initialize(level: INFO, source_name: nil)
    @level = level
    @source_name = source_name
  end

  def log(severity, message)
    if severity >= @level
      puts format_message(severity, message)
    end
  end

  def debug(message)
    log(DEBUG, message)
  end

  def info(message)
    log(INFO, message)
  end

  def warn(message)
    log(WARN, message)
  end

  def error(message)
    log(ERROR, message)
  end

  def format_message(severity, message)
    time = Time.now
    timestamp = time.strftime("[%d/%m/%Y %H:%M:%S.#{time.usec/1000}]")
    source = @source_name ? "#{@source_name}: ": ""
    "#{timestamp} #{format_log_level(severity)} -- #{source}#{message}"
  end

  def format_log_level(severity)
    LOG_LEVEL[severity]
  end

end

# log = Logger.new(level: Logger::DEBUG)
#
# log.debug("Hello world")
# log.info("THIS is INFO")
# log.warn("THIS is WARN")
# log.error("THIS is ERROR")
