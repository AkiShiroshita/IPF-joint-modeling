
# Setting-up --------------------------------------------------------------

packages = c("devtools",
             "usethis",
             "here",
             "readr",
             "readxl",
             "tidyverse",
             "tidylog",
             "lubridate",
             "ggplot2",
             "tidylog",
             "ggplotgui",
             "ggthemes",
             "arsenal")
package.check <- lapply(packages, FUN = function(x){
  if (!require(x, character.only = TRUE)){
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

getwd()
rm(list=ls())
#file.edit("xxx")
#source(here("cleaning","xxx.R"))
#load(here("statistical_analysis","xxx.R"))

# Data import -------------------------------------------------------------

# from DWH between April 1, 2019 and August 5, 2022

dpc_2019 <- read_csv("input/dpc_2019.csv", 
                     locale = locale(encoding = "SHIFT-JIS")) %>% 
  mutate_all(.funs = ~ as.character(.))
dpc_2020 <- read_csv("input/dpc_2020.csv", 
                     locale = locale(encoding = "SHIFT-JIS")) %>% 
  mutate_all(.funs = ~ as.character(.))
dpc_2021 <- read_csv("input/dpc_2021.csv", 
                     locale = locale(encoding = "SHIFT-JIS")) %>% 
  mutate_all(.funs = ~ as.character(.))
dpc_2022 <- read_csv("input/dpc_2022.csv", 
                     locale = locale(encoding = "SHIFT-JIS")) %>% 
  mutate_all(.funs = ~ as.character(.))

dpc <- bind_rows(dpc_2019, dpc_2020, dpc_2021, dpc_2022) 

dpc %>% glimpse()

dpc_id_list <- dpc %>% 
  distinct(`患者ＩＤ`)

ipf <- dpc %>% 
  filter(`病名` == "特発性肺線維症") %>% 
  distinct(`患者ＩＤ`, .keep_all=TRUE) %>% 
  rename(id = `患者ＩＤ`)

# Drug --------------------------------------------------------------------

nintedanib_2019 <- read_csv("input/nintedanib_2019.csv", 
                            locale = locale(encoding = "SHIFT-JIS")) %>% 
  mutate_all(.funs = ~ as.character(.))
nintedanib_2020 <- read_csv("input/nintedanib_2020.csv", 
                            locale = locale(encoding = "SHIFT-JIS")) %>% 
  mutate_all(.funs = ~ as.character(.))
nintedanib_2021 <- read_csv("input/nintedanib_2021.csv", 
                            locale = locale(encoding = "SHIFT-JIS")) %>% 
  mutate_all(.funs = ~ as.character(.))
nintedanib_2022 <- read_csv("input/nintedanib_2022.csv", 
                            locale = locale(encoding = "SHIFT-JIS")) %>% 
  mutate_all(.funs = ~ as.character(.))

nintedanib <- bind_rows(nintedanib_2019, nintedanib_2020, nintedanib_2021, nintedanib_2022) %>% 
  distinct(`患者ID`, .keep_all=TRUE) %>% 
  mutate(nindetanib = 1) %>% 
  rename(id = `患者ID`)

pirfenidon_2019 <- read_csv("input/pirfenidon_2019.csv", 
                            locale = locale(encoding = "SHIFT-JIS")) %>% 
  mutate_all(.funs = ~ as.character(.))
pirfenidon_2020 <- read_csv("input/pirfenidon_2020.csv", 
                            locale = locale(encoding = "SHIFT-JIS")) %>% 
  mutate_all(.funs = ~ as.character(.))

pirfenidon <- bind_rows(pirfenidon_2019, pirfenidon_2020) %>% 
  distinct(`患者ID`, .keep_all=TRUE) %>% 
  mutate(pirfenidon = 1) %>% 
  rename(id = `患者ID`)

ipf <- left_join(ipf, nintedanib, by = "id")
