SELECT 
--	shared_models_catch.id as catch_id,
    shared_models_referencecatch.aphia_id as scientificNameID, -- will need to make a urn 
    shared_models_referencecatch.scientific_name as scientificName,
    shared_models_sample.sample_number AS ANDES_SET,
    shared_models_station.name AS fieldNumber, -- need to make the eventID
    shared_models_mission.mission_number AS mission, -- need to make the eventID
    shared_models_catch.id AS recordNumber,
    shared_models_relativeabundancecategory.description_eng   AS relative_abundance,
--	shared_models_basket.unmeasured_specimen_count as specimen_count,
--	shared_models_basket.basket_wt_kg as weight_kg,
--	shared_models_basket.is_count_subsample as is_subsample,
	shared_models_catch.notes  AS FIELD_SAMPLE_NOTE,
	shared_models_basket.size_class as class,
    mix_parent_refcatch.is_mixed_catch AS from_mixed_catch, -- will need to convert to FRACTION_DENOMINATOR (4 or 1)
    MAX(CASE WHEN (shared_models_basket.is_count_subsample=0) THEN shared_models_basket.basket_wt_kg ELSE '' END) AS VALIDATED_FINAL_MASS_G, -- will need to convert kg to g in R
    MAX(CASE WHEN (shared_models_basket.is_count_subsample=0) THEN shared_models_basket.unmeasured_specimen_count ELSE '' END) AS VALIDATED_FINAL_COUNT,
    MAX(CASE WHEN (shared_models_basket.is_count_subsample=1) THEN shared_models_basket.basket_wt_kg ELSE '' END) AS VALIDATED_FRACTION_MASS_G, -- will need to convert kg to g in R
    MAX(CASE WHEN (shared_models_basket.is_count_subsample=1) THEN shared_models_basket.unmeasured_specimen_count ELSE '' END) AS VALIDATED_FRACTION_COUNT
FROM shared_models_catch
LEFT JOIN shared_models_basket
ON shared_models_basket.catch_id = shared_models_catch.id
LEFT JOIN shared_models_basket mix_parent_bas
ON shared_models_basket.parent_id  = mix_parent_bas.id
LEFT JOIN shared_models_catch mix_parent_cat
ON mix_parent_bas.catch_id = mix_parent_cat.id
LEFT JOIN shared_models_referencecatch mix_parent_refcatch
ON mix_parent_refcatch.id = mix_parent_cat.reference_catch_id 
LEFT JOIN shared_models_relativeabundancecategory
ON shared_models_catch.relative_abundance_category_id = shared_models_relativeabundancecategory.id
LEFT JOIN shared_models_sample
ON shared_models_catch.sample_id=shared_models_sample.id
LEFT JOIN shared_models_referencecatch
ON shared_models_catch.reference_catch_id = shared_models_referencecatch.id
LEFT JOIN shared_models_station
ON shared_models_sample.station_id = shared_models_station.id
LEFT JOIN shared_models_mission
ON shared_models_mission.id = shared_models_sample.mission_id
WHERE shared_models_mission.is_active=1
AND (shared_models_basket.size_class=9 OR shared_models_basket.size_class IS NULL)
-- remove parent mixed catch
AND shared_models_referencecatch.is_mixed_catch=0
GROUP BY
    scientificNameID,
    scientificName,
    ANDES_SET,
    fieldNumber,
    mission,
    recordNumber,
    relative_abundance,
    FIELD_SAMPLE_NOTE,
    class,
    from_mixed_catch
ORDER BY ANDES_SET ASC
--  need to filter by active mission, this should be done in the R function
-- WHERE mix_parent_refcatch.is_mixed_catch = 1
