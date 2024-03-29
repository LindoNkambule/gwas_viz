# pca --------------------------------------------------------------------

# libraries
library(RColorBrewer) # for generating color palettes

pca_plt <- function(eigenvec_file, xComponent = "PC1", yComponent = "PC2", legendPos = "right", soft = "PLINK", colPalette = "Accent"){

    # file header
    switch(soft,
        PLINK = {names(eigenvec_file)[1:12] = c("POP", "Sample", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")},
        EIGENSTRAT = {names(eigenvec_file)[1:12] = c("Sample", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10", "POP")}
      )

    # select only the first 5 eigenvectors
    eigenvec_file <- eigenvec_file[, c("Sample", "PC1", "PC2", "PC3", "PC4", "PC5", "POP")]

    # point shapes (for files with a large number of populations)
    point_shapes <- c(21, 22, 23, 24, 25, 21, 22, 23, 25, 25,
                    21, 22, 23, 24, 25, 21, 22, 23, 25, 25,
                    21, 22, 23, 24, 25, 21, 22, 23, 25, 25,
                    21, 22, 23, 24, 25, 21, 22, 23, 25, 25,
                    21, 22, 23, 24, 25, 21, 22, 23, 25, 25,
                    21, 22, 23, 24, 25, 21, 22, 23, 25, 25)

    # total number of populations
    number_of_populations <- nrow(data.frame(table(eigenvec_file$POP)))

    # colour palette for inputs with many populations
    colourCount = length(unique(eigenvec_file$POP))

    switch(colPalette,
           Paired = {getPalette = colorRampPalette(brewer.pal(12, "Paired"))},
           Set1 = {getPalette = colorRampPalette(brewer.pal(9, "Set1"))},
           Set2 = {getPalette = colorRampPalette(brewer.pal(8, "Set2"))},
           Set3 = {getPalette = colorRampPalette(brewer.pal(12, "Set3"))},
           Dark2 = {getPalette = colorRampPalette(brewer.pal(8, "Dark2"))},
           Accent = {getPalette = colorRampPalette(brewer.pal(8, "Accent"))}
         )

    # ggplot
    ggplot(eigenvec_file, aes_string(x = xComponent, y = yComponent, shape = "POP", fill = "POP")) +
      geom_point(aes(fill = POP)) +
      scale_shape_manual(values = rep(point_shapes[1:number_of_populations], len = number_of_populations)) +
      scale_fill_manual(values = getPalette(colourCount)) +
      scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
      scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
      labs(x = xComponent, y = yComponent) +
      theme_bw() +
      theme(legend.position = legendPos) +
      theme(legend.title=element_blank()) +
      theme(legend.background = element_rect(fill = "white", size = 0.5, linetype = "solid", colour = "black")) +
      theme(panel.border = element_rect(colour = "black", fill = NA, size = 1)) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "black", size = 0.3) +
      geom_vline(xintercept = 0, linetype = "dashed", color = "black", size = 0.3)

}
