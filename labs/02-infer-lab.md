Lab 2 : Data munging and basic statistical tests with R
------------------------------



This document is written using [R Markdown](http://www.rstudio.com/ide/docs/r_markdown). The source code is available in `02-infer-lab.R`. 

Graphics used in this document are all made with the [lattice](http://lattice.r-forge.r-project.org/) package rather than base graphics. Interesting books for statistical data displays are:

- Tukey, JW, [Exploratory data analysis](http://goo.gl/m4R4UC), Pearson, 1977
- Cleveland, WS, [The Elements of Graphing Data](http://goo.gl/NmC9to), Hobart Press, 1994
- Cleveland, WS, [Visualizing Data](http://goo.gl/mmnt6k), Hobart Press, 1993

#### Learning objectives

> * Import external data files
> * Compute aggregated summary statistics
> * Create basic summary graphics
> * Compare two independent sample means

## Data importation

Although it is easy to create a data frame in R, data most of the time come in flat files (in CSV or tab-delimited format). The main command to read an external data file is `read.table()`. There are some variants like `read.csv()` or `read.csv2()` that include convenient options allowing to read CSV files (as exported by MS Excel directly); see the `sep=` and `dec=` options.

Consider the study described in (<a href="">Eysenck, 1974</a>) where the objective was to compare memory levels of young and elderly subjects. The hypothesis was as follows: when people have to process verbal information (simple list of words), in-depth memory processes are probably reduced in elderly, and thus they should recall less words. Artificial data (same means and SDs as in the original study) are available in the file `eysenck74.dat`. The response variable is the number of words correctly recalled. Here are the very first few lines:

    01 1 21
    02 1 19
    03 1 17
    04 1 15
    05 1 22
    06 1 16

The first column contains subject's number, the grouping factor is stored in the second column (1=young, 2=older), and the third and last column is the response variable (number of words). The first two variables should be treated as `factor` by R.


```r
d <- read.table("../data/eysenck74.dat")
names(d) <- c("id", "age", "words")
d$id <- factor(d$id)
d$age <- factor(d$age, levels = 1:2, labels = c("young", "elderly"))
summary(d)
```

```
##        id          age         words     
##  1      : 1   young  :10   Min.   : 5.0  
##  2      : 1   elderly:10   1st Qu.:11.0  
##  3      : 1                Median :15.5  
##  4      : 1                Mean   :15.7  
##  5      : 1                3rd Qu.:19.5  
##  6      : 1                Max.   :22.0  
##  (Other):14
```

Note that it would have been possible to add variable type (`factor` or `numeric`) when calling the `read.table()` command. For instance, we can use the follwowing instruction:

```r
d <- read.table("../data/eysenck74.dat", colClasses = c("factor", "factor", "numeric"))
# check that we get the same data structure
str(d)
```


Beside `summary()`, graphical inspection of the data often shed light on the shape of the distribution for the response variable, on the whole sample or conditional on `age` levels. An histogram is generally used to display the distribution of counts or frequencies (or densities with unequal class intervals). As can be seen in the following picture, the distribution of words recalled by subjects looks rather flat on a certain range of the response, but few subjects were able to recall 10 words or less.

```r
histogram(~words, data = d, type = "count")
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 


The distribution of words can also be displayed separately for young and elderly subjects. This clearly highlight the fact that elderly recall on average less words compared to younger subjects, although they tend to exhibit more variability at the same time.

```r
histogram(~words | age, data = d, type = "percent")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 


Here is the same graphical depiction of the data based on density curves, which provide continuous approximations to classical histograms and allow to superimpose different groups in the same panel.

```r
densityplot(~words, data = d, groups = age)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 


More closely related to the 6-point summary returned by R's `summary()` function, a box and whisker plot, or [boxplot](http://j.mp/hS5RJW), allows to summarize the main characteristics of a continuous distribution using a schematic representation of range and quartiles location along the measurement scale. The box encompasses 50% of the observations, and end edges of the box denotes the first and third quartiles (lower and upper 'hinges'). The median (second quartile) is usually represented as a dot or a vertical bar inside the box. The whiskers show the mimum and maximum values, unless unusual data points are present. In this case, values outside 1.5 times the inter-quartile range from the first or third quartile would be considered as potential 'outliers' and displayed as simple dots--this is the default with R's `boxplot()` or `bwplot()`.

```r
bwplot(age ~ words, data = d, pch = "|")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 


## Comparing two means with Student's t-test

The `t.test()` command implements Student's t-test, which assumes the equality of population variance, as well as Welch-corrected t-test (default method). As seen before, we can use a 'formula' to describe the relationship between variables: in this case, the response variable appears on the left, and the explanatory variable on the right of the `~` symbol. When using R's formulae, it is necessary to indicate the data frame in which  variables can be found. To carry out the classical t-test, the option `var.equal=TRUE` must be used.

```r
aggregate(words ~ age, data = d, mean)
```

```
##       age words
## 1   young  19.3
## 2 elderly  12.0
```

```r
t.test(words ~ age, data = d, var.equal = TRUE)
```

```
## 
## 	Two Sample t-test
## 
## data:  words by age 
## t = 5.023, df = 18, p-value = 8.836e-05
## alternative hypothesis: true difference in means is not equal to 0 
## 95 percent confidence interval:
##   4.247 10.353 
## sample estimates:
##   mean in group young mean in group elderly 
##                  19.3                  12.0
```


One of the requirements for the test to be valid is that variance is equal in both populations. It is easy to compute the ratio of the two variances by hand and check whether it exceeds 3 (or 4) or not, which is usually considered as 'acceptable', or carry out a formal test of hypothesis (Fisher's test of equality of variances), although it is often meaningless in the case of variance.

```r
aggregate(words ~ age, data = d, var)
```

```
##       age  words
## 1   young  7.122
## 2 elderly 14.000
```

```r
var.test(words ~ age, data = d)
```

```
## 
## 	F test to compare two variances
## 
## data:  words by age 
## F = 0.5087, num df = 9, denom df = 9, p-value = 0.3285
## alternative hypothesis: true ratio of variances is not equal to 1 
## 95 percent confidence interval:
##  0.1264 2.0481 
## sample estimates:
## ratio of variances 
##             0.5087
```


The Welch-Satterwaithe correction can be applied on the degrees of freedom of this test to account for unequal variances (in this case, we no longer rely on a pooled variance estimate):

```r
t.test(words ~ age, data = d)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  words by age 
## t = 5.023, df = 16.27, p-value = 0.0001188
## alternative hypothesis: true difference in means is not equal to 0 
## 95 percent confidence interval:
##   4.223 10.377 
## sample estimates:
##   mean in group young mean in group elderly 
##                  19.3                  12.0
```


Another assumption is that of normality (again, such an assumption concerns the population), which can be assessed with the sample at hand by drawing a [quantile-quantile plot](http://en.wikipedia.org/wiki/Q%E2%80%93Q_plot), or QQ plot for short.

```r
qqmath(~words | age, data = d, col = "cornflowerblue", prepanel = prepanel.qqmathline, 
    panel = function(x, ...) {
        panel.qqmathline(x, ...)
        panel.qqmath(x, ...)
    })
```

![plot of chunk qqplot](figure/qqplot.png) 



## Effect size

The results of a t-test tell us whether there exists, on average, a significant difference (at a fixed error rate, usually 5%) between the two samples. Since the difference between the two means is sample-dependent and is hard to interpret without knowing variance of the results in each sample, it is often recommended to compute a [standardized mean difference](http://jpepsy.oxfordjournals.org/content/early/2009/02/16/jpepsy.jsp004.full) (also known as Cohen's d). This basically amounts to divide the difference between the two means by either a common estimate of the standard deviation (or the pooled variance used in the t-test), or the standard deviation of the 'control' group.

Instead of `aggregate()`, it is possible to use the `tapply()` command, which returns a vector rather than a data frame.

```r
words.means <- with(d, tapply(words, age, mean))
words.sd <- with(d, tapply(words, age, sd))
diff(words.means)/words.sd[1]
```

```
## elderly 
##  -2.735
```

```r
diff(words.means)/mean(words.sd)
```

```
## elderly 
##  -2.278
```


With the `MBESS` package (to install it, type `install.packages(MBESS)` at the R prompt), we can easily replicate the above results. 

```r
library(MBESS)
with(d, smd(words[age == "elderly"], words[age == "young"]))
```

```
## [1] -2.246
```

```r
with(d, smd.c(words[age == "elderly"], words[age == "young"]))
```

```
## [1] -2.735
```


## Power analysis

Finally, even if the researcher accepts to be wrong 5% of the time when claiming that the null hypothesis does not hold while in reality there is no difference between the two populations, there still is a risk of not rejecting the null when indeed it should be rejected. For instance, if at the end of a clinical trial no differences have proven to be significant between two parallel groups, this does not mean that the treatment perform equally well in the two group of patients: There exists a risk $\beta$ that there is a true difference between them, but we lack power to detect it. Power analysis and sample size determination are usually done before the study starts. Post-hoc power analysis (i.e., after having seen the data) are not recommended.

Assuming we expect to demonstrate with a two-sided t-test ($\alpha=5$%) and a power of 90% a difference of, say, 5 words (with a standard deviation of 3 words) between the two groups of subjects, the number of subjects to enroll in each group would have been:

```r
power.t.test(power = 0.9, delta = 5, sd = 3)
```

```
## 
##      Two-sample t test power calculation 
## 
##               n = 8.649
##           delta = 5
##              sd = 3
##       sig.level = 0.05
##           power = 0.9
##     alternative = two.sided
## 
##  NOTE: n is number in *each* group
```



## References

Eysenck M (1974). "Age differences in incidental learning."
_Developmental Psychology_, *10*, pp. 936-941.

