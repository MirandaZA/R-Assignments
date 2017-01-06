rm(list = ls())
wd<- path.expand("~/Assignments/")
library(openxlsx)
library(dplyr)
library(tidyr)



# fileNamesList <- c("1106","1107","1108")
# CombineFiles<-function(fileNamesList){
#   df2<- data.frame()
#   for(i in 1:length(fileNamesList)){
#     #read file 
#     df1<- as.data.frame( read.csv(paste0(wd,fileNamesList[i]),header = FALSE,sep =";"))
#     #remove last row
#     df1<-df1[-nrow(df1),]
#     #Remove the first row 
#     df1<- df1[-1,]
#     #combine all files
#     df2<-rbind(df2,df1)
#   }
#   return (df2);
# }
# 
# 
# DataCleanUp<- function(){
#   
#   #call CombineFiles function that will return the data frame that contains all files
#   allFiles<- CombineFiles(fileNamesList)
#   
#   #Retrieve sales dates
#   columnNames <- colnames(allFiles)
#   dates<- columnNames[8:length(columnNames)]
#   numUniqueDates<- length(dates)/3
#   uniqueDates <- vector()
#   for(i in 0:numUniqueDates-1){
#     uniqueDates[i+1]<-dates[i*3 +1] 
#   }
#   
#   
#   #Change Column names
#   firstColNames <- c("SuppCd","SupplierName","SubDepartment","ProductCode","EAN","ProductDescription","Size")
#   numRows <- nrow(allFiles)
#   numCols<- ncol(allFiles)
#   
#   cn <-c("SalesExclVAT","SalesQuantity","GP(%)")
#   repeatedColNames <-(rep(cn,numUniqueDates))
#   colnames(allFiles)<-c(firstColNames,repeatedColNames)
#   
#   #Split allFiles data frame to productInfo and Sales info
#   productInfo <- allFiles[1:numRows,1:7]
#   salesInfo <- allFiles[1:numRows,8:numCols]
#   colnames(salesInfo)<-repeatedColNames
#   
#   
#   #Clean up data to a long format
#   finalDT<- data.frame()
#   for(j in 0:(length(uniqueDates)-1)){
#     sales<- salesInfo[1:numRows,(j*3 +1):((1+j)*3)] #daily sales 
#     Date<- rep(uniqueDates[j+1],numRows)
#     productAndSales <- cbind(productInfo,Date,sales) #Create a new data frame that has product info, dates and sales
#     finalDT<- rbind(finalDT,productAndSales)
#   }
#   return (finalDT);
# }
# 
# 
# cleanData <- DataCleanUp()
# #Writing output on an excel file
# wb <- createWorkbook("Clean Data")
# addWorksheet(wb = wb, sheetName = "Clean Data")
# writeDataTable(wb = wb, sheet = "Clean Data", x = cleanData,withFilter = FALSE)
# saveWorkbook(wb = wb, file = paste0(wd,"/Clean Data.xlsx"), overwrite = TRUE)
