.PHONY = all

all:
	ruby/snowpack_analysis.rb \
		--coop datasets/noaa_coop_1.csv \
		--coop datasets/noaa_coop_2.csv \
		--snotel datasets/snotel.csv \
		--nwac datasets/nwac_heather_meadows.csv \
		--nwac datasets/nwac_snoqualmie_pass.csv \
		--wrcc datasets/wrcc_longmire.csv \
		--wrcc datasets/wrcc_snoqualmie_pass.csv \
		> javascripts/charts_data.js
