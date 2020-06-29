library(tidyverse)

read.csv("LIPIDMAPS_Raw.csv",
         header = FALSE) %>% 
  tbl_df %>% 
  dplyr::rename(Variable = V1) %>% 
  mutate(Variable = gsub(" ", " ", Variable)) %>% 
  separate(Variable, into = c("Variable", "ID"), sep = " \\[") %>% 
  mutate(ID = gsub("\\]", "", ID)) %>% 
  mutate(Number = str_sub(ID, start = 3),
         Class = str_sub(ID, start = 0, end = 2)) %>% 
  mutate(Category = if_else(nchar(Number) == 0, "Class",
                            if_else(nchar(Number) == 2,
                                    "Subclass", "Variable"))) %>%
  dplyr::select(-Number) -> LMSD_RAW_tbl

LMSD_RAW_tbl %>% 
  filter(Category == "Class") %>% 
  dplyr::rename(Class_abbr = Class,
                Class = Variable) %>% 
  dplyr::select(Class, Class_abbr) -> Class_tbw

LMSD_RAW_tbl %>% 
  filter(Category == "Subclass") %>% 
  dplyr::rename(Subclass = Variable,
                Class_abbr = Class) %>% 
  inner_join(., Class_tbw, by = "Class_abbr") %>% 
  dplyr::select(Class, Subclass, ID) -> Class_Subclass_tbw

LMSD_RAW_tbl %>% 
  filter(Category == "Variable") %>% 
  mutate(ID = str_sub(ID, end = 4)) %>% 
  dplyr::select(Variable, ID) %>% 
  inner_join(Class_Subclass_tbw, .) %>% 
  dplyr::select(-ID) -> LMSD_tbw

write.csv(LMSD_tbw, "LIPDMAPS.csv",
          row.names = FALSE)