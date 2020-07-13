# libraries
library(shiny)
library(shinydashboard)
#library(dashboardthemes)
library(shinycssloaders) # spinners for plot output
library(shinyWidgets)

# source tabs files
file.sources = list.files(c("tabs"),
                          pattern="*.R", full.names=TRUE,
                          ignore.case=TRUE)
sapply(file.sources,source,.GlobalEnv)

span("Basic ",
     span("dashboard",
          style = "color: red; font-size: 28px"))

ui <- dashboardPage(

  # header
  dashboardHeader(title = span("gwaRs: A Web Application for Visualizing Genome-Wide Association Studies Data",
                               style = "color: white; font-size: 28px; font-weight: bold"),
                  titleWidth = 1200),

  # side bars
  dashboardSidebar(

    # width
    width = 200,

    # menu items for side bars
    sidebarMenu(
      menuItem("Test Data", tabName = "testData", icon = icon("file")),
      menuItem("SNP Density", tabName = "snpdensity", icon = icon("chart-bar")),
      menuItem("Q-Q Plot", tabName = "qqplot", icon = icon("chart-bar")),
      menuItem("Manhattan Plot", tabName = "manhattan", icon = icon("chart-bar")),
      menuItem("PCA", tabName = "pca", icon = icon("chart-bar"))
      #menuItem("Admixture", tabName = "admixture", icon = icon("chart-bar"))

    ) # sidebarMenu

  ),

  # body
  dashboardBody(

    # theme
    #shinyDashboardThemes(
      #theme = "grey_light"
    #),

    # In the body, add tabItems with corresponding values for tabName
    tabItems(

      testdataTab,

      # snpdens ----------------------------------------------------------------
      snpdensityTab,

      # qqplot -----------------------------------------------------------------
      qqTab,

      # manhattan --------------------------------------------------------------
      manhattanTab,

      # pca --------------------------------------------------------------------
      pcaTab

      # admixture --------------------------------------------------------------
      #admixtureTab

    ) # tabItems

  ) # dashboardBody

) # dashboardPage
