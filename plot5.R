library(dplyr)

# load data, files should be in current  working directory
#scc <- readRDS("Source_Classification_Code.rds")
#nei <- readRDS("summarySCC_PM25.rds")

#create a subset containing Baltimore data
baltimore <- subset(nei, fips =="24510")

# Further subsetting the Baltimore dataset to only include
# emissions from motor vehicles.
#
# First find the matching rows in scc dataframe: 
rownumbers <- grep("[Mm]otor|[Vv]ehicle", scc$SCC.Level.Three)

# Then get the associated SCC-codes from scc dataframe
mv_sources <- scc[rownumbers,][,1]

# Finally subsetting Baltimore dataset, to only include emissions
# from the Motor Vehicles sources:
mv_sub <- subset(baltimore, SCC %in% mv_sources)

# group by year                                           
years <- group_by(mv_sub , year)

# summarize over the created groups, creating a sum of total emissions per group (=per year)
development  <- summarize(years, emissions=sum(Emissions))

# plot the total emissions against year to see development. Force y-scale to start at 0
# in order to get realistic impression of increase/decrease relative to total amount. 
with( development, plot(year, emissions, type="l", col="blue", lwd=4, 
		main="Baltimore - Motorized Vehicles",ylim=c(0,max(emissions))))

# create png file of above create plot
dev.copy(png, file="plot5.png")
dev.off()
