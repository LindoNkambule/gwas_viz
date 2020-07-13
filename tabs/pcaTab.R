# pca --------------------------------------------------------------------

pcaTab <- tabItem(tabName = "pca",

                  fluidRow(
                    tabBox(height = "700px", width = "250px",

                      tabPanel(title = "Information", status = "primary", solidHeader = TRUE, icon = icon("info-circle"),
                              mainPanel(h3("About Principal Component Analysis"),
                                        p("In GWAS, principal component analysis (PCA) can be used to look at population structure and/or
                                        identify outlier individuals which may need to be removed prior to further analyses "),
                                        tags$hr(),
                                        h3("Required file format(s)"),
                                        p("Currently, gwaRs only takes .eigenvec and .evec files generated using PLINK and EIGENSTRAT respectively.
                                        We are currently working on adding an option for reading text files not generated using the two mentioned software."),
                                        p(strong("•This plot is interactive. If you click on one sample and sroll down to the bottom, you will see information about that sample", style = "color:red")),
                                        tags$hr(),
                                        h3("Reference(s)"),
                                        p("1. Abraham, G. and Inouye, M. (2014) ‘Fast principal component analysis of large-scale genome-wide data’,
                                        PLoS ONE. Public Library of Science, 9(4). doi: 10.1371/journal.pone.0093766."))),

                      tabPanel(title = "Input/ Output", status = "primary", solidHeader = TRUE, icon = icon("file"), width = 5,
                              radioButtons(inputId = "soft", "Software used to generate eigenvec file:", choices = c("PLINK", "EIGENSTRAT")),
                              tags$hr(),
                              fileInput("pcaFile", "Choose a file for PCA analysis:", multiple = FALSE, accept = c(".eigenvec", ".evec")),
                              tags$hr(),
                              pickerInput(inputId = "pcaFormat", label = "Choose format for plot output download",
                                        choices = c(".tif", ".png", ".jpeg", ".pdf"),
                                        selected = ".tif", multiple = FALSE),
                              numericInput(inputId = "pcaoutwidth", label = "Output file width:", value = 12, min = 1, max = 20),
                              numericInput(inputId = "pcaoutheight", label = "Output file height:", value = 8, min = 1, max = 20),
                              downloadButton('pcaData', 'Download Plot')),

                      tabPanel("Plot",
                              dropdownButton(
                                tags$h3("Customize plot"),
                                radioButtons(inputId = "pcaLegendPos", "Choose legend position:", choices = c("right", "left", "bottom", "top"), inline = TRUE),
                                radioButtons(inputId = "xpca", "x-axis component:", choices = c("PC1", "PC2", "PC3", "PC4"), inline = TRUE, selected = "PC1"),
                                radioButtons(inputId = "ypca", "y-axis component:", choices = c("PC1", "PC2", "PC3", "PC4"), inline = TRUE, selected = "PC2"),
                                radioButtons(inputId = "colPalette", "Choose a color palette:", choices = c("Accent", "Paired", "Set1", "Set2", "Set3", "Dark2")),
                                circle = FALSE, status = "primary", icon = icon("gear"), width = "270px",
                                tooltip = tooltipOptions(title = "Click to customize plot!"),
                                actionButton("pcaclick", "Plot", icon("paper-plane"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),
                              withSpinner(plotOutput("pcaplot", height = 600, click = "plot_click"), type = 5),
                              icon = icon("bar-chart-o"))
                      )
                    ),

                  fluidRow(
                    column(width = 12,
                      h4("Selected Sample(s):"),
                      verbatimTextOutput("click_info")
                    )
                  )
                )
