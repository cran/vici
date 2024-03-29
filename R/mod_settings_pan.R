# Module UI

#' @title   mod_settings_pan_ui and mod_settings_pan_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param datas internal
#' @param parent
#'
#' @rdname mod_settings_pan
#'
#' @keywords internal
#' @export
#' @importFrom shiny NS tagList
#' @import shinyWidgets
#' @import scales
mod_settings_pan_ui <- function(id){
  ns <- NS(id)
  listPal <- list("Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd","PuBu",
                  "PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd",
                  "BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral",
                  "Set3","Set2","Set1","Pastel2","Pastel1","Paired","Dark2","Accent")
  tagList(
    sidebarPanel(
      # Input: Select a file ----
        h3("Data input"),
        fileInput(ns("datafile"), label = "Choose a CSV/TXT file to import",
                  multiple = FALSE,
                  accept = c("text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv")),

       # Input: Checkbox if file has header ----
        checkboxInput(ns("header"), "Header", TRUE),

        # Input: Select separator ----
        radioButtons(ns("sep"), "Separator",
                     choices = c(Comma = ",",
                                 Semicolon = ";",
                                 Tab = "\t"),
                     selected = "\t"),

      # Input: Select quotes ----
       radioButtons("quote", "Quote",
                    choices = c(None = "",
                                "Double Quote" = '"',
                                "Single Quote" = "'"),
                    selected = '"'),

      # Horizontal line ----
       tags$hr(),

      h3("Input parameters"),
      selectInput(ns("selectModel"), label = "Model choice",
                  choices = list("inter-arm (ARM Compare)" = 1, "intra-arm (TimePoint Compare)" = 2),
                  selected = 2),

      h4("Variable specification"),
      selectizeInput(ns("selectSubject"), label = "Select the column that identifies the subject ID",
                     choices = c(Choose = "", NULL),
                     options = list(placeholder = 'Please select a column name below')
      ),

      selectizeInput(ns("selectResponse"), label = "Select the column(s) that identify ICS response",
                     choices = c(Choose = "", NULL),
                     options = list(placeholder = 'Please select a column name below'),
                     multiple = TRUE
      ),

      selectizeInput(ns("selectStim"), label = "Select the column that identifies the stimulation",
                     choices = c(Choose = "", NULL),
                     options = list(placeholder = 'Please select a column name below')
      ),
      conditionalPanel(
        condition = sprintf("input['%s']!= '' & !output.stimisfactor",ns("selectStim")),#"input.selectStim != '' & !output.stimisfactor",
        verbatimTextOutput(ns("warningstimisfactor"))
      ),
      conditionalPanel(
        condition = sprintf("input['%s'] != '' & output.stimisfactor",ns("selectStim")),#"input.selectStim != '' & output.stimisfactor",
        selectizeInput(ns("selectRefStim"), label = "Select the value that identifies background samples",
                       choices =c(Choose = "", NULL))
      ),

      conditionalPanel(
        condition = sprintf("input['%s'] == 1",ns("selectModel")),#"input.selectModel == 1",
        selectizeInput(ns("selectArmInter"), label = "Select the column that identifies the arm",
                       choices = c(Choose = "", NULL),
                       options = list(placeholder = 'Please select a column name below')
        )
      ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 1 & input['%s'] != '' & !output.armisfactor & output.warningarmisfactor != null",ns("selectModel"),ns("selectArmInter")),#"input.selectModel == 1 & input.selectArmInter != '' & !output.armisfactor & output.warningarmisfactor != null",
        verbatimTextOutput(ns("warningarmisfactor"))
      ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 1 & input['%s'] != '' & output.armisfactor",ns("selectModel"),ns("selectArmInter")),#"input.selectModel == 1 & input.selectArmInter != '' & output.armisfactor",
        selectizeInput(ns("selectRefArmInter"), label = "Select the value that identifies the reference arm",
                       choices =c(Choose = "", NULL))
      ),

      conditionalPanel(
        condition = sprintf("input['%s'] == 1",ns("selectModel")),#"input.selectModel == 1",
        selectizeInput(ns("selectTimeInter"), label = "If several time-points (optional), please select the column that identifies the observation's time-point",
                       choices = c(Choose = "", NULL),
                       options = list(placeholder = 'Please select a column name below')
        )
      ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 1 & input['%s'] != '' ",ns("selectModel"),ns("selectTimeInter")) ,#"input.selectModel == 1 & input.selectTimeInter != '' ",
        selectizeInput(ns("selectRefTimeInter"), label = "Select the time-point to analyze",
                       choices =c(Choose = "", NULL))
      ),

      conditionalPanel(
        condition = sprintf("input['%s'] == 2",ns("selectModel")),#"input.selectModel == 2",
        selectizeInput(ns("selectTimeIntra"), label = "Select the column that identifies the time-points",
                       choices = c(Choose = "", NULL),
                       options = list(placeholder = 'Please select a column name below')
        )
      ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 2 & input['%s'] != ''",ns("selectModel"),ns("selectTimeIntra")),#"input.selectModel == 2 & input.selectTimeIntra != ''",
        selectizeInput(ns("selectRefTimeIntra"), label = "Select the value that identifies the reference time-point",
                       choices =c(Choose = "", NULL))
      ),

      conditionalPanel(
        condition = sprintf("input['%s'] == 2",ns("selectModel")),#"input.selectModel == 2",
        selectizeInput(ns("selectArmIntra"), label = "If several arms (optional) please select the column that identifies the observation's arm",
                       choices = c(Choose = "", NULL),
                       options = list(placeholder = 'Please select a column name below')
        )
      ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 2 & input['%s'] != '' & !output.armisfactor2 & output.warningarm2isfactor != null",ns("selectModel"),ns("selectArmIntra")) ,#"input.selectModel == 2 & input.selectArmIntra != '' & !output.armisfactor2 & output.warningarm2isfactor != null",
        verbatimTextOutput(ns("warningarm2isfactor"))
      ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 2 & input['%s'] != '' & output.arm2isfactor",ns("selectModel"),ns("selectArmIntra")) ,#"input.selectModel == 2 & input.selectArmIntra != '' & output.arm2isfactor",
        selectizeInput(ns("selectRefArmIntra"), label = "Select the arm to analyze",
                       choices =c(Choose = "", NULL))
      ),

      h4("Denominator degrees of freedom approximations"),
      radioButtons(ns("ddf"), NULL,
                   choices = c("By default",
                               "Between-Within",
                               "Satterthwaite",
                               "Kenward-Roger"),
                   selected = "Between-Within"),

      radioButtons(ns("plot"), "Choose the type of plot",
                   choices = c(Boxplot = "boxplot"),
                   #Histogram = "histogram"),
                   selected = "boxplot"),
      

      pickerInput(inputId = ns("color"),
                  label = "Color palette",
                  choices =       listPal <- list("Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd","PuBu",
                                                  "PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd",
                                                  "BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral",
                                                  "Set3","Set2","Set1","Pastel2","Pastel1","Paired","Dark2","Accent"),#c("pal1","pal2", "pal3", "pal4"),#df$val,
                  selected = "Set1",
                  choicesOpt = list(content = c(sprintf("<img src='www/palettes/Blues.png' width=30px><div class='jhr'>%s</div></img>", "Blues"),
                                                sprintf("<img src='www/palettes/BuGn.png' width=30px><div class='jhr'>%s</div></img>", "BuGn"),
                                                sprintf("<img src='www/palettes/BuPu.png' width=30px><div class='jhr'>%s</div></img>", "BuPu"),
                                                sprintf("<img src='www/palettes/GnBu.png' width=30px><div class='jhr'>%s</div></img>", "GnBu"),
                                                sprintf("<img src='www/palettes/Greens.png' width=30px><div class='jhr'>%s</div></img>", "Greens"),
                                                sprintf("<img src='www/palettes/Greys.png' width=30px><div class='jhr'>%s</div></img>", "Greys"),
                                                sprintf("<img src='www/palettes/Oranges.png' width=30px><div class='jhr'>%s</div></img>", "Oranges"),
                                                sprintf("<img src='www/palettes/OrRd.png' width=30px><div class='jhr'>%s</div></img>", "OrRd"),
                                                sprintf("<img src='www/palettes/PuBu.png' width=30px><div class='jhr'>%s</div></img>", "PuBu"),
                                                sprintf("<img src='www/palettes/PuBuGn.png' width=30px><div class='jhr'>%s</div></img>", "PuBuGn"),
                                                sprintf("<img src='www/palettes/PuRd.png' width=30px><div class='jhr'>%s</div></img>", "PuRd"),
                                                sprintf("<img src='www/palettes/Purples.png' width=30px><div class='jhr'>%s</div></img>", "Purples"),
                                                sprintf("<img src='www/palettes/RdPu.png' width=30px><div class='jhr'>%s</div></img>", "RdPu"),
                                                sprintf("<img src='www/palettes/Reds.png' width=30px><div class='jhr'>%s</div></img>", "Reds"),
                                                sprintf("<img src='www/palettes/YlGn.png' width=30px><div class='jhr'>%s</div></img>", "YlGn"),
                                                sprintf("<img src='www/palettes/YlGnBu.png' width=30px><div class='jhr'>%s</div></img>", "YlGnBu"),
                                                sprintf("<img src='www/palettes/YlOrBr.png' width=30px><div class='jhr'>%s</div></img>", "YlOrBr"),
                                                sprintf("<img src='www/palettes/YlOrRd.png' width=30px><div class='jhr'>%s</div></img>", "YlOrRd"),
                                                sprintf("<img src='www/palettes/BrBG.png' width=30px><div class='jhr'>%s</div></img>", "BrBG"),
                                                sprintf("<img src='www/palettes/PiYG.png' width=30px><div class='jhr'>%s</div></img>", "PiYG"),
                                                sprintf("<img src='www/palettes/PRGn.png' width=30px><div class='jhr'>%s</div></img>", "PRGn"),
                                                sprintf("<img src='www/palettes/PuOr.png' width=30px><div class='jhr'>%s</div></img>", "PuOr"),
                                                sprintf("<img src='www/palettes/RdBu.png' width=30px><div class='jhr'>%s</div></img>", "RdBu"),
                                                sprintf("<img src='www/palettes/RdGy.png' width=30px><div class='jhr'>%s</div></img>", "RdGy"),
                                                sprintf("<img src='www/palettes/RdYlBu.png' width=30px><div class='jhr'>%s</div></img>", "RdYlBu"),
                                                sprintf("<img src='www/palettes/RdYlGn.png' width=30px><div class='jhr'>%s</div></img>", "RdYlGn"),
                                                sprintf("<img src='www/palettes/Spectral.png' width=30px><div class='jhr'>%s</div></img>", "Spectral"),
                                                sprintf("<img src='www/palettes/Set3.png' width=30px><div class='jhr'>%s</div></img>", "Set3"),
                                                sprintf("<img src='www/palettes/Set2.png' width=30px><div class='jhr'>%s</div></img>", "Set2"),
                                                sprintf("<img src='www/palettes/Set1.png' width=30px><div class='jhr'>%s</div></img>", "Set1"),
                                                sprintf("<img src='www/palettes/Pastel2.png' width=30px><div class='jhr'>%s</div></img>", "Pastel2"),
                                                sprintf("<img src='www/palettes/Pastel1.png' width=30px><div class='jhr'>%s</div></img>", "Pastel1"),
                                                sprintf("<img src='www/palettes/Paired.png' width=30px><div class='jhr'>%s</div></img>", "Paired"),
                                                sprintf("<img src='www/palettes/Dark2.png' width=30px><div class='jhr'>%s</div></img>", "Dark2"),
                                                sprintf("<img src='www/palettes/Accent.png' width=30px><div class='jhr'>%s</div></img>", "Accent")
    ))),

      radioButtons(ns("jiter"), "Dot of Boxplot",
                   choices = c(Filed = "19",
                               Empty = "1",
                               None = "None"),
                   selected = "19"),

      tags$hr(),
      h3("Run analysis"),
      mod_modelfit_ui("modelfit_ui_1"),

      h3(),
      tags$hr(),
      h3("Example data"),
      fluidRow(
        actionButton(ns("loadExample"), label = "load example data")
      ),
      fluidRow(
        downloadButton(ns("downloadExData"), label = "download example data")
      )
    )
  )
}

# Module Server

#' @rdname mod_settings_pan
#' @export
#' @keywords internal

mod_settings_pan_server <- function(input, output, session,datas,parent){
  ns <- session$ns

  # example data
  output$downloadExData <- downloadHandler(   #Fait appel à une lib externe donc pas besoin de tester
    filename = "exampleICSdata.txt",
    content = function(file) {
      utils::write.table(vici::ICS_ex, file, row.names = FALSE, sep="\t", quote = FALSE)
    }
  )

  observeEvent(input$loadExample,{

    datas$df <<- vici::ICS_ex

    clean_output(output)

    parent$output$table2render <- DT::renderDataTable(datas$df,
                                               options = list(pageLength = 10, lengthMenu = list(c(5, 10, -1), c('5', '10', 'All')))
    )
    output$mod <- reactive(NULL)
    output$mod_display <- reactive(FALSE)
    updateRadioButtons(session, inputId = "sep", selected = "\t")
    updateCheckboxInput(session, inputId = "header", value = TRUE)

    observeEvent(input$selectModel, {
      if (input$selectModel==1){
        available_vars_init <- colnames(datas$df)
        updateSelectizeInput(session, "selectSubject",
                             selected = 'Subject',
                             choices = c('', available_vars_init),
                             options = list(placeholder = 'Please select a variable below')
        )
        updateSelectizeInput(session, "selectResponse",
                             selected = c('Response1', 'Response2'),
                             choices = c('', available_vars_init),
                             options = list(placeholder = 'Please select a variable below')
        )
        updateSelectizeInput(session, "selectStim",
                             selected = 'StimulationPool',
                             choices = c('', available_vars_init),
                             options = list(placeholder = 'Please select a variable below')
        )
        updateSelectizeInput(session, "selectRefStim",
                             selected = 'NS',
                             choices = c(levels(datas$df$StimulationPool))
        )
        updateSelectizeInput(session, "selectArmInter",
                             selected = 'Arm',
                             choices = c('', available_vars_init),
                             options = list(placeholder = 'Please select a variable below')
        )
        updateSelectizeInput(session, "selectRefArmInter",
                             selected = 'Placebo',
                             choices = c(levels(datas$df$Arm))
        )
        updateSelectizeInput(session, "selectTimeInter",
                             selected = 'TimePoint',
                             choices = c('', available_vars_init),
                             options = list(placeholder = 'Please select a variable below')
        )
        updateSelectizeInput(session, "selectRefTimeInter",
                             selected = 'D1',
                             choices = c(levels(datas$df$TimePoint))
        )
        updateTabsetPanel(parent, "inTabset", selected = "dataTab")
      }else if (input$selectModel==2){
        available_vars_init <- colnames(datas$df)
        updateSelectizeInput(session, "selectSubject",
                             selected = 'Subject',
                             choices = c('', available_vars_init),
                             options = list(placeholder = 'Please select a variable below')
        )
        updateSelectizeInput(session, "selectResponse",
                             selected = c('Response1', 'Response2'),
                             choices = c('', available_vars_init),
                             options = list(placeholder = 'Please select a variable below')
        )
        updateSelectizeInput(session, "selectStim",
                             selected = 'StimulationPool',
                             choices = c('', available_vars_init),
                             options = list(placeholder = 'Please select a variable below')
        )
        updateSelectizeInput(session, "selectRefStim",
                             selected = 'NS',
                             choices = c(levels(datas$df$StimulationPool))
        )
        updateSelectizeInput(session, "selectTimeIntra",
                             selected = 'TimePoint',
                             choices = c('', available_vars_init),
                             options = list(placeholder = 'Please select a variable below')
        )
        updateSelectizeInput(session, "selectRefTimeIntra",
                             selected = 'D0',
                             choices = c(levels(datas$df$TimePoint))
        )
        updateSelectizeInput(session, "selectArmIntra",
                             selected = 'Arm',
                             choices = c('', available_vars_init),
                             options = list(placeholder = 'Please select a variable below')
        )
        updateSelectizeInput(session, "selectRefArmIntra",
                             selected = 'A2',
                             choices = c(levels(datas$df$Arm))
        )
        updateTabsetPanel(parent, "inTabset", selected = "dataTab")

      }
    })
  })


  observeEvent({input$datafile; input$header; input$sep}, {
    req(input$datafile)
    datas$df <- {
      # when reading semicolon separated files,
      # having a comma separator causes `read.csv` to error

      tryCatch(
        {
          df <- utils::read.csv(input$datafile$datapath,
                                header = input$header,
                                sep = input$sep)

        },
        error = function(e){ stop(safeError(e)) } # return a safeError if a parsing error occurs
      )

      #Setters
      clean_output(parent$output)
      parent$output$mod <- reactive(NULL)
      parent$output$mod_display <- reactive(FALSE)
      df}

    available_vars_init <- colnames(datas$df)
    updateSelectizeInput(session, "selectSubject",
                         selected = '',
                         choices = c('', available_vars_init),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectResponse",
                         selected = '',
                         choices = c('', available_vars_init),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectStim",
                         selected = '',
                         choices = c('', available_vars_init),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectArmInter",
                         selected = '',
                         choices = c('', available_vars_init),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectArmIntra",
                         selected = '',
                         choices = c('', available_vars_init),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectTimeIntra",
                         selected = '',
                         choices = c('', available_vars_init),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectTimeInter",
                         selected = '',
                         choices = c('', available_vars_init),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectRefTimeIntra",
                         selected = ''
    )
    updateSelectizeInput(session, "selectRefTimeInter",
                         selected = ''
    )
    updateSelectizeInput(session, "selectRefArmInter",
                         selected = ''
    )
    updateSelectizeInput(session, "selectRefArmIntra",
                         selected = ''
    )
    updateSelectizeInput(session, "selectRefStim",
                         selected = ''
    )
    updateTabsetPanel(parent, "inTabset", selected = "dataTab")
  })

  parent$output$table2render <- DT::renderDataTable(
    {
      datas$df
    },
    options = list(pageLength = 10, lengthMenu = list(c(5, 10, -1), c('5', '10', 'All')))
  )


  # update available variables for selection ----
  # observeEvent available_vars ----
  observeEvent(datas$available_vars, {
    updateSelectizeInput(session, "selectSubject",
                         choices = c(input$selectSubject, datas$available_vars, intToUtf8(160)),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectResponse",
                         selected = input$selectResponse,
                         choices = as.list(c(input$selectResponse, datas$available_vars, intToUtf8(160))),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectStim",
                         choices = c(input$selectStim, datas$available_vars, intToUtf8(160)),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectArmInter",
                         choices = c(input$selectArmInter, datas$available_vars, intToUtf8(160)),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectArmIntra",
                         choices = c(input$selectArmIntra, datas$available_vars, intToUtf8(160)),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectTimeIntra",
                         choices = c(input$selectTimeIntra, datas$available_vars, intToUtf8(160)),
                         options = list(placeholder = 'Please select a variable below')
    )
    updateSelectizeInput(session, "selectTimeInter",
                         choices = c(input$selectTimeInter, datas$available_vars, intToUtf8(160)),
                         options = list(placeholder = 'Please select a variable below')
    )}
  )

  observeEvent(input$selectSubject, {
    if (input$selectSubject != ''){
      datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))
    }
    clean_output(output)
  })

  observeEvent(input$selectStim, {
    if (input$selectStim != ''){
      datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))
      if (input$selectStim %in% colnames(datas$df)){
        selected_stim_var <- factor(datas$df[, input$selectStim])
        if(is.factor(selected_stim_var)){
          output$stimisfactor <- reactive(TRUE)
          possible_stims <- levels(selected_stim_var)
          output$warningstimisfactor <- reactive(NULL)
          datas$fact_stim_OK <- TRUE
        }else{
          output$stimisfactor <- reactive(FALSE)
          output$warningstimisfactor <- reactive(paste0("WARNING: '", input$selectStim, "' is not a factor"))
          datas$fact_stim_OK <- FALSE
          possible_stims <- paste0("Error: '", input$selectStim, "' is not a factor\nPlease select a different variable")
        }
        updateSelectizeInput(session, "selectRefStim",
                             choices = c(possible_stims[1], possible_stims),
                             selected = ifelse(input$selectRefStim=='', possible_stims[1], input$selectRefStim)
        )
      }else{
        output$stimisfactor <- reactive(FALSE)
        output$warningstimisfactor <- reactive(paste0("WARNING: '", input$selectStim, "' is not a column in the input data"))
        datas$fact_stim_OK <- FALSE
      }
    }
    clean_output(output)
  })

  observeEvent(input$selectResponse, {
    if (length(input$selectResponse) >= 1){
      if (input$selectResponse[1] != ''){

        datas$available_vars <- update_vars(input, possibilities = colnames(datas$df))

        clean_output(output)
      }
    }
  })

  observeEvent(input$selectArmInter, {
    if (input$selectArmInter != ''){

      datas$available_vars <- update_vars(input, possibilities = colnames(datas$df))


      if (input$selectArmInter %in% colnames(datas$df)){
        selected_arm_var <- factor(datas$df[, input$selectArmInter])
        if(is.factor(selected_arm_var)){
          output$armisfactor <- reactive(TRUE)
          possible_arms <- levels(selected_arm_var)
          output$warningarmisfactor <- reactive(NULL)
          datas$fact_arm_OK <- TRUE
        }else{
          output$armisfactor <- reactive(FALSE)
          output$warningarmisfactor <- reactive(paste0("WARNING: '", input$selectArmInter,
                                                       "' is not a factor"))
          datas$fact_arm_OK <- FALSE
          possible_arms <- paste0("Error: '", input$selectArmInter,
                                  "' is not a factor\nPlease select a different variable")
        }
        updateSelectizeInput(session, "selectRefArmInter",
                             choices = c(possible_arms[1], possible_arms),
                             selected = ifelse(is.null(input$selectRefArmInter) | (length(input$selectRefArmInter)>0 && input$selectRefArmInter==''),
                                               possible_arms[1], input$selectRefArmInter)
        )
      }else if(input$selectArmInter != intToUtf8(160)){
        output$armisfactor <- reactive(FALSE)
        output$warningarmisfactor <- reactive(paste0("WARNING: '", input$selectArmInter,
                                                     "' is not a column in the input data"))
        datas$fact_arm_OK <- FALSE
      }else{
        output$armisfactor <- reactive(FALSE)
        output$warningarmisfactor <- reactive(NULL)
        datas$fact_arm_OK <- FALSE

        datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df)) #A tester

      }
    }else{

      datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))

    }
    clean_output(output)
  })


  observeEvent(input$selectArmIntra, {
    if (input$selectArmIntra != ''){

      datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))


      if (input$selectArmIntra %in% colnames(datas$df)){
        selected_arm2_var <- factor(datas$df[, input$selectArmIntra])
        if(is.factor(selected_arm2_var)){
          output$arm2isfactor <- reactive(TRUE)
          possible_arm2s <- levels(selected_arm2_var)
          output$warningarm2isfactor <- reactive(NULL)
          datas$fact_arm2_OK <- TRUE
        }else{
          output$arm2isfactor <- reactive(FALSE)
          output$warningarm2isfactor <- reactive(paste0("WARNING: '", input$selectArmIntra,
                                                        "' is not a factor"))
          datas$fact_arm2_OK <- FALSE
          possible_arm2s <- paste0("Error: '", input$selectArmIntra,
                                   "' is not a factor\nPlease select a different variable")
        }
        updateSelectizeInput(session, "selectRefArmIntra",
                             choices = c(possible_arm2s[1], possible_arm2s),
                             selected = ifelse(is.null(input$selectRefArmIntra) | (length(input$selectRefArmIntra)>0 && input$selectRefArmIntra==''),
                                               possible_arm2s[1], input$selectRefArmIntra)
        )
      }else if(input$selectArmIntra != intToUtf8(160)){
        output$arm2isfactor <- reactive(FALSE)
        output$warningarm2isfactor <- reactive(paste0("WARNING: '", input$selectArmIntra,
                                                      "' is not a column in the input data"))
        datas$fact_arm2_OK <- FALSE
      }else{
        output$arm2isfactor <- reactive(FALSE)
        output$warningarm2isfactor <- reactive(NULL)
        datas$fact_arm2_OK <- FALSE
        datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))
      }
    }else{
      datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))
    }
    clean_output(output)
  })

  observeEvent(input$selectModel, {
    if(!is.null(datas$available_vars)){
      updateSelectizeInput(session, "selectArmInter",
                           choices = union(c('', datas$available_vars),
                                           union(union(input$selectArmInter, input$selectArmIntra), input$selectTimeInter))
      )
      updateSelectizeInput(session, "selectArmIntra",
                           choices = union(c('', datas$available_vars),
                                           union(union(input$selectArmInter, input$selectArmIntra), input$selectTimeIntra))
      )
      updateSelectizeInput(session, "selectTimeIntra",
                           choices = union(c('', datas$available_vars),
                                           union(union(input$selectArmInter, input$selectArmIntra), input$selectTimeIntra))
      )
      updateSelectizeInput(session, "selectTimeInter",
                           choices = union(c('', datas$available_vars),
                                           union(union(input$selectArmInter, input$selectArmIntra), input$selectTimeInter))
      )
      updateSelectizeInput(session, "selectRefTimeIntra",
                           selected = ''
      )
      updateSelectizeInput(session, "selectRefTimeInter",
                           selected = ''
      )
      updateSelectizeInput(session, "selectRefArmInter",
                           selected = ''
      )
      updateSelectizeInput(session, "selectRefArmIntra",
                           selected = ''
      )
    }
    clean_output(output)
  }
  )

  # observe time ----
  observeEvent(input$selectTimeIntra, {
    if (input$selectTimeIntra != ''){
      datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))
      if(input$selectTimeIntra %in% colnames(datas$df)){
        datas$df[, input$selectTimeIntra] <- as.factor(as.character(datas$df[, input$selectTimeIntra]))
        selected_time_var <- datas$df[, input$selectTimeIntra]
        output$timeisfactor <- reactive(TRUE)
        possible_times <- levels(selected_time_var)
        output$warnintimeisfactor <- reactive(NULL)
        datas$fact_time_OK <- TRUE

        updateSelectizeInput(session, "selectRefTimeIntra",
                             choices = c(possible_times[1], possible_times),
                             selected = ifelse(is.null(input$selectRefTimeIntra) | (length(input$selectRefTimeIntra)>0 && input$selectRefTimeIntra==''),
                                               possible_times[1], input$selectRefTimeIntra)
        )
      }else if(input$selectTimeIntra != intToUtf8(160)){
        output$timeisfactor <- reactive(FALSE)
        output$warnintimeisfactor <- reactive(paste0("WARNING: '", input$selectTimeIntra,
                                                     "' is not a column in the input datas"))
        datas$fact_time_OK <- FALSE
      }else{
        output$timeisfactor <- reactive(FALSE)
        output$warnintimeisfactor <- reactive(NULL)
        datas$fact_time_OK <- FALSE
        datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))
      }
    }else{
      datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))
    }
    clean_output(output)
  })

  # observe time ----
  observeEvent(input$selectTimeInter, {
    if (input$selectTimeInter != ''){
      datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))
      if(input$selectTimeInter %in% colnames(datas$df)){
        datas$df[, input$selectTimeInter] <- as.factor(as.character(datas$df[, input$selectTimeInter]))
        selected_time2_var <- datas$df[, input$selectTimeInter]
        output$time2isfactor <- reactive(TRUE)
        possible_times2 <- levels(selected_time2_var)
        output$warnintime2isfactor <- reactive(NULL)
        datas$fact_time2_OK <- TRUE

        updateSelectizeInput(session, "selectRefTimeInter",
                             choices = c(possible_times2[1], possible_times2),
                             selected = ifelse(is.null(input$selectRefTimeInter) | (length(input$selectRefTimeInter)>0 && input$selectRefTimeInter==''),
                                               possible_times2[1], input$selectRefTimeInter)
        )
      }else if(input$selectTimeInter != intToUtf8(160)){
        output$time2isfactor <- reactive(FALSE)
        output$warnintime2isfactor <- reactive(paste0("WARNING: '", input$selectTimeInter,
                                                      "' is not a column in the input data"))
        datas$fact_time2_OK <- FALSE
      }else{
        output$time2isfactor <- reactive(FALSE)
        output$warnintime2isfactor <- reactive(NULL)
        datas$fact_time2_OK <- FALSE
        datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))
      }
    }else{
      datas$available_vars <-  update_vars(input, possibilities = colnames(datas$df))
    }
    clean_output(output)
  })


  observeEvent(input$ddf, {

    clean_output(parent$output)
  })


  observeEvent({input$selectRefArmInter; input$selectRefArmIntra; input$selectRefStim; input$selectRefTimeIntra; input$selectRefTimeInter}, {
    clean_output(output)
  })

  return(input)
}

## To be copied in the UI
# mod_settings_pan_ui("settings_pan_ui_1")

## To be copied in the server
# callModule(mod_settings_pan_server, "settings_pan_ui_1")

## Code to generate the png files:
# library(ggplot2)
 # listPal <- list("Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd","PuBu",
 #                  "PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd",
 #                  "BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral",
 #                  "Set3","Set2","Set1","Pastel2","Pastel1","Paired","Dark2","Accent")
 # n <- 5
 # for(pal in listPal){
 #   ggplot(data.frame(x=as.character(1:5), y=1)) +
 #     geom_tile(aes(x=x, y=y, fill=x)) +
 #     scale_fill_manual(values = RColorBrewer::brewer.pal(n = n, name = pal)) +
 #     theme_void() +
 #     guides(fill="none") +
 #     scale_x_discrete(expand=c(0,0)) +
 #     scale_y_continuous(expand=c(0,0))
 # }
