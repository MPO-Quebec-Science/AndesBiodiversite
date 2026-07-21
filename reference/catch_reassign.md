# creates an SQL script that will reassign a list of catches to a new reference catch

This is a function that creates an SQL statments that can updates a list
of catches. It is not strickly used by the package, but is a util for
end-users.

## Usage

``` r
catch_reassign(catch_ids = NULL, aphia_id = NULL, quiet = FALSE)
```

## Arguments

- catch_ids:

  A lsit of catch ids to update

- aphia_id:

  The new aphia_id for the given catch_ids

- quiet:

  Supress console messages (default is FALSE).

## Value

an SQL statement that will need to be executed.
