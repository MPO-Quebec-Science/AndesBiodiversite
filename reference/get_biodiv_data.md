# Gets biodiversity data from ANDES database

This function executes a SQL query to retrieve the needed andes data to
construct a Biodiversity table. TODO: The mission filter is not yet
implemented everywhere, but should be added in the future. It currently
uses the active mission The current ANDES active mission will determine
for which mission the data are returned.

## Usage

``` r
get_biodiv_data(andes_db_connection)
```

## Arguments

- andes_db_connection:

  a connection object to the ANDES database.

## Value

a dataframe containing andes biodiveristy data

## See also

\[andes_db_connect()\] for getting a connection object to the ANDES
database.

Other Andesdb query functions:
[`get_andes_catch()`](get_andes_catch.md),
[`get_andes_mission()`](get_andes_mission.md),
[`get_andes_set()`](get_andes_set.md)
