require 'rspec'
require 'open3'

describe 'lottery app' do
  before do
    FileUtils.rm_f Dir.glob('spec/*.raffle')
  end

  specify 'choosing a single winner' do
    run "raffle spec/5names 'POODR'"
    expect(output_lines).to have(1).line
    expect(names_from('spec/5names')).to include(output_lines[0])
  end

  specify 'randomness' do
    winners = []
    100.times do
      run "raffle spec/5names 'POODR'"
      winners << output_lines.first
      FileUtils.rm_f Dir.glob('spec/*.raffle')
    end

    edwina_count = winners.count('Edwina Gusikowski')
    expect(edwina_count / 100.0).to be_within(0.1).of(0.2)
  end

  specify 'remembering winners' do
    run "raffle spec/5names 'POODR' --force '0,1,2,3,4'"
  end

  def run(command)
    bin_path = "#{ENV['PATH']}:#{bin_dir}"
    @command_output, @command_status =
        Open3.capture2({'PATH' => bin_path}, command)
  end

  def output_lines
    @command_output.split("\n")
  end

  def bin_dir
    File.expand_path('../../bin', __FILE__)
  end

  def names_from(filename)
    File.readlines(filename).map(&:chomp)
  end
end