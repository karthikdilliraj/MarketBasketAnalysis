#Load the libraries
install.packages("RColorBrewer")
library(arules)
library(arulesViz)
library(RColorBrewer)

#Load the data set
basket_data <- read.transactions("./data/transaction_data.csv", format = "basket", 
                                 sep = ",")

#Create an item frequency plot for the top 20 items
itemFrequencyPlot(basket_data,topN=20,type="absolute",col=brewer.pal(8,'Pastel2'), main="Absolute Item Frequency Plot")
itemFrequencyPlot(basket_data,topN=20,type="relative",col=brewer.pal(8,'Pastel2'), main="Absolute Item Frequency Plot")

#Get the rules
sink("rules.txt")
rules <- apriori(basket_data, parameter = list(supp=0.006, conf=0.9, 
                                               target = "rules"))

#Summary
summary(rules)
inspect(rules)
sink()

#Sort Rules by confidence
confidence_rules<-sort(rules, by="confidence", decreasing=TRUE)
inspect(confidence_rules)

# Sort Rules by support
support_rules<-sort(rules, by="support", decreasing=TRUE)
inspect(support_rules)

#Sort Rules by lift
lift_rules<-sort(rules, by="lift", decreasing=TRUE)
inspect(lift_rules)

#Getting the rules ny setting maxlen parameter
sink("max_len_rules.txt")
max_len_rules <- apriori(basket_data, parameter = list(supp = 0.006, conf = 0.9,maxlen=3))
summary(max_len_rules)
inspect(max_len_rules)
sink()

#Inspect the redudant rules
inspect(rules[is.redundant(rules)])

#Inspect the non-redudant rules
inspect(rules[!is.redundant(rules)])

#Targeting Items
#RHS
sink("target_rhs_rules.txt")
target_rhs_rules<-apriori(data=basket_data, parameter=list(supp=0.006,conf = 0.9), 
               appearance = list(default="lhs",rhs="POPPY'S PLAYHOUSE BEDROOM"),
               control = list(verbose=F))
summary(target_rhs_rules)
inspect(target_rhs_rules)
sink()

#LHS
sink("target_lhs_rules.txt")
target_lhs_rules<-apriori(data=basket_data, parameter=list(supp=0.006,conf = 0.6), 
               appearance = list(default="rhs",lhs="POPPY'S PLAYHOUSE BEDROOM"),
               control = list(verbose=F))
summary(target_lhs_rules)
inspect(target_lhs_rules)
sink()

#Visualization
plot(rules)
plot(rules,method="graph",interactive=TRUE,shading=NA)
plot(rules,method="two-key plot")
plotly_arules(rules)
plotly_arules(max_len_rules)
plot(rules, method = "graph",  engine = "htmlwidget")
plot(rules, method="paracoord")

## ----clear data---------------------------------------------------------
rm(list = ls())
