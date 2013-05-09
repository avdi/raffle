#!/usr/bin/env ruby
require 'optparse'
require 'yaml/store'

picker = ->(entrants) { entrants.sample }
OptionParser.new do |opts|
  opts.on('--force i,j,k', Array, 'Force indexes of picks (for testing)') do
    |value|
    picker = ->(entrants) { entrants[value.shift.to_i] }
  end
  opts.on('--winners', 'Print list of winners') do
    entrants_file = ARGV[0]
    store = YAML::Store.new("#{entrants_file}.raffle")
    store.transaction do
      store['winners'] ||= {}
      store['winners'].each do |name, prize|
        puts "#{name}: #{prize}"
      end
    end
    exit
  end
end.parse!

entrants_file = ARGV[0]
prize         = ARGV[1]
store = YAML::Store.new("#{entrants_file}.raffle")
store.transaction do
  store['winners'] ||= {}
  entrants = File.readlines(entrants_file).map(&:chomp)
  store['winners'].keys.each do |winner|
    entrants.delete(winner)
  end
  winner = picker.call(entrants)
  store['winners'][winner] = prize
  puts winner
end
