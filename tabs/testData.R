testdataTab <- tabItem(tabName = "testData",
        fluidRow(
          tabBox(height = "700px", width = "250px",
          tabPanel(title = "Information", status = "primary", solidHeader = TRUE, icon = icon("file"),
          mainPanel(h2("Test Data"),
          tags$hr(),
          p("This tab contains two (gzip compressed) files that you can download to test the application."),
          tags$hr(),
          h3("Association file"),
          downloadButton("testAssoc", label = "Download Assoc file"),
          tags$hr(),
          h3("PCA file"),
          downloadButton("testPCA", label = "Download PCA file")
        )
      )
    )
  )
)
