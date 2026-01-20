SELECT 
	shared_models_catch.id AS catch_id,
    shared_models_referencecatch.aphia_id AS scientificNameID, -- will need to make a urn 
    shared_models_referencecatch.scientific_name AS scientificName,
    shared_models_sample.sample_number AS sample_number,
    shared_models_sample.remarks AS eventRemarks,
    shared_models_station.name AS fieldNumber, -- need to make the eventID
    shared_models_mission.mission_number AS mission, -- need to make the eventID
    shared_models_catch.id AS recordNumber,
    shared_models_relativeabundancecategory.description_eng AS REL_ABUNDANCE_DESC,
    shared_models_relativeabundancecategory.code AS REL_ABUNDANCE_CODE,
	shared_models_catch.notes AS occurrenceRemarks,
	shared_models_basket.size_class AS class,
    mix_parent_refcatch.is_mixed_catch AS from_mixed_catch, -- will need to convert to FRACTION_DENOMINATOR (4 or 1)
    MAX(CASE WHEN (shared_models_basket.is_count_subsample=0) THEN shared_models_basket.basket_wt_kg ELSE '' END) AS basket_wt_kg, -- will need to convert kg to g in R
    MAX(CASE WHEN (shared_models_basket.is_count_subsample=0) THEN shared_models_basket.unmeasured_specimen_count ELSE '' END) AS unmeasured_specimen_count,
    MAX(CASE WHEN (shared_models_basket.is_count_subsample=1) THEN shared_models_basket.basket_wt_kg ELSE '' END) AS VALIDATED_SUBSAMPLE_MASS_G, -- will need to convert kg to g in R
    MAX(CASE WHEN (shared_models_basket.is_count_subsample=1) THEN shared_models_basket.unmeasured_specimen_count ELSE '' END) AS VALIDATED_SUBSAMPLE_COUNT
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
AND shared_models_referencecatch.is_mixed_catch=0
GROUP BY
    catch_id,
    scientificNameID,
    scientificName,
    sample_number,
    eventRemarks,
    fieldNumber,
    mission,
    recordNumber,
    REL_ABUNDANCE_DESC,
    REL_ABUNDANCE_CODE,
    occurrenceRemarks,
    class,
    from_mixed_catch
ORDER BY sample_number ASC
--  need to filter by active mission, this should be done in the R function
-- WHERE mix_parent_refcatch.is_mixed_catch = 1
