
## Simpler version of generate-html.R which does not try to control
## the order of links and leaves it to the defaults.

require(tools)
stopifnot(require(Rdpack))
stopifnot(require(mathjaxr))
options(warn = 1)

## TODO: keep track of version in DESCRIPTION and update only if newer

## Assume that CRAN/<pkg> has unpacked sources containing necessary
## components (R, src, etc. not needed)

pkgs <- list.dirs("CRAN", full.names = FALSE, recursive = FALSE)

## packages using mathjaxr

## pkgs <-
##     c("ADMUR", "aglm", "ammistability", "augmentedRCBD",
##       "BayesDLMfMRI", "BEKKs", "bioregion", "BoundEdgeworth",
##       "BrailleR", "clifford", "clugenr", "complexlm", "covatest",
##       "cpop", "Davies", "eatATA", "einsum", "EmiR", "esci", "espadon",
##       "EvaluateCore", "factReg", "FoReco", "frab", "freealg",
##       "germinationmetrics", "GGMncv", "GOCompare", "heterometa",
##       "JointAI", "jointCalib", "jordan", "maczic", "MarZIC",
##       "metadat", "metafor", "metan", "metap", "mlmhelpr", "mlrv",
##       "MM", "multivator", "NetInt", "NFCP", "nonprobsvy", "OCA",
##       "onion", "partitions", "permutations", "PLFD", "poolr",
##       "prospectr", "resemble", "SCEM", "sdcLog", "singleRcapture",
##       "sjSDM", "sorcering", "spfda", "spray", "statpsych", "stokes",
##       "TDLM", "tdsa", "tseriesTARMA", "vcmeta", "weyl")


for (pkg in pkgs) {
##    if (!file.exists(sprintf("refmans/%s.html", pkg))) {
        cat(pkg, fill = TRUE)
        status <-
            try(
                pkg2HTML(package = pkg,
                         dir = sprintf("CRAN/%s", pkg),
                         out = sprintf("docs/%s.html", pkg),
                         stylesheet = "R-nav.css",
                         mathjax_config = "mathjax-config.js",
                         stages = c("build", "install", "render", "later")),
                silent = TRUE)
        if (inherits(status, "try-error")) {
            cat("FAILED with error condition: ",
                conditionMessage(attr(status, "condition")),
                fill = TRUE)
        }
##    }
}

## do 'base' packages from installation

ip <- installed.packages()
wbase <- which(ip[, "Priority"] == "base")

for (pkg in ip[wbase, "Package"]) {
    cat(pkg, fill = TRUE)
    pkg2HTML(pkg, out = sprintf("docs/%s.html", pkg),
             stylesheet = "R-nav.css", 
             stages = c("build", "install", "render"))
}


### Index - see generate-index.R

## for (hfile in list.files("refmans/", pattern = "html$")) {
##     cat(sprintf("- [%s](refmans/%s)\n\n", hfile, hfile),
##         file = "refmans/index.md", append = TRUE)
## }



