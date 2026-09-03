# Voici un fichier exemple pour tester tes changements localement avant de les pousser vers le dépôt github

# loader le package localement pour tester tes changements

devtools::load_all()

# tester ces variables environnementals pour pouvoir établir une connexion

url_bd <- "iml-science-4.ent.dfo-mpo.ca"
port_bd <- 26973
nom_bd <- "andesdb"
nom_usager <- Sys.getenv("NOM_USAGER_BD")
mot_de_passe <- Sys.getenv("MOT_DE_PASSE_BD")

andes_db_connection <- andes_db_connect(
  url_bd = url_bd,
  port_bd = port_bd,
  nom_usager = nom_usager,
  mot_de_passe = mot_de_passe,
  nom_bd = nom_bd
)


devtools::load_all()


df <- get_biodiv_specimen_data(andes_db_connection)

predateur_noms <- c(
  "Homarus americanus",
  "Cancer irroratus",
  "Hyas araneus",
  "Hyas alutaceus",
  "Asterias rubens",
  "Solaster endeca",
  "Crossaster papposus"
  "Henricia",
  "Leptasterias (Hexasterias) polaris",
  "Leptasterias groenlandica"
)

# filter by predators
predator_data <- df[df$scientificName %in% predateur_noms, ]

sampled_predator_data <- predator_data[predator_data$BASKET_SAMPLED == 1, ]
# keep only specific columns
sampled_predator_data <- subset(
  sampled_predator_data,
  select = c(
    "eventID",
    "scientificName",
    "scientificNameID",
    "ANDES_SET",
    "recordNumber",
    "MEASURED_SPECIMEN_COUNT"
  )
)

# get regular dataframe
df <- get_biodiv_data(andes_db_connection)

df <- left_join(
  df,
  sampled_predator_data,
  by = c(
    "eventID",
    "scientificName",
    "scientificNameID",
    "ANDES_SET",
    "recordNumber"
  )
)
# reset row names after join
rownames(df) <- NULL

# select those with a mismatch
idx_with_mismatch <- df$MEASURED_SPECIMEN_COUNT != df$VALIDATED_FRACTION_COUNT

# set na to FALSE (probably did not have specimen data)
idx_with_mismatch[is.na(idx_with_mismatch)] <- FALSE

View(df[idx_with_mismatch, ])
