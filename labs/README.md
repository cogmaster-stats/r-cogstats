Here are the source files for lectures notes used during the class. They are
written in [R Markdown](http://www.rstudio.com/ide/docs/authoring/using_markdown)
(`.rmd` extension) and can be post-processed using the
[knitr](http://yihui.name/knitr/) package to produce standalone HTML files
or extract R code used throughout the document. To extract R code in the
first lecture, we can use:

    install.packages("knitr")
    library(knitr)
    purl("01-intro-lab.md")

If `knitr` is already installed, the first instruction can be skipped.

**Reamrk:** This folder does not include custom stylesheet for HTML
  rendering or external images.
