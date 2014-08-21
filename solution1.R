#Solution to Hands-On Exercise 1 (a package needs to be installed):

# 
# 1 Install package "nycflights13", which contains data about flights departing NYC in 2013
# 2 Load rCharts (first install it if you haven't yet)
# 3 Transform the data for the plot the purpose of which to show average departure delay time (in min) for each airline (carrier), grouped by airport of origin. You can use aggregate() to summarize, 
#   use melt() and dcast() from reshape2 package to make sure there's a line for every combination of airline and airport. And you can use merge() to connect the flights to airlines data sets to get the names of airlines. 
# 4 Using Highcharts library build a bar plot to show the mean departure delay by carrier, group it by origin, and use a relevant title, for example "Average Delay Time by Carrier"
# 5 Rename the y-axis and x-axis default values to be descriptive
# 6 Make x-axis type equal "category" (because we have categorical data mapped to x, even though it will be visually seem like y-axis)
# 7 Change the width of the chart to be 700px and height - 600px
library(nycflights13)
library(rCharts)
library(reshape2)
delayed <- aggregate(flights$dep_delay, by=list(carrier = flights$carrier, origin = flights$origin), mean, na.rm = TRUE)
delayed <- melt(dcast(delayed, carrier ~ origin, value.var = "x", sum), id="carrier")
delayed <- merge(delayed, airlines)
names(delayed) <- c("carrier", "origin", "delay", "name")
delayed$delay <- round(delayed$delay, digits = 1)
delayedPlot <- hPlot(x="name", y="delay", type="bar", group = "origin", data=delayed, title = "Average Delay Time by Carrier")
delayedPlot$xAxis(type = "category", title = list(text = "Delay in Min"))
delayedPlot$yAxis(title = list(text = "Carrier"))
delayedPlot$chart(width = 700, height = 600)
delayedPlot
###Solution to Hands-On Exercise 2 (R native data set is used):
# 1 Load rCharts (first install it if you haven't yet)
# 2 Transform the "mtcars" data set for the plot, the purpose of which is to show average mpg grouped by number of cylinders and transmission type (automatic vs. manual).
#   Feel free to use your preferred method of transformation. You can use aggregate() to summarize, use melt() and dcast() from reshape2 package to make sure there's a 
#   line for every combination of cylinders and transmission (this might not be necessary). 
# 3 Using Highcharts library build a bar plot to show the mean mpg by number of cylinders,  group it by transmission, and use a relevant title, for example "Average MPG by Number of Cylinders"
# 4 Rename the y-axis and x-axis default values to be descriptive
# 5 Make x-axis type equal "category" (because we have categorical data mapped to x, even though it will be visually seem like y-axis)
# 6 Change the width of the chart to be 700px and height - 600px
library(rCharts)
carsdata <- aggregate(mtcars$mpg, by=list(cylinder = mtcars$cyl, transmission = mtcars$am), mean, na.rm = TRUE)
names(carsdata) <- c("cylinder", "transmission", "mpg")
carsdata$mpg <- round(carsdata$mpg, digits = 1)
carsdata$cylinder <- factor(carsdata$cylinder)
carsdataPlot <- hPlot(x="cylinder", y="mpg", type="bar", group = "transmission", data=carsdata, title = "Average MPG by Number of Cylinders")
carsdataPlot$xAxis(type = "category", title = list(text = "MPG"))
carsdataPlot$yAxis(title = list(text = "Cylinders"))
carsdataPlot$chart(width = 700, height = 600)
carsdataPlot