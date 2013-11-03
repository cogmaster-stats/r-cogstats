
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
brain <- read.table("../data/IQ_Brain_Size.txt", header=FALSE, skip=27, nrows=20)
names(brain) <- tolower(c("CCMIDSA", "FIQ", "HC", "ORDER", 
                          "PAIR", "SEX", "TOTSA", "TOTVOL", 
                          "WEIGHT"))
brain$order <- factor(brain$order)
brain$pair <- factor(brain$pair)
brain$sex <- factor(brain$sex, levels=1:2, labels=c("Male", "Female"))
summary(brain)


## ------------------------------------------------------------------------
brain2 <- subset(brain, order == 1, c(totsa, totvol))


## ----, fig.height=5, fig.width=5-----------------------------------------
xyplot(totvol ~ totsa, data=brain2, type=c("p", "g", "smooth"), span=1,
       xlab="Total surface area (cm2)", ylab="Total brain volume (cm3)")


## ------------------------------------------------------------------------
cor(brain2$totvol, brain2$totsa)


## ------------------------------------------------------------------------
cor(brain2$totvol, brain2$totsa, method="spearman")


## ------------------------------------------------------------------------
cor.test(~ totvol + totsa, data=brain2)


## ------------------------------------------------------------------------
m <- lm(totvol ~ totsa, data=brain2)
summary(m)


## ----, eval=FALSE--------------------------------------------------------
## lm(totvol ~ totsa, brain, subset = order == 1)


## ------------------------------------------------------------------------
anova(m)


## ----, fig.height=4------------------------------------------------------
xyplot(resid(m) ~ fitted(m), type=c("p", "g"), abline=list(h=0, lty=2),
       xlab="Predicted values (totvol)", ylab="Residuals")


## ----, echo=FALSE, message=FALSE-----------------------------------------
m.inf <- as.data.frame(influence.measures(m)$infmat)
n <- 10
obs <- 1:n
indiv <- seq(1,20,by=2)
m.inf$obs <- obs
dfbs.cut <- c(-1,1)*2/sqrt(n)
dffit.cut <- c(-1,1)*2*sqrt(2/n)
cook.cut <- 4/(n-2-1)
p <- list()
p[[1]] <- xyplot(resid(m) ~ fitted(m), abline=list(h=0, lty=2, col="gray30"),
                 type="p", col.line="#BF3030", span=1/3, 
                 xlab="Fitted values", ylab="Residuals",
                 par.settings=custom.theme.2(pch=19))
p[[2]] <- xyplot(rstudent(m) ~ fitted(m), type="p",
                 jitter.x=TRUE, amount=.2, col.line="#BF3030", 
                 ylim=c(-5, 5),
                 xlab="Fitted values", ylab="Studentized residuals",
                 par.settings=custom.theme.2(pch=19),
                 panel=function(x, y, ...) {
                   panel.xyplot(x, y, ...)
                   panel.abline(h=c(-2,2), lty=2, col="gray30")
                   panel.text(x[abs(y)>2],
                              y[abs(y)>2],
                              indiv[abs(y)>2],
                              cex=.8, adj=c(-.5, .5))
                 })
p[[3]] <- xyplot(cook.d ~ obs, data=m.inf, 
                 ylab="Cook's distance", xlab="Observation",
                 ylim=c(-0.1, 1.2),
                 par.settings=custom.theme.2(pch=19),
                 panel=function(x, y, ...) {
                   panel.xyplot(x, y, ...)
                   panel.abline(h=cook.cut, lty=2, col="gray30")
                   panel.text(x[y>cook.cut],
                              y[y>cook.cut],
                              indiv[y>cook.cut],
                              cex=.8, adj=c(-.5, .5))
                 })
p[[4]] <- xyplot(dfb.tots ~ obs, data=m.inf, 
                 ylab="DFBETAS", xlab="Observation",
                 ylim=c(-2.35, 2.35),
                 par.settings=custom.theme.2(pch=19),
                 panel=function(x, y, ...) {
                   panel.xyplot(x, y, ...)
                   panel.abline(h=dfbs.cut, lty=2, col="gray30")
                   panel.text(x[abs(y)>dfbs.cut[2]],
                              y[abs(y)>dfbs.cut[2]],
                              indiv[abs(y)>dfbs.cut[2]],
                              cex=.8, adj=c(-.5, .5))
                 })
library(gridExtra)                 
do.call(grid.arrange, p)


## ----, echo=FALSE, results='asis'----------------------------------------
bibliography(style="text")


