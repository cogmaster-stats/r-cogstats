Lab 3 : Answers to exercices
------------------------------



This document is written using [R Markdown](http://www.rstudio.com/ide/docs/r_markdown). The source code is available in `04-regression-lab-answers.R`.

## Application 1

Here are the raw data:

```r
smoking <- c(77, 137, 117, 94, 116, 102, 111, 93, 88, 102, 91, 104, 107, 112, 113, 
    110, 125, 133, 115, 105, 87, 91, 100, 76, 66)
mortality <- c(84, 116, 123, 128, 155, 101, 118, 113, 104, 88, 104, 129, 86, 96, 
    144, 139, 113, 146, 128, 115, 79, 85, 120, 60, 51)
```


A data frame holding these two variables can be created as follows:

```r
d <- data.frame(smoking, mortality)
rm(smoking, mortality)
```

Note that we just deleted the two variables afterwards in order to keep a clean workspace. 

A numerical summary of the data can then be given as

```r
summary(d)
```

```
##     smoking      mortality  
##  Min.   : 66   Min.   : 51  
##  1st Qu.: 91   1st Qu.: 88  
##  Median :104   Median :113  
##  Mean   :103   Mean   :109  
##  3rd Qu.:113   3rd Qu.:128  
##  Max.   :137   Max.   :155
```

```r
sapply(d, sd)
```

```
##   smoking mortality 
##     17.20     26.11
```

Altough it would be possible to write a custom R function that returns all quantites, we can justuse `summary()` followed by a call to `sd()` on all variables (hence the use of `sapply()`).

A basic scatterplot of the data can be displayed using the following command:

```r
xyplot(mortality ~ smoking, data = d, type = c("p", "g"))
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 

To add a scatterplot smoother with varying span values, we could use the same command, replacing `type=c("p","g")` with `type=c("p", "g", "smooth")` and adding `span=1/3`, or any other value. Here is a more automated method:

```r
spans <- rev(c(1/3, 1/2, 2/3, 3/4))
my.key <- list(corner = c(0, 1), title = "Span", cex.title = 0.8, text = list(format(spans, 
    digits = 2), cex = 0.7), lines = list(type = "l", lty = 1:length(spans), col = "#BF3030"))
xyplot(mortality ~ smoking, data = d, type = c("p", "r"), key = my.key, panel = function(x, 
    y, ...) {
    panel.xyplot(x, y, ...)
    for (sp in seq_along(spans)) panel.loess(x, y, span = spans[sp], col = "#BF3030", 
        lty = sp, ...)
})
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 

As can be seen, when the span parameter decreases the smoother becomes too sensitive to local variations and the curve becomes more noisy.

Pearson's correlation is readily obtained using

```r
cor(d$mortality, d$smoking)
```

```
## [1] 0.7162
```

although we can also get the parameter estimate with the `cor.test()` command. This has two advantages, it provides 95% confidence interval, and it relies on a formula.

```r
cor.test(~mortality + smoking, data = d)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  mortality and smoking 
## t = 4.922, df = 23, p-value = 5.658e-05
## alternative hypothesis: true correlation is not equal to 0 
## 95 percent confidence interval:
##  0.4479 0.8662 
## sample estimates:
##    cor 
## 0.7162
```


Results for the regression model are provided in the next chunk. We use a formula where the response variable appears to the left, and the explanatory variable to the right of the `~` operator. The `summary()` command returns a table with regression coefficients and associated t-tests.

```r
m <- lm(mortality ~ smoking, data = d)
summary(m)
```

```
## 
## Call:
## lm(formula = mortality ~ smoking, data = d)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -30.11 -17.89   3.15  14.13  31.73 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   -2.885     23.034   -0.13      0.9    
## smoking        1.088      0.221    4.92  5.7e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
## 
## Residual standard error: 18.6 on 23 degrees of freedom
## Multiple R-squared: 0.513,	Adjusted R-squared: 0.492 
## F-statistic: 24.2 on 1 and 23 DF,  p-value: 5.66e-05
```


It is possible to extract/display regression coefficients with the `coef()` command. Then, it is easy to renormalize the slope parameter to find the correlation coefficient.

```r
coef(m)
```

```
## (Intercept)     smoking 
##      -2.885       1.088
```

```r
coef(m)[2] * sd(d$smoking)/sd(d$mortality)
```

```
## smoking 
##  0.7162
```


Finally, the squared correlation between predicted and observed values is just the $R^2$ [coefficient of determination](http://en.wikipedia.org/wiki/Coefficient_of_determination) which was displayed by R when calling `summary(m)`.  

```r
cor(fitted(m), d$mortality)^2
```

```
## [1] 0.513
```


