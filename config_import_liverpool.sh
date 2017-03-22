#Arches load Liverpool Workshop Data script
#Rebuild db
#
# Note: run to set permissions:
#	sudo chmod 755 'config_import_liverpool.sh'
#
# For testing, just load HER Monuments data...
# NOTE: Loading the smaller version of the .csv file to improve performance on Liverpool computers...
#
# Uncomment next 2 lines to load Activity and Information Asset Data
python manage.py packages -o import_business_data -s '/users/dwuthrich/arches/her/business_data/HER Activities_master.csv' -c '/users/dwuthrich/arches/her/business_data/HER Activities.mapping' -ow overwrite -bulk
python manage.py packages -o import_business_data -s '/users/dwuthrich/arches/her/business_data/HER Information Assets.csv' -c '/users/dwuthrich/arches/her/business_data/HER Information Assets.mapping' -ow overwrite -bulk
python manage.py packages -o import_business_data -s '/users/dwuthrich/arches/her/business_data/HER Monuments Workshop.csv' -c '/users/dwuthrich/arches/her/business_data/HER Monuments.mapping' -ow overwrite -bulk
python manage.py packages -o import_business_data -s '/users/dwuthrich/arches/her/business_data/HER Actors_master.csv' -c '/users/dwuthrich/arches/her/business_data/HER Actors.mapping' -ow overwrite -bulk

#
# Don't load related resources by default
#python manage.py packages -o import_business_data_relations -s '/users/dwuthrich/arches/her/business_data/HER Monuments.relations'
