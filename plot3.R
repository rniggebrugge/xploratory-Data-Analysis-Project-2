library(dplyr)
library(ggplot2)

# load data, files should be in current  working directory
#scc <- readRDS("Source_Classification_Code.rds")
#nei <- readRDS("summarySCC_PM25.rds")

#create a subset containing Baltimore data
baltimore <- subset(nei, fips =="24510")

# group by year and type                                           
yeartype              <- group_by(baltimore, year, type)

# summarize over the created groups, creating a sum of total 
#emissions per group (=per year/type combination)
development  <- summarize(yeartype, emissions=sum(Emissions))

# plot the total emissions against year to see development. Force y-scale to start at 0
# in order to get realistic impression of increase/decrease relative to total amount. 

g <- ggplot(development, aes( year, emissions))
g <- g + geom_point(color="blue") + geom_line(color="#0099ff")
g <- g + facet_grid( . ~ type) + ggtitle("Baltimore ")
g <- g + theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(g)


# create png file of above create plot
dev.copy(png, file="plot3.png")
dev.off()
