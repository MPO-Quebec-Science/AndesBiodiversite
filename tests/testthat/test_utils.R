# Annoying bug with floating point representation and the lack of rounding in the formatting.
# for example, test "2024-06-01 13:14:15.10" vs "2024-06-01 13:14:15.11"
# format(lubridate::ymd_hms("2024-06-01 13:14:15.10"), format = "%Y-%m-%dT%H:%M:%OS6%z")
# format(lubridate::ymd_hms("2024-06-01 13:14:15.11"), format = "%Y-%m-%dT%H:%M:%OS6%z")
# for the purpose of testing, I will choose "2024-06-01 13:14:15.15" which does not exhibit the bug.

testthat::test_that("obis_datetime_str works correctly, no explicit timezone", {
  # this is by default in UTC
  dt <- lubridate::ymd_hms("2024-06-01 13:14:15.15")
  testthat::expect_equal(obis_datetime_str(dt, 1), "2024")
  testthat::expect_equal(obis_datetime_str(dt, 2), "2024-06")
  testthat::expect_equal(obis_datetime_str(dt, 3), "2024-06-01")
  testthat::expect_equal(obis_datetime_str(dt, 4), "2024-06-01T13+0000")
  testthat::expect_equal(obis_datetime_str(dt, 5), "2024-06-01T13:14+0000")
  testthat::expect_equal(obis_datetime_str(dt, 6), "2024-06-01T13:14:15+0000")
  testthat::expect_equal(
    obis_datetime_str(dt, 7),
    "2024-06-01T13:14:15.150000+0000"
  )
})

testthat::test_that("obis_datetime_str works correctly, explicit timezone", {
  # this is by default in UTC
  dt <- lubridate::ymd_hms("2024-06-01 13:14:15.15", tz = "EST")
  testthat::expect_equal(obis_datetime_str(dt, 1), "2024")
  testthat::expect_equal(obis_datetime_str(dt, 2), "2024-06")
  testthat::expect_equal(obis_datetime_str(dt, 3), "2024-06-01")
  testthat::expect_equal(obis_datetime_str(dt, 4), "2024-06-01T13-0500")
  testthat::expect_equal(obis_datetime_str(dt, 5), "2024-06-01T13:14-0500")
  testthat::expect_equal(obis_datetime_str(dt, 6), "2024-06-01T13:14:15-0500")
  testthat::expect_equal(
    obis_datetime_str(dt, 7),
    "2024-06-01T13:14:15.150000-0500"
  )
})

testthat::test_that("obis_datetime_str works correctly, explicit timezone", {
  # this is by default in UTC
  dt <- lubridate::ymd_hms("2024-06-01 13:14:15.15")
  # tell obis_datetime_str to interpret that string in EST
  testthat::expect_equal(obis_datetime_str(dt, 1, tz = "EST"), "2024")
  testthat::expect_equal(obis_datetime_str(dt, 2, tz = "EST"), "2024-06")
  testthat::expect_equal(obis_datetime_str(dt, 3, tz = "EST"), "2024-06-01")
  testthat::expect_equal(
    obis_datetime_str(dt, 4, tz = "EST"),
    "2024-06-01T13-0500"
  )
  testthat::expect_equal(
    obis_datetime_str(dt, 5, tz = "EST"),
    "2024-06-01T13:14-0500"
  )
  testthat::expect_equal(
    obis_datetime_str(dt, 6, tz = "EST"),
    "2024-06-01T13:14:15-0500"
  )
  testthat::expect_equal(
    obis_datetime_str(dt, 7, tz = "EST"),
    "2024-06-01T13:14:15.150000-0500"
  )
})
