library(dplyr)
library(ggplot2)

# load data, files should be in current  working directory
# scc <- readRDS("Source_Classification_Code.rds")
# nei <- readRDS("summarySCC_PM25.rds")

#create a subset containing Baltimore data
baltimore_la <- subset(nei, fips =="24510" | fips=="06037")

# Further subsetting the Baltimore dataset to only include
# emissions from motor vehicles.
#
# First find the matching rows in scc dataframe: 
rownumbers <- grep("[Mm]otor|[Vv]ehicle", scc$SCC.Level.Three)

# Then get the associated SCC-codes from scc dataframe
mv_sources <- scc[rownumbers,][,1]

# Finally subsetting Baltimore dataset, to only include emissions
# from the Motor Vehicles sources:
mv_sub <- subset(baltimore_la, SCC %in% mv_sources)


mv_sub$city <- factor(mv_sub$fips, labels=c("Los Angeles","Baltimore"))

# group by year                                           
years_city <- group_by(mv_sub , year, city)

# summarize over the created groups, creating a sum of total emissions 
# per group (=per year and per city)
development  <- summarize(years_city, emissions=sum(Emissions))

# Now in order to compare changes, we need to normalize the results.
# For both countries I will use 1999 to index all values against.		
la_index <- subset(development, city=="Los Angeles" & year==1999)[,3][[1]]/100
bt_index <- subset(development, city=="Baltimore" & year==1999)[,3][[1]]/100

# With these index values, let's create a new column with the indices for 
# each city, for each year. By definition 1999 will get index 100 for both.
development <- mutate(development, 
		emission_index = ifelse(city=="Los Angeles", emissions/la_index, emissions/bt_index)) 

# Finally plot the results, using the city field to create two facets.
g <- ggplot(development, aes( year, emission_index , index))
g <- g + geom_point(color="blue") + geom_line(color="#0099ff")
g <- g + facet_grid( . ~ city) 
g <- g + theme(axis.text.x = element_text(angle = 45, hjust = 1))
g <- g + labs(y = "Emissions (1999 = index)")

print(g)

# create png file of above create plot
dev.copy(png, file="plot6.png")
dev.off()
