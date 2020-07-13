# admixture --------------------------------------------------------------

admixtureTab <- tabItem(tabName = "admixture",
                        fluidRow(
                          
                          tabBox(height = "700px", width = "250px",
                                 tabPanel(title = "Input File", status = "primary", solidHeader = TRUE, width = 5,
                                          fileInput("admixqFile", "Choose Q file for Admixture analysis",
                                                    multiple = FALSE, accept = ".Q")),
                                 tabPanel("Plot", plotOutput("admixtureplot", height = 600, width = 900))
                                 )
                          )
                        )
