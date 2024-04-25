context("Test for lets.presab")

data(Phyllomedusa)

test_that("lets.presab return a correct PresenceAbsence object", {
  skip_on_cran()
  PAM <-
    lets.presab(
      Phyllomedusa,
      xmn = -93,
      xmx = -29,
      ymn = -57,
      ymx = 15,
      resol = 1,
      remove.cells = TRUE,
      remove.sp = TRUE,
      show.matrix = FALSE,
      crs = terra::crs("+proj=longlat +datum=WGS84"),
      cover = 0,
      presence = NULL,
      origin = NULL,
      seasonal = NULL,
      count = FALSE
    )
  expect_equal(class(PAM), "PresenceAbsence")
expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
})



test_that("lets.presab return a correct PresenceAbsence object for the world", {
  skip_on_cran()
  
  PAM <- lets.presab(Phyllomedusa, resol=5, remove.cells=TRUE,
                     remove.sp=TRUE, show.matrix=FALSE,
                     crs=terra::crs("+proj=longlat +datum=WGS84"),
                     cover=0, presence=NULL, origin=NULL,
                     seasonal=NULL, count=FALSE)
  
  expect_equal(class(PAM), "PresenceAbsence")
  expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
  
  
})



test_that("lets.presab return a correct PresenceAbsence object (count=TRUE)", {
  skip_on_cran()
  
  PAM <- lets.presab(Phyllomedusa, xmn=-93, xmx=-29, ymn= -57, ymx=15,
                     resol=1, remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE,
                     crs=terra::crs("+proj=longlat +datum=WGS84"), cover=0, presence=NULL,
                     origin=NULL, seasonal=NULL, count=TRUE)
  
  expect_equal(class(PAM), "PresenceAbsence")
  expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
  
  
})


test_that("lets.presab return a correct PresenceAbsence object, cover=0.2", {
  skip_on_cran()
  
  PAM <- lets.presab(Phyllomedusa, xmn=-93, xmx=-29, ymn= -57, ymx=15,
                     resol=1, remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE,
                     crs=terra::crs("+proj=longlat +datum=WGS84"), cover=0.2, presence=NULL,
                     origin=NULL, seasonal=NULL, count=FALSE)
  
  expect_equal(class(PAM), "PresenceAbsence")
  expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
  
  
})

test_that("lets.presab return a correct PresenceAbsence object different projection, cover=0.2", {
  skip_on_cran()
  
  pro <- paste("+proj=eqdc +lat_0=-32 +lon_0=-60 +lat_1=-5",
               "+lat_2=-42 +x_0=0 +y_0=0 +ellps=aust_SA", 
               "+units=m +no_defs")
  SA_EC <- terra::crs(pro)
  PAM_proj <- lets.presab(shapes = Phyllomedusa,
                          xmn = -4135157,
                          xmx = 4707602,
                          ymn = -450000, 
                          ymx = 5774733,
                          resol = 100000,
                          crs.grid = SA_EC, cover = .9)
  
  expect_equal(class(PAM_proj), "PresenceAbsence")
  expect_true(is.matrix(PAM_proj[[1]]))
  expect_true(inherits(PAM_proj[[2]], "SpatRaster"))
  expect_equal(class(PAM_proj[[3]]), "character")
  
  
})


test_that("lets.presab return a correct PresenceAbsence object, remove.sp=FALSE", {
  skip_on_cran()
  
  PAM <- lets.presab(Phyllomedusa, xmn=-93, xmx=-29, ymn= -57, ymx=15,
                     resol=1, remove.cells=TRUE, remove.sp=FALSE, show.matrix=FALSE,
                     crs=terra::crs("+proj=longlat +datum=WGS84"), cover=0.2, presence=NULL,
                     origin=NULL, seasonal=NULL, count=FALSE)
  
  expect_equal(class(PAM), "PresenceAbsence")
  expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
  
  
  response <- summary(PAM)
  expect_true(response$Specieswithoutanypresence > 0)
  
})


test_that("lets.presab return a correct PresenceAbsence object, remove.cells=FALSE", {
  skip_on_cran()
  
  PAM <- lets.presab(Phyllomedusa, xmn=-93, xmx=-29, ymn= -57, ymx=15,
                     resol=1, remove.cells=FALSE, remove.sp=TRUE, show.matrix=FALSE,
                     crs=terra::crs("+proj=longlat +datum=WGS84"), cover=0, presence=NULL,
                     origin=NULL, seasonal=NULL, count=FALSE)
  
  expect_equal(class(PAM), "PresenceAbsence")
  expect_true(is.matrix(PAM[[1]]))
  expect_true(inherits(PAM[[2]], "SpatRaster"))
  expect_equal(class(PAM[[3]]), "character")
  
    
  response <- summary(PAM)
  expect_true(response$Cellswithoutanypresence > 0)
  
})




test_that("lets.presab new projection grid", {
  skip_on_cran()
  pro <- paste("+proj=eqdc +lat_0=-32 +lon_0=-60 +lat_1=-5",
               "+lat_2=-42 +x_0=0 +y_0=0 +ellps=aust_SA", 
               "+units=m +no_defs")
  PAM2 <- lets.presab(Phyllomedusa, 
                      xmn = -4135157,
                      xmx = 4707602,
                      ymn = -450000, 
                      ymx = 5774733,
                      resol = 100000, 
                      crs.grid =  pro,
                      count = TRUE)
  
  expect_equal(class(PAM2), "PresenceAbsence")
  expect_true(is.matrix(PAM2[[1]]))
  expect_true(inherits(PAM2[[2]], "SpatRaster"))
  expect_equal(class(PAM2[[3]]), "character")  
  
})

test_that("lets.presab stops when species names column is missing", {
  
  Phyllo2 <- Phyllomedusa
  names(Phyllo2)[1] <- "species_name"
  expect_error(
  lets.presab(Phyllo2)
  )

})
