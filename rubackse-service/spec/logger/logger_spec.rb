require_relative '../../lib/logger/logger'

describe Logger do

  def capture(&block)
    begin
      $stdout = StringIO.new
      $stderr = StringIO.new
      yield
      result = {}
      result[:stdout] = $stdout.string
      result[:stderr] = $stderr.string
    ensure
      $stdout = STDOUT
      $stderr = STDERR
    end
    result
  end

  describe "Logger instance" do

    it "should create an INFO logger" do
      logger = Logger.new
      expect(logger.level).to eq(1)
    end

    it "should create a DEBUG logger" do
      logger = Logger.new(level: Logger::DEBUG)
      expect(logger.level).to eq(0)
    end

  end

  describe "Logger print message" do

    it "should print only INFO messages" do
      log = Logger.new
      result = capture{
        log.debug("message 0")
        log.info("message 1")
      }
      expect(result[:stdout]).not_to include("message 0")
      expect(result[:stdout]).to include("message 1")
    end

    it "should print all messages" do
      log = Logger.new(level: Logger::DEBUG)
      result = capture{
        log.debug("message 0")
        log.info("message 1")
        log.warn("message 2")
        log.error("message 3")
      }
      expect(result[:stdout]).to include("message 0")
      expect(result[:stdout]).to include("message 1")
      expect(result[:stdout]).to include("message 2")
      expect(result[:stdout]).to include("message 3")
    end

  end

end
