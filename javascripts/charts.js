document.addEventListener('DOMContentLoaded', () => {
  let chartsData = JSON.parse(rawChartsData);

  generateYearlyGraphs(chartsData);
  generateDailyGraphs(chartsData);
});

function generateYearlyGraphs(chartsData) {
  let chartsYearly = document.querySelectorAll('.chart.yearly');

  for(let i=0; i<chartsYearly.length; i++) {
    const chartData = chartsData[chartsYearly[i].id];

    if(!chartData) {
      console.log(`${chartsYearly[i].id} not found in charts data`);
      continue;
    }

    const chartConfig = {
      type: 'bar',
      data: {
        labels: chartData['labels'],
        datasets: [{
          label: chartData['units'],
          data: chartData['values'],
          backgroundColor: 'rgb(2, 114, 183)',
          // borderColor: 'rgb(40, 177, 241)',
          // borderWidth: 1,
          trendlineLinear: {
            style: 'rgb(189, 66, 95)',
            lineStyle: 'dotted|solid',
            width: 4,
          }
        }],
      },
      options: chartOptions(`${chartData['title']} - ${chartData['description']}`, chartData['units']),
    };

    new Chart(chartsYearly[i].querySelector('canvas').getContext('2d'), chartConfig);
    populateStationsList(chartsYearly[i], chartData['stations']);
  }
}

function generateDailyGraphs(chartsData) {
  let chartsDaily = document.querySelectorAll('.chart.daily');

  for(let i=0; i<chartsDaily.length; i++) {
    const chartData = chartsData[chartsDaily[i].id];

    if(!chartData) {
      console.log(`${chartsDaily[i].id} not found in charts data`);
      continue;
    }

    const datasets = [];
    const yearsToDatasetIndex = {};
    const hues = generateHues(chartData['values'].length);

    for(let j=0; j<chartData['values'].length; j++) {
      // Keep track of which index a dataset is in so we can toggle its visibility in the controls later on
      yearsToDatasetIndex[chartData['values'][j]['title']] = j;

      datasets.push({
        label: chartData['values'][j]['title'],
        data: chartData['values'][j]['values'],
        borderColor: `hsl(${hues[j]}, 75%, 50%)`,
        pointRadius: 0,
      });
    }

    const chartConfig = {
      type: 'line',
      data: {
        labels: chartData['labels'],
        datasets: datasets,
      },
      options: chartOptions(`${chartData['title']} - ${chartData['description']}`, chartData['units']),
    };

    const chart = new Chart(chartsDaily[i].querySelector('canvas').getContext('2d'), chartConfig);

    initChartControls(chartsDaily[i], chart, yearsToDatasetIndex);
    populateStationsList(chartsDaily[i], chartData['stations']);
  }
}

function populateStationsList(chartContainer, stations) {
  let description = chartContainer.querySelector('.description');
  let stationsList = document.createElement('ul');

  for(stationId in stations) {
    let station = stations[stationId];
    let listItem = document.createElement('li');
    let stationList = document.createElement('ul');

    let location = document.createElement('li');
    let elevation = document.createElement('li');
    let periodOfRecord = document.createElement('li');
    let source = document.createElement('li');

    listItem.innerText = station['name'];
    elevation.innerText = `Elevation: ${station['elevation']}`;
    periodOfRecord.innerText = `Period of Record: ${station['period_start']} - ${station['period_end']}`;
    location.innerText = `Location (approx.): ${station['latitude']}, ${station['longitude']}`;
    source.innerText = `Data Source: ${station['type']}`;

    stationList.appendChild(elevation);
    stationList.appendChild(periodOfRecord);
    stationList.appendChild(location);
    stationList.appendChild(source);

    listItem.appendChild(stationList);
    stationsList.appendChild(listItem);
  }

  description.appendChild(stationsList);
}

function chartOptions(title, units) {
  let options = {
    animation: false,
    plugins: {
      title: {
        display: true,
        text: title,
      },
    },
    scales: {
      x: {
        title: {
          display: true,
          text: 'Date',
        },
      },
      y: {
        title: {
          display: true,
          text: units,
        },
      },
    },
  }

  // Show a freezing line if this is a temperature graph
  if(units.indexOf('Temperature') !== -1) {
    options['plugins']['annotation'] = {
      annotations: {
        freezing: {
          type: 'line',
          yMin: 32, // Degrees F
          yMax: 32, // Degrees F
          borderColor: '#1d4cb3',
          borderWidth: 2,
          borderDash: [10, 10],
        },
      },
    };
  }

  return options;
}

function initChartControls(chartContainer, chart, yearsToDatasetIndex) {
  const controls = chartContainer.querySelectorAll('.controls input[type="checkbox"]');

  for(let i=0; i<controls.length; i++) {
    controls[i].addEventListener('change', (event) => {
      const datasets = event.target.dataset.datasets.split(',');

      // Find the index of each dataset this control toggles and change its visibility
      for(let j=0; j<datasets.length; j++) {
        const datasetIndex = yearsToDatasetIndex[datasets[j]];
        if(datasetIndex === undefined) continue;
        chart.setDatasetVisibility(datasetIndex, event.target.checked);
      }

      chart.update();
    });
  }
}

function generateHues(numBuckets) {
  const maxHue = 270;
  const hues = [];

  for(let hue=0; hue<maxHue; hue+=(maxHue/numBuckets)) {
    hues.push(hue);
  }

  return hues;
}
