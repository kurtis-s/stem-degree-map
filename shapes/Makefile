us.json: us_geoJSON.json
	topojson -o us.json --properties name --id-property code_local -- us_geoJSON.json

us_geoJSON.json: ne_110m_admin_1_states_provinces_shp.shp
	ogr2ogr -f GeoJSON us_geoJSON.json ne_110m_admin_1_states_provinces_shp.shp

ne_110m_admin_1_states_provinces_shp.shp: ne_110m_admin_1_states_provinces.zip
	unzip ne_110m_admin_1_states_provinces.zip
	touch ne_110m_admin_1_states_provinces_shp.shp
