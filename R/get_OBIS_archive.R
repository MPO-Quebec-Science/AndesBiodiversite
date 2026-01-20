
get_OBIS_archive <- function(andes_db_connection) {

    andes_mission <- get_andes_mission(andes_db_connection)
    andes_sets <- get_andes_set(andes_db_connection, mission_id = andes_mission$id)
    andes_catches <- get_andes_catch(andes_db_connection)

    obis_occurrence_table <- NULL
    obis_event_table <- NULL
    mission_event <- event_from_mission(andes_mission, parent = NULL)

    # events start as mission
    obis_event_table <- row_union(obis_event_table, mission_event)

    # iterate through every Set in the mission
    for (i in seq_len(nrow(andes_sets))) {
        set <- andes_sets[i, ]
        set_event <- event_from_fishing_set(set, parent_event = mission_event)
        # add set event to obis_event_table
        obis_event_table <- row_union(obis_event_table, set_event)

        # iterate through every Catch in the Set
        andes_catches_in_this_set <- andes_catches[andes_catches$sample_number == set$sample_number,]
        for (j in seq_len(nrow(andes_catches_in_this_set))) {
            catch <- andes_catches_in_this_set[j, ]
                occurrence <- occurrence_from_catch(catch, event = set_event)
            obis_occurrence_table <- row_union(obis_occurrence_table, occurrence)
        }
    }

    return(list(
        occurrence = obis_occurrence_table,
        event = obis_event_table
    ))

}