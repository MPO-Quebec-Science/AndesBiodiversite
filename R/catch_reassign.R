#' creates an SQL script that will reassign a list of catches to a new reference catch
#'
#' This is a function that creates an SQL statments that can updates a list of catches.
#' It is not strickly used by the package, but is a util for end-users.
#'
#' @param catch_ids A lsit of catch ids to update
#' @param aphia_id The new aphia_id for the given catch_ids
#' @param quiet Supress console messages (default is FALSE).
#' @return an SQL statement that will need to be executed.
#' @export

catch_reassign <- function(catch_ids = NULL, aphia_id = NULL, quiet = FALSE) {
  if (is.null(aphia_id)) {
    stop("need to provide an aphia_id to assign")
  }

  if (!is.numeric(aphia_id)) {
    stop("aphia_id has to be an integer")
  }

  if (is.null(FALSE)) {
    message("need to provide a list of catches")
  }
  if (length(catch_ids) < 1) {
    message("List of catches is empty!")
  }

  # sanity-check #1, make sure aphia_id is present in the reference catch list

  # from the aphia_id, get the new reference catch id
  # -- ÉTAPE 1: TROUVER LA NOUVELLE CAPTURE DE REFERENCE
  # -- on va temporairement sauvegarder la nouvelle capture de reference dans une variable
  # DECLARE @NewRefCatchID INT;
  # -- on va trouver le nouveau referencecatch_id a partir du aphia_id
  # SET @NewRefCatchID = (SELECT id FROM shared_models_referencecatch WHERE aphia_id = 127144);
  # -- maintenant, la variable @NewRefCatchID contient la bonne valeur, il reste a faire le changement.

  sql_query <- sprintf(
    "SELECT id FROM shared_models_referencecatch WHERE aphia_id=%d",
    aphia_id
  )
  result <- DBI::dbSendQuery(andes_db_connection, sql_query)
  ref_catch <- DBI::dbFetch(result, n = 1)
  DBI::dbClearResult(result)

  if (length(ref_catch$id) == 0) {
    stop("failed sanity check, aphia_id ", aphia_id, " not found in DB")
  }

  if (quiet == FALSE) {
    message(paste0(
      "Found reference_catch_id=",
      ref_catch$id[1],
      " for the given aphia_id=",
      aphia_id
    ))
  }

  # sanity-check #2, make sure given catch ids are all present

  sql_query <- "SELECT id FROM shared_models_catch WHERE 0=1"
  for (catch_id in catch_ids) {
    sql_query <- paste(sql_query, "OR shared_models_catch.id =", catch_id)
  }

  result <- DBI::dbSendQuery(andes_db_connection, sql_query)
  result_catch_ids <- DBI::dbFetch(result, n = Inf)
  # print(result_catch_ids)
  DBI::dbClearResult(result)

  # result_catch
  for (catch_id in catch_ids) {
    if (!(catch_id %in% result_catch_ids$id)) {
      stop("failed sanity check, catch ", catch_id, " not found in DB")
    }
  }

  if (quiet == FALSE) {
    message("Found all catch ids in the database.")
    message("All sanity checks passed, ready to generate SQL...")
  }

  # now, we need to update the catches

  # -- ÉTAPE 2: MODIFIER LA CAPTURE DE REFERENCE
  # -- on va modifier la table shared_models_catch
  # UPDATE shared_models_catch
  # -- on change la valeur de reference_catch_id par celui trouvé ci-haut (selon le nouveau aphia_id voulu)
  # SET shared_models_catch.reference_catch_id = @NewRefCatchID
  # -- mais seulement pour les catch_id spécifiques
  # WHERE shared_models_catch.id = 4931 OR shared_models_catch.id = 4969

  sql_statement <- paste0(
    "UPDATE shared_models_catch SET shared_models_catch.reference_catch_id=",
    ref_catch$id[1]
  )

  # first, always is false
  sql_statement <- paste(sql_statement, "WHERE 1=0")

  # after, append conditional requirements
  for (catch_id in catch_ids) {
    sql_statement <- paste0(
      sql_statement,
      " OR shared_models_catch.id=",
      catch_id
    )
  }
  sql_statement <- paste0(sql_statement, ";")

  return(sql_statement)
}
