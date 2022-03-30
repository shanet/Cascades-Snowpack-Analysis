class Sources::Wrcc < Sources::Source
  def process!
    @csv.each do |row|
      add_datapoint(
        id: row['COOP'],
        type: :wrcc,
        name: row['Name'],
        elevation: row['Elevation'].to_i,
        latitude: row['Latitude'].to_f,
        longitude: row['Longitude'].to_f,
        date: Date.parse(row['ObsDate']),
        temperature_min: row['MnTmp'].to_i,
        temperature_max: row['MxTmp'].to_i,
        temperature_average: row['AvTmp'].to_i,
        snowfall: row['Snwfl'].to_f,
        snowdepth: row['Snwdp'].to_f,
      )
    end
  end

  def list
    stations = Set.new

    @csv.each do |row|
      stations << {id: row['COOP'], name: row['Name']}
    end

    return stations
  end
end
