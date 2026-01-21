/* The OBIS occurrence Table is mostly constructed from this result based off of ANDES Catches*/
SELECT DISTINCT
    shared_models_referencecatch.scientific_name AS scientific_name,
    shared_models_referencecatch.aphia_id AS aphia_id,
    shared_models_sample.sample_number AS sample_number,
    shared_models_catch.notes AS notes,
    shared_models_catch.id AS catch_id
FROM shared_models_catch
LEFT JOIN shared_models_referencecatch
    ON shared_models_catch.reference_catch_id = shared_models_referencecatch.id
LEFT JOIN shared_models_sample 
	ON shared_models_sample.id=shared_models_catch.sample_id
LEFT JOIN shared_models_basket
    ON shared_models_basket.catch_id = shared_models_catch.id
LEFT JOIN shared_models_mission
    ON shared_models_sample.mission_id=shared_models_mission.id
WHERE shared_models_mission.is_active="1"
AND (shared_models_basket.size_class=9 OR shared_models_basket.size_class IS NULL)
AND shared_models_referencecatch.is_mixed_catch=0
ORDER BY sample_number ASC