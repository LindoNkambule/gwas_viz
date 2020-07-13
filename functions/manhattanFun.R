# libraries
library(ggplot2) # plot
library(dplyr) # piping
library(ggrepel) # annotations

# manhattan --------------------------------------------------------------

# arguments for the function
#1. ylim: the y-axis scale
#2. cex: the size of the points (dot plots)
#3. cex.axis: the size of x- and y-axis scales
#4. col: the color of the points
#5. suggestiveline:
#6. genomewideline: line for separating genome-wide SNPs from insignificant SNPs
#7. chrlabs: labels for chromosomes on x-axis
manhattan_plt <- function(data, chromCol = c("#276FBF", "#183059"), genomewideSig = NULL,
                          annotatePval = NULL, chromosome = "ALL", annotateCol = "red"){

    # error handling
    #1. column headers
    colheaders <- c("SNP", "CHR", "BP", "P")
    for(header in colheaders){
      if(!(header %in% colnames(data))){
        stop(paste("The file you provided does not have the", header, "column header. Check the Information tab for required file format", sep = " "))
      }
    }

    #2. check chromosomes
    # 23 = X
    # 24 = Y
    # 25 = XY
    # 26 = MT
    chromosomes <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
               11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
               21, 22, 23, 24, 25, 26)

    for (chrom in unique(data$CHR)){
      if(!(chrom %in% chromosomes)){
        stop(paste("The file you provided has an unrecognized chromosome", chrom, ". The CHR column should be numeric. If you have 'X', 'Y', 'XY', 'MT' chromosome etc in your file, change them to numbers and try again. Check the info tab for more information", sep = " "))
      }
    }

    #3. if plotting only one chromosome, check if the file has the specified chromosome
    chroms <- unique(data$CHR)
    if ((chromosome %in% chroms) | chromosome == "ALL"){
      print("")
    }else{
      stop(paste("The file you provided does not have chromosome", chromosome, sep = " "))
    }

    pfile <- data %>%

      group_by(CHR) %>%
      summarise(chr_len=max(BP)) %>%

      mutate(tot=cumsum(chr_len)-chr_len) %>%
      select(-chr_len) %>%

      left_join(data, ., by=c("CHR"="CHR")) %>%

      arrange(CHR, BP) %>%
      mutate( BPcum=BP+tot)

    # sort the chromosomes in ascending order
    sfile <- pfile[order(as.numeric(as.character(pfile$CHR))), ]

    if(chromosome != "ALL"){
      plt_file <- sfile[ which(sfile$CHR == chromosome),]
      nCHR <- length(unique(plt_file$CHR))
      x_lab <- paste("Chromosome", chromosome, "(Mb)", sep = " ")
      ylim <- abs(floor(log10(min(plt_file$P)))) + 1

      # get significant SNPs
      if(!is.null(annotatePval)){
        significantSNPs <- plt_file[ which(plt_file$P <= annotatePval), ]
      }

      # default params for plot
      manplot <- ggplot(plt_file, aes(x = BPcum/1e6, y = -log10(P), color = as.factor(CHR), label = SNP)) +
        geom_point(size = 0.5) +

        ## optional arguments
        # genomewide line
        {
          if(!is.null(genomewideSig)) geom_hline(yintercept = -log10(genomewideSig), color = "red", linetype = "dashed")
        } +

        # p-value annotations
        {
          if(!is.null(annotatePval)) geom_point(data = significantSNPs, color = annotateCol, size = 1)
        } +

        {
          if(!is.null(annotatePval)) geom_label_repel(data = significantSNPs, label.size = 0.1, size = 3, color = "black")
        } +
        ##

        scale_y_continuous(expand = c(0,0), limits = c(0, ylim), labels = scales::comma) +
        scale_x_continuous(labels = scales::comma) +
        scale_color_manual(values = rep(chromCol, nCHR)) +
        scale_size_continuous(range = c(0.5,3)) +
        labs(x = x_lab, y = bquote(-log[10]~italic((p)))) +
        theme_classic() +
        theme(
        legend.position = "none",
        panel.border = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text.x = element_text(angle = 90, size = 7, vjust = 0.5),
        axis.text.y = element_text(size = 7)
        )

    }else{
      plt_file <- sfile
      nCHR <- length(unique(plt_file$CHR))
      axis.set <- plt_file %>% group_by(CHR) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 )
      axis_label <- axis.set[order(as.numeric(as.character(axis.set$CHR))), ]
      x_lab <- "Genomic Position (chromosome)"
      ylim <- abs(floor(log10(min(plt_file$P)))) + 1

      # get significant SNPs
      if(!is.null(annotatePval)){
        significantSNPs <- plt_file[ which(plt_file$P <= annotatePval), ]
      }

      manplot <- ggplot(plt_file, aes(x = BPcum, y = -log10(P), color = as.factor(CHR), label = SNP)) +
        geom_point(size = 0.5) +

        ## optional arguments
        # genomewide line
        {
          if(!is.null(genomewideSig)) geom_hline(yintercept = -log10(genomewideSig), color = "red", linetype = "dashed")
        } +

        # p-value annotations
        {
          if(!is.null(annotatePval)) geom_point(data = significantSNPs, color = annotateCol, size = 1)
        } +

        {
          if(!is.null(annotatePval)) geom_label_repel(data = significantSNPs, label.size = 0.1, size = 3, color = "black")
        } +
        ##

        scale_y_continuous(expand = c(0,0), limits = c(0, ylim)) +
        scale_x_continuous(label = axis_label$CHR, breaks = axis_label$center) +
        scale_color_manual(values = rep(chromCol, nCHR)) +
        scale_size_continuous(range = c(0.5,3)) +
        labs(x = x_lab, y = bquote(-log[10]~italic((p)))) +
        theme_classic() +
        theme(
        legend.position = "none",
        panel.border = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text.x = element_text(angle = 90, size = 7, vjust = 0.5),
        axis.text.y = element_text(size = 7)
        )
    }

    manplot

}
