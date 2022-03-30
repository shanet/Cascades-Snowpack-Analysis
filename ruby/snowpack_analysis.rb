#!/usr/bin/env ruby

require 'byebug'
require 'csv'
require 'json'
require 'optparse'
require 'set'

require_relative 'source'
require_relative 'compiler'
require_relative 'coop'
require_relative 'grapher'
require_relative 'nwac'
require_relative 'snotel'
require_relative 'wrcc'

def main
  options = parse_options

  case options[:mode]
    when :process, :inspect
      process_csv_files(options)
    when :list
      list_stations(options)
  end
end

def list_stations(options)
  sources = Sources::Compiler.new(options[:files])

  sources.list.each do |station|
    puts "#{station[:id]}: #{station[:name]}"
  end
end

def process_csv_files(options)
  sources = Sources::Compiler.new(options[:files])
  sources.process!

  graph_data = Grapher.new(sources.locations).generate_graph_data

  if options[:mode] == :inspect
    puts 'Starting debugger for data inspection. Run `sources.locations.keys` to see available location data.'
    byebug
  else
    puts "const rawChartsData = '#{graph_data.to_json}';"
  end
end

def parse_options
  options = {
    files: [],
    mode: :process,
  }

  option_parser = OptionParser.new do |parser|
    parser.banner = 'Usage: __FILE__ [options]'

    parser.on('-c', '--coop FILE', 'Parse a NOAA Cooperative Observer Network (COOP) CSV file') do |file|
      options[:files] << {path: file, format: :coop}
    end

    parser.on('-s', '--snotel FILE', 'Parse a USDA SNOTEL CSV file') do |file|
      options[:files] << {path: file, format: :snotel}
    end

    parser.on('-n', '--nwac FILE', 'Parse an NWAC CSV file') do |file|
      options[:files] << {path: file, format: :nwac}
    end

    parser.on('-w', '--wrcc FILE', 'Parse a WRCC CSV file') do |file|
      options[:files] << {path: file, format: :wrcc}
    end

    parser.on('-l', '--list', 'List stations in CSV files and exit') do
      options[:mode] = :list
    end

    parser.on('-i', '--inspect', 'Start a debugger to allow for inspection of parsed data') do
      options[:mode] = :inspect
    end

    parser.on('-h', '--help', 'Print this message') do
      puts parser
      exit
    end
  end

  option_parser.parse(ARGV)

  return options
end

main
