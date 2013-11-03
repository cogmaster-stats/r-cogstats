
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
d <- read.table("../data/tab13-tabagisme.dat", header = FALSE)
names(d) <- c("task", "group", "error")
d$task <- factor(d$task, labels = c("ident", "cogn", "simul"))
summary(d)


## ------------------------------------------------------------------------
aggregate(error ~ group + task, data=d, mean)


## ------------------------------------------------------------------------
f <- function(x) c(mean=mean(x), sd=sd(x))
aggregate(error ~ group + task, data=d, f)


## ------------------------------------------------------------------------
group.task <- interaction(d$group, d$task)
aggregate(error ~ group.task, data=d, mean)


## ----, fig.height=5------------------------------------------------------
bwplot(error ~ task | group, data=d, pch="|", layout=c(3,1))


## ----, fig.height=3------------------------------------------------------
error.means <- aggregate(error ~ group + task, data=d, mean)
dotplot(task ~ error, data=error.means, groups=group, type="l", 
        auto.key=list(space="right", points=FALSE, lines=TRUE))


## ------------------------------------------------------------------------
replications(error ~ group * task, data=d)


## ------------------------------------------------------------------------
m <- aov(error ~ group * task, data=d)
summary(m)


## ----, fig.height=5------------------------------------------------------
xyplot(error ~ group, data=d, groups=task, type=c("a","g"),
       auto.key=list(corner=c(1,1), points=FALSE, lines=TRUE))


## ------------------------------------------------------------------------
op <- options(show.signif.stars=FALSE)
for (cond in levels(d$task)) {
  cat("Task = ", cond, "\n")
  print(summary(aov(error ~ group, data = d, subset = task==cond)))
  cat("\n")
}
options(op)


## ------------------------------------------------------------------------
28662/(28662+13587)


