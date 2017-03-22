#Arches DB rebuild and config script
#Rebuild db
#
# Note: run to set permissions:
#	sudo chmod 755 'config_liverpool.sh'
#
#
#Rebuild db
echo "  "
echo "  "
echo "Setting up database..."
python manage.py packages -o setup_db
#
#
## Load Liverpool specific Arches defaut thesauri and collections
echo "  "
echo "  "
echo "Loading Arches concepts for Liverpool..."
python manage.py packages -o import_reference_data -s '../her/reference_data/arches_liverpool_concepts.xml' -ow overwrite -st keep
#
#
#
echo "  "
echo "  "
echo "Loading HER Liverpool concepts..."
python manage.py packages -o import_reference_data -s '../her/reference_data/Lincoln_Additional_Schemes.xml' -ow overwrite -st keep
python manage.py packages -o import_reference_data -s '../her/reference_data/Lincoln_dm_Type.xml' -ow overwrite -st keep
python manage.py packages -o import_reference_data -s '../her/reference_data/Lincoln_HER_Designation_Type.xml' -ow overwrite -st keep
python manage.py packages -o import_reference_data -s '../her/reference_data/Lincoln_HER_Period_Type.xml' -ow overwrite -st keep
python manage.py packages -o import_reference_data -s '../her/reference_data/Lincoln_Monument_Types_v4.xml' -ow overwrite -st keep
python manage.py packages -o import_reference_data -s '../her/reference_data/Lincoln_Recording_Event_Type.xml' -ow overwrite -st keep
python manage.py packages -o import_reference_data -s '../her/reference_data/Lincoln_Source_Type.xml' -ow overwrite -st keep
#
#
#
echo "  "
echo "  "
echo "Loading Arches dropdowns for Liverpool..."
python manage.py packages -o import_reference_data -s '../her/reference_data/arches_liverpool_collections.xml' -ow overwrite -st keep
#
#
#
#
# Load Resource Models, Branches
##echo "  "
##echo "  "
##echo "Loading Arches resource models..."
##python manage.py packages -o import_graphs -s 'arches/db/graphs/resource_models'
#
#
#
echo "  "
echo "  "
echo "Loading Arches branches..."
python manage.py packages -o import_graphs -s 'arches/db/graphs/branches'
#
#
#
echo "  "
echo "  "
echo "Loading Lincoln resource and branches..."
python manage.py packages -o import_graphs -s '../her/graphs/branches/'
python manage.py packages -o import_graphs -s '../her/graphs/resource_models/'
#
#
#
# Load Overlays
echo "  "
echo "  "
echo "Overlays loaded..."
python manage.py packages -o add_mapbox_layer -j /Users/dwuthrich/Downloads/mapbox_styles/Emerald/style.json -n "Emerald" -b
python manage.py packages -o add_mapbox_layer -j /Users/dwuthrich/Downloads/mapbox_styles/Outdoors/style.json -n "Outdoors" -b
python manage.py packages -o add_mapbox_layer -j /Users/dwuthrich/Downloads/mapbox_styles/Light/style.json -n "Light Streets" -b
python manage.py packages -o add_mapbox_layer -j /Users/dwuthrich/Downloads/mapbox_styles/Dark/style.json -n "Dark Streets" -b
python manage.py packages -o add_mapbox_layer -j /Users/dwuthrich/Downloads/mapbox_styles/Satellite-Streets/style.json -n Satellite_Streets -b
python manage.py packages -o add_tileserver_layer -m arches/tileserver/town_plan_3857.xml -n "Lincoln 1886-1998"
python manage.py packages -o add_tileserver_layer -m arches/tileserver/hillshade.xml -n "Hillshade"
#
#
echo "  "
echo "  "
echo "Finished configuring Arches..."
#
#
echo "  "
echo "  "
echo "Starting Arches..."
python manage.py runserver


