@title Load HER Data
@echo off

rem INTERACTIVE VARIABLE SETTING
rem set /p var=hello there! 
rem echo %var%

rem GET START TIME
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

set /p ARCHESDIR="Enter the path to arches: "
set HERPATH=%~dp0

cd %ARCHESDIR%

echo Rebuilding db
python manage.py packages -o setup_db
echo     rebuild complete.
echo ~-~-~-~-~-~-~

echo Loading thesauri and collections...
python manage.py packages -o import_reference_data -s %HERPATH%/reference_data/arches_liverpool_concepts.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s %HERPATH%/reference_data/Lincoln_Additional_Schemes.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s %HERPATH%/reference_data/Lincoln_dm_Type.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s %HERPATH%/reference_data/Lincoln_HER_Designation_Type.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s %HERPATH%/reference_data/Lincoln_HER_Period_Type.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s %HERPATH%/reference_data/Lincoln_Monument_Types_v4.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s %HERPATH%/reference_data/Lincoln_Recording_Event_Type.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s %HERPATH%/reference_data/Lincoln_Source_Type.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s %HERPATH%/reference_data/arches_liverpool_collections.xml -ow overwrite -st keep
echo     load complete.
echo ~-~-~-~-~-~-~

echo Loading resource models and branches...
python manage.py packages -o import_graphs -s arches/db/graphs/branches
python manage.py packages -o import_graphs -s %HERPATH%/graphs/branches/
python manage.py packages -o import_graphs -s %HERPATH%/graphs/resource_models/
echo     load complete.
echo ~-~-~-~-~-~-~

echo Loading map overlays...
python manage.py packages -o add_mapbox_layer -j %HERPATH%/mapbox_styles/Emerald/style.json -n "Emerald" -b
python manage.py packages -o add_mapbox_layer -j %HERPATH%/mapbox_styles/Outdoors/style.json -n "Outdoors" -b
python manage.py packages -o add_mapbox_layer -j %HERPATH%/mapbox_styles/Light/style.json -n "Light Streets" -b
python manage.py packages -o add_mapbox_layer -j %HERPATH%/mapbox_styles/Dark/style.json -n "Dark Streets" -b
python manage.py packages -o add_mapbox_layer -j %HERPATH%/mapbox_styles/Satellite-Streets/style.json -n Satellite_Streets -b
python manage.py packages -o add_tileserver_layer -m %HERPATH%/tilestache/town_plan_3857.xml -n "Lincoln 1886-1998"
python manage.py packages -o add_tileserver_layer -m %ROOTDIR%/arches/tileserver/hillshade.xml -n "Hillshade"
echo     load complete.
echo ~-~-~-~-~-~-~

echo Loading business data...
python manage.py packages -o import_business_data -s "%HERPATH%/business_data/HER Activities_master.csv" -c "%HERPATH%/business_data/HER Activities.mapping" -ow overwrite -bulk
python manage.py packages -o import_business_data -s "%HERPATH%/business_data/HER Information Assets.csv" -c "%HERPATH%/business_data/HER Information Assets.mapping" -ow overwrite -bulk
python manage.py packages -o import_business_data -s "%HERPATH%/business_data/HER Monuments Workshop.csv" -c "%HERPATH%/business_data/HER Monuments.mapping" -ow overwrite -bulk
python manage.py packages -o import_business_data -s "%HERPATH%/business_data/HER Actors_master.csv" -c "%HERPATH%/business_data/HER Actors.mapping" -ow overwrite -bulk
echo     load complete.
echo ~-~-~-~-~-~-~

rem GET END TIME
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

rem GET ELAPSED TIME
set /A elapsed=end-start

rem SHOW ELAPSED TIME
set /A hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100
if %mm% lss 10 set mm=0%mm%
if %ss% lss 10 set ss=0%ss%
if %cc% lss 10 set cc=0%cc%
echo %hh%:%mm%:%ss%,%cc%
