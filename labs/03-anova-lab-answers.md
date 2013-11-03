Lab 3 : Answers to exercices
------------------------------



This document is written using [R Markdown](http://www.rstudio.com/ide/docs/r_markdown). The source code is available in `03-anova-lab-answers.R`.

## Application 1

Let us load the data as suggested:

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


As can be seen, there are two factors, `ident` and `cogn`, for this experiment using independent groups (we don't really need to add an extra `subject` variable in this case). A very basic formula that we will use throughout this session would look like `error ~ group + task`, which means "describe `error` by a combination of `ident` and `cogn`". This simple formula allows to summarize and plot data by groups. For ANOVA, we will also need to include an interaction term, hence the formula `error ~ group + task + group:task`, which can also be written as `error ~ group * task`.

### Summarizing data
The mean number of errors in each treatment (here, a treatment means any combination of levels for the two factors) can be obtained using `aggregate()` and the basic formula discussed above:

```r
aggregate(error ~ group + task, data = d, mean)
```

```
##   group  task  error
## 1    FA ident  9.933
## 2    FP ident  9.600
## 3    NF ident  9.400
## 4    FA  cogn 47.533
## 5    FP  cogn 39.933
## 6    NF  cogn 28.867
## 7    FA simul  2.333
## 8    FP simul  6.800
## 9    NF simul  9.933
```


We can use the same approach to compute standard deviation, replacing `mean` by `sd`. It is also possible to write a little function that will compute these two statistics for each treatment: (Note that we gave names to the returned values.)

```r
f <- function(x) c(mean = mean(x), sd = sd(x))
aggregate(error ~ group + task, data = d, f)
```

```
##   group  task error.mean error.sd
## 1    FA ident      9.933    6.519
## 2    FP ident      9.600    4.405
## 3    NF ident      9.400    1.404
## 4    FA  cogn     47.533   14.652
## 5    FP  cogn     39.933   20.133
## 6    NF  cogn     28.867   14.687
## 7    FA simul      2.333    2.289
## 8    FP simul      6.800    5.441
## 9    NF simul      9.933    6.006
```

The `aggregate()` command will separate the whole data frame into smaller chunks corresponding to each treatment e.g., `task=ident` and `group=FA`), to which the `f()` function will be applied. It would be possible to create a treatment indicator with the help of the `interaction()` command:

```r
group.task <- interaction(d$group, d$task)
aggregate(error ~ group.task, data = d, mean)
```

```
##   group.task  error
## 1   FA.ident  9.933
## 2   FP.ident  9.600
## 3   NF.ident  9.400
## 4    FA.cogn 47.533
## 5    FP.cogn 39.933
## 6    NF.cogn 28.867
## 7   FA.simul  2.333
## 8   FP.simul  6.800
## 9   NF.simul  9.933
```


Here is a quick visual inspection of the distribution of errors: 

```r
bwplot(error ~ task | group, data = d, pch = "|", layout = c(3, 1))
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 

The `error ~ task | group` expression just means "draw a boxplot of errors by task, for each level of group". This is arranged in a custom layout (3 panels arranged on one row). We often see average data shown as bar charts (`barchart()` in R) in the litterature. It is also possible to rely on [Cleveland's dotplots](http://goo.gl/iSrlOh), which generally offer a good data-ink ratio:

```r
error.means <- aggregate(error ~ group + task, data = d, mean)
dotplot(task ~ error, data = error.means, groups = group, type = "l", auto.key = list(space = "right", 
    points = FALSE, lines = TRUE))
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 

Note that we stored the average results in a separate variable, and since the `aggregate()` command returns a data frame, it can easily be used with `lattice` commands.

> Describe in plain English the apparent patterns of variation.

### Fitting the ANOVA model
The total number of statistical units available in each treatment can be obtained with `replication()`. It is also useful to check when a given design is balanced or not.

```r
replications(error ~ group * task, data = d)
```

```
##      group       task group:task 
##         45         45         15
```


The two-way ANOVA can be fitted using the extended formula `error ~ group * task`, and we get the following results:

```r
m <- aov(error ~ group * task, data = d)
summary(m)
```

```
##              Df Sum Sq Mean Sq F value  Pr(>F)    
## group         2    355     177    1.64 0.19733    
## task          2  28662   14331  132.90 < 2e-16 ***
## group:task    4   2729     682    6.33 0.00011 ***
## Residuals   126  13587     108                    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The ANOVA results indicate that the interaction between the two factors is significant at the 5% level, suggesting that the effect of `task` depends on the levels of `group`. Thus, simple effects cannot be interpreted directly. An interaction plot will help summarizing those results, since the absence of interaction would result in "parallel lines" for the marginal effects in the following display:

```r
xyplot(error ~ group, data = d, groups = task, type = c("a", "g"), auto.key = list(corner = c(1, 
    1), points = FALSE, lines = TRUE))
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9.png) 


To summarize simple effects, we can fit separate one-way models for each level of, say, `task`. To illustrate the use of simple loops in R, we create a small iteration over `task` levels: 

```r
op <- options(show.signif.stars = FALSE)
for (cond in levels(d$task)) {
    cat("Task = ", cond, "\n")
    print(summary(aov(error ~ group, data = d, subset = task == cond)))
    cat("\n")
}
```

```
## Task =  ident 
##             Df Sum Sq Mean Sq F value Pr(>F)
## group        2      2    1.09    0.05   0.95
## Residuals   42    894   21.29               
## 
## Task =  cogn 
##             Df Sum Sq Mean Sq F value Pr(>F)
## group        2   2643    1322    4.74  0.014
## Residuals   42  11700     279               
## 
## Task =  simul 
##             Df Sum Sq Mean Sq F value  Pr(>F)
## group        2    438   218.8    9.26 0.00047
## Residuals   42    993    23.6
```

```r
options(op)
```

Note that in this case we need to explicitly `print()` the results. The first and last line are here to suppress part of the ANOVA table, namely "[significance stars](http://www.jerrydallal.com/LHSP/p05.htm)". These comparisons are, however, less powerful than the full ANOVA model (we use smaller samples, and the error risk accumulated over multiple tests), and significance tests must be treated with caution. Sum of squares remain, however, fully interpretable. The above results would suggest that the `group` effect essentially holds in the last two tasks (`cogn` and `simul`).

### Computing effect-size measures
Although we computed average error for each treatment, it is also possible to provide a measure of the effect size for each factor. In the one-way design, dividing the sum of squares (SS) for the effect by the total sum of squares (effect + error), also called the $\eta^2$, provides such a measure: it sumamrizes the proportion of variance accounted for by the factor under study. In two-way designs, we can compute partial $\eta^2$ along the same idea, but the denominator would only include the residual and effect SSs. In this case, the partial effect for the `task` factor would be:

```r
28662/(28662 + 13587)
```

```
## [1] 0.6784
```

that is, about 68% of explained variance. Confidence intervals can be computed for partial effects by using the `ci.pvalf()` command from the `MBESS` package. See <http://yatani.jp/HCIstats/ANOVA> for more examples.
