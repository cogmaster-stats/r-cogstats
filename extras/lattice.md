<!--- Time-stamp: <2013-11-24 20:32:38 chl> -->

<!--- To generate HTML output:
library(knitr)
library(markdown)
knit("lattice.rmd", quiet=TRUE)
markdownToHTML("lattice.md", "lattice.html", stylesheet="styles.css", option=c("highlight_code", "toc"), title="Using lattice graphics")
browseURL("lattice.html")
-->





<p style="font-size: 200%; font-weight: bold; text-align: center;">Using lattice graphics</p>


This document describes the main features of R's [lattice][1] package for
use as a graphical exploratory tool or produce ready-to-print graphical
figures. Extra features are available in the [latticeExtra][2] packages, and
more information can be found on the [latticeExtra companion website][3], as
well as the [lattice companion website][4]. The definitive reference to
using lattice graphics is

> Sarkar, D. (2007). *Lattice: Multivariate Data Visualization with
> R*. Springer.


## Introduction

A definitive key feature of `lattice` is that it will generally
produce informative and already nice looking plots. Furthermore, as it
relies on "formula" notation, calling a `lattice` plotting function
is not so much different from evaluating statistical models using
`lm()` or `glm()`. Finally, the updating mechanism renders
step-by-step plotting interaction an easy task to perform, even for
users with limited knowledge of R; in fact, there's no real need to
bother with redrawing onto the same graphical device using `points()`
or `lines()` instead of `plot()`: with `lattice`, just draw a basic
canvas, and then update it with additional information or replace
default settings (e.g., color, type of points) with customized ones.

For R practitioners used to base graphics, switching to `lattice`
will not be a big deal. The base syntax for drawing a simple
scatterplot is `plot(x, y)` or `plot(y ~ x, data=)` which reads
`xyplot(y ~ x, data=)` using `lattice`. Most of the base plotting
commands have their equivalent in `lattice`, for example:

| Type        | Base R            | Lattice              |
| ----------- |:-----------------:|:--------------------:|
| Scatterplot | plot(x,y)         | xyplot(y ~ x)        |
| Histogram   | hist(x)           | histogram(~ x)       |
| Density     | plot(density(x))  | densityplot(~ x)     |
| Barchart    | barplot(table(x)) | barchart(xtabs(~ x)) |
| Dotchart    | dotchart(table(x))| dotplot(x)           |
| QQ plot     | qqplot(x)         | qqmath(~ x)          |


However, where we would have to split our plot in multiple subplot manually
using base R graphics, `lattice` offers a convenient and intuitive way for
arranging the information into multiple panels using the
[trellis approach][5] used and described in Cleveland's famous
books:

- Cleveland, WS, [The Elements of Graphing Data](http://goo.gl/NmC9to), Hobart Press, 1994
- Cleveland, WS, [Visualizing Data](http://goo.gl/mmnt6k), Hobart Press, 1993

Another good reference, which put more emphasis on R implementation
is Murrell's [*R Graphics*][6].


## Main components of a lattice object

The main components of a `lattice` object are shown in the picture
below. In this case, an automatic layout was choosen where each panel
describes the relationship between the outcome, `y`, and one
predictor, `x`, according to the levels of a categorical variable `g`
and a continuous variable `z` summarized as *shingles*.

Let's start with a scatterplot for a multiway data set.

```r
set.seed(88)
n <- 100
x <- runif(n, min = 10, max = 20)
z <- runif(n, min = 0, max = 10)
g <- factor(sample(letters[1:2], n, rep = TRUE))
y <- 1.2 + 0.8 * x - 0.2 * z + 0.5 * as.numeric(g) + rnorm(n)

d <- data.frame(x, z, g, y)
d <- transform(d, zc = equal.count(z, 4))

xyplot(y ~ x | g + zc, data = d, type = c("p", "g", "smooth"), col.line = "peachpuff3", 
    lwd = 2, xlab = "X-axis label", ylab = "Y-axis label", main = "Title", sub = "Subtitle")
```

<img src="figure/fig1.png" title="plot of chunk fig1" alt="plot of chunk fig1" style="display: block; margin: auto;" />


It is worth noting that local smoother and regression fit are applied
for each panel (in fact, they evaluate `x` conditional to `g` and `zc`
from the `data=` argument, which might not be always the case with
other constructions). All axes are scaled in a similar manner, and 
horizontal and vertical axis alternate from bottom to top, or left to
right, respectively.

Some important parameters of a `lattice` graphic are given below:

- `aspect` determine the ratio of height to width of the graphical
region. It can be a (positive) number, or one of the available options:
`xy` means that the *45° banking rule* [@cleveland88] is used to
determine x and y scale; `iso` means that the number of units per cm
is the same for both axes which implies that relation between physical
distance on the display and in the data scale is respected.
- `layout` describes the arrangement of panel as columns by rows;
  e.g., `layout=c(2, 3)` means to display the panel in a grid composed
  of two columns and three rows. 
- `scales` is a list with various parameters to customize axis setting.
- `between` is the amount of space between each panel. By default, it
  equals 0, that is there is no space left between panels.
- `key` or `auto.key` allows to set up the legend, with more or less
  default control.



[1]: http://cran.r-project.org/web/packages/lattice/index.html
[2]: http://cran.r-project.org/web/packages/latticeExtra/index.html
[3]: http://latticeextra.r-forge.r-project.org/
[4]: http://lmdvr.r-forge.r-project.org/
[5]: http://stat.bell-labs.com/project/trellis/wwww.html
[6]: https://www.stat.auckland.ac.nz/~paul/RGraphics/rgraphics.html
