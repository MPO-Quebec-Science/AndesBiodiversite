# Package index

## All functions

- [`andes_db_connect()`](andes_db_connect.md) : Establish a connection
  to the andes database
- [`.calc_nautical_dist()`](dot-calc_nautical_dist.md) : Calculate
  nautical distance between two geographic points \#' This function
  calculates the great-circle distance between two points on the Earth's
  surface \#' given their latitude and longitude using the Haversine
  formula.
- [`event_from_fishing_set()`](event_from_fishing_set.md) : Create an
  OBISEvent from an Andes fishing set
- [`event_from_mission()`](event_from_mission.md) : Create an OBISEvent
  from an Andes mission
- [`get_OBIS_archive()`](get_OBIS_archive.md) : Extract OBIS archive
  from ANDES database
- [`get_andes_catch()`](get_andes_catch.md) : Get a catch dataframe
- [`get_andes_mission()`](get_andes_mission.md) : Get a mission
  dataframe
- [`get_andes_set()`](get_andes_set.md) : Get a set dataframe
- [`get_biodiv_data()`](get_biodiv_data.md) : Gets biodiversity data
  from ANDES database
- [`linestring_wkt()`](linestring_wkt.md) : Create a WKT linestring from
  two points This function creates a WKT (Well-Known Text)
  representation of a linestring connecting two points. Each point is
  represented as a list containing 'lon' and 'lat' fields, and
  optionally a 'z' field for elevation (a negative number representing
  depth).
- [`make_set_wkt()`](make_set_wkt.md) : Create a WKT linestring for an
  Andes set
- [`obis_datetime_str()`](obis_datetime_str.md) : Convert a datetime to
  an OBIS-compliant datetime string based on precision
- [`obis_time_str()`](obis_time_str.md) : Convert a datetime to an
  OBIS-compliant time string based on precision
- [`occurrence_from_catch()`](occurrence_from_catch.md) : Create an
  OBISOccurence from an Andes catch
- [`row_union()`](row_union.md) : rbind, but allow different columns
  names Make a union of the rows filling missing columns with NA
