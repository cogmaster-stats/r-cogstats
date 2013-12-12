#! /usr/bin/Rscript

library(knitr)
library(markdown)
knit('lattice.rmd', quiet=TRUE)
markdownToHTML('lattice.md', 'lattice.html', stylesheet='styles.css', 
               option=c('highlight_code', 'toc'), title='Using lattice graphics')
purl('lattice.rmd')
