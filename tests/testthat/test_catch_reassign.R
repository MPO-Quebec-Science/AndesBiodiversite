testthat::test_that("test errors when used with bad arguments", {
  testthat::expect_error(
    catch_reassign(
      catch_ids = c(1, 2, 3),
      aphia_id = NULL,
    ),
    "need to provide an aphia_id"
  )

  testthat::expect_error(
    catch_reassign(
      catch_ids = NULL,
      aphia_id = 123
    ),
    "need to provide a list of catches"
  )

  testthat::expect_error(
    catch_reassign(
      catch_ids = list(),
      aphia_id = "abcd"
    ),
    "aphia_id has to be a number"
  )

  testthat::expect_error(
    catch_reassign(
      catch_ids = list(),
      aphia_id = 123
    ),
    "List of catches is empty!"
  )
})
