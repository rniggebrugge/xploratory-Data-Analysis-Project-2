library(dplyr)

# load data, files should be in current  working directory
#scc <- readRDS("Source_Classification_Code.rds")
#nei <- readRDS("summarySCC_PM25.rds")

#create a subset containing Baltimore data
baltimore <- subset(nei, fips =="24510")

# group by year                                           #
years              <- group_by(baltimore, year)

# summarize over the created groups, creating a sum of total emissions per group (=per year)
development  <- summarize(years, emissions=sum(Emissions))

# plot the total emissions against year to see development. Force y-scale to start at 0
# in order to get realistic impression of increase/decrease relative to total amount. 
with( development, plot(year, emissions, type="l", col="blue", lwd=4, 
		main="Baltimore",ylim=c(0,max(emissions))))

# create png file of above create plot
dev.copy(png, file="plot2.png")
dev.off()
