
stopifnot(require(Rdpack))
options(warn = 1)

## TODO: keep track of version in DESCRIPTION and update only if newer

## Assume that CRAN/<pkg> has unpacked sources containing necessary
## components (R, src, etc. not needed)

pkgs <- list.dirs("CRAN", full.names = FALSE, recursive = FALSE)

for (pkg in pkgs) {
    if (!file.exists(sprintf("refmans/%s.html", pkg))) {
        cat(pkg, fill = TRUE)
        status <-
            try(
                tools::pkg2HTML(package = pkg,
                                dir = sprintf("CRAN/%s", pkg),
                                out = sprintf("docs/%s.html", pkg),
                                stylesheet = "R-nav.css",
                                stages = c("build", "install", "render")),
                silent = TRUE)
        if (inherits(status, "try-error")) {
            cat("FAILED with error condition: ",
                conditionMessage(attr(status, "condition")),
                fill = TRUE)
        }
    }
}

## do 'base' packages from installation

ip <- installed.packages()
wbase <- which(ip[, "Priority"] == "base")

for (pkg in ip[wbase, "Package"]) {
    cat(pkg, fill = TRUE)
    tools::pkg2HTML(pkg, out = sprintf("docs/%s.html", pkg),
                    stylesheet = "R-nav.css", 
                    stages = c("build", "install", "render"))
}



## TODO: make this a table, perhaps a DataTable

for (hfile in list.files("refmans/", pattern = "html$")) {
    cat(sprintf("- [%s](refmans/%s)\n\n", hfile, hfile),
        file = "refmans/index.md", append = TRUE)
}



