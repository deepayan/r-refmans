#!/usr/bin/env bash

rsync -avz --recursive --delete --delete-excluded \
      --exclude=src --exclude=R --exclude=data    \
      --exclude=inst --exclude=vignettes          \
      --exclude=tests --exclude=*.pdf             \
      ${CRANPKGS} ./CRAN

mv aliases.rds aliases.rds~
wget https://cran.r-project.org/src/contrib/Meta/aliases.rds
