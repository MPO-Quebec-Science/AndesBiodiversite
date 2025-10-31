# ANDES crabe

Ce dépot contient des wrappers en `R` de commandes `SQL` pour extraire des données de crabe des neiges (équipe IML de la région du Québec) fait avec ANDES.

## Requirements
The `{MySQL ODBC 8.0 Unicode Driver}` should be available on DFO workstations. It can be installed in the software center.
Name: MySQL Connector ODBC
Version 8.0.22

URL: softwarecenter:SoftwareID=ScopeId_A90E3BBE-DB35-4A92-A44E-15F8C7C595B3/Application_dec16a4a-d57f-44b1-8a9f-8f6267f34539

List available drivers `using odbc::odbcListDrivers()` and see if it is present.


# Utilisation
1. Donner les détails de la connexion
2. Établir un connexion
3. Obtenir les données avec `get_fishing_sets_bsm()` et `get_specimens_bsm()`


## Connexion et authentification a la BD ANDES  

Il est FORTEMENT DÉCONSIELLER de mettre les mots de passes directement dans un script (mais vouz pouvez le faire temporairement pour déboguguer). Il faut voir les scripts comme étant publique et ouvert a tous.

Pour sauvegarder les mots de passes de BD, il faut faire une copie du fichier gabarit `exemple.Renviron` et le nomer `.Renviron`. Par la suite il faut remplir le nom d'usagé et le mot de passe pour pouvoir faire une connexion a la BD. Il est possible de falloir redémarré `R` apres avoir modifier `.Renviron` car la lecture est uniquement fait au démarage de `R`. Le fichier `.Renviron` peut être placé dans le dossier home de l'usager `C:\Users\TON_NOM` (sur windows) ou `/home/TON_NOM` (sur Linux).

Ces informations seront par la suite disponnible via la fonction `Sys.getenv()`, comme dans cette exemple ci-bas.

``` R
# Infos connexion BD, voir section Authentification Connexion BD
url_bd <- "iml-science-4.ent.dfo-mpo.ca"
port_bd <- 25988
nom_bd <- "andesdb"
nom_usager <- Sys.getenv("NOM_USAGER_BD")
mot_de_passe <- Sys.getenv("MOT_DE_PASSE_BD")
```

``` R
# établir connexion BD (il faut être sur le réseau MPO)
source("R/andes_db_connect.R")
andes_db_connection <- andes_db_connect(
  url_bd = url_bd,
  port_bd = port_bd,
  nom_usager = nom_usager,
  mot_de_passe = mot_de_passe,
  nom_bd = nom_bd
)
```