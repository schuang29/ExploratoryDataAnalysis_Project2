setwd("D:/GitHub/ExploratoryDataAnalysis_Project2")

if(!(file.exists("summarySCC_PM25.rds") && 
     file.exists("Source_Classification_Code.rds"))) { 
    
    fileName <- "NEI_data.zip"
    if(!file.exists(fileName)) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(url=fileURL,destfile=fileName,mode="wb")
    }  
    unzip(dataFile) 
}


# Load up the data frames
NEIdata <- readRDS("summarySCC_PM25.rds")
SCCdata <- readRDS("Source_Classification_Code.rds")

#Load up the plotting libraries that we need
library(ggplot2)
library(plyr)

#Aggregate the Emissions data
NEIdataBaltimore<-subset(NEIdata, fips == "24510")
emmissionsTotal <- aggregate(Emissions ~ year, NEIdataBaltimore, sum)

#Plot the graph
barplot(
    (emmissionsTotal$Emissions)/10^6,
    names.arg=emmissionsTotal$year,
    xlab="Year",
    ylab="PM2.5 Emissions (10^6 Tons)",
    main="Total PM2.5 Emissions of Baltimore City, MD"
)