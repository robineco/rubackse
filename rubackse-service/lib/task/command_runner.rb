class CommandRunner

  def initialize(options:)
    if options.has_key?(:commands)
      @commands = options[:commands]
    end
    if options.has_key?(:before)
      @before = options[:before]
    end
    if options.has_key?(:after)
      @after = options[:after]
    end
  end

  def run
    response = Hash.new
    if @before
      response[:before] = Array.new
      @before.each { |c| response[:before] << execute(c) }
    end
    if @commands
      response[:commands] = Array.new
      @commands.each { |c| response[:commands] << execute(c) }
    end
    if @after
      response[:after] = Array.new
      @after.each { |c| response[:after] <<  execute(c) }
    end
    return response
  end

  def execute(command)
    begin
      response = IO.popen(command).gets
      return response
    rescue Errno::ENOENT => e
      raise e
    end
  end

end
