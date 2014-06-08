##load required libraries
library(sqldf)

##Working directory must be set to the location of the household_power_consumption.txt file
wd <- getwd()

##combine fields to get full file path
file <- paste(wd,"/", "household_power_consumption.txt", sep="")

##Read in the Data file
data <- read.table(file, sep = ";", header = TRUE)

##Find the records that match only 2/1/2007 or 2/2/2007 and reduce the dataframe to only those records
data <- sqldf("select * from data where Date = '1/2/2007' or Date = '2/2/2007'")

##merge data and time to one column
data$Date <- paste(data$Date, data$Time)

##drop Time column
data <- data[,-match(c("Time"),names(data))]

##format date and time to a POSIXlt format
data$Date <- strptime(data$Date, format = "%d/%m/%Y %T")

##Convert Sub_meetering 1, 2 & 3 to numeric
data$Sub_metering_1 <- as.numeric(as.character(data$Sub_metering_1))
data$Sub_metering_2 <- as.numeric(as.character(data$Sub_metering_2))
data$Sub_metering_3 <- as.numeric(as.character(data$Sub_metering_3))

##open plot3.png 
png("plot3.png")

##make the graph, type="n" adds no lines
plot(data$Date,data$Sub_metering_1, type = "n", xlab = "", ylab = 'Energy sub metering')

##adds the data line to the graph
lines(data$Date,data$Sub_metering_1, col= "black")
lines(data$Date,data$Sub_metering_2, col = "red")
lines(data$Date,data$Sub_metering_3, col = "blue")

##add a legend
legend("topright", col = c("black","red","blue"), lty = 1, legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#closes the file
dev.off()


