Lab 3 : Analysis of variance with R
------------------------------



This document is written using [R Markdown](http://www.rstudio.com/ide/docs/r_markdown). The source code is available in `03-anova-lab.R`. 


#### Learning objectives

> * Import external data files
> * Recode variables into factors
> * Aggregate and display data from factorial experiments
> * Compute F-tests and display ANOVA tables


## Two-way ANOVA

The following data set is available in R as the `ToothGrowth` data (<a href="">Bliss, 1952</a>). In this study, the response is the length of odontoblasts (teeth) in each of 10 guinea pigs at each of three dose levels of Vitamin C (0.5, 1, and 2 mg) with each of two delivery methods (orange juice or ascorbic acid). 

Once data are loaded into R, we need to convert the `dose` variable into a factor. Note that the `ToothGrowth$dose <- factor(ToothGrowth$dose)` command will not allow R to treat it as a factor with ordered levels, but let's ignore this for the purpose of this exercise.

```r
data(ToothGrowth)
ToothGrowth$dose <- factor(ToothGrowth$dose)
fm <- len ~ supp * dose
replications(fm, data = ToothGrowth)
```

```
##      supp      dose supp:dose 
##        30        20        10
```

```r
f <- function(x) c(mean = mean(x), sd = sd(x))
aggregate(fm, ToothGrowth, f)
```

```
##   supp dose len.mean len.sd
## 1   OJ  0.5   13.230  4.460
## 2   VC  0.5    7.980  2.747
## 3   OJ    1   22.700  3.911
## 4   VC    1   16.770  2.515
## 5   OJ    2   26.060  2.655
## 6   VC    2   26.140  4.798
```


Since we know that we will be using the basic formula `len ~ supp * dose`, we stored it in a dedicated variable. Indeed, the object of the analysis will be to study the variation of teeth length as a function of Vitamin C dose and delivery method, and their interaction. This formula expands to `len ~ supp + dose + supp:dose`. The `replications()` command is useful to check if the design is balanced or not, and how many observations are available in each treatment. It is fairly easy to pass any custom function to the `aggregate()` command; in this case, we just wrote a little helper function that returns the mean and standard deviation of a vector of values. The `aggregate()` command will take care of applying this function to each chunk of data.

The full model for the ANOVA can be estimated using the following commands:

```r
aov.fit <- aov(fm, data = ToothGrowth)
summary(aov.fit)
```

```
##             Df Sum Sq Mean Sq F value  Pr(>F)    
## supp         1    205     205   15.57 0.00023 ***
## dose         2   2426    1213   92.00 < 2e-16 ***
## supp:dose    2    108      54    4.11 0.02186 *  
## Residuals   54    712      13                    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


As can be seen, all effects are significant at the 5% level, in particular the interaction term. This means that it will be difficult to interpret any single effect without taking into account that both factors are interacting together.

The interaction effect is summarized below:

```r
model.tables(aov.fit, type = "means", se = TRUE, cterms = "supp:dose")
```

```
## Tables of means
## Grand mean
##       
## 18.81 
## 
##  supp:dose 
##     dose
## supp 0.5   1     2    
##   OJ 13.23 22.70 26.06
##   VC  7.98 16.77 26.14
## 
## Standard errors for differences of means
##         supp:dose
##             1.624
## replic.        10
```


It can be visualized using an interaction plot:

```r
xyplot(len ~ dose, data = ToothGrowth, groups = supp, type = c("a", "g"), xlab = "Dose (mg)", 
    ylab = "Tooth length", lwd = 2, auto.key = list(space = "top", columns = 2, points = FALSE, 
        lines = TRUE))
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 


The normality of the residuals can be assessed graphically from a QQ-plot. If they were really distributed as normal deviates, they should align on a straight line in the following picture.

```r
qqmath(~resid(aov.fit), col = my.col[1], alpha = 0.5, xlab = "Normal quantiles", 
    ylab = "Residuals")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 


Likewise, it is easy to check visually that variances across treatments are not 'too different' (i.e., each treatment distribution exhibits the same shape). A formal test of hypothesis can also be carried out, but bear in mind that it comes with specific hypothesis about the population distributions too. What is important here is that variances are computed from the treatments, and not factor levels separately. Hence the need to recreate the interaction term with the `interaction()` command.

```r
bwplot(len ~ interaction(supp, dose), data = ToothGrowth, do.out = FALSE, fill = my.col, 
    pch = "|", col = "white")
```

![plot of chunk assumptions](figure/assumptions.png) 

```r
bartlett.test(len ~ interaction(supp, dose), data = ToothGrowth)
```

```
## 
## 	Bartlett test of homogeneity of variances
## 
## data:  len by interaction(supp, dose) 
## Bartlett's K-squared = 6.927, df = 5, p-value = 0.2261
```



## Application

Let's consider the study ran by <a href="">Spilich et al. (1992)</a> about the effects of smoking on cognitive performance. The authors used three different tasks that differed according to the level of cognitive treatment required to execute them. Each task was performed was performed by different subjects. The first task was a pattern identification task, which consisted in locating a target presented on a computer screen. The second task was a cognitive task where subjects were asked to read some text and recall it afterwards. The third task consisted in a videogame driving simulation. In each condition, the dependent variable was the number of errors made by the subject. 

Subjects were then divided in three groups, depending on their level of exposure to tobacco. The FA group consisted of people who were actively smoking during the execution of the task or just before. The FP group included subjects who had not smoked for three hours prior to the execution of the task. The NF group was composed of usual smokers. Data are available in the file `tab13-tabagisme.dat`.

The `read.table()` command can be used to load the data. However, it should be noted that the first column is comprised of numbers (1, 2, 3), which will be treated as a `numeric` variable by R, unless stated otherwise, and there's no header text in this data file.


```r
d <- read.table("../data/tab13-tabagisme.dat", header = FALSE)
names(d) <- c("task", "group", "error")
d$task <- factor(d$task, labels = c("ident", "cogn", "simul"))
summary(d)
```

```
##     task    group       error     
##  ident:45   FA:45   Min.   : 0.0  
##  cogn :45   FP:45   1st Qu.: 6.0  
##  simul:45   NF:45   Median :11.0  
##                     Mean   :18.3  
##                     3rd Qu.:26.0  
##                     Max.   :75.0
```


1. Compute mean and standard deviation of each treatment.
2. Draw a boxplot of individual responses by task, for each smoking type.
3. Perform a two-way ANOVA (`error ~ task * group`), and comment the results.
4. Display an interaction plot.
5. Summarize simple effects for the `task` factor.

## References

Bliss C (1952). _The Statistics of Bioassay_. Academic Press.

Spilich G, June L and Renner J (1992). "Cigarette smoking and cognitive
performance." _Bristish Journal of Addiction_, *87*, pp. 1313-1326.

