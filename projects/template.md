Project xxx: Short title goes here
==============================================================================

<big>
**Author**  
**Date**
</big>




A summary of Markdown syntax is available when editing R Markdown documents
under RStudio, or on this [Markdown Cheatsheet](http://goo.gl/6ThPR7).

To compile this document, you can use the following commands in R:

    library(knitr)
    library(markdown)
    knit("template.Rmd", quiet=TRUE)
    markdownToHTML("template.md", "template.html", option=c("highlight_code", "toc"), title="Simple R Markdown template")
    browseURL("template.html")

This only requires a working installation of the `knitr` and `markdown` packages.

## Importing data

The following R code is based on the **first project**. Set the `WD`
variable to point to your *working directory* (assuming the data file can be
found there).

Without further option, the following code chunk will be printed and executed.


```r
library(foreign)
WD <- "."
w <- read.spss(paste(WD, "01-weights.sav", sep = "/"), to.data.frame = TRUE)
names(w)
```

```
## [1] "ID"       "WEIGHT"   "LENGTH"   "HEADC"    "GENDER"   "EDUCATIO"
## [7] "PARITY"
```

```r
str(w)
```

```
## 'data.frame':	550 obs. of  7 variables:
##  $ ID      : Factor w/ 550 levels "L001","L003",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ WEIGHT  : num  3.95 4.63 4.75 3.92 4.56 ...
##  $ LENGTH  : num  55.5 57 56 56 55 51.5 56 57 58.5 52 ...
##  $ HEADC   : num  37.5 38.5 38.5 39 39.5 34.5 38 39.7 39 38 ...
##  $ GENDER  : Factor w/ 2 levels "Male","Female": 2 2 1 1 1 2 2 1 1 1 ...
##  $ EDUCATIO: Factor w/ 3 levels "year10","year12",..: 3 3 2 3 1 3 1 1 3 1 ...
##  $ PARITY  : Factor w/ 4 levels "Singleton","One sibling",..: 4 1 3 2 3 1 4 4 3 2 ...
##  - attr(*, "variable.labels")= Named chr  "ID" "Weight (kg)" "Length (cms)" "Head circumference (cms)" ...
##   ..- attr(*, "names")= chr  "ID" "WEIGHT" "LENGTH" "HEADC" ...
```


The following chunk will, however, not be displayed, but expressions will be
evaluated and results available for later use.




## Overview

Here is a brief sketch of the data, number and type of variables, number of
observations, etc.

Tables can be created using base R commands, like `table()` or `xtabs()`,
and the [xtable](http://cran.r-project.org/web/packages/xtable) package. We
just have to set the option `result='asis'`, and ask for HTML output when
calling `print.xtable()`, as illustrated in the next chunk.


```r
print(xtable(head(iris)), type = "html", include.rownames = FALSE)
```

<!-- html table generated in R 2.15.2 by xtable 1.7-1 package -->
<!-- Tue Jan  7 12:40:27 2014 -->
<TABLE border=1>
<TR> <TH> Sepal.Length </TH> <TH> Sepal.Width </TH> <TH> Petal.Length </TH> <TH> Petal.Width </TH> <TH> Species </TH>  </TR>
  <TR> <TD align="right"> 5.10 </TD> <TD align="right"> 3.50 </TD> <TD align="right"> 1.40 </TD> <TD align="right"> 0.20 </TD> <TD> setosa </TD> </TR>
  <TR> <TD align="right"> 4.90 </TD> <TD align="right"> 3.00 </TD> <TD align="right"> 1.40 </TD> <TD align="right"> 0.20 </TD> <TD> setosa </TD> </TR>
  <TR> <TD align="right"> 4.70 </TD> <TD align="right"> 3.20 </TD> <TD align="right"> 1.30 </TD> <TD align="right"> 0.20 </TD> <TD> setosa </TD> </TR>
  <TR> <TD align="right"> 4.60 </TD> <TD align="right"> 3.10 </TD> <TD align="right"> 1.50 </TD> <TD align="right"> 0.20 </TD> <TD> setosa </TD> </TR>
  <TR> <TD align="right"> 5.00 </TD> <TD align="right"> 3.60 </TD> <TD align="right"> 1.40 </TD> <TD align="right"> 0.20 </TD> <TD> setosa </TD> </TR>
  <TR> <TD align="right"> 5.40 </TD> <TD align="right"> 3.90 </TD> <TD align="right"> 1.70 </TD> <TD align="right"> 0.40 </TD> <TD> setosa </TD> </TR>
   </TABLE>


The `xtable` package will also work with tables produced by `summary()` for
ANOVA and regression models.

Figures are displayed easily too, and there are various custom settings that
can be used, see the `knitr`
[Chunk options and package options](http://yihui.name/knitr/options). 


```r
xyplot(Sepal.Length ~ Sepal.Width, data = iris, groups = Species, type = c("p", 
    "g"))
```

<img src="figure/xyplot.png" title="plot of chunk xyplot" alt="plot of chunk xyplot" style="display: block; margin: auto;" />


Finally, external figures can be included using standard Markdown syntax:
`![alt label](filename)`.

![rstudio](./ens.jpg)
