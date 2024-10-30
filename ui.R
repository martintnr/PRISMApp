### Packages check

list.of.packages = c("shiny", "shinydashboard", "ggplot2", "data.table", "dplyr", "ggvis", "circlize", "splitstackshape", "visNetwork")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)>0){
  install.packages(new.packages, dependencies = TRUE)
}


library(shiny)
library(shinydashboard)
library(ggplot2)
library(data.table)
library(dplyr)
library(ggvis)
library(circlize)
library(splitstackshape)
library(visNetwork)
# library(shinycssloaders)

##############################################################################################################################
######################################################### Deployment #########################################################
##############################################################################################################################

# runApp('~/Partage/PleioMap/BioRes/Scripts/PRISM')
# library(rsconnect) ; setwd("~/Partage/PleioMap/BioRes/Scripts/") ; rsconnect::setAccountInfo(name='verbam01', token='54F6017970657E5E67DE79515AED53D2', secret='RUmGdgjYI6k9bPRNRZ3cooM2wCN3/FiY/8SL6Deo') ; deployApp("PRISM", appName = "PRISM")

shinyUI(dashboardPage(skin = "blue",

                      dashboardHeader(
                        title = "PRISM",
                        dropdownMenuOutput("messageMenu")
                      ),

                      ##############################################################################################################################
                      ########################################################## Sidebar ###########################################################
                      ##############################################################################################################################
                      dashboardSidebar(
                        sidebarMenu(
                          id = "tabs",
                          menuItem("About PRISM",
                                   tabName = "About",
                                   icon = icon("info")
                          ),
                          menuItem("Trait pleiotropic relationships",
                                   tabName = "TraitCau",
                                   icon = icon("arrows-turn-to-dots")
                          ),
                          menuItem("Top variant network",
                                   tabName = "VariantNet",
                                   icon = icon("diagram-project")
                          ),
                          menuItem("Variant network (full results)",
                                   tabName = "VariantNetFull",
                                   icon = icon("circle-nodes")
                          )
                        )
                      ),

                      #############################################################################################################################
                      ########################################################### Body ############################################################
                      ##############################################################################################################################
                      dashboardBody(
                        tabItems(
                          ##################################################################################################################################
                          tabItem(tabName = "About",

                                  # fluidRow(
                                  # 	infoBox(title = "How to run the app locally?",
                                  # 			"If you are experiencing any delays or issues with the online app, you can run it locally from R using the following command: ",
                                  # 			code('shiny::runGitHub(repo = "martintnr/PRISMApp", subdir = "")'),
                                  # 			icon = icon("circle-exclamation"),
                                  # 			fill = TRUE,
                                  # 			color = "orange",
                                  # 			width = 12
                                  # 	)
                                  # ),

                                  h1("Pleiotropic Relationships to Infer SNP Model - PRISM"),
                                  br(), br(),

                                  fluidRow(
                                    box(title = "Summary of the PRISM method",
                                        "Using molecular phenotypes (e.g. expression quantitative trait loci) to fine-map the associations between genetic variants and complex traits from genome-wide association studies (GWAS) seems highly limited because of the very small overlap between the two. Taking the opposite view to current methods, we propose to leverage pleiotropy, occurring when a genetic variant affects at least two traits, which is thought to play a central role in the genetic architecture of complex traits. We have developed PRISM (Pleiotropic Relationships to Infer SNP Model), an algorithm to detect both direct and pleiotropic effects of genome-wide variants. PleioVar derives variant effects from an integrative Mendelian Randomization method (i.e. LHC-MR) modeling pleiotropy, and allows to disentangle the effects using Gaussian mixture models, at the level of variants. To assess the performances of PleioVar, we built a comprehensive network GWAS simulation framework encompassing multiple complex scenarios. Then, using GWAS summary statistics from UK Biobank, we used PleioVar to disentangle the variant effects on a set of heritable traits and diseases.",
                                        img(src = "PRISM.jpeg", width = "100%", height = "auto"),
                                        solidHeader = TRUE,
                                        status = "primary",
                                        width = 12
                                    ),
                                  ),
                                  fluidRow(
                                    column(width = 4, valueBox(61, HTML("UK Biobank traits"), icon = icon("medkit"), width = 12, color = "blue")),
                                    column(width = 4, valueBox(format("4 millions", big.mark = ","), HTML("Variants analyzed with PRISM"), color = "light-blue", icon = icon("pie-chart"), width = 12)),
                                    column(width = 4, valueBox(format("393,076", big.mark = ","), HTML("Variants identified by PRISM"), color = "blue", icon = icon("check"), width = 12))
                                  ),
                                  fluidRow(
                                    infoBox(title = "Reference",
                                            uiOutput("TournaireEtAl"),
                                            icon = icon("graduation-cap"),
                                            fill = TRUE,
                                            width = 6
                                    ),
                                    infoBox(title = "Repository",
                                            uiOutput("github"),
                                            icon = icon("github"),
                                            fill = TRUE,
                                            width = 6
                                    )
                                  ),
                                  fluidRow(
                                    infoBox(title = "About",
                                            uiOutput("info"),
                                            width = 6,
                                            icon = icon("info"),
                                            fill = FALSE,
                                            color = "light-blue"
                                    ),
                                    infoBox(title = "Contact information",
                                            uiOutput("email"),
                                            width = 6,
                                            icon = icon("envelope"),
                                            fill = FALSE,
                                            color = "navy"
                                    )
                                  )
                          ),
                          tabItem(tabName = "TraitCau",
                                  h1("Visualization of the global pleiotropic relationships between traits"),
                                  br(), br(),
                                  fluidRow(
                                    box(title = "Pleiotropic relationships between traits",
                                        # sliderInput("PvalCutoff", label = "", min = 10^-10, step = 10^-6, max = 0.05, value = 10^-5),
                                        # seq(from = 10^-10, to = 0.05, by = 10^-9)
                                        img(src = "CircosPleiotropic relationships.jpeg", width = "100%", height = "auto"),
                                        # imageOutput("TraitCausal", height = "1100px", width = "1100px") %>% withSpinner(color="#0dc5c1"),
                                        status = "primary",
                                        solidHeader = TRUE,
                                        width = 12
                                    )
                                  )
                          ),

                          ##################################################################################################################################

                          tabItem(tabName = "VariantNet",
                                  h1("Visualization of the pleiotropic network of a genetic variant"),
                                  br(), br(),


                                  fluidRow(
                                    box(
                                      title = "Select a chromosome and visualize the pleiotropy of the genetic variants",
                                      selectInput("PleioType", label = "", choices = c(`Horizontal pleiotropy` = "No supplementary info", `Vertical pleiotropy` = "Suspected Vertical Pleiotropy", `Network pleiotropy` = "Detected Network Pleiotropy")),
                                      column(12, align = "center", ggvisOutput("ChromosomePlot")),
                                      # ggvisOutput("ChromosomePlot"),
                                      '* only the top variants are represented in this tab. Please go to the \"full results\" table',
                                      actionButton("GoToFullResults", "Go to full results tab"),
                                      status = "primary",
                                      solidHeader = TRUE,
                                      width = 12
                                    ),
                                  ),
                                  fluidRow(
                                    uiOutput("VariantSelect"),
                                    uiOutput("NbVariants")
                                  ),
                                  fluidRow(
                                    uiOutput("VariantNetworkTabs")
                                  )
                          ),
                          ##################################################################################################################################
                          tabItem(tabName = "VariantNetFull",
                                  h1("Visualization of the pleiotropic network of a genetic variant"),
                                  br(), br(),

                                  fluidRow(
                                    box(
                                      title = "Enter the variant ID to visualize its network.",
                                      textInput("ManualVariant", label = "", value = "1:109817192:A:G"),
                                      em('*Variant IDs must be entered as chr:position:allele1:allele2 or rsids (build 37/hg19). Here are some examples: 1:109817192:A:G / rs7528419, 18:57884750:G:A / rs12970134, 4:72608383:T:G / rs2282679'),
                                      status = "primary",
                                      solidHeader = TRUE,
                                      width = 12
                                    )
                                  ),
                                  fluidRow(
                                    uiOutput("VariantNetworkTabsFull")
                                  )
                          )
                          ##################################################################################################################################
                        )
                      )
)
)
