# Convert a datetime to an OBIS-compliant time string based on precision

Convert a datetime to an OBIS-compliant time string based on precision

## Usage

``` r
obis_time_str(dt, precision, tz = NULL)
```

## Arguments

- dt:

  A POSIXct datetime object.

- precision:

  An integer indicating the precision level (1-7).

- tz:

  An optional timezone string.

## Value

A string formatted according to OBIS standards.
