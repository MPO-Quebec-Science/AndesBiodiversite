# Extract OBIS archive from ANDES database

This function extracts data from an ANDES database connection and
formats it into OBIS-compliant occurrence and event tables.

## Usage

``` r
get_OBIS_archive(andes_db_connection, ...)
```

## Arguments

- andes_db_connection:

  a connection object to the ANDES database.

- ...:

  Additional arguments passed on to methods

## Value

A dataframe containing the OBIS data. Use \`\$occurrence\` and
\`\$event\` to access the respective tables.
