require_relative 'severity'

class Logger

  include Severity

  attr_reader :level
  LOG_LEVEL = %w(DEBUG INFO WARNING ERROR)

  def initialize(level: INFO, source_name: nil, filename: nil)
    @level = level
    @source_name = source_name
    @log_file = nil
    if filename
      @log_file = create_log_file(filename)
    end
  end

  def log(severity, message)
    if @log_file
      @log_file.write(format_message(severity, message))
    end
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
    "#{timestamp} #{format_log_level(severity)} -- #{source}#{message}\n"
  end

  def format_log_level(severity)
    LOG_LEVEL[severity]
  end

  def create_log_file(filename)
    @log_file = File.open(filename, "a+")
  end

  # Change log level & get current level
  def debug?; @level <= DEBUG; end

  def debug!; @level = DEBUG; end

  def info?; @level <= INFO; end

  def info!; @level = INFO; end

  def warn?; @level <= WARN; end

  def warn!; @level = WARN; end

  def error?; @level <= ERROR; end

  def error!; @level = ERROR; end

end

