setwd("C:/Users/Admin/Downloads/")

data <- read.csv("L_helle_QC_stats.txt", header = F, sep = ",")

## Recalculating the percentages to account for total reads.
for (i in 6:11){
  quan <- data$V2[i]/data$V2[1]
  data$V3[i] <- round(quan*100,2)
}

data

#####################################################################
#### Create a new dataframe containing Mapped/Unmapped relation ####
####################################################################
par(mfrow = c(1, 2))
df <- data.frame(data[2:3,])
V1 <- "Low MAPQ"
V2 <- data$V2[1] - (data$V2[2]+data$V2[3])
V3 <- (data$V3[1]) - (data$V3[2]+data$V3[3])
t <- data.frame(V1,V2,V3, stringsAsFactors = FALSE)

alignment <- rbind(df,t)

p1 <- ggplot(alignment, aes(x = "", y = V2, fill = V1)) +
  geom_col() +
   geom_text(aes(label = V3),position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y") + labs(fill="Alignment",x=NULL,y=NULL) + theme_void()

#####################################################################
###### Create a new dataframe containing DUP/ NO-DUP relation #######
####################################################################

Dup_No_dup <- data.frame(data[4:5,])

p2 <- ggplot(Dup_No_dup, aes(x = "", y = V2, fill = V1)) +
  geom_col() +
  geom_text(aes(label = V3),position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y") + labs(fill="Dup/No-Dup",x=NULL,y=NULL) + theme_void()


#####################################################################
############ Create a new dataframe containing NO-DUP types ########
####################################################################

# 1. Cis/Trans reads
cis_trans <- data.frame(data[6:7,])

p3 <- ggplot(cis_trans, aes(x = "", y = V2, fill = V1)) +
  geom_col() +
  geom_text(aes(label = V3),position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y") + labs(fill= "Cis/Trans",x=NULL,y=NULL) + theme_void() + scale_fill_brewer(palette='Set1')

# 2. Valid/No-valid
Valid_novalid <- data.frame(data[8:9,])

p4 <- ggplot(Valid_novalid, aes(x = "", y = V2, fill = V1)) +
  geom_col() +
  geom_text(aes(label = V3),position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y") + labs(fill= "Valid reads",x=NULL,y=NULL) + theme_void() + scale_fill_brewer(palette='Set2')


#####################################################################
############ Display the 4 pie charts from the Statistics table######
####################################################################
library(patchwork)
pie_plots <- (p1|p2)/(p3|p4)
pie_plots + plot_annotation(tag_levels = 'A', title = "Lycaena Helle statistics")


ggplot(data, aes(x = "", y = V2, fill = V1)) +
  geom_col() +
  geom_text(aes(label = V3),position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y") + labs(fill= "Valid reads",x=NULL,y=NULL) + theme_void() + scale_fill_brewer(palette='Set3')

ggplot(alignment, aes(x = V1, y = V2, fill=V1)) + geom_bar(stat = "identity") + labs(y="# Read pairs (millions)", x= "Alignment") + geom_text()

       
