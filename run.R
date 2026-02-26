# Voici un fichier exemple pour tester tes changements localement avant de les pousser vers le dépôt github

# loader le package localement pour tester tes changements

devtools::load_all()

# tester ces variables environnementals pour pouvoir établir une connexion
url_bd <- "iml-science-4.ent.dfo-mpo.ca"
port_bd <- 24991
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


df <- get_biodiv_data(andes_db_connection)
write.csv(df, "IML-2024-009-quantitative.csv", row.names = FALSE, na = "")

df_obis <- get_OBIS_archive(andes_db_connection)

write.csv(df_obis$event, "IML-2024-009-event.csv", row.names = FALSE, na = "")
write.csv(
  df_obis$occurrence,
  "IML-2024-009-occurrence.csv",
  row.names = FALSE,
  na = ""
)


# documenter vos changements
devtools::document()

devtools::build_rmd("vignettes/column_definitions.Rmd")

# roulez vos tests!
devtools::test()

# roulez vos exemples
devtools::run_examples()

# tester le package
rcmdcheck::rcmdcheck(
  args = c("--no-manual", "--no-examples"),
  error_on = "error"
)

# contruire la documentation avec pkgdown
pkgdown::build_site()
pkgdown::build_reference()
pkgdown::build_articles()
