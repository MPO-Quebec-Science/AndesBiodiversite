# Get a mission dataframe

This function queries the andes database and returns a dataframe
containing the mission data. TODO: The mission filter is not yet
implemented everywhere, but should be added in the future. It currently
uses the active mission

## Usage

``` r
get_andes_mission(andes_db_connection)
```

## Arguments

- andes_db_connection:

  A connection object to the ANDES database.

## Value

a dataframe containing andes catch rows

## See also

\[andes_db_connect()\] for getting a connection object to the ANDES
database.

Other Andesdb query functions:
[`get_andes_catch()`](get_andes_catch.md),
[`get_andes_set()`](get_andes_set.md),
[`get_biodiv_data()`](get_biodiv_data.md)
