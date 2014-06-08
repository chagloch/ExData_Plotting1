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

##Convert Global Active Power to numeric
data$Global_active_power <- as.numeric(as.character(data$Global_active_power))

##open plot1.png 
png("plot1.png")

#plots the histogram
hist(data$Global_active_power, col = "red", main = "Global Active Power", xlab = 'Global Active Power (kilowatts)')

#closes the file
dev.off()


