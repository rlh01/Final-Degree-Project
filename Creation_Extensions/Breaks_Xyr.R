## BREAKS - DEFAULT
setwd("C:/Users/Admin/Downloads/")

file2 <- "xyrichtys_novacula_yahs_scaffolds_final.agp"

AGP_file2 <- read.csv(file2, sep = '\t', header = F, col.names = c("object", "object_beg","object_end", 
                                                                   "part_num","comp_type","comp_id","comp_beg","comp_end","orientation"))

broken_contigs <- AGP_file2$comp_id[which(duplicated(AGP_file2$comp_id) & AGP_file2$comp_id!=200)]
breaks <- AGP_file2[AGP_file2$comp_id %in% broken_contigs,]

library(dplyr)

ord_contigs_tab <- arrange(breaks,breaks$comp_id)

scaff_belong <- c();
scaff_coord <- c();
for (i in 2:nrow(ord_contigs_tab)){
  if (ord_contigs_tab$comp_id[i]==ord_contigs_tab$comp_id[i-1]){
    
    if (ord_contigs_tab$orientation[i]=="+"){
      if (ord_contigs_tab$comp_beg[i] > ord_contigs_tab$comp_beg[i-1]){
        scaff_belong <- c(scaff_belong, ord_contigs_tab$object[i-1])
        scaff_coord <- c(scaff_coord, ord_contigs_tab$object_end[i-1])
      }
      else{
        scaff_belong <- c(scaff_belong, ord_contigs_tab$object[i])
        scaff_coord <- c(scaff_coord, ord_contigs_tab$object_end[i])
        
      }
    }
    if (ord_contigs_tab$orientation[i]=="-"){ ## When orientation is "-"
      if (ord_contigs_tab$comp_beg[i] > ord_contigs_tab$comp_beg[i-1]){
        scaff_belong <- c(scaff_belong, ord_contigs_tab$object[i-1])
        scaff_coord <- c(scaff_coord, ord_contigs_tab$object_end[i-1])
        
      }
      else{
        scaff_belong <- c(scaff_belong, ord_contigs_tab$object[i])
        scaff_coord <- c(scaff_coord, ord_contigs_tab$object_beg[i])
        
      }
      
    }
  }
}
  
  

scaff_break_coord2 <- cbind(scaff_belong,as.integer(scaff_coord), as.integer(scaff_coord)+199, 200)

data.frame(scaff_break_coord2)


IGV_information <-  cbind(scaff_belong,":",as.integer(scaff_coord)-50000, "-",as.integer(scaff_coord)+50000)
write.table(IGV_information, "breaks_bam.txt", row.names = F, col.names = F, sep = "")


