require_relative '../../lib/task/command_runner'

describe CommandRunner do

  def run_command(cmd)
    [IO.popen(cmd).gets]
  end

  describe "CommandRunner execution" do
    it 'should execute the command' do
      options = {
        commands: ['whoami'],
      }
      runner = CommandRunner.new(options: options)
      response = runner.run

      expect(response.has_key?(:commands)).to eq(true)
      expect(run_command("whoami")).to eq(response[:commands])
    end

    it 'should execute the before command' do
      options = {
        commands: ['whoami'],
        before: ['echo "hello"']
      }
      runner = CommandRunner.new(options: options)
      response = runner.run

      expect(response.has_key?(:commands)).to eq(true)
      expect(response.has_key?(:before)).to eq(true)
      expect(run_command("whoami")).to eq(response[:commands])
      expect(run_command("echo 'hello'")).to eq(response[:before])
    end

    it 'should execute the after command' do
      options = {
        commands: ['whoami'],
        after: ['echo "hello"']
      }
      runner = CommandRunner.new(options: options)
      response = runner.run

      expect(response.has_key?(:commands)).to eq(true)
      expect(response.has_key?(:after)).to eq(true)
      expect(run_command("whoami")).to eq(response[:commands])
      expect(run_command("echo 'hello'")).to eq(response[:after])
    end

    it 'should execute the before & after command' do
      options = {
        commands: ['whoami'],
        before: ['echo "before"'],
        after: ['echo "after"']
      }
      runner = CommandRunner.new(options: options)
      response = runner.run

      expect(response.has_key?(:commands)).to eq(true)
      expect(response.has_key?(:before)).to eq(true)
      expect(response.has_key?(:after)).to eq(true)
      expect(run_command("whoami")).to eq(response[:commands])
      expect(run_command("echo 'before'")).to eq(response[:before])
      expect(run_command("echo 'after'")).to eq(response[:after])
    end

    it 'should execute multiple commands' do
      options = {
        commands: ['whoami', 'echo "hello"'],
      }
      runner = CommandRunner.new(options: options)
      response = runner.run

      expect(response.has_key?(:commands)).to eq(true)
      expect(response[:commands].length).to eq(options[:commands].length)
    end

    it 'should raise an error, when the command fails' do
      options = {
        commands: ['whoamii'],
      }
      runner = CommandRunner.new(options: options)

      expect { runner.run }.to raise_error(Errno::ENOENT)
    end
  end

end