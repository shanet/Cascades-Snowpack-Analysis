class Sources::Nwac < Sources::Source
  def process!
    @csv.each do |row|
      add_datapoint(
        id: row['Station Id'],
        type: :nwac,
        name: row['Station Name'],
        elevation: row['Elevation'].to_i,
        latitude: row['Latitude'].to_f,
        longitude: row['Longitude'].to_f,
        date: Date.parse(row['Date/Time (PST)']),
        # There is only one current temperature value here so use it for both min & max
        temperature_min: row['Temperature (deg F)'].to_i,
        temperature_max: row['Temperature (deg F)'].to_i,
        snowfall: row['24 Hour Snow'].to_f,
        snowdepth: row['Total Snow Depth'].to_f,
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
end
