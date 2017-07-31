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

summary(SCCdata)

# Subset the data by vehicles
vehicles <- grep("vehicle", SCCdata$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCCdata[vehicles,]$SCC
vehiclesNEI <- NEIdata[NEIdata$SCC %in% vehiclesSCC,]

#Subset the Emissions data from Baltimore City and add column to capture city name
VehicleNEIdataBaltimore<-vehiclesNEI[vehiclesNEI$fips=="24510",]
VehicleNEIdataBaltimore$city <- "Baltimore City"

#Subset the Emissions data from LA and add column to capture city name
VehicleNEIdataLosAngeles<-vehiclesNEI[vehiclesNEI$fips=="06037",]
VehicleNEIdataLosAngeles$city <- "Los Angeles County"

#Combine both datasets
NEIBaltimoreAndLosAngeles <- rbind(VehicleNEIdataBaltimore, VehicleNEIdataLosAngeles)

#Plot the graph
ggp <- ggplot(NEIBaltimoreAndLosAngeles,aes(x=factor(year),y=Emissions, fill=city)) +
    geom_bar(stat="identity",aes(fill=year)) +
    facet_grid(~city) +
    theme_bw() +  guides(fill=FALSE) +
    labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
    labs(title=expression("PM"[2.5]*" Motor Vehicle Emissions in Baltimore and LA from 1999-2008"))

print(ggp)
