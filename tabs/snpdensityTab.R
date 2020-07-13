# SNP density --------------------------------------------------------------

snpdensityTab <- tabItem(tabName = "snpdensity",
                        fluidRow(

                          tabBox(height = "700px", width = "250px",
                                 tabPanel(title = "Information", status = "primary", solidHeader = TRUE, icon = icon("info-circle"),
                                          mainPanel(h3("About SNP density plots"),
                                                    p("SNP Density plots are a good way to look at how densely populated a particular region (window size) in a chromosome is by SNPs.
                                                    gwaRs uses the CMplot R package for this type of plot. Users can set they prefered window size and density colors by using the dropdown button in the
                                                    'Plot' tab"),
                                                    tags$hr(),
                                                    h3("Required file format(s)"),
                                                    p("Below is the required file format if you want to visualize SNP density plots using gwaRs."),
                                                    p(strong("•The header column labels SNP, CHR, and BP are mandatory and they can be in any order", style = "color:red")),
                                                    img(src = "snpdensFormat.png", height = 180, width = 150),
                                                    p(strong("•gwaRs also accepts association (.assoc) files generated using PLINK")),
                                                    tags$hr(),
                                                    h3("Reference(s)"),
                                                    p("1. LiLin, Y. (2019) ‘A high-quality drawing tool designed for Manhattan plot of genomic analysis’, https://github.com/YinLiLin/R-CMplot"))),

                                 tabPanel(title = "Input/ Output", status = "primary", solidHeader = TRUE, icon = icon("file"), width = 5,
                                          fileInput("snpdensFile", "Choose input file:",
                                                    multiple = FALSE, accept = c(".assoc", ".txt")),
                                          tags$hr(),
                                          pickerInput(inputId = "snpdensFormat", label = "Choose format for plot output download",
                                                    choices = c(".tif", ".png", ".jpeg", ".pdf"),
                                                    selected = ".tif", multiple = FALSE),
                                          numericInput(inputId = "snpdensoutwidth", label = "Output file width:", value = 8, min = 1, max = 20),
                                          numericInput(inputId = "snpdensoutheight", label = "Output file height:", value = 5, min = 1, max = 20),
                                          downloadButton('snpdenseData', 'Download Plot')),

                                 tabPanel("Plot",
                                          dropdownButton(
                                            tags$h3("Customize plot"),
                                            selectInput(inputId = "denscolor", label = "Density colors",
                                                    choices = c("darkgreen", "yellow", "red", "seagreen4", "steelblue4", "gray47", "mediumorchid", "cyan3", "darkorange3", "gray71"),
                                                    selected = c("darkgreen", "yellow", "red"), multiple = TRUE),
                                            numericInput(inputId = "binsize", label = "Choose SNP window size:", value = 1e6, min = 0, max = 1e20),
                                            circle = FALSE, status = "primary", icon = icon("gear"), width = "270px",
                                            tooltip = tooltipOptions(title = "Click to customize plot!"),
                                            actionButton("snpdensclick", "Plot", icon("paper-plane"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),
                                          withSpinner(plotOutput("snpdensityplot", height = 600), type = 5), width = 900, icon = icon("bar-chart-o"))
                                 )
                          )
                        )
