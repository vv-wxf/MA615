# library(tidyverse)
# library(RSQLite)
# library(DBI)
# library(readxl)
# con<-dbConnect(SQLite(),"chinook.db")
# 
# dbGetQuery(con,"select FirstName,LastName from Customers where Country = 'Brazil';")
# 
# dbGetQuery(con,"select FirstName,LastName from customers where Country = 'Brazil';")


# hw

library(tidyverse)
library(readxl)

donars_des <- read_excel("Top MA Donors 2016-2020.xlsx",sheet = 1)
contrib_all <- read_excel("Top MA Donors 2016-2020.xlsx",sheet = 2)
JFC <- read_excel("Top MA Donors 2016-2020.xlsx",sheet = 3)

# contribid --A unique identifier for individual donors. 
contributors <- select(contrib_all,
                       contribid,fam,contrib,City,State,Zip,Fecoccemp,orgname,lastname)%>%distinct()

orgs <- select(contrib_all,orgname,ultorg)%>%distinct()

contribution <- select(contrib_all,
                       fectransid,contribid,date,amount,recipid,cycle,type,cmteid)%>%distinct()
recipients <- select(contrib_all,
                     recipid,recipient,party,recipcode,cmteid)%>%distinct()

mydb = dbConnect(SQLite(),"Political Contribution_vivian.sqlite")
dbWriteTable(mydb,"Contributor",contributors)
dbWriteTable(mydb,"Orgs",orgs)
dbWriteTable(mydb,"Contribution",contribution)
dbWriteTable(mydb,"Recipients",recipients)


