# Get a catch dataframe

This function queries the andes database and returns a dataframe
containing the catch data. TODO: The mission filter is not yet
implemented everywhere, but should be added in the future. It currently
uses the active mission

## Usage

``` r
get_andes_catch(andes_db_connection, mission_id = NULL)
```

## Arguments

- andes_db_connection:

  A connection object to the ANDES database.

- mission_id:

  A string or integer representing the mission ID to filter the catches
  (default is NULL, which retrieves all catches).

## Value

a dataframe containing andes catch rows

## See also

\[andes_db_connect()\] for getting a connection object to the ANDES
database.

Other Andesdb query functions:
[`get_andes_mission()`](get_andes_mission.md),
[`get_andes_set()`](get_andes_set.md),
[`get_biodiv_data()`](get_biodiv_data.md)
