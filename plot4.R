## This function downloads the household power consumption data set from the internet
## and plots four graphs for the available data from 2007-02-01 to 2007-02-02 into
## one png file. The graphs are:
## Top left: Global active power vs. time
## Top right: Voltage vs. time
## Bottom Left: Energy sub metering vs. time
## Bottom right: Global reactive power vs. time

plot4 <- function() {
  
  ## Set the locale to English for correct weekday abbreviations
  Sys.setlocale("LC_TIME", "English")
  
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
  
  ## Convert the literal dates and times to the R date/time format
  relevant_data$datetime <- as.POSIXct(paste(relevant_data$Date, relevant_data$Time), format="%d/%m/%Y %H:%M:%S")
  
  ## Remove the original date and time data from memory
  relevant_data$Date <- NULL
  relevant_data$Time <- NULL
  
  ## Open the destination file "plot4.png" for plotting
  png("plot4.png", width = 480, height = 480)

  ## Set the plotting areas and order. Top left first, then bottom left, etc.
  par(mfcol = c(2, 2))
  
  ## Global active power vs. time graph
  ## Plot an empty graph first, then add the data lines
  y_lab <- "Global Active Power (kilowatts)"
  with(relevant_data, plot(datetime, Global_active_power, type = "n", xlab = "", ylab = y_lab))
  with(relevant_data, lines(datetime, Global_active_power, type="l"))

  ## Energy Sub Metering vs. time graph
  ## Plot an empty graph first, then add the data lines
  y_lab <- "Energy sub metering"
  with(relevant_data, plot(datetime, Sub_metering_1, type = "n", xlab = "", ylab = y_lab))
  with(relevant_data, lines(datetime, Sub_metering_1, type="l"))
  with(relevant_data, lines(datetime, Sub_metering_2, type="l", col = "red"))
  with(relevant_data, lines(datetime, Sub_metering_3, type="l", col = "blue"))
  
  ## Plot the legend
  legend_labels <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
  legend_colors <- c("black", "red", "blue")
  legend("topright", legend = legend_labels, col = legend_colors,
         lty = 1, bg = "transparent", box.col = "transparent", cex = 0.95)
  
  ## Global voltage vs. time graph
  ## Plot an empty graph first, then add the data lines
  with(relevant_data, plot(datetime, Voltage, type = "n"))
  with(relevant_data, lines(datetime, Voltage, type="l"))

  ## Global reactive power vs. time graph
  ## Plot an empty graph first, then add the data lines
  with(relevant_data, plot(datetime, Global_reactive_power, type = "n"))
  with(relevant_data, lines(datetime, Global_reactive_power, type="l"))

  ## Close the output file
  dev.off()
}
