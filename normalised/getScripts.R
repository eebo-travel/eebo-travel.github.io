library(tidyverse)

d <- readLines("reactable2 copy.html")

# omit lines that are commented out
d <- d[-grep("^//#", d)]


d2 <- unlist(strsplit(paste0(d, collapse = " "), "<script>"))

for(i in 2:length(d2)) {
  if(i==2) {
    write.table(unlist(strsplit(d2[i], "</script>"))[1],
                "table_scripts.js", row.names=F, col.names=F, quote=F) 
  } else {
    write.table(unlist(strsplit(d2[i], "</script>"))[1],
                "table_scripts.js", row.names=F, col.names=F, quote=F,
                append = T)
  }
  
}

unlist(strsplit(d2[2], "</script>"))[1]

grep("<script", d)
grep("</script>", d)
