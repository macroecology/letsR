# Function to get and fix species names
# Used inside lets.iucn functions
# Bruno Vilela

.getnames <- function(input) {
  
  # Get species from a PAM
  if (class(input) == "PresenceAbsence") {
    input <- input$S
  }
  
  # Accept species separeted by underline or space
  input <- gsub(as.matrix(input), pattern = "_", 
                replacement = " ")
  
  # Remove space from the beggining and end
  trim <- function(x) {gsub("^\\s+|\\s+$", "", x)}
  input <- as.vector(trim(input))
  count2 <- function(x){length(x) != 2}
  binomialerror <- sapply((strsplit(input, " ")),
                          count2)
  sps <- which(binomialerror)
  sps_name <- paste("\t", input[sps], "\n")
  # Error in species name control
  if (length(sps) > 0) {
    warning(paste("The following species do not follow a binomial nomeclature:\n",
                  paste(sps_name, collapse = "")))
  }
  return(input)
}