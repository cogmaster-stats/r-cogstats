
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
                box.rectangle = list(col = "white", lwd=1.5),
                box.umbrella = list(col = my.col),
                #box.dot = list(col = my.col),
                #plot.rect = list(col = my.col, border = my.col),
                #plot.polygon = list(col = my.col[1], border = "white"),
                fontsize = list(text = 16, points = 8))
set.seed(101)


## ----load2---------------------------------------------------------------
data(ToothGrowth)
ToothGrowth$dose <- factor(ToothGrowth$dose)
fm <- len ~ supp * dose
replications(fm, data=ToothGrowth)
f <- function(x) c(mean=mean(x), sd=sd(x))
aggregate(fm, ToothGrowth, f)


## ----aov2----------------------------------------------------------------
aov.fit <- aov(fm, data=ToothGrowth)
summary(aov.fit)


## ----effects-------------------------------------------------------------
model.tables(aov.fit, type="means", se=TRUE, cterms="supp:dose")


## ------------------------------------------------------------------------
xyplot(len ~ dose, data=ToothGrowth, groups=supp, type=c("a", "g"),
       xlab="Dose (mg)", ylab="Tooth length", lwd=2, 
       auto.key=list(space="top", columns=2, points=FALSE, lines=TRUE))


## ----, fig.height=5------------------------------------------------------
qqmath(~ resid(aov.fit), col=my.col[1], alpha=.5,
       xlab="Normal quantiles", ylab="Residuals")


## ----assumptions, fig.height=5-------------------------------------------
bwplot(len ~ interaction(supp, dose), data=ToothGrowth, do.out=FALSE,
       fill=my.col, pch="|", col="white")
bartlett.test(len ~ interaction(supp,dose), data=ToothGrowth)


## ----load----------------------------------------------------------------
d <- read.table("../data/tab13-tabagisme.dat", header = FALSE)
names(d) <- c("task", "group", "error")
d$task <- factor(d$task, labels = c("ident", "cogn", "simul"))
summary(d)


## ----, echo=FALSE, results='asis'----------------------------------------
bibliography(style="text")


