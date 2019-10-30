# hw

library(tidyverse)
library(readxl)
library(RSQLite)
library(DBI)

donars_des <- read_excel("Top MA Donors 2016-2020.xlsx",sheet = 1)
contrib_all <- read_excel("Top MA Donors 2016-2020.xlsx",sheet = 2)
JFC <- read_excel("Top MA Donors 2016-2020.xlsx",sheet = 3)


# data cleaning
## Turn full name into first name and delete all unnecessary part in the name
## delete the '.' at the end of the Fecoccemp
DF <- contrib_all %>% separate(contrib, c("last", "first"), ",") %>%
  separate(first, c("redundancy", "firstname"), " ") %>%
  dplyr::select(-redundancy,-last)
DF$Fecoccemp <- as.factor(gsub("\\.", "", DF$Fecoccemp))


# contribid --A unique identifier for individual donors. 
contributors <- select(DF,
                       contribid,fam,firstname,lastname,City,State,Zip,Fecoccemp,orgname)%>%distinct()

orgs <- select(DF,orgname,ultorg)%>%distinct()

contribution <- select(DF,
                       fectransid,contribid,date,amount,recipid,cycle,type,cmteid)%>%distinct()
recipients <- select(DF,
                     recipid,recipient,party,recipcode,cmteid)%>%distinct()

mydb = dbConnect(SQLite(),"Political Contribution_vivian.sqlite")
dbWriteTable(mydb,"Contributor",contributors)
dbWriteTable(mydb,"Orgs",orgs)
dbWriteTable(mydb,"Contribution",contribution)
dbWriteTable(mydb,"Recipients",recipients)


