# This script strips away all XML tags that are
# not needed in the VRT files.

library(tidyverse)

# list of files -----------------------------------------------------------

f <- list.files("vrt/", full.names = T)


# get text ----------------------------------------------------------------

for(i in 1:length(f)) {
  
  tx <- readLines(f[i])
  
  # find all <g ...> tags
  g <- grep("<g .*/>", tx)
  pb <- grep("<pb.*/>", tx)
  fg  <- grep("<figure/>", ty)
  
  if(length(g) > 0) {
    tx <- tx[-c(g, pb, fg)]
  }
  
  write.table(tx,
              paste0("vrt2/", gsub(".*/", "", f[i])),
              row.names = F, col.names = F, quote = F)
  
  print(i)
}
