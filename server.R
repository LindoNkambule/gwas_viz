library(shiny)
library(shinydashboard)
library(data.table) # faster than read.table
library(tools)

# source plot functions
file.sources = list.files(c("functions"),
                          pattern="*.R", full.names=TRUE,
                          ignore.case=TRUE)
sapply(file.sources,source,.GlobalEnv)

# allow file uploads of up to 400MB
options(shiny.maxRequestSize=400*1024^2)

# Set the application-scoped cache to be a memory cache that is 400 MB in size, and where cached objects expire after one hour.
shinyOptions(cache = memoryCache(max_size = 400e6, max_age = 3600))

server <- function(input, output) {

  # testData ----------------------------------------------------------------------
  # (a) Association file
  output$testAssoc <- downloadHandler(
  filename <- function() {
    paste("gwaRs_QC.assoc", "gz", sep = ".")
  },

  content <- function(file) {
    file.copy("testData/gwaRs_QC.assoc.gz", file)
  },
  contentType = "testData/gz")

  # (b) PCA file
  output$testPCA <- downloadHandler(
  filename <- function() {
    paste("gwaRs_QC.eigenvec", "gz", sep = ".")
  },

  content <- function(file) {
    file.copy("testData/gwaRs_QC.eigenvec.gz", file)
  },
  contentType = "testData/gz")

  # 1. qqplot ---------------------------------------------------------------------

  # 1(a). data
  qqplotData <- reactive({
    qqpltFile <- input$qqFile
    if(is.null(qqpltFile)){return()}
    fread(qqpltFile$datapath, header = TRUE)
  })

  # 1(b). click events
  diagColor <- eventReactive(input$qqclick, {
    input$diagColor
  })

  pointColor <- eventReactive(input$qqclick, {
    input$pointColor
  })

  diagLine <- eventReactive(input$qqclick, {
    input$diagLine
  })

  # 1(c). plot
  output$qqplot <- renderCachedPlot({
    if(is.null(qqplotData())){return()}

    qq <- qqplotData()
    qq_plot(qq, point_col = pointColor(), diag_col = diagColor(), diag_line = diagLine())

  }, cache = "session", cacheKeyExpr = { list(pointColor(), diagColor(), diagLine()) })

  # 1(d). save plot
  output$qqData <- downloadHandler(
    filename = function() {
      paste('QQPlot', input$qqFormat, sep='')
    },
    content = function(file) {
        ggsave(file, plot = qq_plot(qqplotData(), point_col = input$pointColor,
          diag_col = input$diagColor, diag_line = input$diagLine),
        device = switch(input$qqFormat, .tif = {"tiff"}, .png = {"png"}, .jpeg = {"jpeg"}, .pdf = {"pdf"}),
        dpi = 1200, width = input$qqoutwidth, height = input$qqoutheight)
    }
  )

  # 2. manhattan ------------------------------------------------------------------

  # 2(a). data
  manhattanplotData <- reactive({
    manpltFile <- input$manhattanFile
    if(is.null(manpltFile)){return()}
    fread(manpltFile$datapath, header = TRUE)
  })

  # 2(b). click events
  genomewideline <- eventReactive(input$manclick, {
    input$genomewideline
  })

  annotatePvalQ <- eventReactive(input$manclick, {
    input$annotatePvalQ
  })

  chromcolor <- eventReactive(input$manclick, {
    input$chromcolor
  })

  chrom <- eventReactive(input$manclick, {
    input$chrom
  })

  annotateCol <- eventReactive(input$manclick, {
    input$annotateCol
  })

  # 2(c). plot
  output$manhattanplot <- renderCachedPlot({
    if(is.null(manhattanplotData())){return()}

    manhattan <- manhattanplotData()

    if(!is.null(genomewideline()) & !is.null(annotatePvalQ())){

      #1. add genomewide line and annotate SNPs by p-value
      manhattan_plt(manhattan, chromCol = chromcolor(), genomewideSig = genomewideline(),
        annotatePval = annotatePvalQ(), chromosome = chrom(), annotateCol = annotateCol())

    }else if(!is.null(genomewideline()) & is.null(annotatePvalQ())){

      #2. add ONLY genomewide line
      manhattan_plt(manhattan, chromCol = chromcolor(), genomewideSig = genomewideline(),
        chromosome = chrom())

    }else if(!is.null(annotatePvalQ()) & is.null(genomewideline())){

      #3. ONLY annotate SNPs by p-value
      manhattan_plt(manhattan, chromCol = chromcolor(), annotatePval = annotatePvalQ(),
        chromosome = chrom(), annotateCol = annotateCol())

    }else{

      #4. just output the default plot XX
      manhattan_plt(manhattan, chromCol = chromcolor(), chromosome = chrom())
    }

  }, cache = "session", cacheKeyExpr = { list(chromcolor(), genomewideline(), annotatePvalQ(), chrom(), annotateCol()) })

  # 2(d). save plot
  output$manhattanData <- downloadHandler(
    filename = function() {
      paste('ManhattanPlot', input$manhattanFormat, sep='')
    },
    content = function(file) {
        ggsave(file, plot = manhattan_plt(manhattanplotData(), chromCol = input$chromcolor, genomewideSig = input$genomewideline,
          annotatePval = input$annotatePvalQ, chromosome = input$chrom, annotateCol = input$annotateCol),
        device = switch(input$manhattanFormat, .tif = {"tiff"}, .png = {"png"}, .jpeg = {"jpeg"}, .pdf = {"pdf"}),
        dpi = 1200, width = input$manoutwidth, height = input$manoutheight)
    }
  )

  # 3. pca ------------------------------------------------------------------------

  # 3(a). data
  pcaplotData <- reactive({
    pcapltFile <- input$pcaFile
    if(is.null(pcapltFile)){return()}

    # error handling
    get_ext <- file_ext(pcapltFile$datapath)
    accepted_ext = c("eigenvec", "evec")
    if(!(get_ext %in% accepted_ext)){
        stop("The file you provided does not have the extension .eigenvec or .evec. Check info tab for more information")
    }else{
      fread(pcapltFile$datapath, header = FALSE)
    }

  })

  # 3(b). click events
  # click events
  xpca <- eventReactive(input$pcaclick, {
    input$xpca
  })

  ypca <- eventReactive(input$pcaclick, {
    input$ypca
  })

  pcaLegendPos <- eventReactive(input$pcaclick, {
    input$pcaLegendPos
  })

  colPalette <- eventReactive(input$pcaclick, {
    input$colPalette
  })

  # plot
  output$pcaplot <- renderCachedPlot({
    if(is.null(pcaplotData())){return()}

    pca <- pcaplotData()
    pca_plt(pca, xComponent = xpca(), yComponent = ypca(), legendPos = pcaLegendPos(),
      soft = input$soft, colPalette = colPalette())

  }, cache = "session", cacheKeyExpr = { list(xpca(), ypca(), pcaLegendPos(), colPalette()) })

  output$pcaData <- downloadHandler(
    filename = function() {
      paste('PCAPlot', input$pcaFormat, sep='')
    },
    content = function(file) {
        ggsave(file, plot = pca_plt(pcaplotData(), xComponent = input$xpca, yComponent = input$ypca,
        legendPos = input$pcaLegendPos, soft = input$soft, colPalette = input$colPalette),
        device = switch(input$pcaFormat, .tif = {"tiff"}, .png = {"png"}, .jpeg = {"jpeg"}, .pdf = {"pdf"}),
        dpi = 1200, width = input$pcaoutwidth, height = input$pcaoutheight)
    }
  )

  # interactive plot
  output$click_info <- renderPrint({
    if(is.null(pcaplotData())){return()}

    pca <- pcaplotData()
    switch(input$soft,
      PLINK = {names(pca)[1:12] = c("POP", "Sample", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")},
      EIGENSTRAT = {names(pca)[1:12] = c("Sample", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10", "POP")}
    )

    # select only the first 10 eigenvectors
    pca <- pca[, c("Sample", "PC1", "PC2", "PC3", "PC4", "PC5", "POP")]

    nearPoints(pca, input$plot_click, maxpoints = 4, addDist = FALSE)
  })

  # 4. snpdensity -----------------------------------------------------------------

  # 4(a). data
  snpdensData <- reactive({
    snpdensFile <- input$snpdensFile
    if(is.null(snpdensFile)){return()}
    fread(snpdensFile$datapath, header = TRUE)
  })

  # 4(b). click events
  binsize <- eventReactive(input$snpdensclick, {
    input$binsize
  })

  denscolor <- eventReactive(input$snpdensclick, {
    input$denscolor
  })

  # 4(c). plot
  output$snpdensityplot <- renderCachedPlot({
    if(is.null(snpdensData())){return()}

    snpdens <- snpdensData()
    snpdensplt(snpdens, binsize = binsize(), denscolor = denscolor())

  }, cache = "session", cacheKeyExpr = { list(binsize(), denscolor()) })

  # 4(d). save plot
  output$snpdenseData <- downloadHandler(
    filename = function() {
      paste('SNPDensityPlot', input$snpdensFormat, sep='')
    },
    content = function(file) {
        ggsave(file, plot = snpdensplt(snpdensData(), binsize = input$binsize, denscolor = input$denscolor),
        device = switch(input$snpdensFormat, .tif = {"tiff"}, .png = {"png"}, .jpeg = {"jpeg"}, .pdf = {"pdf"}),
        dpi = 350, width = input$snpdensoutwidth, height = input$snpdensoutheight)
    }
  )

  # 5. admixture ------------------------------------------------------------------

}
