
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
                #box.rectangle = list(col = "white", lwd=1.5),
                box.umbrella = list(col = my.col),
                box.dot = list(col = my.col),
                plot.rect = list(col = my.col, border = my.col),
                plot.polygon = list(col = my.col[1], border = "white"),
                fontsize = list(text = 16, points = 8))
set.seed(101)


## ------------------------------------------------------------------------
x <- c(5.4, 6.1, 6.2, NA, 6.2, 5.6, 19.0, 6.3)
x


## ------------------------------------------------------------------------
x[7] <- NA
x


## ------------------------------------------------------------------------
x[is.na(x)] <- mean(x, na.rm=TRUE)
x


## ------------------------------------------------------------------------
tx <- factor(rep(rep(c("std","new"), each=3), 10))


## ------------------------------------------------------------------------
tx <- gl(2, 3, 60, labels=c("std","new"))
head(tx, n=7)


## ------------------------------------------------------------------------
levels(tx)[1] <- "old"
tx <- relevel(tx, ref="new")
head(tx <- sample(tx), n=7)


## ------------------------------------------------------------------------
data(birthwt, package="MASS")


## ----, eval=FALSE--------------------------------------------------------
## help(birthwt, package="MASS")


## ------------------------------------------------------------------------
yesno <- c("No","Yes")
ethn <- c("White","Black","Other")
birthwt <- within(birthwt, {
  low <- factor(low, labels=yesno)
  race <- factor(race, labels=ethn)
  smoke <- factor(smoke, labels=yesno)
  ui <- factor(ui, labels=yesno)
  ht <- factor(ht, labels=yesno)
})
birthwt$lwt <- birthwt$lwt/2.2


## ------------------------------------------------------------------------
table(birthwt$ht)
prop.table(table(birthwt$ht))


## ------------------------------------------------------------------------
mean(birthwt[birthwt$smoke=="Yes" & birthwt$ht=="No", "bwt"])


## ------------------------------------------------------------------------
sapply(subset(birthwt, smoke == "Yes" & ht == "No", bwt), mean)


## ------------------------------------------------------------------------
wk.df <- subset(birthwt, lwt < quantile(lwt, probs=.25), bwt)
sapply(wk.df, sort)[1:5]


## ------------------------------------------------------------------------
birthwt$ptl2 <- ifelse(birthwt$ptl > 0, 1, 0)
birthwt$ptl2 <- factor(birthwt$ptl2, labels=c("0", "1+"))
with(birthwt, table(ptl2, ptl))


## ----, fig.height=5------------------------------------------------------
histogram(~ bwt | ptl2, data=birthwt, xlab="Baby weight (g)")


## ----, eval=FALSE--------------------------------------------------------
## is.num <- sapply(birthwt, is.numeric)
## wk.df <- birthwt[,which(is.num)]
## wk.df <- sapply(wk.df, scale)
## library(reshape2)
## bwplot(value ~ variable, melt(data.frame(wk.df)))


