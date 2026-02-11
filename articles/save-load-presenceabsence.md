# How to save and load a PresenceAbsence object

`PresenceAbsence` objects include SpatRaster objects that cannot be
saved directly into an RData external file. For this reason, we
developed specific functions (`lets.save` and `lets.load`) to save and
load `PresenceAbsence` objects in a similar fashion to the base
functions `save` and `load`.

``` r
library(letsR)

data(PAM) # Example data
lets.save(PAM, file = "PAM.RData") # save the PresenceAbsence object
PAM <- lets.load(file = "PAM.RData") # Load the PresenceAbsence object 
```
