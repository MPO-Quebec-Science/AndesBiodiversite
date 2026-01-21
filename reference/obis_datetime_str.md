# Convert a datetime to an OBIS-compliant datetime string based on precision

Convert a datetime to an OBIS-compliant datetime string based on
precision

## Usage

``` r
obis_datetime_str(dt, precision = 6, tz = NULL)
```

## Arguments

- dt:

  A POSIXct datetime object.

- precision:

  An integer indicating the precision level (1-7).

- tz:

  An optional timezone string. Interpret the passed \`dt\` in this
  \`tz\`, ignoring its embedded timezone

## Value

A string formatted according to OBIS standards.
