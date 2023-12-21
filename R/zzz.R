shinyHLTHStartupMessage <- function()
{
  # Startup message obtained as 
  msg <- c(paste0(
    packageVersion("shinyHLTH")),
    "\nWelcome to the shinyHLTH package",
    "\nUse start_dashboard() to begin creating a new dashboard")
  return(msg)
}

.onAttach <- function(lib, pkg)
{
  # unlock .mclust variable allowing its modification
  unlockBinding(".shinyHLTH", asNamespace("shinyHLTH")) 
  # startup message
  msg <- shinyHLTHStartupMessage()
  if(!interactive())
    msg[1] <- paste("Package 'shinyHLTH' version", packageVersion("shinyHLTH"))
  packageStartupMessage(msg)      
  invisible()
}

# reference https://stackoverflow.com/questions/67986577/how-to-create-custom-start-up-messages-for-r-packages