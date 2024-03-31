
stopifnot(require(Rdpack))
options(warn = 1)

pkgs <- list.dirs("CRAN", full.names = FALSE, recursive = FALSE)


for (pkg in pkgs) {
    if (!file.exists(sprintf("refmans/%s.html", pkg))) {
        cat(pkg, fill = TRUE)
        status <-
            try(
                tools::pkg2HTML(package = pkg,
                                dir = sprintf("CRAN/%s", pkg),
                                out = sprintf("refmans/%s.html", pkg),
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

## tools:::pkg2HTML("sass", out = "sass.html") # error

for (hfile in list.files("refmans/", pattern = "html$")) {
    cat(sprintf("- [%s](refmans/%s)\n\n", hfile, hfile),
        file = "refmans/index.md", append = TRUE)
}


if (FALSE)
{

    hook <- function(pkg) {
        cat(sys.calls() |> as.character(),
            file = "~/hook-output.txt",
            append = TRUE, fill = TRUE, sep = " >>> ")
        cat(pkg, ": ", ans <- sprintf("%s.html", pkg), "\n-----------\n",
            file = "~/hook-output.txt",
            append = TRUE)
        ans
    }
    
    pkg  <-  "lattice"
    tools::pkg2HTML(package = pkg,
                    dir = sprintf("CRAN/%s", pkg),
                    out = sprintf("refmans/%s.html", pkg),
                    stylesheet = "R-nav.css",
                    hooks = list(pkg_href = hook),
                    stages = c("build", "install", "render"))


}
