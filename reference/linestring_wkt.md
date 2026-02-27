# Create a WKT linestring from two points This function creates a WKT (Well-Known Text) representation of a linestring connecting two points. Each point is represented as a list containing 'lon' and 'lat' fields, and optionally a 'z' field for elevation (a negative number representing depth).

Create a WKT linestring from two points This function creates a WKT
(Well-Known Text) representation of a linestring connecting two points.
Each point is represented as a list containing 'lon' and 'lat' fields,
and optionally a 'z' field for elevation (a negative number representing
depth).

## Usage

``` r
linestring_wkt(p1, p2, fmt = 3)
```

## Arguments

- p1:

  A list with 'lon' and 'lat' (and optionally 'z') fields for the first
  point

- p2:

  A list with 'lon' and 'lat' (and optionally 'z') fields for the second
  point

- fmt:

  format, NOT YET USED !

  defing this here instead of using the package sf to avoid dependency
  If we ever import sf or wellknown, we can replace this function
