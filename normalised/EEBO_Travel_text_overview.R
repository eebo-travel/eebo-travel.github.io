library(tidyverse)
library(knitr)
library(kableExtra)
library(reactable)
library(DT)

# read file
d <- read_csv("../docs/eebo_travel_selection.csv")

# d %>% select(TCP, Author, Date, Length) %>% setNames(c("ID", "Author", "Date", "Tokens")) %>% datatable() %>% saveWidget("table.html")
# d %>% select(TCP, Author, Date, Length) %>% setNames(c("ID", "Author", "Date", "Tokens")) %>% reactable


# # select relevant columns
d %>% select(TCP, Author, Title, Date, Length) %>% setNames(c("ID", "Author", "Title", "Date", "Tokens")) %>% 
   kbl() %>% kable_styling(bootstrap_options = c("striped", "hover", "condensed")) %>% scroll_box() %>% save_kable("overview_table.html")
