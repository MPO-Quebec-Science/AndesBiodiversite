# Create an OBISEvent from an Andes fishing set

This function creates an OBISEvent object representing a fishing set
from the ANDES database. It maps certain fields to a corresponding DwC
event fields, and addes hard-coded values where necessary.

## Usage

``` r
event_from_fishing_set(set, parent_event = NULL, quiet = FALSE)
```

## Arguments

- set:

  A dataframe (single row) containing a fishing set from ANDES database

- parent_event:

  The parent event of class OBISEvent (default is NULL).

- quiet:

  Supress console messages (default is FALSE).

## Value

an event of class OBISEvent representing a fishing set

## See also

\[get_andes_set()\] for getting a list of sets from the Andes DB.

Other OBISEvent creation functions:
[`event_from_mission()`](event_from_mission.md)
