# test-package-load

## options
```
-db : run setup_py to rebuild your database
-ow : overwrite concepts and collections 
-st : stage concepts and collections
-s  : a zipfile located on github or locally
```
## configuration
By default mapbox-style layers will be loaded with the name property found in the layer's style.json file. The default name for tile server layers will be the basename of the layer's xml file. For both mapbox-style and tile server layers the default icon-class will be `fa fa-globe`. To customize the name and icon-class, simply add a meta.json file to the layer's directory with the following object:

```
{
  "name": "example name",
  "icon": "fa example-class"
}
```

## load data
To load data the target must be an arches project rather than the arches application:

```
arches-project create myproject
cd myproject
python manage.py packages -o load_package -s https://github.com/archesproject/test-package-load/archive/master.zip -db true
```


## Writing a resource model view for GIS clients

You can add any number of database views representing your resource models for shapefile export or to connect directly to a GIS client such as QGIS or ArcGIS. When writing a view to support shapefile export be sure that your view does not violate any shapefile restrictions. For example field names must be no longer than 10 characters with no special characters and text fields will not hold more than 255 characters.

If you plan to use the arches `export` command to export your view as a shapefile you need to be sure that your view contains 2 fields: `geom` with the geometry representing your resource instance's location and `geom_type` with the postgis geometry type of your `geom` column. 

To write your view, you should start by getting a mapping file for your resource. You can do that by going to the Arches Designer page and then in the `manage` dropdown of your resource model select `Create Mapping File`. A zip file will be downloaded and within that file you will find a `.mapping` file. This file will contain all the ids that you will need to design your view.

Below is an example of a simple resource model view. The UUID (ab74af76-fa0e-11e6-9e3e-026d961c88e6) in this example is the id of the view's resource model.

When creating your own view, you will need to replace this UUID with your own resource model's id. You can find this UUID in your mapping file assigned to the property: `resource_model_id`.

```
DROP VIEW IF EXISTS vw_monuments_simple;
CREATE OR REPLACE VIEW vw_monuments_simple AS
with mv as (select tileid, resourceinstanceid, nodeid, ST_Union(geom) as geom, ST_GeometryType(geom) as geom_type
	from mv_geojson_geoms
	group by tileid, nodeid, resourceinstanceid, ST_GeometryType(geom)) -- Union like geometry types within the same tile into a multipart geometry
select row_number() over () as gid,
    mv.resourceinstanceid,
	mv.tileid,
	mv.nodeid,
	ST_GeometryType(geom) as geom_type,
	geom
from mv
where (select graphid from resource_instances where mv.resourceinstanceid = resourceinstanceid) = 'ab74af76-fa0e-11e6-9e3e-026d961c88e6'
```

Below is a more complete example which includes columns with tile data:

```
DROP VIEW IF EXISTS vw_monuments;
CREATE OR REPLACE VIEW vw_monuments AS
with mv as (select tileid, resourceinstanceid, nodeid, ST_Union(geom) as geom, ST_GeometryType(geom) as geom_type
	from mv_geojson_geoms
	group by tileid, nodeid, resourceinstanceid, ST_GeometryType(geom)) -- Union like geometry types within the same tile into a multipart geometry
select row_number() over () as gid,
        mv.resourceinstanceid,
	mv.tileid,
	mv.nodeid,
	ST_GeometryType(geom) as geom_type,
	name_tile.tiledata ->> '677f303d-09cc-11e7-9aa6-6c4008b05c4c' as name,  -- get a simple string value from tile json
	(select value from values where cast(name_tile.tiledata ->> '677f39a8-09cc-11e7-834a-6c4008b05c4c' as uuid) = valueid ) as nametype, -- get a concept's value label
	(select value from values where cast(component.tiledata ->>'ab74b009-fa0e-11e6-9e3e-026d961c88e6' as uuid) = valueid ) as construction_type,
	array_to_string((select array_agg(v.value) from unnest(ARRAY(SELECT jsonb_array_elements_text(component.tiledata -> 'ab74afec-fa0e-11e6-9e3e-026d961c88e6'))::uuid[]) item_id left join values v on v.valueid=item_id), ',') as const_tech, -- get the value labels from a concept list
	(select value from values where cast(record.tiledata ->> '677f2c0f-09cc-11e7-b412-6c4008b05c4c' as uuid) = valueid ) as record_type,
	geom
from mv
left join tiles name_tile
	 on mv.resourceinstanceid = name_tile.resourceinstanceid
	 and name_tile.tiledata->>'677f39a8-09cc-11e7-834a-6c4008b05c4c'
		!= ''
left join tiles component
	on name_tile.resourceinstanceid = component.resourceinstanceid
	and component.tiledata->>'ab74afec-fa0e-11e6-9e3e-026d961c88e6'
		!= ''
left join tiles record
        on name_tile.resourceinstanceid = record.resourceinstanceid
        and record.tiledata->>'677f2c0f-09cc-11e7-b412-6c4008b05c4c'
		!= ''
where (select graphid from resource_instances where mv.resourceinstanceid = resourceinstanceid) = 'ab74af76-fa0e-11e6-9e3e-026d961c88e6'

```
