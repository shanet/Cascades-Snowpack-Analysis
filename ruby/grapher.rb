class Grapher
  GRAPHS = [
    {
      key: :snowdepth,
      cadence: :yearly,
      metric: :peak_snowdepth,
      description: 'Yearly peak snowdepth',
      units: 'Snowdepth (in)',
    },
    {
      key: :snowfall,
      cadence: :yearly,
      metric: :total_snowfall,
      description: 'Yearly snowfall',
      units: 'Snowfall (in)',
    },
    {
      key: 'average-average-temperature',
      cadence: :yearly,
      metric: :average_average_temperature,
      description: 'Average average temperature (December - March)',
      units: 'Temperature (F)',
    },
    {
      key: :snowdepth,
      cadence: :daily,
      metric: :snowdepth,
      description: 'Snowdepth by day',
      units: 'Snowdepth (in)',
    },
    {
      key: 'average-temperature',
      cadence: :daily,
      metric: :temperature_average,
      description: 'Average temperature by day',
      units: 'Snowdepth (in)',
    },
  ]

  def initialize(locations)
    @locations = locations
  end

  def generate_graph_data
    graph_datasets = {}

    @locations.each do |location_id, location|
      stations = {}

      location[:stations].each do |station_id, station|
        stations[station_id] = {
          name: station[:name],
          type: station[:type].to_s.upcase,
          elevation: "#{station[:elevation].to_i}ft",
          latitude: station[:latitude],
          longitude: station[:longitude],
          period_start: station[:period_start].strftime('%Y-%m-%d'),
          period_end: station[:period_end].strftime('%Y-%m-%d'),
        }
      end

      GRAPHS.each do |graph|
        labels, values = send("generate_#{graph[:cadence]}_graph_data", location, graph[:metric])

        graph_datasets["#{location_id}-#{graph[:key]}-#{graph[:cadence]}"] = {
          title: location_id.capitalize,
          description: graph[:description],
          labels: labels,
          values: values,
          stations: stations,
          units: graph[:units],
        }
      end
    end

    return graph_datasets
  end

private

  def generate_yearly_graph_data(location, metric)
    labels = []
    values = []

    start_year = location[:yearly_data].keys.min
    end_year = location[:yearly_data].keys.max

    (start_year..end_year).each do |year|
      labels << "#{year} - #{year + 1}"

      if location[:yearly_data][year]&.[](metric)
        values << (location[:yearly_data][year][metric] < 1 ? nil : location[:yearly_data][year][metric].round(1))
      else
        values << nil
      end
    end

    return labels, values
  end

  def generate_daily_graph_data(location, metric)
    labels = Set.new
    values = []

    location[:daily_data].each do |year, months|
      # Start the snow year on August 1st (the year doesn't matter here so just use the epoch)
      start_date = Date.parse('1970-09-01')

      values << {
        title: year,
        values: [],
      }

      365.times do |i|
        date = start_date + i
        labels << "#{date.month}/#{date.day}"
        daily_data = months[date.month]&.[](date.day)

        if daily_data
          values.last[:values] << (daily_data[metric] < 1 ? nil : daily_data[metric])
        else
          values.last[:values] << nil
        end
      end
    end

    return labels.to_a, values
  end
end
