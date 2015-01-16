library(dplyr)
library(ggplot2)

# load data, files should be in current  working directory
# scc <- readRDS("Source_Classification_Code.rds")
# nei <- readRDS("summarySCC_PM25.rds")

# create a subset containing sources related to coal combustion
#  Not an expert myself and after having looked at the data, I 
# decided that the applicable sources have both the words
# "Coal" and "Combustion" as value for SCC$Short.Name
#
# First find the matching rows: 
rownumbers <- grep("[Cc]oal.*[Cc]ombustion", scc$Short.Name)

# Then get the associated SCC-codes from scc dataframe
cc_sources <- scc[rownumbers,][,1]

# Finally subsetting nei dataframe, to only include emissions
# from the Coal Combustion associated sources:
cc_sub <- subset(nei, SCC %in% cc_sources)

# group by year                                            
year <- group_by(cc_sub, year)

# summarize over the created groups, creating a sum of total 
#emissions per group (=per year)
development  <- summarize(year, emissions=sum(Emissions))

# plot the total emissions against year to see development. Force y-scale to start at 0
# in order to get realistic impression of increase/decrease relative to total amount. 
with( development, plot(year, emissions, type="l", col="blue", lwd=4, 
		 main="Coal Combustion related", ylim=c(0,max(emissions))))

# create png file of above create plot
dev.copy(png, file="plot4.png")
dev.off()
