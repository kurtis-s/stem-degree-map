create_files: engineer_counts.json us.json

engineer_counts.json: ACS_12_3YR_C15010_with_ann.csv ACS_12_3YR_DP05_with_ann.csv
	python data/datamerge.py --csvpath data/unzipped

ACS_12_3YR_C15010_with_ann.csv: data/ACS_12_3YR_C15010.zip
	mkdir -p data/unzipped
	unzip -o data/ACS_12_3YR_C15010.zip -d data/unzipped

ACS_12_3YR_DP05_with_ann.csv: data/ACS_12_3YR_DP05.zip
	mkdir -p data/unzipped
	unzip -o data/ACS_12_3YR_DP05.zip -d data/unzipped

us.json: us_geoJSON.json
	topojson -o us.json --properties name --id-property code_local -- shapes/generated/us_geoJSON.json

us_geoJSON.json: ne_110m_admin_1_states_provinces_shp.shp
	ogr2ogr -f GeoJSON shapes/generated/us_geoJSON.json shapes/generated/ne_110m_admin_1_states_provinces_shp.shp

ne_110m_admin_1_states_provinces_shp.shp: shapes/ne_110m_admin_1_states_provinces.zip
	mkdir -p shapes/generated
	unzip -o shapes/ne_110m_admin_1_states_provinces.zip -d shapes/generated
	touch shapes/generated/ne_110m_admin_1_states_provinces_shp.shp

clean:
	rm -rf shapes/generated
	rm -f us.json
	rm -rf data/unzipped
	rm -f engineer_counts.json
	rm -f engineer_counts.csv
