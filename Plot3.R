#read the data frame, which is assumed to be in the data folder, please change accordingly
NEI <- readRDS("./data/summarySCC_PM25.rds")
#store the years to be analysed
years <- c(1999,2002,2005,2008)
#create empty matrix to store result
result <- data.frame(Year = integer(), type = character(), Pollutant = character(), Emissions = integer() )
#subset the data for Baltimore City, Maryland (fips == "24510")
NEIbyArea <- NEI[NEI$fips == "24510", ]
#run two for loops and subset, the first for loop subsets year and the second for loop subsets that year further by different type
for (i in years) {
  #subset the data by year
  NEIbyYrNdArea <- NEIbyArea[NEIbyArea$year == i, ]
  for(j in unique(NEIbyYrNdArea$type)) {
    #subset further by type
    NEIbyYrNdAreaNdType <- NEIbyYrNdArea[NEIbyYrNdArea$type == j, ]
    #store summary of subset in buffer
    buffer <- data.frame(Year = i, 
                         type = j, 
                         Pollutant = "PM25-PRI", 
                         Emissions = mean(NEIbyYrNdAreaNdType$Emissions, na.rm = TRUE) )
    #store result
    result <- rbind(result,buffer)
  }
}
#load ggplot2
require(ggplot2)
#draw the graph with qplot
resultPlot<- qplot(result$Year, result$Emissions, color=result$type, ylab = "Emission", xlab = "Year", main = "PM Emissions from 1999-2008 for Baltimore City") + geom_line()
#save ggplot, this will save a 400x400 file at 100 ppi
ggsave("./Plot3.png", width=7, height=5, dpi=100)