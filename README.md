Cascades Snowpack Analysis
==========================

This repo contains the source data and association graph generation code for the blog post located at: TODO.

It serves to pull together historical data from the early 1900's to 2020's to analyze how the snowpack across the Cascades has changed over time at a range of elevations.

The following metrics are considered:

* Snowdepth
* Snowfall
* Average temperature

A variety of weather stations were considered:

* High elevation: ~5,000ft
* Low elevation: ~2,500ft
* Major ski areas
  * Mt. Baker Ski Area
  * Stevens Pass
  * Snoqualmie Pass

## Instructions

0. Simply open `index.html` in a web browser to view graphs over of the above metrics over time.

To generate a new JavaScript source for the graphs from the provided CSV files simply run `make`.

## Data Sources

This repo includes data from the following locations:

* NOAA COOP (Cooperative Observer Network). Specifically the following stations:
  * https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USC00456898/detail
  * https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USC00456894/detail
  * https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USC00456896/detail
  * https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USC00453728/detail
  * https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USC00453730/detail
  * https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USC00455128/detail
  * https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USC00455133/detail
  * https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USC00455663/detail
  * https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USC00458059/detail
  * https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USC00458089/detail
* USDA Snotel
  * https://www.nrcs.usda.gov/wps/portal/wcc/home/quicklinks/imap
* WRCC
  * https://wrcc.dri.edu/cgi-bin/cliMAIN.pl?wa6894
  * https://wrcc.dri.edu/cgi-bin/cliMAIN.pl?wa7781
* NWAC
  * https://nwac.us/data-portal/location/mt-baker-ski-area/
  * https://nwac.us/data-portal/location/snoqualmie-pass/

## License

Does not apply to the included third-party libraries.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
