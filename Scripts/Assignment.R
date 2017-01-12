setwd("~/GitHub/R-Assignments/Data")
wd<- path.expand("~/GitHub/R-Assignments/Data")
library(openxlsx)
library(dplyr)
library(tidyr)

#list of all files that need to be cleaned
file.list <- list.files()

DataCleanUP(file.list){
  #Cleans up each file in the file list and then combines all files into one file
  #   
  #Args:
  #   file.list: list of files that will be combined
  #Return:
  #   clean.file: data frame of all the cleaned up files
  clean.data.frame.list <- list(length=length(file.list))
  for(i in seq_len(length(file.list))){
    
    date.sales.spread <-as.data.frame( read.table(paste0(wd,"/",file.list[i]),header=FALSE, sep=";"))
    #Remove the last row i.e remove the overall sales calculations
    dates.product.info <- date.sales.spread[-nrow(date.sales.spread),]
    
    #%%%%%%%%%%%%Creating appropriate column names that will be in the format "date.salesInformation"%%%%%%%%%%%%%%#
    #Retrieve dates 
    dates <- as.data.frame.array( date.sales.spread[1, ])
    
    #retrieve sales information and removing space, dots and dashes in each column 
    sales.column.names <- as.data.frame.array(date.sales.spread[2, ])
    
    for(l in seq_len(length( sales.column.names))){
      sales.column.names[l] <- gsub(" ","",sales.column.names[l])
      sales.column.names[l] <- gsub("[.]","",sales.column.names[l])
      sales.column.names[l] <- gsub("[-]","",sales.column.names[l])
      if(l>7){
        #Putting together the column names 
        sales.column.names[l] <- paste0(dates[l],".",sales.column.names[l] )
        
      }
    }
    
    
    #Setting date.sales.sprea data frame's column names 
    names(date.sales.spread) <- sales.column.names
    
    #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Data frame structure clean up %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%# 
    
    #Remove the first 2 rows to remove the dates and sales information 
    date.sales.spread <-date.sales.spread[-(1:2), ]
    
    #Gather the date.sales.spread data frame by the date.SalesInfo
    gather.date.sales <- gather( data = date.sales.spread, key = SalesDate, value = Value,-SuppCd,-SupplierName,-SubDepartment,
                                 -ProductCode,-EAN,-ProductDescription,-Size)
    
    #Separate the date and sales Info
    separate.date.sales <- gather.date.sales %>% separate( data = SalesDate, into = c("Date","SalesInfo"), sep = ".")
    
    #Spread the separate.date.sales date frame by date and sales information, this is the final clean data frame 
    spread.date.sales <- spread( separate.date.sales, SalesInfo)
    
    #Add the cleaned up data frames to the list 
    clean.data.frame.list[i] <- spread.date.sales
    
    
  }
  
  #rbind the data frames in the list into one big data frame
  clean.files<- as.data.frame(bind_rows(data.frame.list))
  
  return(clean.files);
}




cleanData <- DataCleanUp(file.list)
#Writing output on an excel file
wb <- createWorkbook("Clean Data")
addWorksheet(wb = wb, sheetName = "Clean Data")
writeDataTable(wb = wb, sheet = "Clean Data", x = cleanData,withFilter = FALSE)
saveWorkbook(wb = wb, file = paste0(wd,"/Clean Data.xlsx"), overwrite = TRUE)

#I'm trying out these branching thing, don't mind me. 
