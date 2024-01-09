
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to the shinyHLTH package version ", utils::packageVersion("shinyHLTH"), ' \nUse create_dashboard("Path") to begin creating a new dashboard')
}

# reference https://stackoverflow.com/questions/67986577/how-to-create-custom-start-up-messages-for-r-packages
# https://github.com/cran/mclust/blob/master/R/zzz.R

#https://r-pkgs.org/code.html#sec-code-r-landscape