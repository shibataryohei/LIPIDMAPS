library(tidyverse)
library(rvest)

html <- read_html("http://prime.psc.riken.jp/compms/msdial/lipidnomenclature.html")
html


html %>% 
  html_nodes("body") %>% # HTMLのbodyタグの情報を取り出す
  html_text() %>% 
  gsub("\t", "", .) %>% 
  strsplit(. , "\n\n\n") %>% 
  .[[1]] %>% 
  .[-1:-57] %>% 
  gsub("\n", "", .) -> Text

grep("\\[[A-Z]{2}\\]", Text) -> N_Category
  
Text[N_Category] -> Category
Text[N_Category+1] -> Mainclass
Text[N_Category+2] -> Subclass
Text[N_Category+3] -> Abbreviation

data.frame(Category, Mainclass, Subclass, Abbreviation) %>% 
  tbl_df -> LSN_tbw

write.csv(LSN_tbw, "LSN.csv",
          row.names = FALSE)
