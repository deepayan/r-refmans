# npx is a npm package installed with npm i accessibility checker (with npm == 10.8.1)
# "scanID": "855bf216-11d4-4a23-9ee7-bf2d701ae88f",
# "toolID": "accessibility-checker-v3.1.73",

system2("npx", "achecker --outputfolder results  --baselineFolder results docs")

## Parse output of json files
## 
check_json <- function(folder = "results")  {
  all_checks <- list.files(path = folder, pattern = "*.html.json", 
                           full.names = TRUE, recursive = TRUE)

  common_problems <- vector("character", length = length(all_checks))
  common_rule <- common_type <- common_help <- common_problems
  
  
  for (check in all_checks) {
    check_pkg <- jsonlite::read_json(check)
    for (result in check_pkg$results) {
      value <- "fail"
      if (any(result$value == "POTENTIAL")) {
        value <- "potential"
      }
      violation <- result$message
      if (!violation %in% common_problems) {
        position_in_vector <- which(!nzchar(common_problems))[1]
        common_problems[position_in_vector] <-  violation
        common_help[position_in_vector] <-  result$help
        common_type[position_in_vector] <-  value
        common_rule[position_in_vector] <- result[["ruleId"]]
      } 
    }
  }
  data.frame(problem = common_problems[nzchar(common_problems)], 
             help = common_help[nzchar(common_problems)],
             type = common_type[nzchar(common_problems)],
             rule = common_rule[nzchar(common_problems)]
             )
}
checks <- check_json()
