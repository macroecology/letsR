context("Test for lets.iucn.his")

sp <- c("Musonycteris harrisoni", "Ailuropoda melanoleuca",
        "Cebus flavius")


test_that("lets.iucn.his works fine, one species", {
  
  testiucn <- lets.iucn.his("Panthera tigris")
  expect_equal(class(testiucn), "data.frame")
  testiucn2 <- lets.iucn.his("Panthera onca")
  expect_equal(class(testiucn2), "data.frame")
})

test_that("lets.iucn.his works fine, one species, count = TRUE", {
  
  testiucn <- lets.iucn.his("Panthera tigris", count = TRUE)
  expect_equal(class(testiucn), "data.frame")
  testiucn2 <- lets.iucn.his("Panthera onca", count = TRUE)
  expect_equal(class(testiucn2), "data.frame")
})


test_that("lets.iucn.his works fine, multiple species", {
  
  testiucn <- lets.iucn.his(sp)
  expect_equal(class(testiucn), "data.frame")
  testiucn2 <- lets.iucn.his(sp, count = TRUE)
  expect_equal(class(testiucn2), "data.frame")
  expect_equal(testiucn, testiucn2)
})
