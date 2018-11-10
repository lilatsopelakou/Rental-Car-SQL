library(RMySQL)

#Load csv file to R
customer <-read.csv(file = "C:/Users/User/Desktop/Assignment_1_Customers.csv",
                    header=TRUE,sep=",",stringsAsFactors = FALSE)

#Connect to the DataBase
mydb <- dbConnect(MySQL(),user='root',password='Lt2091992!',
                  dbname='dmbi_assignment1',host='127.0.0.1')

#rs1 <- dbSendQuery(mydb, "SELECT * FROM customer")
data1 <- dbFetch(rs1,n=-1) 
names(customer_csv)<-names(data1) #make the csv's column names identical to the
#table's column names on the DataBase

#Populate the table from csv
dbWriteTable(mydb, name="Customer", value=customer_csv, overwrite=FALSE,
             append= TRUE,row.names=FALSE)

#Check if the table is filled in
rs2 <- dbSendQuery(mydb, "SELECT * FROM customer")
data2 <- dbFetch(rs2,n=-1)
head(data2)
str(data2)

dbClearResult(dbListResults(mydb)[[1]])
dbDisconnect(mydb)