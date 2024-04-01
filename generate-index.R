
options(warn = 1)


## TODO: perhaps make this a DataTable, but given the large size, will
## probably need to go via JSON

## Assume that CRAN/<pkg> has unpacked sources containing necessary
## components (R, src, etc. not needed)

sanitize_maintainer <- function(x) gsub("@", " at ", x, fixed = TRUE)

makeTableRow <- function(x)
{
    trow_fmt <- paste0("\n<tr>",
                       "<td><a href='%s.html'>%s</a></td>", # pkg, pkg (link to refman)
                       "<td>%s</td>", # Version
                       "<td><a href='https://cran.r-project.org/package=%s'>%s</a></td>",
                                        # pkg, Title (link to CRAN)
                       "<td>%s</td>", # Maintainer
                       "</tr>")
    with(x,
         sprintf(trow_fmt,
                 Package, Package, Version, Package, Title,
                 sanitize_maintainer(Maintainer)))
}

INDEX_FILE <- "docs/index.html"

cat(file = INDEX_FILE, append = FALSE, sep = "\n",
    "<!DOCTYPE html>",
    "<html>",
    "<head><title>R Package Manuals</title>",
    "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />",
    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes\" />",
    "<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH' crossorigin='anonymous'>",
    "</head><body><div class='container-fluid'>",
    "<h1>R Package Manuals</h1>",
    "<hr/>",
    "<table class='table table-striped'>",
    "<tr><th>Package</th><th>Version</th><th>Title</th><th>Maintainer</th></tr>")


ip <- installed.packages()
wbase <- which(ip[, "Priority"] == "base")

for (pkg in ip[wbase, "Package"]) {
    cat(pkg, fill = TRUE)
    desc <- packageDescription(pkg)
    makeTableRow(desc) |> cat(file = INDEX_FILE, append = TRUE)
}

pkgs <- list.dirs("CRAN", full.names = FALSE, recursive = FALSE)

for (pkg in pkgs) {
    if (file.exists(sprintf("docs/%s.html", pkg))) {
        cat(pkg, fill = TRUE)
        desc <- read.dcf(file.path("CRAN", pkg, "DESCRIPTION")) |> as.data.frame()
        makeTableRow(desc) |> cat(file = INDEX_FILE, append = TRUE)
    }
}

cat(file = INDEX_FILE, append = TRUE, sep = "\n",
    "</table>",
    "</div></body>",
    "</html>")
    



