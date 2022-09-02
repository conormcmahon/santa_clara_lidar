

# ********************************************************
# ***************** Load Data and Libraries ******************

library(raster)
library(here)

files_2015 <- list.files(path=here::here("data","veg_rasters_2015"), pattern="*histogram.tif")
files_2018 <- list.files(path=here::here("data","veg_rasters_2018"), pattern="*histogram.tif")



# ********************************************************
# ***************** Mosaicking Function ******************

# Add a new raster stack (from a file path) to an existing raster mosaic
#   At overlapping points, retains the maximum 
addImageToMosaic <- function(new_image_path, existing_image)
{
  print(paste("  Loading a new image from ",
              new_image_path), sep="")
  # If existing image is empty, just return the new image
  if(!hasValues(existing_image))
    return(stack(new_image_path))
  # Else, mosaic the two together
  raster::mosaic(stack(new_image_path), 
                 existing_image, 
                 fun=max)
}



# ********************************************************
# ***************** Generate 2015 Mosaic *****************

print(paste("Starting to construct raster for 2015 data, from ",
            length(files_2015), 
            " input rasters.", sep=""))
mosaic_2015 <- raster()
# There's probably a better way to do this without a for loop but I am too tired to think of it 
for(file in files_2015)
{
  mosaic_2015 <- addImageToMosaic(paste(here::here("data","veg_rasters_2015"), file, sep="/"),
                                  mosaic_2015)
}
writeRaster(mosaic_2015, here::here("outputs","histogram_2015_mosaic.tif"))




# ********************************************************
# ***************** Generate 2018 Mosaic *****************

print(paste("Starting to construct raster for 2018 data, from ",
            length(files_2018), 
            " input rasters.", sep=""))
mosaic_2018 <- raster()
# There's probably a better way to do this without a for loop but I am too tired to think of it 
for(file in files_2018)
{
  mosaic_2018 <- addImageToMosaic(paste(here::here("data","veg_rasters_2018"), file, sep="/"),
                                  mosaic_2018)
}
writeRaster(mosaic_2018, here::here("outputs","histogram_2018_mosaic.tif"))