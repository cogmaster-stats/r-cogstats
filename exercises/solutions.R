
## ----setup, cache=FALSE, include=FALSE-----------------------------------
opts_knit$set(echo=FALSE, message=FALSE, progress=FALSE, 
              verbose=FALSE, tidy=TRUE)
opts_knit$set(aliases=c(h='fig.height', w='fig.width',
                cap='fig.cap', scap='fig.scap'))
opts_knit$set(eval.after = c('fig.cap','fig.scap'))
opts_chunk$set(cache=TRUE)
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


## ------------------------------------------------------------------------
d <- data.frame(height = rnorm(40, 170, 10),
                class = sample(LETTERS[1:2], 40, rep=TRUE))
d$height[sample(1:40, 1)] <- 220


## ------------------------------------------------------------------------
d$class[which(d$height == max(d$height))]


## ------------------------------------------------------------------------
d[do.call(order, d),"class"][40]


## ------------------------------------------------------------------------
WD <- "../data"
lung <- read.table(paste(WD, "lungcancer.txt", sep="/"),
                   header=TRUE, na.strings=".")
str(lung)
summary(lung)  
head(sort(lung$time))
head(sort(lung$age))
table(lung$cens)
table(lung$vital.capac)
lung <- within(lung, {
  time[time < 0] <- NA
  age[age == 5] <- NA
  cens[cens == 2] <- NA
  cens <- factor(cens)
  levels(vital.capac)[2:3] <- "low"
})
summary(lung)


## ------------------------------------------------------------------------
reading <- read.csv("../data/reading2.csv", na.strings=".")
head(reading)
summary(reading)


## ------------------------------------------------------------------------
sum(is.na(reading$Response))


## ------------------------------------------------------------------------
sum(is.na(reading$Response[reading$Treatment == "Control"]))
sum(is.na(reading$Response[reading$Treatment == "Treated"]))


## ------------------------------------------------------------------------
nmiss <- function(x) sum(is.na(x))
tapply(reading$Response, reading$Treatment, nmiss)


## ----, eval=FALSE--------------------------------------------------------
## aggregate(Response ~ Treatment, reading, nmiss, na.action=na.pass)


## ------------------------------------------------------------------------
table(reading$Treatment)


## ----, fig.height=5------------------------------------------------------
densityplot(~ Response, data=reading, groups=Treatment, auto.key=TRUE)


## ------------------------------------------------------------------------
t.test(Response ~ Treatment, data=reading, var.equal=TRUE)


## ----, fig.height=5------------------------------------------------------
aggregate(Response ~ Treatment, data=reading, var)
bwplot(Response ~ Treatment, data=reading, pch="|")


## ----, warning = FALSE---------------------------------------------------
wilcox.test(Response ~ Treatment, data=reading)


## ------------------------------------------------------------------------
fus <- read.table("../data/fusion.dat", header=FALSE)
names(fus) <- c("resp", "grp")
str(fus)


## ----, eval=2, fig.height=4, fig.width=4---------------------------------
bwplot(resp ~ grp, data=fus)
stripplot(resp ~ grp, data=fus, jitter.data=TRUE, grid="h", alpha=0.5)


## ------------------------------------------------------------------------
f <- function(x, na.rm=TRUE) c(mean=mean(x, na.rm=na.rm), s=sd(x, na.rm=na.rm))
aggregate(resp ~ grp, data=fus, FUN=f)


## ------------------------------------------------------------------------
t.test(resp ~ grp, data=fus, var.equal=TRUE)
t.test(resp ~ grp, data=fus)$p.value


## ------------------------------------------------------------------------
fus$resp.log <- log10(fus$resp)
aggregate(resp.log ~ grp, data=fus, FUN=f)
histogram(~ resp + resp.log | grp, data=fus, breaks="Sturges", scales=list(relation="free"))
t.test(resp.log ~ grp, data=fus, var.equal=TRUE)


## ------------------------------------------------------------------------
brain <- read.table("../data/IQ_Brain_Size.txt", header=FALSE, skip=27, nrows=20)
head(brain, 2)


## ------------------------------------------------------------------------
names(brain) <- tolower(c("CCMIDSA", "FIQ", "HC", "ORDER", 
                          "PAIR", "SEX", "TOTSA", "TOTVOL", 
                          "WEIGHT"))
str(brain)


## ------------------------------------------------------------------------
brain$order <- factor(brain$order)
brain$pair <- factor(brain$pair)
brain$sex <- factor(brain$sex, levels=1:2, labels=c("Male", "Female"))
summary(brain)


## ----, eval=c(1,3)-------------------------------------------------------
table(brain$sex)
table(brain$sex) / sum(table(brain$sex))
prop.table(table(brain$sex))


## ------------------------------------------------------------------------
mean(brain$fiq)
median(brain$fiq)


## ------------------------------------------------------------------------
table(brain$fiq < 90)


## ------------------------------------------------------------------------
quantile(brain$ccmidsa, probs=c(0.25, 0.75))
diff(quantile(brain$ccmidsa, probs=c(0.25, 0.75)))
IQR(brain$ccmidsa)


## ------------------------------------------------------------------------
sapply(brain[,c("ccmidsa","hc","totsa","totvol")], IQR)


## ----, fig.height=5------------------------------------------------------
histogram(~ weight | order, data=brain, type="count", 
          xlab="Weight (kg)", ylab="Counts")


## ------------------------------------------------------------------------
quantile(brain$weight, probs=0:3/3)


## ------------------------------------------------------------------------
weight.terc <- cut(brain$weight, breaks=quantile(brain$weight, probs=0:3/3),
                   include.lowest=TRUE)
table(weight.terc)
aggregate(totvol ~ weight.terc, data=brain, FUN=function(x) c(mean(x), sd(x)))


## ------------------------------------------------------------------------
aggregate(fiq ~ order, data=brain, function(x) c(mean(x), sd(x)))
t.test(fiq ~ order, data=brain, paired=TRUE)


## ------------------------------------------------------------------------
aggregate(hc ~ sex, data=brain, function(x) c(mean(x), sd(x)))
t.test(hc ~ sex, data=brain)


## ----, fig.height=5------------------------------------------------------
dotplot(hc ~ sex, data=brain, groups=order, type=c("p", "a"), jitter.x=TRUE, 
        auto.key=list(title="Birth order", cex=.8, cex.title=1, columns=2))


## ------------------------------------------------------------------------
set.seed(101)
k <- 3                   # number of groups 
ni <- 10                 # number of observations per group
mi <- c(10, 12, 8)       # group means
si <- c(1.2, 1.1, 1.1)   # group standard deviations
grp <- gl(k, ni, k * ni, labels = c("A", "B", "C"))
resp <- c(rnorm(ni, mi[1], si[1]), rnorm(ni, mi[2], si[2]), rnorm(ni, mi[3], si[3]))


## ------------------------------------------------------------------------
d <- data.frame(grp, resp)
rm(grp, resp)
summary(d)
aggregate(resp ~ grp, data=d, mean)


## ------------------------------------------------------------------------
resp.means <- aggregate(resp ~ grp, data=d, mean)


## ------------------------------------------------------------------------
resp.means$resp - mean(d$resp)


## ----, fig.height=5------------------------------------------------------
bwplot(resp ~ grp, data=d)


## ------------------------------------------------------------------------
m <- aov(resp ~ grp, data=d)
summary(m)


## ------------------------------------------------------------------------
fval <- 33.031/0.828  ## MS grp / MS residual, see print(summary(m), digits=5)
pval <- pf(fval, 2, 27, lower.tail=FALSE)
format(pval, digits=5)


## ------------------------------------------------------------------------
m2 <- aov(resp ~ grp, data=d, subset = grp != "C")
summary(m2)


## ----, eval=1------------------------------------------------------------
t.test(d$resp[d$grp == "A"], d$resp[d$grp == "B"], var.equal=TRUE)
t.test(resp ~ grp, data=subset(d, grp != "C"), var.equal=TRUE)


## ------------------------------------------------------------------------
taste <- read.table("../data/taste.dat", header=TRUE)
summary(taste)


## ------------------------------------------------------------------------
taste$SCR <- factor(taste$SCR, levels=0:1, labels=c("coarse", "fine"))
taste$LIQ <- factor(taste$LIQ, levels=0:1, labels=c("low", "high"))
names(taste) <- tolower(names(taste))
summary(taste)


## ------------------------------------------------------------------------
fm <- score ~ scr * liq
replications(fm, data=taste)


## ------------------------------------------------------------------------
f <- function(x) c(n=length(x), mean=mean(x), sd=sd(x))
res <- aggregate(fm, data=taste, f)
res


## ----, eval=FALSE--------------------------------------------------------
## dotplot(score ~ scr, data=aggregate(fm, taste, mean), groups=liq, type="l")


## ----, fig.height=5------------------------------------------------------
dotplot(score ~ scr, data=taste, groups=liq, type=c("a"), auto.key=TRUE)


## ----, fig.height=5------------------------------------------------------
bwplot(score ~ scr +  liq, taste, ablie=list(h=mean(taste$score), lty=2))


## ------------------------------------------------------------------------
m0 <- aov(fm, data=taste)  ## full model
summary(m0)


## ------------------------------------------------------------------------
m1 <- update(m0, . ~ . - scr:liq)  ## reduced model
summary(m1)


## ------------------------------------------------------------------------
bartlett.test(score ~ interaction(liq, scr), data=taste)


## ------------------------------------------------------------------------
10609/(10609+5089)  ## 68% of explained variance


## ------------------------------------------------------------------------
t.test(score ~ scr, data=taste, var.equal=TRUE)
library(MBESS)
with(taste, smd(score[scr=="coarse"], score[scr=="fine"]))


## ------------------------------------------------------------------------
brains <- read.table("../data/brain_size.dat", header=TRUE, 
                     na.strings=".")  
str(brains)


## ----, fig.height=5------------------------------------------------------
xyplot(MRI_Count ~ Weight, data=brains, pch=as.numeric(brains$Gender), type=c("p", "g", "smooth"), auto.key=TRUE) 


## ------------------------------------------------------------------------
head(as.character(brains$Gender))
head(as.numeric(brains$Gender))


## ------------------------------------------------------------------------
with(brains, cor(MRI_Count, Weight))


## ------------------------------------------------------------------------
with(brains, cor(MRI_Count, Weight, use="pair"))


## ------------------------------------------------------------------------
cor.test(~ MRI_Count + Weight, data=brains)


## ----, eval=1------------------------------------------------------------
cor.test(~ MRI_Count + Weight, data=subset(brains, Gender == "Female"))
cor.test(~ MRI_Count + Weight, data=subset(brains, Gender == "Male"))


## ------------------------------------------------------------------------
library(psych)
r.test(20, .4463, -.07687)


## ----, fig.height=5------------------------------------------------------
xyplot(MRI_Count ~ Weight, data=brains, groups=Gender, type=c("p", "g", "r"), auto.key=TRUE) 


## ------------------------------------------------------------------------
m <- lm(MRI_Count ~ Weight, data=brains)
summary(m)


## ------------------------------------------------------------------------
confint(m)


## ----, eval=1, fig.height=5----------------------------------------------
histogram(~ resid(m))
xyplot(resid(m) ~ fitted(m), abline=list(h=0, lty=2), 
       type=c("p","g","smooth"))


