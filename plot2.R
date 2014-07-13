############################################################################################
#
# Exploratory Data Analysis
# Project 1
# Plot 2
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
with(dat, plot(datetime,Global_active_power,xlab = "", ylab = "Global Active Power (kilowatts)", type="l"))

# Create the png file
dev.copy(png, file = "plot2.png",width = 480, height = 480, units = "px")
dev.off()
