ui = navbarPage("AC 3.0: Self-Organizing Maps",
                theme = shinytheme("journal"),
                header = tags$head(
                  tags$link(rel = "stylesheet",
                            type = "text/css",
                            href = "style.css") 
                ),
                
# introduction
  tabPanel("Introduction",
    fluidRow(
      withMathJax(),
        column(width = 6, 
          wellPanel(
            class = "scrollable-well",
              div(
                class = "html-fragment",
                includeHTML("text/introduction.html")
                )
            )),
          column(width = 6,
            align = "center",
            img(src = "som-grid.png", height = "500px"),
                 )
            )),

# first activity
  tabPanel("RGB Colors",
    fluidRow(
      column(
        width = 6,
        wellPanel(
          class = "scrollable-well",
            div(
                class = "html-fragment",
                includeHTML("text/activity1.html")
                      ))),
        column(
          width = 6,
          align = "center",
            splitLayout(
              sliderInput("ac1_red", "red", width = "75%",
                          value = 128, min = 0, max = 255),
              sliderInput("ac1_green", "green", width = "75%", 
                          value = 128, min = 0, max = 255),
              sliderInput("ac1_blue", "blue", width = "75%", 
                          value = 128, min =  0, max = 255)
               ),
                    
                plotOutput("activity1a", height = "200px"),
                br(),br(),
                plotOutput("activity1b", height = "200px")
          
                    ))),

# second activity
tabPanel("Competition",
  fluidRow(
    column(
      width = 6,
        wellPanel(
          class = "scrollable-well",
          div(
            class = "html-fragment",
                 includeHTML("text/activity2.html")
               ))),
           column(
             width = 6,
             align = "center",
              plotOutput("activity2a", height = "400px"),
              img(src = "training-swatch.png", height = "35px"),
              br(), br(),
             div(
               style = "display: flex; align-items: center; gap: 10px;",
                sliderInput("row_number", "row", 
                            min = 1, max = 10, value = 1, 
                            width = "150px"),
                sliderInput("column_number", "column", 
                            min = 1, max = 10,  value = 1, 
                            width = "150px"),
                textOutput("rgb"),
                textOutput("distance")
              )
           ))),

# third activity
tabPanel("Cooperation",
         fluidRow(
           column(
             width = 6,
             wellPanel(
               class = "scrollable-well",
               div(
                 class = "html-fragment",
                 includeHTML("text/activity3.html")
               ))),
           column(
             width = 6,
             align = "center",
             splitLayout(
               sliderInput("stepsize", "step-size", width = "75%",
                           value = 0.5, step = 0.1, min = 0, max = 1),
               sliderInput("radius", "radius", width = "75%", 
                           value = 5, step = 1, min = 1, max = 10)
             ),
           plotOutput("activity3a", height = "250px"),
           plotOutput("activity3b", height = "250px")
           
         ))),

# fourth activity
tabPanel("Adaptation",
         fluidRow(
           column(
             width = 6,
             wellPanel(
               class = "scrollable-well",
               div(
                 class = "html-fragment",
                 includeHTML("text/activity4.html")
               ))),
           column(
             width = 6,
             align = "center",
             splitLayout(
               sliderInput("eta_0", "initial step-size", width = "70%",
                           value = 0.5, min = 0.1, max = 0.9, step = 0.1),
               sliderInput("radius_0", "initial radius", width = "70%", 
                           value = 5, min = 1, max = 10, step = 1),
               sliderInput("iterations", "iterations", width = "70%",
                           value = 1, min = 1, max = 25, step = 1)
             ),
               
           plotOutput("activity4a", height = "500px")
           
         ))),

tabPanel("Wrapping Up",
         fluidRow(
           column(
             width = 6,
             wellPanel(
               class = "scrollable-well",
               div(
                 class = "html-fragment",
                 includeHTML("text/wrapup.html")
               ))),
           column(
             width = 6,
             align = "center",
             br(),br(),
             img(src = "four_soms.png", height = "500px")
           ))),

) # keep as solo close for user interface
