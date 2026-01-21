# Create an OBISOccurence from an Andes catch

This function creates an OBISOccurence object representing a catch from
the Andes database. It maps certain fields to a corresponding DwC event
fields, and addes hard-coded values where necessary.

## Usage

``` r
occurrence_from_catch(catch, event = NULL, quiet = FALSE)
```

## Arguments

- catch:

  A dataframe (single row) containing a catch data from an Andes
  database

- event:

  The parent event of class OBISEvent (default is NULL). The mission
  OBISevent is usually usually the top-level event and has no parent.

- quiet:

  Supress console messages (default is FALSE).

## Value

an occurrence of class OBISOccurence representing the catch.
