
## ----setup, include=FALSE------------------------------------------------
opts_knit$set(progress=FALSE, verbose=FALSE, width=90)
opts_chunk$set(message=FALSE, tidy=TRUE, highlight=TRUE, fig.align="center")
library(latticeExtra)
trellis.par.set(custom.theme.2())
trellis.par.set(plot.symbol=list(pch=19, cex=1.2),
                strip.background = list(col = "transparent"), 
                fontsize = list(text = 16, points = 8))


## ----hmisc, eval=1-------------------------------------------------------
library(Hmisc)
help(package=Hmisc)


## ----birthwt, eval=1-----------------------------------------------------
data(birthwt, package="MASS")
help(birthwt)


## ----missing-------------------------------------------------------------
birthwt$age[5] <- NA
birthwt$ftv[sample(1:nrow(birthwt), 5)] <- NA
yesno <- c("No", "Yes")
birthwt <- within(birthwt, {
  smoke <- factor(smoke, labels=yesno)
  low <- factor(low, labels=yesno)
  ht <- factor(ht, labels=yesno)
  ui <- factor(ui, labels=yesno)
  race <- factor(race, levels=1:3, labels=c("White", "Black", "Other"))
  lwt <- lwt/2.2  ## weight in kg
})
label(birthwt$age) <- "Mother age"
units(birthwt$age) <- "years"
label(birthwt$bwt) <- "Baby weight"
units(birthwt$bwt) <- "grams"
label(birthwt, self=TRUE) <- "Hosmer & Lemeshow's low birth weight study."
list.tree(birthwt)  ## equivalent to str(birthwt)


## ----contents------------------------------------------------------------
contents(birthwt)


## ----describe------------------------------------------------------------
describe(birthwt, digits=3)


## ----subset, eval=FALSE--------------------------------------------------
## describe(subset(birthwt, select=c(age, race, bwt, low)))


## ----cut2----------------------------------------------------------------
table(cut2(birthwt$lwt, g=4))
table(cut2(birthwt$age, g=3, levels.mean=TRUE))


## ----impute--------------------------------------------------------------
lwt <- birthwt$lwt
lwt[sample(length(lwt), 10)] <- NA
lwt.i <- impute(lwt)
summary(lwt.i)


## ----summarize, echo=1:2-------------------------------------------------
f <- function(x, na.opts=TRUE) c(mean=mean(x, na.rm=na.opts), sd=sd(x, na.rm=na.opts))
out <- with(birthwt, summarize(bwt, race, f))
prn(out, "Average baby weight by ethnicity")


## ------------------------------------------------------------------------
dim(out)  ## should have 3 columns
dim(aggregate(bwt ~ race, data=birthwt, f))


## ------------------------------------------------------------------------
with(birthwt, summarize(bwt, llist(race, smoke), f))


## ----bystats-------------------------------------------------------------
with(birthwt, bystats(cbind(bwt, lwt), smoke, race))
with(birthwt, bystats2(lwt, smoke, race))


## ----summary-------------------------------------------------------------
summary(bwt ~ race + ht + lwt, data=birthwt)
summary(cbind(lwt, age) ~ race + bwt, data=birthwt, method="cross")
summary(low ~ race + ht, data=birthwt, fun=table)
out <- summary(low ~ race + age + ui, data=birthwt, method="reverse", overall=TRUE, test=TRUE)
print(out, prmsd=TRUE, digits=2)


## ----plot_summary_reverse------------------------------------------------
plot(out, which="categorical")


## ----xyplot, echo=c(1:3,5), fig.show="hide", message=FALSE---------------
se <- function(x) sd(x)/sqrt(length(x))
f <- function(x) c(mean=mean(x), lwr=mean(x)-se(x), upr=mean(x)+se(x))
d <- with(birthwt, summarize(bwt, race, f))
prn(d, "Summary statistics (Mean +/- SE) by group")
xYplot(Cbind(bwt, lwr, upr) ~ numericScale(race, label="Ethnicity"),
       data=d, type="b", keys="lines", ylim=range(apply(d[,3:4], 2, range))+c(-1,1)*100,
       scales = list(x=list(at = 1:3, labels = levels(d$race))))


## ----segplot, fig.height=5-----------------------------------------------
library(latticeExtra)
segplot(race ~ lwr + upr, data=d, centers=bwt, horizontal=FALSE,
draw.bands=FALSE, ylab="Baby weight (g)")


## ----directlabels, fig.height=5------------------------------------------
d <- with(birthwt, summarize(bwt, llist(race, smoke), f))
xYplot(Cbind(bwt, lwr, upr) ~ numericScale(race), groups=smoke,
       data=d, type="l", keys="lines", method="alt bars", ylim=c(2200, 3600),
	   scales = list(x=list(at = 1:3, labels = levels(d$race))))


## ----ols-----------------------------------------------------------------
library(rms)
m <- ols(bwt ~ age + race + ftv, data=birthwt, x=TRUE)
m


## ----datadist------------------------------------------------------------
d <- datadist(birthwt)
options(datadist="d")
m <- ols(bwt ~ age + race + ftv, data=birthwt, x=TRUE)
summary(m)


## ----plot_summary, fig.height=4------------------------------------------
plot(summary(m))


## ----summary_effect------------------------------------------------------
summary(m, race="Other", age=median(birthwt$age))


## ----anova---------------------------------------------------------------
anova(m)


## ----influence-----------------------------------------------------------
which.influence(m)
vif(m)


## ----predict, fig.height=5-----------------------------------------------
p <- Predict(m, age=seq(20, 35, by=5), race, ftv=1)
xYplot(Cbind(yhat,lower,upper) ~ age | race, data=p, layout=c(3,1),
       method="filled bands", type="l", col.fill=gray(.95))


