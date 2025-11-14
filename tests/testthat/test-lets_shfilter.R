context("Test for shFilter")

data("Phyllomedusa")

test_that("lets.shFilter returns original shapes when no filters are given", {
  
  resu_test <- lets.shFilter(Phyllomedusa)
  expect_s4_class(resu_test, "SpatVector")
  expect_equal(terra::nrow(resu_test), nrow(Phyllomedusa))
  resu_test_sf <- sf::st_as_sf(resu_test)
  
  expect_equal(
    sf::st_drop_geometry(resu_test_sf),
    sf::st_drop_geometry(Phyllomedusa)
  )
})


test_that("lets.shFilter filters by presence", {
  
  resu_test <- lets.shFilter(Phyllomedusa, presence = 1)
  expect_true(all(resu_test$presence == 1))
})


test_that("lets.shFilter filters by origin", {
  
  resu_test <- lets.shFilter(Phyllomedusa, origin = 1)
  expect_true(all(resu_test$origin == 1))
})


test_that("lets.shFilter filters by multiple criteria", {
  
  resu_test <- lets.shFilter(Phyllomedusa, presence = 1, origin = 1, seasonal = 1)
  expect_true(all(resu_test$presence == 1 & resu_test$origin == 1 & resu_test$seasonal == 1))
})


test_that("lets.shFilter returns NULL when no shapes match filters", {
  
  resu_test <- lets.shFilter(Phyllomedusa, presence = 999)
  expect_null(resu_test)
})


