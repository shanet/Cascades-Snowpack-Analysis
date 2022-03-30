class Sources::Coop < Sources::Source
  def process!
    @csv.each do |row|
      add_datapoint(
        id: row['STATION'],
        type: :coop,
        name: row['NAME'].split(',').first.split(' ').map {|word| word.capitalize}.join(' '),
        elevation: row['ELEVATION'].to_f * 3.28, # Meters -> feet conversion
        latitude: row['LATITUDE'],
        longitude: row['LONGITUDE'],
        date: Date.parse(row['DATE']),
        temperature_min: row['TMIN'].to_i,
        temperature_max: row['TMAX'].to_i,
        temperature_average: (row['TMIN'].to_i + row['TMAX'].to_i) / 2,
        snowfall: row['SNOW'].to_f,
        snowdepth: row['SNWD'].to_f,
      )
    end
  end

  def list
    stations = Set.new

    @csv.each do |row|
      stations << {id: row['STATION'], name: row['NAME']}
    end

    return stations
  end
end
