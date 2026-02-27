# Create an OBISEvent from an Andes mission

This function creates an OBISEvent object representing a mission from
the Andes database. It maps certain fields to a corresponding DwC event
fields, and addes hard-coded values where necessary.

## Usage

``` r
event_from_mission(mission, parent = NULL, quiet = FALSE)
```

## Arguments

- mission:

  A dataframe (single row) containing a mission set from an Andes
  database

- parent:

  The parent event of class OBISEvent (default is NULL). The mission
  OBISevent is usually usually the top-level event and has no parent.

- quiet:

  Supress console messages (default is FALSE).

## Value

an event of class OBISEvent representing a mission.

## See also

\[get_andes_mission()\] for getting a list of missions (usualy only a
single active mission) from the Andes DB.

Other OBISEvent creation functions:
[`event_from_fishing_set()`](event_from_fishing_set.md)
