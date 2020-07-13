# libraries
library(ggplot2)

# qqplots -----------------------------------------------------------------
qq_plot <- function(data, point_col = "black", diag_col = "red", diag_line = "solid"){

  # error handling
  # check if the file has the correct 'P' header label
  if(!("P" %in% names(data))){
    stop("The file you provided does not have the 'P' column header label. Check the Information tab for required file format.")
  }

  # data
  #input <- read.table(data, header = TRUE)
  observed_p <- sort(data$P)
  log_obs <- -(log10(observed_p))
  expected_p <- c(1:length(observed_p))
  log_exp <- -(log10(expected_p / (length(expected_p)+1)))
  xlim <- as.numeric(as.integer(max(log_obs) + 2))
  ylim <- xlim

  # plot
  if(!("CHISQ" %in% names(data))){

    plty <- ggplot(data, aes(x = log_exp, y = log_obs)) +
      geom_point(size = 0.5, color = point_col) + geom_abline(color = diag_col, linetype = diag_line) +
      theme_classic() +
      labs(x = expression(paste(-log[10]~italic((p)), ", ", "Expected")), y = expression(paste(-log[10]~italic((p)), ", ", "Observed"))) +
      scale_x_continuous(expand = c(0, 0), limits = c(0, xlim)) + scale_y_continuous(expand = c(0, 0), limits = c(0, ylim))

  }else{

    gc <-median(data$CHISQ)/0.455

    plty <- ggplot(data, aes(x = log_exp, y = log_obs)) +
      geom_point(size = 0.5, color = point_col) + geom_abline(color = diag_col, linetype = diag_line) +
      theme_classic() +
      labs(x = expression(paste(-log[10]~italic((p)), ", ", "Expected")), y = expression(paste(-log[10]~italic((p)), ", ", "Observed"))) +
      annotate("text", x = 2 , y = 5, label = paste("lambda[GC] ==", gc, sep = " "), parse = TRUE) +
      scale_x_continuous(expand = c(0, 0), limits = c(0, xlim)) + scale_y_continuous(expand = c(0, 0), limits = c(0, ylim))
  }

  plty

}
