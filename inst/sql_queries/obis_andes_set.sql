/* The OBIS event Table is mostly constructed from this result based off of ANDES Set*/
SELECT 
    shared_models_sample.sample_number AS sample_number,
    shared_models_sample.is_valid AS set_is_valid,
    shared_models_mission.id AS andes_mission_id,
    shared_models_station.name AS station_name, -- this needs to be numeric, will have to strip alphabetic characters
    shared_models_operation.abbrev AS operation, -- fish or ctd, will help with COD_TYP_TRAIT if ctd
    -- MAX(CASE WHEN (shared_models_sampleobservationtype.export_name='set_result') THEN value ELSE '' END) AS COD_RESULT_OPER,
    shared_models_sample.start_date AS start_date,
    shared_models_sample.end_date AS end_date,
    -- also copy these previous two for HEURE_DEB_TRAIT and HEURE_DEB_TRAIT
    shared_models_sample.start_latitude AS start_latitude,
    shared_models_sample.end_latitude AS end_latitude,
    shared_models_sample.start_longitude AS start_longitude,
    shared_models_sample.end_longitude AS end_longitude,
    MAX(CASE WHEN (shared_models_sampleobservationtype.export_name='start_depth_m') THEN value ELSE '' END) AS start_depth_m,
    MAX(CASE WHEN (shared_models_sampleobservationtype.export_name='end_depth_m') THEN value ELSE '' END) AS end_depth_m,
    MAX(CASE WHEN (shared_models_sampleobservationtype.export_name='max_depth_m') THEN value ELSE '' END) AS max_depth_m,
    MAX(CASE WHEN (shared_models_sampleobservationtype.export_name='min_depth_m') THEN value ELSE '' END) AS min_depth_m,
    shared_models_sample.remarks AS remarks
FROM shared_models_sampleobservation
LEFT JOIN shared_models_sampleobservationtype
	ON shared_models_sampleobservationtype.id=shared_models_sampleobservation.sample_observation_type_id
LEFT JOIN shared_models_sample 
	ON shared_models_sample.id=shared_models_sampleobservation.sample_id
LEFT JOIN shared_models_station
    ON shared_models_sample.station_id=shared_models_station.id
LEFT JOIN shared_models_mission
    ON shared_models_sample.mission_id=shared_models_mission.id
LEFT JOIN shared_models_sample_operations
    ON shared_models_sample.id=shared_models_sample_operations.sample_id
LEFT JOIN shared_models_operation
    ON shared_models_operation.id=shared_models_sample_operations.operation_id
WHERE shared_models_mission.is_active="1"
    AND shared_models_operation.abbrev="fish"
GROUP BY
    andes_mission_id,
    set_is_valid,
    sample_number,
    station_name,
    operation,
    start_date,
    start_latitude,
    start_longitude,
    end_date,
    end_latitude,
    end_longitude,
    remarks
ORDER BY sample_number ASC