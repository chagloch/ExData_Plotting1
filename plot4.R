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

##Convert data fields to numeric
data$Sub_metering_1 <- as.numeric(as.character(data$Sub_metering_1))
data$Sub_metering_2 <- as.numeric(as.character(data$Sub_metering_2))
data$Sub_metering_3 <- as.numeric(as.character(data$Sub_metering_3))
data$Global_active_power <- as.numeric(as.character(data$Global_active_power))
data$Global_reactive_power <- as.numeric(as.character(data$Global_reactive_power))
data$Voltage <- as.numeric(as.character(data$Voltage))

##open plot4.png 
png("plot4.png")

#make the graphing area a 2x2 grid
par(mfrow = c(2,2))

#Create the Top Left Graph in the 2x2 grid
plot(data$Date,data$Global_active_power, type = "n", xlab = "", ylab = 'Global Active Power')
lines(data$Date,data$Global_active_power)

#Create the Top Right Graph in the 2x2 grid
plot(data$Date,data$Voltage, type = "n", xlab = "datetime", ylab = 'Voltage')
lines(data$Date,data$Voltage)

#Create the Bottome Left Graph in the 2x2 grid
plot(data$Date,data$Sub_metering_1, type = "n", xlab = "", ylab = 'Energy sub metering')
lines(data$Date,data$Sub_metering_1, col= "black")
lines(data$Date,data$Sub_metering_2, col = "red")
lines(data$Date,data$Sub_metering_3, col = "blue")
legend("topright", col = c("black","red","blue"), bty= "n", lty = 1, legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#Create the Bottome Right Graph in the 2x2 grid
plot(data$Date,data$Global_reactive_power, type = "n", xlab = "datetime", ylab = 'Global_reactive_power')
lines(data$Date,data$Global_reactive_power)

#closes the file
dev.off()



