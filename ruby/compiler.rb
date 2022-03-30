module Sources
  class Compiler
    attr_reader :locations

    def initialize(files)
      @locations = {}
      @sources = []

      files.each do |file|
        @sources << Object.const_get("Sources::#{file[:format].capitalize}").new(file[:path], self)
      end
    end

    def process!
      @sources.each do |source|
        source.process!
      end

      calculate_yearly_summaries!
    end

    def inspect
    end

    def list
      stations = Set.new

      @sources.each do |source|
        stations.merge source.list
      end

      return stations
    end

private

    def calculate_yearly_summaries!
      @locations.each do |_id, location|
        location[:daily_data].each do |year, years|
          prior_year = location[:daily_data][year.to_i - 1] || {}
          current_year = location[:daily_data][year] || {}

          months = prior_year.select{|month, _months| (9..12).include? month}
          months.merge!(current_year.select{|month, _months| (1..8).include? month})

          total_snowfall = 0
          total_snow_water_equivalent = 0
          peak_snowdepth = 0
          minimum_temperatures = []
          maximum_temperatures = []
          average_temperatures = []

          months.each do |month, days|
            days.each do |day, daily_data|
              total_snowfall += daily_data[:snowfall]
              total_snow_water_equivalent += daily_data[:snow_water_equivalent]
              peak_snowdepth = [peak_snowdepth, daily_data[:snowdepth]].max
              minimum_temperatures << daily_data[:temperature_min] if winter_month?(month)
              maximum_temperatures << daily_data[:temperature_max] if winter_month?(month)
              average_temperatures << daily_data[:temperature_average] if winter_month?(month)
            end
          end

          location[:yearly_data][year.to_i - 1] = {
            total_snowfall: total_snowfall,
            total_snow_water_equivalent: total_snow_water_equivalent,
            peak_snowdepth: peak_snowdepth,
            average_minimum_temperature: (minimum_temperatures.length > 0 ? minimum_temperatures.sum / minimum_temperatures.length : nil),
            average_maximum_temperature: (maximum_temperatures.length > 0 ? maximum_temperatures.sum / maximum_temperatures.length : nil),
            average_average_temperature: (average_temperatures.length > 0 ? average_temperatures.sum / average_temperatures.length : nil),
          }
        end
      end
    end

    def winter_month?(month)
      return (month >= 12 || month <= 3)
    end
  end
end
