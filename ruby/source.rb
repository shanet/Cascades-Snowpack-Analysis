module Sources
  class Source
    LOCATIONS = {
      paradise: ['USC00456898'].to_set,
      longmire: ['454764'].to_set,
      stehekin: ['USC00458059'].to_set,
      ohanapecosh: ['USC00456896'].to_set,
      mazama: ['USC00455133', 'USC00455128'].to_set,
      baker: ['USC00455663', 'hm1'].to_set,
      stevens: [791, 'USC00458089'].to_set,
      holden: ['USC00453728', 'USC00453730'].to_set,
      snoqualmie: ['457781', 'sno1'].to_set,
    }

    def initialize(path, compiler)
      @compiler = compiler
      @invalid_locations = Set.new

      parse_csv(path)
    end

    def add_datapoint(**kwargs)
      # Skip locations we've already determined to be invalid (avoids printing out a warning for each datapoint)
      return if @invalid_locations.include?(kwargs[:id])

      location_id = find_location_for_station(kwargs[:id])

      unless location_id
        @invalid_locations << kwargs[:id]
        return
      end

      @compiler.locations[location_id] ||= {
        id: location_id,
        stations: {},
        yearly_data: {},
        daily_data: {},
      }

      station_metadata = @compiler.locations[location_id][:stations][kwargs[:id]] ||= {
        type: kwargs[:type],
        name: kwargs[:name],
        elevation: kwargs[:elevation],
        latitude: kwargs[:latitude],
        longitude: kwargs[:longitude],
        period_start: Date.today,
        period_end: Date.parse('0000-01-01'),
      }

      station_metadata[:period_start] = [station_metadata[:period_start], kwargs[:date]].min
      station_metadata[:period_end] = [station_metadata[:period_end], kwargs[:date]].max

      station = @compiler.locations[location_id]
      station[:daily_data] ||= {}
      station[:daily_data][kwargs[:date].year] ||= {}
      station[:daily_data][kwargs[:date].year][kwargs[:date].month] ||= {}
      station[:daily_data][kwargs[:date].year][kwargs[:date].month][kwargs[:date].day] = {
        station_id: kwargs[:id],
        temperature_min: kwargs[:temperature_min] || 0,
        temperature_max: kwargs[:temperature_max] || 0,
        temperature_average: kwargs[:temperature_average] || 0,
        snowfall: kwargs[:snowfall] || 0,
        snowdepth: kwargs[:snowdepth] || 0,
        snow_water_equivalent: kwargs[:snow_water_equivalent] || 0,
      }
    end

    def find_location_for_station(station_id)
      LOCATIONS.each do |location_id, station_ids|
        return location_id if station_ids.include?(station_id)
      end

      STDERR.puts "Warning: Unknown station ID: #{station_id}"
      return nil
    end

  private

    def parse_csv(path)
      @csv = CSV.parse(File.read(path), headers: true)
    end
  end
end
