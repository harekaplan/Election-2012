## Make sure your working directory is set to the Plots folder
## (The folder containing Plots.R)
## setwd("Code/Plots")
source("../MergedCleanup.R")

dates <- c(as.Date("2012-8-11", format="%Y-%m-%d"),
           as.Date("2012-8-28", format="%Y-%m-%d"),
           as.Date("2012-9-4", format="%Y-%m-%d"),
           as.Date("2012-9-17", format="%Y-%m-%d"),
           as.Date("2012-10-3", format="%Y-%m-%d"),
           as.Date("2012-11-6", format="%Y-%m-%d"))
special.dat <- data.frame(x = dates, label = 1:6)

bucketPlotCount <- ggplot(bucket.data) +
    geom_bar(aes(x=factor(bucket2, levels = c("ad", "direct contact", "overhead", "swag", "other")), y=count, fill=bucket2), stat = "identity", show_guide=FALSE, width=.75) +
    xlab("Bucket") +
    ylab("Number of Expenditures") +
    scale_y_log10(label = math_format(format = log10)) +
    scale_fill_brewer(palette="Set1") +
    theme_bw()

bucketPlotSum <- ggplot(bucket.data) +
    geom_bar(aes(x=factor(bucket2, levels = c("ad", "direct contact", "overhead", "swag", "other")), y=sum, fill=bucket2), stat = "identity", show_guide=FALSE, width=.75) +
    xlab("Bucket") +
    ylab("Sum of Expenditure Amounts (Log 10)") +
    scale_y_log10(label = math_format(format = log10)) +
    scale_fill_brewer(palette="Set1") +
    theme_bw()

temporalPlot <- ggplot(num.weeks, aes(date, WeeklySum, colour = beneful_can)) + facet_grid(facets=bucket2~sup_opp) + 
    scale_colour_manual(name = "Candidate who benefits", values = c("#3D64FF", "#CC0033"), labels=c("Obama","Romney" )) + 
    xlab("Weeks") + 
    ylab("Amount Spent (Log 10)") + 
    annotate(geom = "rect", xmin = as.Date("2012-8-11", format="%Y-%m-%d"), xmax = as.Date("2012-8-12", format="%Y-%m-%d"), ymin = 1, ymax = 1e+08, alpha = .3, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-8-28", format="%Y-%m-%d"), xmax = as.Date("2012-8-30", format="%Y-%m-%d"), ymin = 1, ymax = 1e+08, alpha = .3, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-9-4", format="%Y-%m-%d"), xmax = as.Date("2012-9-6", format="%Y-%m-%d"), ymin = 1, ymax = 1e+08, alpha = .3, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-9-17", format="%Y-%m-%d"), xmax = as.Date("2012-9-18", format="%Y-%m-%d"), ymin = 1, ymax = 1e+08, alpha = .3, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-10-3", format="%Y-%m-%d"), xmax = as.Date("2012-10-4", format="%Y-%m-%d"), ymin = 1, ymax = 1e+08, alpha = .3, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-11-6", format="%Y-%m-%d"), xmax = as.Date("2012-11-7", format="%Y-%m-%d"), ymin = 1, ymax = 1e+08, alpha = .3, fill = "black") + 
    geom_point(size = 3.5) + geom_line(size = 1.5) +
    geom_text(data = special.dat, aes(x = x, label = label, hjust = -0.5), y = log10(5), inherit.aes = FALSE, show_guide = FALSE) +
    scale_y_log10(label = math_format(format = log10)) +
    theme_bw() +
    theme(legend.position="bottom")

minValue <- min(c(sum_exp2$obama, sum_exp2$romney))
maxValue <- max(c(sum_exp2$obama, sum_exp2$romney)) + 500000000
typePlot<-qplot(romney, obama, data=sum_exp2, color = `df2$bucket2`) +
    geom_abline() + 
    geom_text(aes(label=`df2$bucket2`), data=sum_exp2, hjust=-.1, vjust=-.02) + 
    scale_x_log10(limits = c(minValue, maxValue)) + 
    scale_y_log10(limits = c(minValue, maxValue)) +
    theme(legend.position="none") +
    theme_bw() +
    coord_fixed()

typePlot2<-ggplot(sum_exp2_p, aes(bucket2, Sum, fill = beneful_can)) + 
    geom_bar(position = "dodge", stat = "identity") + 
    coord_flip() + 
    scale_y_log10() + 
    scale_fill_manual(name = "Candidate", values = c("#3D64FF", "#CC0033")) + 
    xlab("") + 
    ylab("Amount Spent (Log 10)") +
    theme_bw() +
    theme(legend.position="bottom")

pacPlot <- ggplot(sum_exp.spep, aes(beneful_can, Sum/1000000, fill = spe_nam)) + 
    geom_bar(stat = "identity") + 
    xlab("Benefiting Candidate") + 
    ylab("Amount Spent (In Millions of $)") +
    scale_fill_manual(values=c(blue, red), labels = substring(sum_exp.spep$spe_nam, 1, 30), name = "Super PAC") +
    theme_bw()

analyzeStateTrends <- function(state) {
  polls.chosen <- subset(polls.data[-(6:7)], State %in% state)
  polls.chosenm <- melt(polls.chosen, id = c("Date", "Pollster", "State"))
  ggplot(polls.chosenm, aes(x=Date, y=value,colour=variable)) + 
    scale_colour_manual(name = "Candidate", values = c("#3D64FF", "#CC0033"), labels=c("Obama","Romney" )) +
    facet_wrap(facets = ~State, ncol = 2) +
    ylab("Percentage Support") +
    annotate(geom = "rect", xmin = as.Date("2012-8-11", format="%Y-%m-%d"), xmax = as.Date("2012-8-12", format="%Y-%m-%d"), ymin = 30, ymax = 60, alpha = .4, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-8-28", format="%Y-%m-%d"), xmax = as.Date("2012-8-30", format="%Y-%m-%d"), ymin = 30, ymax = 60, alpha = .4, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-9-4", format="%Y-%m-%d"), xmax = as.Date("2012-9-6", format="%Y-%m-%d"), ymin = 30, ymax = 60, alpha = .4, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-9-17", format="%Y-%m-%d"), xmax = as.Date("2012-9-18", format="%Y-%m-%d"), ymin = 30, ymax = 60, alpha = .4, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-10-3", format="%Y-%m-%d"), xmax = as.Date("2012-10-4", format="%Y-%m-%d"), ymin = 30, ymax = 60, alpha = .4, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-11-6", format="%Y-%m-%d"), xmax = as.Date("2012-11-7", format="%Y-%m-%d"), ymin = 30, ymax = 60, alpha = .4, fill = "black") +
    theme_bw() +
    geom_text(data = special.dat, aes(x = x, label = label, hjust = -0.5), y = 33.5, inherit.aes = FALSE, show_guide = FALSE) +
    geom_smooth(method="loess", size = 1.5) +
    geom_point() +
    theme(legend.position="bottom")
}

#list taken from http://www.realclearpolitics.com
swing.states <- c("Colorado", "Florida", "Iowa", "Michigan", "Missouri", "Nevada", "New Hampshire", "North Carolina", "Ohio", "Pennsylvania", "Virginia", "Wisconsin")
swingPlot <- analyzeStateTrends(swing.states)

labels.spending <- data.frame(yval=c(1e+04, 1e+04), xval=c(as.Date("28/5/2012","%d/%m/%Y"), as.Date("10/9/2012","%d/%m/%Y")), text=c("1", "2"))
trendPlot <- qplot(Date, sum, data = num.weeks.sum, colour = beneful_can, geom = "blank") + 
    scale_y_log10(label = math_format(format = log10)) +
    annotate("rect", xmin=as.Date("2/2/2012","%d/%m/%Y"), xmax=as.Date("08/7/2012","%d/%m/%Y"), ymin = 0, ymax = Inf, fill="darkgrey", alpha=0.4) +
    geom_point(size = 3.5) +
    geom_line(size = 1.5) +
    #annotate("text", x=as.Date("14/7/2012","%d/%m/%Y"), y=5e+07, label="1", color="#FF0000", hjust=-0.5, alpha=0.4, size=10) +
    scale_colour_manual(name = "Candidate", values = c("#3D64FF", "#CC0033"), labels=c("Obama","Romney" )) +
    ylab("Total Spending (Log 10)") + 
    scale_x_date(limits=c(as.Date("25/4/2012","%d/%m/%Y"), as.Date("2/11/2012","%d/%m/%Y"))) +
    geom_text(data=labels.spending[1,], mapping=aes(x=xval, y=yval, label=text), inherit.aes = FALSE, show_guide = FALSE) +
    geom_text(data=labels.spending[2,], mapping=aes(x=xval, y=yval, label=text), inherit.aes = FALSE, show_guide = FALSE) +
    theme_bw() +
    theme(legend.position="bottom")

obamaEffectPlot <- ggplot(final.df3[-1,], aes(x=ObamaSpendChange/1000000, y=ObamaPollChange)) +
    geom_smooth(method="loess", size = 1.5, colour = "#3D64FF") +
    geom_point(colour = I("darkblue")) +
    ylab("Change in % Support (Weekly Average)") +
    xlab("Change in Super PAC Spending (In Millions of $)") +
    annotate("text", x = final.df3$ObamaSpendChange[15]/1000000, y = final.df3$ObamaPollChange[15], label = "1", color = "#000000", hjust = -0.5, size = 5) +
    annotate("text", x = final.df3$ObamaSpendChange[18]/1000000, y = final.df3$ObamaPollChange[18], label = "2", color = "#000000", hjust = -0.5, size = 5) +
    annotate("text", x = final.df3$ObamaSpendChange[19]/1000000, y = final.df3$ObamaPollChange[19], label = "3", color = "#000000", hjust = -0.5, size = 5) +
    annotate("text", x = final.df3$ObamaSpendChange[21]/1000000, y = final.df3$ObamaPollChange[21], label = "4", color = "#000000", hjust = -0.5, size = 5) +
    annotate("text", x = final.df3$ObamaSpendChange[24]/1000000, y = final.df3$ObamaPollChange[24], label = "5", color = "#000000", hjust = -0.5, size = 5) +
    theme_bw() +
    ylim(c(-6,11)) +
    theme(legend.position="bottom")

romneyEffectPlot <- ggplot(final.df3[-1,], aes(x=RomneySpendChange/1000000, y=RomneyPollChange)) +
    geom_smooth(method="loess", colour = "#CC0033", size = 1.5) +
    geom_point(colour = I("darkred")) +
    ylab("Change in % Support (Weekly Average)") +
    xlab("Change in Super PAC Spending (In Millions of $)") +
    annotate("text", x = final.df3$RomneySpendChange[15]/1000000, y = final.df3$RomneyPollChange[15], label = "1", color = "#000000", hjust = -0.5, size = 5) +
    annotate("text", x = final.df3$RomneySpendChange[18]/1000000, y = final.df3$RomneyPollChange[18], label = "2", color = "#000000", hjust = -0.5, size = 5) +
    annotate("text", x = final.df3$RomneySpendChange[19]/1000000, y = final.df3$RomneyPollChange[19], label = "3", color = "#000000", hjust = -0.5, size = 5) +
    annotate("text", x = final.df3$RomneySpendChange[21]/1000000, y = final.df3$RomneyPollChange[21], label = "4", color = "#000000", hjust = -0.5, size = 5) +
    annotate("text", x = final.df3$RomneySpendChange[24]/1000000, y = final.df3$RomneyPollChange[24], label = "5", color = "#000000", hjust = -0.5, size = 5) +
    theme_bw() +
    # ylim(c(-6,12)) + 
    theme(legend.position="bottom")

colours.pal <- brewer.pal(n = 3, name = "Set1")

effectPlot <- qplot(Date, Obama.Romney, data = polls.data, geom = "blank") +
    scale_alpha(guide="none") +
    scale_colour_manual(name = " ", values = c("#FFBE0D", colours.pal[3]), labels=c("Swing State","National" ), breaks=c(FALSE, TRUE)) + 
    scale_x_date(limits=c(as.Date("25/4/2012","%d/%m/%Y"), as.Date("2/11/2012","%d/%m/%Y"))) +
    scale_y_continuous(limits=c(-20,20)) +
    ylab("Romney -------- | -------- Obama  ") +
    annotate("rect", xmin=as.Date("2/2/2012","%d/%m/%Y"), xmax=as.Date("08/7/2012","%d/%m/%Y"), ymin = -Inf, ymax = 0, fill="darkgrey", alpha=0.4) +
    annotate("rect", xmin=as.Date("2/2/2012","%d/%m/%Y"), xmax=as.Date("08/7/2012","%d/%m/%Y"), ymin = 0, ymax = Inf, fill="darkgrey", alpha=0.4) +
    annotate("rect", xmin=as.Date("2/2/2012","%d/%m/%Y"), xmax=as.Date("2/12/2012","%d/%m/%Y"), ymin=0, ymax=Inf, fill="blue", alpha=0.03) +
    annotate("rect", xmin=as.Date("2/2/2012","%d/%m/%Y"), xmax=as.Date("2/12/2012","%d/%m/%Y"), ymin=-Inf, ymax=0, fill="red", alpha=0.03) +
    annotate(geom = "rect", xmin = as.Date("2012-8-11", format="%Y-%m-%d"), xmax = as.Date("2012-8-12", format="%Y-%m-%d"), ymin = -20, ymax = 20, alpha = .4, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-8-28", format="%Y-%m-%d"), xmax = as.Date("2012-8-30", format="%Y-%m-%d"), ymin = -20, ymax = 20, alpha = .4, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-9-4", format="%Y-%m-%d"), xmax = as.Date("2012-9-6", format="%Y-%m-%d"), ymin = -20, ymax = 20, alpha = .4, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-9-17", format="%Y-%m-%d"), xmax = as.Date("2012-9-18", format="%Y-%m-%d"), ymin = -20, ymax = 20, alpha = .4, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-10-3", format="%Y-%m-%d"), xmax = as.Date("2012-10-4", format="%Y-%m-%d"), ymin = -20, ymax = 20, alpha = .4, fill = "black") + 
    annotate(geom = "rect", xmin = as.Date("2012-11-6", format="%Y-%m-%d"), xmax = as.Date("2012-11-7", format="%Y-%m-%d"), ymin = -20, ymax = 20, alpha = .4, fill = "black") +
    geom_text(data = special.dat, aes(x = x, label = label, hjust = -0.7), y = -18, inherit.aes = FALSE, show_guide = FALSE) +
    theme_bw() +
    theme(legend.position="bottom") +
    geom_line(data=polls.smooth, aes(x=Date, y=Obama.Romney, colour=isNational), inherit.aes=FALSE, size = 1.5) +
    geom_point(aes(colour = isNational))
