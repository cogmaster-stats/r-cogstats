
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
trellis.par.set(custom.theme.2())
set.seed(101)


## ----dfrm----------------------------------------------------------------
subject <- factor(rep(c("Jim", "Victor", "Faye", "Ron", "Jason"), each=3))
cond <- factor(rep(c("Neg", "Neu", "Pos"), 5))
words <- c(32, 15, 45, 30, 13, 40, 26, 12, 42, 22, 10, 38, 29, 8, 35)
dfrm <- data.frame(subject, cond, words)
head(dfrm)


## ----subset--------------------------------------------------------------
dfrm[subject == "Victor",]


## ----mean----------------------------------------------------------------
dfrm[subject == "Victor","words"]
mean(dfrm[subject == "Victor","words"])


## ----, eval=FALSE--------------------------------------------------------
## subset(dfrm, subject == "Victor", "words")


## ------------------------------------------------------------------------
mean(dfrm[cond == "Neu","words"])


## ------------------------------------------------------------------------
aggregate(words ~ cond, data=dfrm, FUN=mean)


## ------------------------------------------------------------------------
tmp <- read.table("../data/words.dat", sep=",", skip=2, 
                  header=FALSE, col.names=c("subject", "Neg", "Neu", "Pos"))
library(reshape2)
dfrm <- melt(tmp)
head(dfrm)


## ----read----------------------------------------------------------------
d <- read.csv2("../data/brain_size.csv")
head(d)


## ----del-----------------------------------------------------------------
d <- d[,-1]
head(d)


## ----colnames------------------------------------------------------------
names(d)


## ----summary-------------------------------------------------------------
summary(d)


## ----, eval=FALSE--------------------------------------------------------
## d <- read.csv2("../data/brain_size.csv", na.strings=".")


## ----recode--------------------------------------------------------------
d$Weight <- as.numeric(as.character(d$Weight))
d$Height <- as.numeric(as.character(d$Height))
summary(d)


## ----na------------------------------------------------------------------
sum(is.na(d$Weight))
table(is.na(d$Weight))


## ----table---------------------------------------------------------------
table(d[,"Gender"])  # or table(d[,1])


## ----ave-----------------------------------------------------------------
mean(d$FSIQ)


## ----avec----------------------------------------------------------------
mean(d$FSIQ[d$Gender == "Male"])


## ----agg-----------------------------------------------------------------
aggregate(FSIQ ~ Gender, d, mean)


## ----log-----------------------------------------------------------------
mean(log(d$MRI_Count, base=10))  # or we can use log10


## ----, echo=FALSE, results='asis'----------------------------------------
bibliography(style="text")


