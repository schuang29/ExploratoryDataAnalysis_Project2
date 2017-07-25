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

#Get the combustion entries from the Level One attribute
combustionEntries <- grepl("comb", SCCdata$SCC.Level.One, ignore.case=TRUE)

#Get the coal entries from theLevel Four attribute
coalEntries <- grepl("coal", SCCdata$SCC.Level.Four, ignore.case=TRUE) 

#Xref the two sets to find the common entries that are both coal and combustion
coalCombustionEntries <- (combustionEntries & coalEntries)

#Get the monitor # of the common entries
coalCombustionSCC <- SCCdata[coalCombustionEntries,]$SCC

#Xref to the NEI data to get the rows (readings) matching the SCC
coalCombustionNEI <- NEIdata[NEIdata$SCC %in% coalCombustionSCC,]

#plot the graph
ggp <- ggplot(coalCombustionNEI,aes(factor(year),Emissions/10^5)) +
    geom_bar(stat="identity",fill="grey",width=0.75) +
    theme_bw() +  guides(fill=FALSE) +
    labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
    labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

print(ggp)