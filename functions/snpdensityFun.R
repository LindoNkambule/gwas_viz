library(CMplot)

snpdensplt <- function(file, binsize = 1e6, denscolor = c("darkgreen", "yellow", "red")){

  # error handling
  colheaders <- c("SNP", "CHR", "BP")
  for(header in colheaders){
    if(!(header %in% colnames(file))){
      stop(paste("The file you provided does not have the", header, "column header. Check the Information tab for required file format", sep = " "))
    }
  }

  # data
  plt_file <- file[, c("SNP", "CHR", "BP")]
  names(plt_file) <- c("SNP", "Chromosome", "Position")

  # plot
  CMplot(plt_file, type = "p", plot.type = "d", bin.size = binsize, chr.den.col = denscolor,
  memo = "", dpi = 300, file.output = FALSE, verbose = TRUE, width = 12, height = 6)
}
