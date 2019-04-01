#read the data frame, which is assumed to be in the data folder, please change accordingly
NEI <- readRDS("./data/summarySCC_PM25.rds")
#read the Source Classification Code Table 
SccTable <- readRDS("./data/Source_Classification_Code.rds")
#subset motor
SccTableMotor<- SccTable[grep("Mobile", SccTable$EI.Sector), ]
#store scc motor in vector
SccMotor <- SccTableMotor[,"SCC"]
#subset NEI for motor
NEIMotor <- NEI[NEI$SCC %in% SccMotor, ] 
#create empty matrix to store result
result <- data.frame(Year = integer(), Pollutant = character(), Emissions = integer() )
#store the years to be analysed
years <- c(1999,2002,2005,2008)
#run for loop to subset by year
for (i in years) {
  #subset the data by year
  NEIMotorbyYr <- NEIMotor[NEIMotor$year == i, ]
  #store summary of subset in buffer
  buffer <- data.frame(Year = i, 
                       Pollutant = "PM25-PRI", 
                       Emissions = mean(NEIMotorbyYr$Emissions, na.rm = TRUE) )
  #store result
  result <- rbind(result,buffer)
}
#load ggplot2
require(ggplot2)
#draw the graph with qplot
resultPlot<- qplot(result$Year, result$Emissions,  ylab = "Emission", xlab = "Year", main = "PM Emissions from motors in Baltimore City") + geom_line()
#save ggplot, this will save a 400x400 file at 100 ppi
ggsave("./Plot5.png", width=7, height=5, dpi=100)