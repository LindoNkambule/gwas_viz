# manhattan --------------------------------------------------------------------

manhattanTab <- tabItem(tabName = "manhattan",
                        fluidRow(

                          tabBox(height = "700px", width = "250px",

                                tabPanel(title = "Information", status = "primary", solidHeader = TRUE, icon = icon("info-circle"),
                                        mainPanel(h3("About Manhattan plots"),
                                                    p("Manhattan plots represent the P values of the entire GWAS on a genomic scale and
                                                    are a great way to distinguish significant SNPs from insignificant ones. With gwaRs, you can alter your plot,
                                                    using the dropdown button in the 'Plot' tab:
                                                    (1) Acording to Chromosome; (2) by adding a genomwide line to separate significant SNPs from insignificant one;
                                                    and (3) by annotating SNPs using a threshold p-value"),
                                                    tags$hr(),
                                                    h3("Required file format(s)"),
                                                    p("Below is the required file format if you want to visualize Manhattan plots using gwaRs."),
                                                    p(strong("•The header column labels SNP, CHR, P, and BP are mandatory and they can be in any order", style = "color:red")),
                                                    p(strong("•If your file has any X, Y, XY, MT etc. chromosomes, please change them to numbers
                                                    like 23, 24, 25, 26 as gwaRs requires all the chromosomes in the CHR column to be numeric", style = "color:red")),
                                                    img(src = "manFormat.png", height = 155, width = 165),
                                                    p(strong("•gwaRs also accepts association (.assoc) files generated using PLINK")),
                                                    tags$hr(),
                                                    h3("Reference(s)"),
                                                    p("1. Ehret, G. B. (2010) ‘Genome-wide association studies: Contribution of genomics to understanding blood pressure and
                                                    essential hypertension’, Current Hypertension Reports. NIH Public Access, pp. 17–25. doi: 10.1007/s11906-009-0086-6."))),

                                tabPanel(title = "Input/ Output", status = "primary", solidHeader = TRUE, icon = icon("file"), width = 5,
                                        fileInput("manhattanFile", "Choose input file:",
                                                    multiple = FALSE, accept = c(".assoc", ".txt")),
                                        tags$hr(),
                                        pickerInput(inputId = "manhattanFormat", label = "Choose format for plot output download",
                                                    choices = c(".tif", ".png", ".jpeg", ".pdf"),
                                                    selected = ".tif", multiple = FALSE),
                                        numericInput(inputId = "manoutwidth", label = "Output file width:", value = 10, min = 1, max = 20),
                                        numericInput(inputId = "manoutheight", label = "Output file height:", value = 8, min = 1, max = 20),
                                        downloadButton('manhattanData', 'Download Plot')),

                                tabPanel("Plot",
                                        dropdownButton(
                                          tags$h3("Customize plot"),
                                          selectInput(inputId = "chrom", label = "Which chromosome do you want to plot?",
                                                      choices = c("ALL", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                                                      "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "20", "21", "22", "23", "24", "25", "26"),
                                                      selected = "ALL", multiple = FALSE),
                                          selectInput(inputId = "chromcolor", label = "Chromosome colors",
                                                      choices = c("blue4", "orange3", "gray16", "red2", "seagreen4", "steelblue4", "gray47", "mediumorchid", "cyan3", "darkorange3", "gray71"),
                                                      selected = c("gray16", "gray47"), multiple = TRUE),
                                          tags$hr(),
                                          numericInput(inputId = "annotatePvalQ", label = "Put a threshold for annotating SNPs by p-value", value = NULL, min = 0, max = 1),
                                          selectInput(inputId = "annotateCol", label = "Select annotations color",
                                                      choices = c("red", "green", "blue", "yellow", "orange"), selected = "red", multiple = FALSE),
                                          numericInput(inputId = "genomewideline", label = "genomewideline:", value = NULL, min = 0, max = 15),
                                          circle = FALSE, status = "primary", icon = icon("gear"), width = "270px",
                                          tooltip = tooltipOptions(title = "Click to customize plot!"),
                                          actionButton("manclick", "Plot", icon("paper-plane"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),
                                        withSpinner(plotOutput("manhattanplot", height = 600), type = 5), width = 900, icon = icon("bar-chart-o")))
                          )
                        )
