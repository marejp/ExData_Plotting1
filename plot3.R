############################################################################################
#
# Exploratory Data Analysis
# Project 1
# Plot 3
#
############################################################################################

myFile <- c("household_power_consumption.txt")

# Make sure we have the dataset
if (!file.exists(myFile)) {
  url1 <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
  download.file(url1,"household_power_consumption.zip")
  unzip("household_power_consumption.zip")
}

# Set up the filter to use when reading the data - was tested with Windows 7
# http://technet.microsoft.com/en-us/library/bb490907.aspx
pipestr = '"grep "^[1-2]/2/2007" myFile'
if(Sys.info()['sysname'] == 'Windows') {
  pipestr = paste("findstr /B /R ^[1-2]/2/2007 ", myFile)
}

# Read the data set. See the following link for more information:
# http://www.biostat.jhsph.edu/~rpeng/docs/R-large-tables.html
tab5rows <- read.table(myFile, header = TRUE,sep=";", nrows = 5)
hdrs <- names(tab5rows)
classes <- sapply(tab5rows, class)
dat <- read.table(pipe(pipestr), header = FALSE,sep=";", col.names = hdrs, colClasses = classes,  comment.char = "",na.strings = "?")

# Combine the date and time fields to create new field
dat$datetime <- strptime(paste(dat$Date, dat$Time), "%d/%m/%Y %H:%M:%S")

# Create the plot
yscale = range(c(dat$Sub_metering_1,dat$Sub_metering_2,dat$Sub_metering_3))
with(dat, plot(datetime,Global_active_power,ylim=yscale,xlab = "", ylab = "Energy sub metering", type="n"))
with(dat, lines(datetime,Sub_metering_1,ylim=yscale, col = "black", type = "l"))
with(dat, lines(datetime,Sub_metering_2,ylim=yscale, col = "red", type = "l"))
with(dat, lines(datetime,Sub_metering_3,ylim=yscale, col = "blue", type = "l"))
legend("topright", lty = 1, col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),cex = 0.6)

# Create PNG
dev.copy(png, file = "plot3.png",width = 480, height = 480, units = "px")
dev.off()
