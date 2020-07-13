# qqplot -----------------------------------------------------------------------

qqTab <- tabItem(tabName = "qqplot",
        fluidRow(

          tabBox(height = "700px", width = "250px",
                tabPanel(title = "Information", status = "primary", solidHeader = TRUE, icon = icon("info-circle"),
                   mainPanel(h3("About quantile-quantile (Q-Q) plots"),
                          p("The QQ plot is a graphical representation of the deviation of the observed P values from the null hypothesis:
                          the observed P values for each SNP are sorted from largest to smallest and plotted against expected values from a theoretical χ2-distribution.
                          QQ plots are a great way of looking at population structure and investigating if whether or not there may be population stratification."),
                          tags$hr(),
                          h3("Required file format(s)"),
                          p("Below is the required file format if you want to visualize QQ plots using gwaRs:"),
                          p(strong("•The header column label P is mandatory.", style = "color:red")),
                          img(src = "qqFormat.png", height = 80, width = 60),
                          p(strong("•gwaRs also accepts association (.assoc) files generated using PLINK")),
                          tags$hr(),
                          h3("Reference(s)"),
                          p("1. Ehret, G. B. (2010) ‘Genome-wide association studies: Contribution of genomics to understanding blood pressure and
                          essential hypertension’, Current Hypertension Reports. NIH Public Access, pp. 17–25. doi: 10.1007/s11906-009-0086-6."))),

                tabPanel(title = "Input/ Output", status = "primary", solidHeader = TRUE, icon = icon("file"), width = 5,
                          fileInput("qqFile", "Choose input file:", multiple = FALSE, accept = ".assoc"),
                          tags$hr(),
                          pickerInput(inputId = "qqFormat", label = "Choose format for plot output download",
                                      choices = c(".tif", ".png", ".jpg", ".pdf"),
                                      selected = ".tif", multiple = FALSE),
                          numericInput(inputId = "qqoutwidth", label = "Output file width:", value = 5, min = 1, max = 20),
                          numericInput(inputId = "qqoutheight", label = "Output file height:", value = 5, min = 1, max = 20),
                          downloadButton('qqData', 'Download Plot')),

                tabPanel("Plot",
                        dropdownButton(
                          tags$h3("Customize plot"),
                          chooseSliderSkin("Flat"),
                          setSliderColor(c("DodgerBlue", "DodgerBlue"), c(1, 2)),
                          selectInput(inputId = "pointColor", label = "Point color",
                                      choices = c("black", "red", "blue4", "orange3", "gray16", "red2", "seagreen4", "steelblue4", "gray47", "mediumorchid", "cyan3", "darkorange3"),
                                      selected = "black", multiple = FALSE),
                          selectInput(inputId = "diagLine", label = "Diagonal line type",
                                      choices = c("solid", "dashed"),
                                      selected = "solid", multiple = FALSE),
                          selectInput(inputId = "diagColor", label = "Diagonal line color",
                                      choices = c("black", "red", "blue4", "orange3", "gray16", "red2", "seagreen4", "steelblue4", "gray47", "mediumorchid", "cyan3", "darkorange3"),
                                      selected = "red", multiple = FALSE),
                          circle = FALSE, status = "primary", icon = icon("gear"), width = "270px",
                          tooltip = tooltipOptions(title = "Click to customize plot!"),
                          actionButton("qqclick", "Plot", icon("paper-plane"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),
                        withSpinner(plotOutput("qqplot", height = 600, width = 600), type = 5), icon = icon("bar-chart-o"))
                )
          )
        )
