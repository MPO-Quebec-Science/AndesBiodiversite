# ANDES Biodiversité

Ce dépot contient des wrappers en `R` de commandes `SQL` pour extraire des données de biodiversité (équipe IML de la région du Québec) fait avec ANDES.

## Requirements
The `{MySQL ODBC 8.0 Unicode Driver}` should be available on DFO workstations. It can be installed in the software center.
Name: MySQL Connector ODBC
Version 8.0.22

URL: softwarecenter:SoftwareID=ScopeId_A90E3BBE-DB35-4A92-A44E-15F8C7C595B3/Application_dec16a4a-d57f-44b1-8a9f-8f6267f34539

List available drivers `using odbc::odbcListDrivers()` and see if it is present.


# Installation

 - installer le `MySQL Connector ODBC` du centre logiciel
 - installer le package devtools `install.packages("devtools")`
 - installer devtools pour install le package `devtools::install_github("MPO-Quebec-Science/AndesBiodiversite")`



# Utilisation
1. Donner les détails de la connexion
2. Établir un connexion
3. Obtenir les données avec `get_biodiv_data()`



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

Tester la connexion
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

# Guide developpement
Pour modifier ce package, il ne faut pas l'installer proprement dit, mais le "loader" à partir du code source (qu'on va vouloir éventuellement modifier).

Il faut faire une séparation entre le code source *du package* et le code qui *utilise* le package.

Le code source R du package lui-même réside sous le dossier `./R/` (et `./inst/`). Le code qui *utilise* le package ne doit jamais se trouver là! Le code qui utilise le package réside chez les évaluateurs / utilisateurs et pas dans ce dépot git.

Par contre, en tant que dévéloppeur du package il est pratique de pouvoir faire usage du package en meme parallel, cela permet de tester nos ajouts/modifications a mesure. Veuillez voir `run.R` comme exemple.

Pour loader le package avec le code présent sous `./R/` (donc sans installer le package lui-meme), utiliser la fonction `devtools::load_all()`, vous pourriez ensuite utiliser les fonctions disponibles.

``` R
> devtools::load_all()
ℹ Loading PSEtoDataframe
> source_info_df <- source_info_list()
```
## Documentation

Documenter brievement les fonctions individuelles avec des commentaires sous le format `doxygen`.
Par exemple, ceci pourrait être le contenu du fichier `./R/add.R` :

``` R
#' Add together two numbers
#'
#' @param x A numeric value.
#' @param y A numeric value.
#' @return The sum of `x` and `y`.
#' @examples
#' add(1, 2)
#' add(5, 10)
add <- function(x, y) {
  x + y
}
```

Utiliser la fonction `devtools::document()` pour mettre a jour la documentation dans `./man/` en utilisant les commentaires `doxygen`
``` R
> devtools::document()
ℹ Updating PSEtoDataframe documentation
ℹ Loading PSEtoDataframe
Writing NAMESPACE
Writing add.Rd
```