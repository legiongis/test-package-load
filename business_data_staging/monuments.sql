select row_number() over () as gid,
	mv.*,
	name_tile.tiledata ->> '677f303d-09cc-11e7-9aa6-6c4008b05c4c' as name,
	name_tile.tiledata ->> '677f39a8-09cc-11e7-834a-6c4008b05c4c' as nametype,
	(select value from values where cast(component.tiledata ->>'ab74b009-fa0e-11e6-9e3e-026d961c88e6' as uuid) = valueid ) as cot,
	component.tiledata ->> 'ab74afec-fa0e-11e6-9e3e-026d961c88e6' as const_tech,
	record.tiledata ->> '677f2c0f-09cc-11e7-b412-6c4008b05c4c' as record_type
from mv_geojson_geoms mv
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
