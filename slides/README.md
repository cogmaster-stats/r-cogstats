Here are the source files for slides used during the class. Slides are
written using RStudio and
[R presentations](http://www.rstudio.com/ide/docs/presentations/overview)
(`.Rpres` extension),
which are currently only available with the
[preview release](http://www.rstudio.com/ide/download/preview) of RStudio
v0.9*.

RStudio also generates simple
[Markdown](http://www.rstudio.com/ide/docs/authoring/using_markdown) files
(`.md` extension) that can be processed fairly easily using the
[knitr](http://yihui.name/knitr/) package to produce standalone HTML files
or extract R code used throughout the document. To extract R code in the
first lecture, we can use:

    install.packages("knitr")
    library(knitr)
    purl("01-intro.md")

If `knitr` is already installed, the first instruction can be skipped.

**Reamrk:** This folder does not include custom stylesheet for HTML
  rendering or external images.
