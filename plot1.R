## This function downloads the household power consumption data set from the internet
## and plots a histogram of global active power (in kilowatts) for the available data
## from 2007-02-01 to 2007-02-02.

## We use the lubridate package for easy date conversions
library(lubridate)

plot1 <- function() {

  ## Download and extract the raw data file, if it doesn't exist

  if(! file.exists("household_power_consumption.txt")) {
    if(! file.exists("household_power_consumption.zip")) {
      url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(url, destfile="household_power_consumption.zip", method="curl")
    }
    unzip("household_power_consumption.zip")
  }

  ## Read the raw data
  raw_data <- read.csv("household_power_consumption.txt", sep = ";", na.strings = "?")
  
  ## Keep all rows with a date between 2007-02-01 and 2007-02-02
  relevant_data <- raw_data[raw_data$Date == "1/2/2007" | raw_data$Date == "2/2/2007",]
  
  ## Remove the raw data from memory
  rm(raw_data)
  
  ## Plot the global active power histogram into the file "plot1.png"
  png("plot1.png", width = 480, height = 480)
  hist(relevant_data$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col="red")
  dev.off()
}

