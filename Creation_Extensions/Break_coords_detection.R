## DETECTING BREAK CORDINATES IN THE DEFAULT ASSEMBLY

setwd("C:/Users/Admin/Downloads/")

file2 <- "xyrichtys_novacula_yahs_scaffolds_final.agp" #Default AGP

AGP_file2 <- read.csv(file2, sep = '\t', header = F, 
                      col.names = c("object", "object_beg","object_end", 
                      "part_num","comp_type","comp_id","comp_beg","comp_end","orientation"))

# 1. Selecting the contigs that appear more than once (Meaning have broken into pieces)
     # Create a subset

broken_contigs <- AGP_file2$comp_id[which(duplicated(AGP_file2$comp_id) & AGP_file2$comp_id!=200)]
breaks <- AGP_file2[AGP_file2$comp_id %in% broken_contigs,]

library(dplyr)

# 2. Order the contigs subset using arrange function from dplyr library  
ord_contigs_tab <- arrange(breaks,breaks$comp_id)

# 3. Generating the CONTIG breaking coordinates
     # and its corresponding scaffold coordinates on the default assembly.
     # Need to consider different cases when contig is placed forward or reverse.

ctg_belong <- c();
ctg_coord <- c();

scaff_belong <- c();
scaff_coord <- c();

for (i in 2:nrow(ord_contigs_tab)){
  if (ord_contigs_tab$comp_id[i]==ord_contigs_tab$comp_id[i-1]){
    
    if (ord_contigs_tab$orientation[i]=="+"){
      if (ord_contigs_tab$comp_beg[i] > ord_contigs_tab$comp_beg[i-1]){
        ctg_belong <- c(ctg_belong, ord_contigs_tab$comp_id[i-1])
        ctg_coord <- c(ctg_coord, ord_contigs_tab$comp_end[i-1])
        
        scaff_belong <- c(scaff_belong, ord_contigs_tab$object[i-1])
        scaff_coord <- c(scaff_coord, ord_contigs_tab$object_end[i-1])
        
       }
      else{
        ctg_belong <- c(ctg_belong, ord_contigs_tab$comp_id[i])
        ctg_coord <- c(ctg_coord, ord_contigs_tab$comp_end[i])
        
        scaff_belong <- c(scaff_belong, ord_contigs_tab$object[i])
        scaff_coord <- c(scaff_coord, ord_contigs_tab$object_end[i])

      }
    }
    if (ord_contigs_tab$orientation[i]=="-"){ 
      if (ord_contigs_tab$comp_beg[i] > ord_contigs_tab$comp_beg[i-1]){
        ctg_belong <- c(ctg_belong, ord_contigs_tab$comp_id[i-1])
        ctg_coord <- c(ctg_coord, ord_contigs_tab$comp_end[i-1])
        
        scaff_belong <- c(scaff_belong, ord_contigs_tab$object[i-1])
        scaff_coord <- c(scaff_coord, ord_contigs_tab$object_end[i-1])
        
        
      }
      else{
        ctg_belong <- c(ctg_belong, ord_contigs_tab$comp_id[i])
        ctg_coord <- c(ctg_coord, ord_contigs_tab$comp_end[i])
        
        scaff_belong <- c(scaff_belong, ord_contigs_tab$object[i])
        scaff_coord <- c(scaff_coord, ord_contigs_tab$object_end[i])
      }
      
    }
  }
}

# 4. Saving the coordinates in a TXT file to later use it.
# Contig coordinates
ctg_coord <- cbind(ctg_belong,as.integer(ctg_coord), as.integer(ctg_coord)+199, 200)
write.table(ctg_coord, "break_ctg_coords_default.txt", row.names = F, col.names = F,sep="\t")
break_ctg_coords_default <- data.frame(ctg_coord[,1:2])

# Scaffold coordinates (use when creating the BREAKS extension in Pretext)
scaff_break_coord2 <- cbind(scaff_belong,as.integer(scaff_coord), as.integer(scaff_coord)+199, 200)
data.frame(scaff_break_coord2)

# Additionally, selecting the break regions to be visualized in IGV (interval of 100,000 base pairs)
sam_tools_info <-  cbind(scaff_belong,":",as.integer(scaff_coord)-50000, "-",as.integer(scaff_coord)+50000)
write.table(sam_tools_info, "breaks_bam.txt", row.names = F, col.names = F, sep = "")


# 5. Transferring the coordinates to scaffold coordinates of the unbroken assembly.
file <- "xyr_novacula_yahs_scaffolds_final.agp"
AGP_file <- read.csv(file, sep = '\t', header = F, 
                     col.names = c("object", "object_beg","object_end", 
                     "part_num","comp_type","comp_id","comp_beg","comp_end","orientation"))

unbrok_scaffolds <- AGP_file[AGP_file$comp_id %in% break_ctg_coords_default$ctg_belong,]
unbrok_scaffolds <- arrange(unbrok_scaffolds, unbrok_scaffolds$comp_id)
break_ctg_coords_default$V2 <- as.numeric(break_ctg_coords_default$V2)

scaff_ubk <- c()
new_coord_ubk <- c()

for (i in 1:nrow(unbrok_scaffolds)){
  scaff_ubk <- c(scaff_ubk, unbrok_scaffolds$object[i])
  
  if (unbrok_scaffolds$orientation[i]=="+"){
    coord <- unbrok_scaffolds$object_beg[i] + break_ctg_coords_default$V2[i]-1;
    new_coord_ubk <- c(new_coord_ubk,coord)
  }
  else{
    coord <- unbrok_scaffolds$object_end[i]-break_ctg_coords_default$V2[i]+1;
    new_coord_ubk <- c(new_coord_ubk,coord)
  }

}

# 6. Saving the new coordinates from unbroken assembly.
scaff_new_ubk <- cbind(scaff_ubk,as.integer(new_coord_ubk), as.integer(new_coord_ubk)+199, 200)
write.table(scaff_new_ubk, "break_ctg_coords_default.txt", row.names = F, col.names = F,sep="\t")
