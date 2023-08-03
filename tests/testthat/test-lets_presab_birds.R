context("Test for lets.presab.birds")

# Path
path.Ramphastos <- system.file("extdata", package = "letsR")

test_that("lets.presab.birds return a correct PresenceAbsence object", {
  skip_on_cran()
  PAM <- lets.presab.birds(path.Ramphastos, xmn=-93, xmx=-29, ymn= -57, ymx=25,
                     resol=1, remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE,
                     crs=CRS("+proj=longlat +datum=WGS84"), cover=0, presence=NULL,
                     origin=NULL, seasonal=NULL, count=FALSE)
  
  expect_equal(class(PAM)[1], "PresenceAbsence")
  expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]])[1], "character")
})


test_that("lets.presab.birds return a correct PresenceAbsence object for the world", {
  skip_on_cran()
  
  PAM <- lets.presab.birds(path.Ramphastos, resol=5, remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE,
                    crs=CRS("+proj=longlat +datum=WGS84"), cover=0.2, presence=NULL,
                    origin=NULL, seasonal=NULL, count=FALSE)
  
  expect_equal(class(PAM), "PresenceAbsence")
expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
  
  
})


test_that("lets.presab.birds return a correct PresenceAbsence object for cover different projection", {
  skip_on_cran()
  pro <- paste("+proj=eqdc +lat_0=-32 +lon_0=-60 +lat_1=-5",
               "+lat_2=-42 +x_0=0 +y_0=0 +ellps=aust_SA", 
               "+units=m +no_defs")
  SA_EC <- suppressWarnings(CRS(pro))
  
  PAM3 <- lets.presab.birds(path.Ramphastos, xmn = -4135157,
                            xmx = 4707602,
                            ymn = -450000, ymx = 5774733,
                            resol = 100000,
                            crs.grid = SA_EC, cover = 0.1)
  
  
  expect_equal(class(PAM3), "PresenceAbsence")
  expect_true(is.matrix(PAM3[[1]]))
  expect_true(inherits(PAM3[[2]], "SpatRaster"))
  expect_equal(class(PAM3[[3]]), "character")
  
})


test_that("lets.presab.birds return a correct PresenceAbsence object (count=TRUE)", {
  skip_on_cran()
  
  PAM <- lets.presab.birds(path.Ramphastos, xmn=-93, xmx=-29, ymn= -57, ymx=25,
                    resol=1, remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE,
                    crs=CRS("+proj=longlat +datum=WGS84"), cover=0, presence=NULL,
                    origin=NULL, seasonal=NULL, count=TRUE)  
  expect_equal(class(PAM), "PresenceAbsence")
  expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
})


test_that("lets.presab.birds return a correct PresenceAbsence object, cover=0.2", {
  skip_on_cran()
  
  PAM <- lets.presab.birds(path.Ramphastos, xmn=-93, xmx=-29, ymn= -57, ymx=25,
                    resol=1, remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE,
                    crs=CRS("+proj=longlat +datum=WGS84"), cover=0.2, presence=NULL,
                    origin=NULL, seasonal=NULL, count=FALSE)
  
  expect_equal(class(PAM), "PresenceAbsence")
  expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
  
  
})


test_that("lets.presab.birds return a correct PresenceAbsence object,
          remove.sp = FALSE", {
  skip_on_cran()
  
  PAM <- lets.presab.birds(path.Ramphastos, xmn=-93, xmx=-29, ymn= -57, ymx=25,
                    resol=1, remove.cells=TRUE, remove.sp=FALSE, show.matrix=FALSE,
                    crs=CRS("+proj=longlat +datum=WGS84"), cover = 0.999999, presence=NULL,
                    origin=NULL, seasonal=NULL, count=FALSE)
  expect_equal(class(PAM), "PresenceAbsence")
  expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
})


test_that("lets.presab.birdsreturn a correct PresenceAbsence object, remove.cells=FALSE", {
  skip_on_cran()
  
  PAM <- lets.presab.birds(path.Ramphastos, xmn=-93, xmx=-29, ymn= -57, ymx=25,
                    resol=1, remove.cells=FALSE, remove.sp=TRUE, show.matrix=FALSE,
                    crs=CRS("+proj=longlat +datum=WGS84"), cover=0, presence=NULL,
                    origin=NULL, seasonal=NULL, count=FALSE)
  
  expect_equal(class(PAM), "PresenceAbsence")
  expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
  
  
  response <- summary(PAM)
  expect_true(response$Cellswithoutanypresence > 0)
  
})



test_that("lets.presab.birds new projection", {
  skip_on_cran()
  desiredcrs <- CRS("+proj=laea +lat_0=0 +lon_0=-80 +x_0=180 +y_0=70 +units=km") 
  PAM <- lets.presab.birds(path.Ramphastos, xmn = -3000,
                           xmx = 6000, ymn = -5000, 
                           ymx = 3000, res = 100, remove.cells=TRUE,
                           remove.sp=TRUE, show.matrix=FALSE,
                           crs=CRS("+proj=longlat +datum=WGS84"), cover=0, 
                           presence=NULL,
                           crs.grid = desiredcrs,
                           origin=NULL, seasonal=NULL, count=TRUE)
  
  expect_equal(class(PAM), "PresenceAbsence")
  expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
  
  
})






