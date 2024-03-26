

## do for all installed packages:

ip <- installed.packages()

for (pkg in ip[, "Package"]) {
    if (pkg != "sass") {
        cat(pkg, fill = TRUE)
        tools:::pkg2HTML(pkg, out = sprintf("%s.html", pkg),
                         stylesheet = "R-nav.css")
    }
}

## tools:::pkg2HTML("sass", out = "sass.html") # error

for (hfile in list.files(".", pattern = "html$")) {
    cat(sprintf("- [%s](%s)\n\n", hfile, hfile),
        file = "index.md", append = TRUE)
}



## Try some CRAN packages as well

## for (extpkg in c("RJDBC", "RMySQL", "ROracle", "rpostgis", "RPostgreSQL")) {
##     ## find pkg tarball URL?
## }

