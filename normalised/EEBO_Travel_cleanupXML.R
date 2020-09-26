library(tidyverse)



# list files --------------------------------------------------------------

f <- list.files("varded(50%) - Changes Tagged/", full.names = T, pattern = "vrt")
f2 <-list.files("../files/", full.names = T, pattern = "xml")[1:length(f)]

# check that IDs are equal:
# gsub(".*/|\\.vrt", "", f) == gsub(".*/", "", f2)

for(fl in 212:length(f)) {
  
  
  # read data ---------------------------------------------------------------
  
  t1 <- readLines(f[fl])
  t2 <- readLines(f2[fl])
  
  
  
  # replace header ----------------------------------------------------------
  
  header_start <- grep("<teiHeader>", t1)
  header_end   <- grep("</teiHeader>", t1)
  
  header_start2 <- grep("<teiHeader>", t2)
  header_end2   <- grep("</teiHeader>", t2)
  
  # convert header to flat xml
  
  h <- t2[header_start2:header_end2]
  
  # get source description
  sd_s <- grep("<sourceDesc>", h)
  sd_e <- grep("</sourceDesc>", h)
  sd <- h[sd_s:sd_e]
  
  # get title and author
  title_long <- gsub(".*<title>|</title>", "", sd[grep("<title>", sd)[1]])
  title_short <- gsub(".*<title>|</title>", "", sd[grep("<title>", sd)[2]])
  
  authors <- trimws(gsub("<.*?>", "", grep("<author", sd, value = T)))
  if(length(authors)>1) {
    authors <- paste0(authors, collapse = "; ")
  }
  
  # get publisher and publication place
  publisher <- trimws(gsub("<.*?>", "", grep("<publisher>", sd, value=T)))
  
  if(length(publisher)>1) {
    publisher <- paste0(publisher, collapse = "; ")
  }
  
  pubPlace <- trimws(gsub("<.*?>", "", grep("<pubPlace>", sd, value=T)))
  
  if(length(pubPlace)>1) {
    pubPlace <- paste0(pubPlace, collapse = "; ")
  }
  
  # get edition statement & date
  es_s <- grep("<editionStmt>", h)
  es_e <- grep("</editionStmt>", h)
  es <- h[es_s:es_e]
  dates <- trimws(gsub("<.*?>", "", grep("<date", es, value = T)))
  
  # get publication ID
  id <- gsub("\\..*", "", gsub(".*/", "", f[fl]))
  
  
  
  # in the text, replace normalized words by their
  # original and add a column with the normalized variant
  
  nml <- grep("<normalised", t1)
  nml2 <- grep("</normalised", t1)
  
  # list of all rows with normalised variants
  all_nml <- unlist(sapply(1:length(nml), function(i) nml[i]:nml2[i]))
  
  # list of all rows that start with <
  all_brackets <- grep("^<", t1)
  
  # the entire rest
  rest <- (1:length(t1))[-c(all_nml, all_brackets)]
  
  # for all rows that are not normalized,
  # copy&paste the original word from the first column
  t1[rest] <-  sapply(1:length(rest), function(i)  paste0(gsub("\t.*", "", t1[rest[i]]), "\t", t1[rest[i]], collapse=""))
  
  
  # in the first row after the normalization tag,
  # add the original word.
  # In some cases, one word is split up in two 
  # over the course of normalization,
  # e.g. shalbe > shall be.
  # In this case, it is repeated but with a marker:
  # Is is inserted in three brackets.
  
  t1[nml+1] <- sapply(1:length(nml), function(i) paste0(gsub("\".*", "", gsub("<normalised orig=\"", "", t1[nml[i]])), "\t", t1[(nml[i]+1)], collapse = "\t"))
  
  # normalizations spanning more than 1 token:
  nml_more_than_one <- which(nml2 != nml+2)
  
  if(length(nml_more_than_one)>0) {
    for(j in 1:length(nml_more_than_one)) {
      # rows to replace
      to_replace <- (nml[nml_more_than_one[j]]+2):(nml2[nml_more_than_one[j]]-1)
      
      for(i in 1:length(to_replace)) {
        t1[to_replace[i]] <- paste0(paste0("(((", gsub("\".*", "", gsub("<normalised orig=\"", "", t1[nml[nml_more_than_one[j]]])), ")))"), "\t", t1[to_replace[i]], collapse="")
        
      }
    }
    
  }
  
  
  
  # remove all "normalised" tags
  t1 <- t1[-c(nml, nml2)]
  
  # extract just the text from t1
  text_start <- grep("<text( |>)", t1, value=F)[1]
  t1b <- t1[text_start:length(t1)]
  
  
  # add language tags
  langs <- grep("xml:lang", t1b, value = F)
  
  for(i in 1:length(langs)) {
    # get current language
    l1 <- gsub(".*xml\\:lang=\"|\">", "", t1b[langs[i]])
    
    # find all that do not begin with < in current span
    if(i < length(langs)) {
      cur <- langs[i]:langs[i+1]
    } else {
      cur <- langs[i]:length(t1b)
    }
    
    cur <- cur[grep("^<", t1b[cur], invert = T)]
    t1b[cur] <- paste(t1b[cur], l1, sep = "\t")
  }
  
  
  
  
  
  # omit TEI closing tag
  t1b <- t1b[which(t1b!="</TEI>")]
  
  # add VRT header with metadata
  h1 <- "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  h2 <- paste0("<text id=\"", id, "\" title=\"", title_long, "\" title_short=\"", 
               title_short, "\" author=\"", authors, "\" publisher=\"", publisher ,
               "\" date=\"", dates,  "\" pubPlace=\"", pubPlace, "\">")
  
  
  # combine all elements
  c(h1,
    h2,
    t1b,
    "</text>") %>% write.table(paste0("vrt/", id, ".vrt"),
                               col.names = F, row.names = F,
                               quote = F)
  
  print(fl)
  
}


# # read data ---------------------------------------------------------------
# 
# t1 <- readLines(f[1])
# t2 <- readLines(f2[1])
# 
# 
# 
# # replace header ----------------------------------------------------------
# 
# header_start <- grep("<teiHeader>", t1)
# header_end   <- grep("</teiHeader>", t1)
# 
# header_start2 <- grep("<teiHeader>", t2)
# header_end2   <- grep("</teiHeader>", t2)
# 
# # convert header to flat xml
# 
# h <- t2[header_start2:header_end2]
# 
# # get source description
# sd_s <- grep("<sourceDesc>", h)
# sd_e <- grep("</sourceDesc>", h)
# sd <- h[sd_s:sd_e]
# 
# # get title and author
# title_long <- gsub(".*<title>|</title>", "", sd[grep("<title>", sd)[1]])
# title_short <- gsub(".*<title>|</title>", "", sd[grep("<title>", sd)[2]])
# 
# authors <- trimws(gsub("<.*?>", "", grep("<author", sd, value = T)))
# if(length(authors)>1) {
#   authors <- paste0(authors, collapse = "; ")
# }
# 
# # get publisher and publication place
# publisher <- trimws(gsub("<.*?>", "", grep("<publisher>", sd, value=T)))
# 
# if(length(publisher)>1) {
#   publisher <- paste0(publisher, collapse = "; ")
# }
# 
# pubPlace <- trimws(gsub("<.*?>", "", grep("<pubPlace>", sd, value=T)))
# 
# if(length(pubPlace)>1) {
#   pubPlace <- paste0(pubPlace, collapse = "; ")
# }
# 
# # get edition statement & date
# es_s <- grep("<editionStmt>", h)
# es_e <- grep("</editionStmt>", h)
# es <- h[es_s:es_e]
# dates <- trimws(gsub("<.*?>", "", grep("<date", es, value = T)))
# 
# # get publication ID
# id <- gsub("\\..*", "", gsub(".*/", "", f[1]))
# 
# 
# 
# # in the text, replace normalized words by their
# # original and add a column with the normalized variant
# 
# nml <- grep("<normalised", t1)
# nml2 <- grep("</normalised", t1)
# 
# # list of all rows with normalised variants
# all_nml <- unlist(sapply(1:length(nml), function(i) nml[i]:nml2[i]))
# 
# # list of all rows that start with <
# all_brackets <- grep("^<", t1)
# 
# # the entire rest
# rest <- (1:length(t1))[-c(all_nml, all_brackets)]
# 
# # for all rows that are not normalized,
# # copy&paste the original word from the first column
# t1[rest] <-  sapply(1:length(rest), function(i)  paste0(gsub("\t.*", "", t1[rest[i]]), "\t", t1[rest[i]], collapse=""))
# 
# 
# # in the first row after the normalization tag,
# # add the original word.
# # In some cases, one word is split up in two 
# # over the course of normalization,
# # e.g. shalbe > shall be.
# # In this case, it is repeated but with a marker:
# # Is is inserted in three brackets.
# 
# t1[nml+1] <- sapply(1:length(nml), function(i) paste0(gsub("\".*", "", gsub("<normalised orig=\"", "", t1[nml[i]])), "\t", t1[(nml[i]+1)], collapse = "\t"))
# 
# # normalizations spanning more than 1 token:
# nml_more_than_one <- which(nml2 != nml+2)
# 
# 
# for(j in 1:length(nml_more_than_one)) {
#   # rows to replace
#   to_replace <- (nml[nml_more_than_one[j]]+2):(nml2[nml_more_than_one[j]]-1)
#   
#   for(i in 1:length(to_replace)) {
#     t1[to_replace[i]] <- paste0(paste0("(((", gsub("\".*", "", gsub("<normalised orig=\"", "", t1[nml[nml_more_than_one[j]]])), ")))"), "\t", t1[to_replace[i]], collapse="")
#     
#   }
# }
# 
# 
# # remove all "normalised" tags
# t1 <- t1[-c(nml, nml2)]
# 
# # extract just the text from t1
# text_start <- grep("<text( |>)", t1, value=F)[1]
# t1b <- t1[text_start:length(t1)]
# 
# 
# # add language tags
# langs <- grep("xml:lang", t1b, value = F)
# 
# for(i in 1:length(langs)) {
#   # get current language
#   l1 <- gsub(".*xml\\:lang=\"|\">", "", t1b[langs[i]])
#   
#   # find all that do not begin with < in current span
#   if(i < length(langs)) {
#     cur <- langs[i]:langs[i+1]
#   } else {
#     cur <- langs[i]:length(t1b)
#   }
#   
#   cur <- cur[grep("^<", t1b[cur], invert = T)]
#   t1b[cur] <- paste(t1b[cur], l1, sep = "\t")
# }
# 
# 
# 
# 
# 
# # omit TEI closing tag
# t1b <- t1b[which(t1b!="</TEI>")]
# 
# # add VRT header with metadata
# h1 <- "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
# h2 <- paste0("<text id=\"", id, "\" title=\"", title_long, "\" title_short=\"", 
#        title_short, "\" author=\"", authors, "\" publisher=\"", publisher ,
#        "\" date=\"", dates,  "\" pubPlace=\"", pubPlace, "\">")
# 
# 
# # combine all elements
# c(h1,
#   h2,
#   t1b,
#   "</text>") %>% write.table(paste0("vrt/", id, ".vrt"),
#                              col.names = F, row.names = F,
#                              quote = F)
# 
# 
