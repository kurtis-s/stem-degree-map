us.json: us_geoJSON.json
	topojson -o shapes/us.json --properties name --id-property code_local -- shapes/generated/us_geoJSON.json

us_geoJSON.json: ne_110m_admin_1_states_provinces_shp.shp
	ogr2ogr -f GeoJSON shapes/generated/us_geoJSON.json shapes/generated/ne_110m_admin_1_states_provinces_shp.shp

ne_110m_admin_1_states_provinces_shp.shp: shapes/ne_110m_admin_1_states_provinces.zip
	mkdir -p shapes/generated
	unzip shapes/ne_110m_admin_1_states_provinces.zip -d shapes/generated
	touch shapes/generated/ne_110m_admin_1_states_provinces_shp.shp

clean:
	rm -rf shapes/generated
	rm -f shapes/us.json
