
## xyrichtys_novacula

## Create the Bedgraph file with the GAPS 

setwd("C:/Users/Admin/Downloads/")

### 1. No-contig option

file <- "xyr_novacula_yahs_scaffolds_final.agp" 

AGP_file <- read.csv(file, sep = '\t', header = F, 
                     col.names = c("object", "object_beg","object_end", 
                    "part_num","comp_type","comp_id","comp_beg","comp_end","orientation"))

nrows <- nrow(AGP_file)

gaps_ext <-c()
for (i in 1:nrows){
  if (AGP_file$comp_id[i]==200){
    gaps_ext <- rbind(gaps_ext,c(AGP_file$object[i],
                                 AGP_file$object_beg[i],AGP_file$object_beg[i]+199,AGP_file$comp_id[i]))
  }
}

GAPS <- data.frame(gaps_ext)
write.table(GAPS,"Gaps_no-contig.txt", sep = "\t", col.names=F, row.names = F)


### 2. Default option

file2 <- "xyrichtys_novacula_yahs_scaffolds_final.agp" 

AGP_file2 <- read.csv(file2, sep = '\t', header = F, 
                      col.names = c("object", "object_beg","object_end", 
                      "part_num","comp_type","comp_id","comp_beg","comp_end","orientation"))

nrows2 <- nrow(AGP_file2)

gaps_ext2 <-c()
for (i in 1:nrows2){
  if (AGP_file2$comp_id[i]==200){
    gaps_ext2 <- rbind(gaps_ext2,c(AGP_file2$object[i],
                                   AGP_file2$object_beg[i],AGP_file2$object_beg[i]+199,AGP_file2$comp_id[i]))
  }
}

GAPS2 <- data.frame(gaps_ext2)
write.table(GAPS2,"Gaps_def.txt", sep = "\t", col.names=F, row.names = F)
