
## ----setup, cache=FALSE, include=FALSE-----------------------------------
opts_knit$set(echo=FALSE, message=FALSE, progress=FALSE, 
              cache=TRUE, verbose=FALSE, tidy=TRUE)
opts_knit$set(aliases=c(h='fig.height', w='fig.width',
                cap='fig.cap', scap='fig.scap'))
opts_knit$set(eval.after = c('fig.cap','fig.scap'))
knit_hooks$set(document = function(x) {
  gsub('(\\\\end\\{knitrout\\}[\n]+)', '\\1\\\\noindent ', x)
})
library(knitcitations)
cite_options(tooltip=FALSE)
bib <- read.bibtex("../refs.bib")
options(width=80)
library(latticeExtra)
my.col <- c('cornflowerblue', 'chartreuse3', 'darkgoldenrod1', 'peachpuff3',
            'mediumorchid2', 'turquoise3', 'wheat4', 'slategray2')
trellis.par.set(strip.background = list(col = "transparent"), 
                plot.symbol = list(pch = 19, cex = 1.2, col = my.col),
                plot.line = list(lwd = 2, col = my.col[1]),
                superpose.symbol = list(pch = 19, cex = 1.2, col = my.col),
                superpose.line = list(lwd = 2, col = my.col),
                box.rectangle = list(col = my.col),
                box.umbrella = list(col = my.col),
                box.dot = list(col = my.col),
                #plot.rect = list(col = my.col, border = my.col),
                plot.polygon = list(col = my.col[1], border = "white"),
                fontsize = list(text = 16, points = 8))
set.seed(101)


## ----import--------------------------------------------------------------
d <- read.table("../data/eysenck74.dat")
names(d) <- c("id", "age", "words")
d$id <- factor(d$id)
d$age <- factor(d$age, levels=1:2, labels=c("young", "elderly"))
summary(d)


## ----import2, eval=FALSE-------------------------------------------------
## d <- read.table("../data/eysenck74.dat",
##                 colClasses = c("factor", "factor", "numeric"))
## # check that we get the same data structure
## str(d)


## ----, fig.height=6, fig.weight=10---------------------------------------
histogram(~ words, data=d, type="count")


## ----, fig.height=5, fig.weight=10---------------------------------------
histogram(~ words | age, data=d, type="percent")


## ----, fig.height=5------------------------------------------------------
densityplot(~ words, data=d, groups=age)


## ----, fig.height=5------------------------------------------------------
bwplot(age ~ words, data=d, pch="|")


## ----ttest---------------------------------------------------------------
aggregate(words ~ age, data = d, mean)
t.test(words ~ age, data = d, var.equal = TRUE)


## ----vartest-------------------------------------------------------------
aggregate(words ~ age, data = d, var)
var.test(words ~ age, data = d)


## ----wtest---------------------------------------------------------------
t.test(words ~ age, data = d)


## ----qqplot, fig.height=5------------------------------------------------
qqmath(~ words | age, data = d, col="cornflowerblue",
       prepanel = prepanel.qqmathline, 
       panel = function(x, ...){
          panel.qqmathline(x, ...)
          panel.qqmath(x, ...)
       })


## ----es------------------------------------------------------------------
words.means <- with(d, tapply(words, age, mean))
words.sd <- with(d, tapply(words, age, sd))
diff(words.means) / words.sd[1]
diff(words.means) / mean(words.sd)


## ----es2-----------------------------------------------------------------
library(MBESS)
with(d, smd(words[age=="elderly"], words[age=="young"]))
with(d, smd.c(words[age=="elderly"], words[age=="young"]))


## ----power---------------------------------------------------------------
power.t.test(power = .90, delta = 5, sd = 3)


## ----, echo=FALSE, results='asis'----------------------------------------
bibliography(style="text")


