#'Plotting function for displaying histograms and associated p-values
#'
#'Internal function for displaying significance histograms
#'
#'@param data_df a \code{data.frame}.
#'@param pval_2plot a \code{data.frame} with the p-values to display.
#'@param response_name a character string indicating the name of the response.
#'@param input internal input from UI.
#'@param inter a logical flag indicating whether we are in the interarm setting or not.
#'Default is \code{TRUE}.
#'@param baseline baseline value used in title when \code{inter} is \code{FALSE}.
#'Default is \code{NULL}.
#'
#'@return a \code{ggpubr} plot object
#'
#'@author Clément NERESTAN
#'
#'@keywords internal
#'
#'@import ggplot2
#'@import ggpubr
#'@import RColorBrewer

histogram_VICI <- function(data_df, pval_2plot, response_name, input, inter=TRUE, baseline=NULL){
  
  #browser()
  p <- NULL
  
  if(inter){
    #browser()
    data_df$arm <- relevel(data_df$arm, ref=input$selectRefArmInter)
    #browser()
    #suppressWarnings(
      #browser(),
      p <-
        ggbarplot(na.omit(data_df), x="stim",y="response",
                    color= "arm", palette = "RdGy",#c("Red","Blue","Black"),#"RdBu",
                  #fill="white",#"arm",
                  alpha=0.3,
                  sort.by.groups = TRUE) +
        #theme_bw() +
        # theme_grey() + 
        # #theme(panel.grid.major.x = element_blank()) +
        # #scale_colour_manual(values = CPCOLS) +
        scale_color_brewer(palette = input$color) +#"RdGy") +
        # #scale_fill_viridis_d("Arm: ") +
        # #scale_color_viridis_d("Arm: ") +
         stat_pvalue_manual(data = pval_2plot, label = "pvalue_format",
                            tip.length = 0.025) +
         #ylab(paste0("Response ", response_name)) +
         xlab("Stimulation") +
         ggtitle(paste0("Arm effect on ", response_name),
                 subtitle = "p-values taking into account background response levels through bivariate modeling") +
         labs(caption = "made with VICI")
    #)
  }else{
    data_df$time <- relevel(data_df$time, ref=input$selectRefTimeIntra)
    #browser()
    suppressWarnings(
    p <-
      ggbarplot(na.omit(data_df), x="stim", y="response", 
                  color="time",# palette = "RdGy",#c("Red","Blue","Black"),#"RdBu",
                #fill="white",#"time",
                alpha=0.3,
                sort.by.groups = TRUE) +
      # #theme_bw() +
      # theme_grey() + 
      # #scale_colour_manual(values = CPCOLS) +
       scale_color_brewer(palette = input$color)+#"RdGy") +
      # #scale_fill_viridis_d("Time-point: ") +
      # #scale_color_viridis_d("Time-point: ") +
       stat_pvalue_manual(data = pval_2plot, label = "pvalue_format",
                          tip.length =  0.025) +
      # ylab(paste0("Response ", response_name)) +
       xlab("Stimulation") +
       ggtitle(paste0("Intra-arm vaccine effect on ", response_name, " compared to baseline ", baseline),
               subtitle = "p-values taking into account background response levels through bivariate modeling") +
       labs(caption = "made with VICI")
    )
    
  }
  return(p)
  
}