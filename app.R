
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)



# Define UI for miles per gallon app ----
ui <- fluidPage(
    
    # App title ----
    titlePanel("Sample Mercury Comparison"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Selector for variable to plot against mpg ----
            selectInput("variable", "Variable:",
                        c("Site" = "SITE",
                          "Species" = "SPECIES",
                          "Total Length (mm)" = "TOTAL_LENGTH")),
            
            # Input: Checkbox for whether outliers should be included ----
            checkboxInput("outliers", "Show outliers", TRUE)
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Formatted text for caption ----
            h3(textOutput("caption")),
            
            # Output: Plot of the requested variable against mpg ----
            plotOutput("mpgPlot")
            
        )
    )
)

# Data pre-processing ----
# Tweak the "am" variable to have nicer factor labels -- since this
# doesn't rely on any user inputs, we can do this once at startup
# and then use the value throughout the lifetime of the app
sampleData <-  read.csv("C:/Users/Caitlyn/Desktop/Caitlyn/mywebsite/App-1/my_app/sample.csv")


# Define server logic to plot various variables against mpg ----
server <- function(input, output) {  
    
    # Compute the formula text ----
    # This is in a reactive expression since it is shared by the
    # output$caption and output$mpgPlot functions
    formulaText <- reactive({
        paste("MERCURY ~", input$variable)
    })
    
    # Return the formula text for printing as a caption ----
    output$caption <- renderText({
        formulaText()
    })
    
    # Generate a plot of the requested variable against mpg ----
    # and only exclude outliers if requested
    output$mpgPlot <- renderPlot({
        boxplot(as.formula(formulaText()),
                data = sampleData,
                outline = input$outliers,
                col = "#007bc2", pch = 19)
    })
    
}

shinyApp(ui, server)




