require 'rspec'
require 'open3'

describe 'lottery app' do
  before do
    FileUtils.rm_f Dir.glob('spec/*.raffle')
  end

  specify 'choosing a single winner' do
    run "raffle spec/140names pick 'POODR'"
    expect(output_lines).to have(1).line
  end

  def run(command)
    bin_path = "#{ENV['PATH']}:#{bin_path}"
    @command_output, @command_status =
        Open3.capture2({'PATH' => bin_path}, command)
  end

  def output_lines
    @command_output.split("\n")
  end

  def bin_dir
    File.expand_path('../../bin', __FILE__)
  end
end