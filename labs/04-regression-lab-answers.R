
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
trellis.par.set(custom.theme.2())
trellis.par.set(plot.symbol=list(pch=19, cex=1.2),
                strip.background = list(col = "transparent"), 
                fontsize = list(text = 16, points = 8))
set.seed(101)


## ------------------------------------------------------------------------
smoking <- c(77,137,117,94,116,102,111,93,88,102,91,104,107,112,113,110,125,133,115,105,87,91,100,76,66)
mortality <- c(84,116,123,128,155,101,118,113,104,88,104,129,86,96,144,139,113,146,128,115,79,85,120,60,51)


## ------------------------------------------------------------------------
d <- data.frame(smoking, mortality)
rm(smoking, mortality)


## ------------------------------------------------------------------------
summary(d)
sapply(d, sd)


## ----, fig.height=5------------------------------------------------------
xyplot(mortality ~ smoking, data=d, type=c("p", "g"))


## ----, fig.height=5------------------------------------------------------
spans <- rev(c(1/3, 1/2, 2/3, 3/4))
my.key <- list(corner=c(0,1), title="Span", cex.title=.8,
               text=list(format(spans, digits=2), cex=.7),
               lines=list(type="l", lty=1:length(spans), col="#BF3030"))
xyplot(mortality ~ smoking, data=d, type=c("p", "r"),
       key=my.key,
       panel=function(x, y, ...) {
         panel.xyplot(x, y, ...)
         for (sp in seq_along(spans))
           panel.loess(x, y, span=spans[sp], col="#BF3030", lty=sp, ...)
     })


## ------------------------------------------------------------------------
cor(d$mortality, d$smoking)


## ------------------------------------------------------------------------
cor.test(~ mortality + smoking, data=d)


## ------------------------------------------------------------------------
m <- lm(mortality ~ smoking, data=d)
summary(m)


## ------------------------------------------------------------------------
coef(m)
coef(m)[2]*sd(d$smoking)/sd(d$mortality)


## ------------------------------------------------------------------------
cor(fitted(m), d$mortality)^2


