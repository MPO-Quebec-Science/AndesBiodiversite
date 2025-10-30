# ANDES crabe

Ce dépot contient des wrappers en `R` de commandes `SQL` pour extraire des données de crabe des neiges (équipe IML de la région du Québec) fait avec ANDES.

## Requirements
The `{MySQL ODBC 8.0 Unicode Driver}` should be available on DFO workstations. It can be installed in the software center.
Name: MySQL Connector ODBC
Version 8.0.22

URL: softwarecenter:SoftwareID=ScopeId_A90E3BBE-DB35-4A92-A44E-15F8C7C595B3/Application_dec16a4a-d57f-44b1-8a9f-8f6267f34539

List available drivers `using odbc::odbcListDrivers()` and see if it is present.

## Installation
``` R
devtools::install_github("MPO-Quebec-Science/AndesCrabe")
```

# Utilisation
1. Installer
2. Donner les détails de la connexion
3. Établir un connexion
4. Obtenir les données avec `get_fishing_sets_bsm()` et `get_specimens_bsm()`

``` R
library(ANDESCrabe)

# Infos connexion BD, voir section Authentification Connexion BD
url_bd <- "iml-science-4.ent.dfo-mpo.ca"
port_bd <- 25993
nom_bd <- "andesdb"
nom_usager <- Sys.getenv("NOM_USAGER_BD")
mot_de_passe <- Sys.getenv("MOT_DE_PASSE_BD")

# établir connexion BD (il faut être sur le réseau MPO)
andes_db_connection <- andes_db_connect(
  url_bd = url_bd,
  port_bd = port_bd,
  nom_usager = nom_usager,
  mot_de_passe = mot_de_passe,
  nom_bd = nom_bd
)
# les traits
traits <- get_fishing_sets_bsm(andes_db_connection)
View(traits)
# les spécimens
specimens <- get_specimens_bsm(andes_db_connection)
View(specimens)
```

## Authentification Connexion BD
Il faut faire une copie du fichier gabarit `exemple.Renviron` et le nomer `.Renviron`. Par la suite il faut remplir le nom d'usagé et le mot de passe pour pouvoir faire une connexion a la BD. Il est possible de falloir redémarré `R` apres avoir modifier `.Renviron` car la lecture est uniquement fait au démarage de `R`. Le fichier `.Renviron` peut être placé au dossier home de l'usager `C:\Users\TON_NOM` (sur windows) ou `/home/TON_NOM` (sur Linux).


# Developpement
checkout the repo and use
``` R
devtools::load_all()
devtools::document()
```
to load the library in memory without installing it.

To test the github package, detach an re-install
``` R
detach("package:ANDESCrabe", unload=TRUE)
devtools::install_github("MPO-Quebec-Science/AndesCrabe")
library(ANDESCrabe)
```
