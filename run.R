# Voici un fichier exemple pour tester tes changements localement avant de les pousser vers le dépôt github

# loader le package localement pour tester tes changements
devtools::load_all()

# tester ces variables environnementals pour pouvoir établir une connexion
url_bd <- "iml-science-4.ent.dfo-mpo.ca"
port_bd <- 25988
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

# tester votre nouveux code
df <- get_biodiv_data(andes_db_connection)

# documenter vos changements
devtools::document()
