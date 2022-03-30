class Sources::Snotel < Sources::Source
  def process!
    @csv.each do |row|
      add_datapoint(
        id: row['Station Id'].to_i,
        type: :snotel,
        name: row['Station Name'],
        elevation: row['Elevation (ft)'].to_i,
        latitude: row['Latitude'].to_f,
        longitude: row['Longitude'].to_f,
        date: Date.parse(row['Date']),
        temperature_min: row['Air Temperature Minimum (degF)'].to_i,
        temperature_max: row['Air Temperature Maximum (degF)'].to_i,
        snowdepth: row['Snow Depth (in) Start of Day Values'].to_f,
        snow_water_equivalent: row['Snow Water Equivalent (in) Start of Day Values'].to_f,
      )
    end
  end

  def list
    stations = Set.new

    @csv.each do |row|
      stations << {id: row['Station Id'], name: row['Station Name']}
    end

    return stations
  end

private

  def parse_csv(path)
    # Filter out the lengthy header comment
    lines = File.readlines(path).reject {|line| line.start_with? '#'}.join
    @csv = CSV.parse(lines, headers: true)
  end
end
