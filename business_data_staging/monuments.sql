CREATE OR REPLACE VIEW vw_monuments AS
with mv as (select tileid, resourceinstanceid, nodeid, ST_Union(geom) as geom, ST_GeometryType(geom) as geom_type, count(tileid) as count
	from mv_geojson_geoms
	group by tileid, nodeid, resourceinstanceid, ST_GeometryType(geom))
select row_number() over () as gid,
	mv.tileid,
	mv.nodeid,
	ST_GeometryType(geom) as geom_type,
	name_tile.tiledata ->> '677f303d-09cc-11e7-9aa6-6c4008b05c4c' as name,
	name_tile.tiledata ->> '677f39a8-09cc-11e7-834a-6c4008b05c4c' as nametype,
	(select value from values where cast(component.tiledata ->>'ab74b009-fa0e-11e6-9e3e-026d961c88e6' as uuid) = valueid ) as cot,
	component.tiledata ->> 'ab74afec-fa0e-11e6-9e3e-026d961c88e6' as const_tech,
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
