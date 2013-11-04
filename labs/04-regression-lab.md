Lab 4 : Regression analysis with R
------------------------------



This document is written using [R Markdown](http://www.rstudio.com/ide/docs/r_markdown). The source code is available in `04-regression-lab.R`. 


#### Learning objectives

> * Use scatter display and smoother
> * Compute linear and rank correlation
> * Build a linear regression model and interpret model parameters
> * Use basic diagnostic tools for regression modeling

## Scatterplot and correlation

We will consider the data discussed in [Exercise 8](http://rpubs.com/chl/cogmaster-stats-exercises) (see the [solution](http://rpubs.com/chl/cogmaster-stats-solutions)) about the imaging study on brain volume and anthropometric characteristics of Monozygotic twins (<a href="">Tramo et al. 1998</a>). The data set was loaded and recoded as follows:

```r
brain <- read.table("../data/IQ_Brain_Size.txt", header = FALSE, skip = 27, nrows = 20)
names(brain) <- tolower(c("CCMIDSA", "FIQ", "HC", "ORDER", "PAIR", "SEX", "TOTSA", 
    "TOTVOL", "WEIGHT"))
brain$order <- factor(brain$order)
brain$pair <- factor(brain$pair)
brain$sex <- factor(brain$sex, levels = 1:2, labels = c("Male", "Female"))
summary(brain)
```

```
##     ccmidsa          fiq              hc       order       pair       sex    
##  Min.   :5.73   Min.   : 85.0   Min.   :52.9   1:10   1      :2   Male  :10  
##  1st Qu.:6.29   1st Qu.: 92.0   1st Qu.:54.8   2:10   2      :2   Female:10  
##  Median :6.71   Median : 96.5   Median :56.8          3      :2              
##  Mean   :6.99   Mean   :101.0   Mean   :56.1          4      :2              
##  3rd Qu.:7.63   3rd Qu.:105.5   3rd Qu.:57.2          5      :2              
##  Max.   :8.76   Max.   :127.0   Max.   :59.2          6      :2              
##                                                       (Other):8              
##      totsa          totvol         weight     
##  Min.   :1685   Min.   : 963   Min.   : 57.6  
##  1st Qu.:1772   1st Qu.:1035   1st Qu.: 61.6  
##  Median :1864   Median :1079   Median : 76.0  
##  Mean   :1906   Mean   :1126   Mean   : 77.8  
##  3rd Qu.:1984   3rd Qu.:1181   3rd Qu.: 85.0  
##  Max.   :2264   Max.   :1439   Max.   :133.4  
## 
```


We will focus on the relationship between two numerical variables: `totvol` (total brain volume, in cm$^3$) and `totsa` (total surface area, in cm$^2$). The analysis will be restricted on the 10 subjects defined by birth order (`order=1`). To simplify command arguments, we can extract the relevant data into a derived data frame, but we could also work directly with `subset()` each time.

```r
brain2 <- subset(brain, order == 1, c(totsa, totvol))
```



Before computing any measure of linear association, like Pearson's r, it is highly recommended to plot all data points into a two-dimensional display, also called scatterplot. The basic `lattice` command is the `xyplot()` function, with a formula describing what to plot on y-axis (left-hand side of the formula) and what will go on the x-axis (right-hand side). Many options are available, including `type="p"` (points), `type="l"` (lines), `type="g"` (grid), `type="smooth"` (lowess smoother). Here is an example of use:

```r
xyplot(totvol ~ totsa, data = brain2, type = c("p", "g", "smooth"), span = 1, xlab = "Total surface area (cm2)", 
    ylab = "Total brain volume (cm3)")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

[Lowess smoother](http://en.wikipedia.org/wiki/Local_regression) belongs to local regression methods that allows to assess the linearity of the relationship between two variables (<a href="">Cleveland, 1979</a>). The `span=` parameter allows to control the width of the smoothing window. The larger it is, the less the local smoother will adjust to local irregularities. It is often useful to specify a combination of `type="smooth"` and `type="r"` to get lowess and OLS (regression), i.e. `type=c("p", "r", "smooth")`, superimposed on the same panel since it will help to spot possible deviations from the linearity assumption.

Pearson's correlation can be obtained with the `cor()` command.

```r
cor(brain2$totvol, brain2$totsa)
```

```
## [1] 0.816
```


In case there are missing values, it is necessary to indicate to R how to compute the correlation coefficient. Usually, we add `use="pairwise.complete.obs"` when there are more than 2 variables and we are interested in computing a correlation matrix. Spearman $\rho$ (rank-based measure of correlation, which allows to summarize a monotonic relationship) can be obtained by adding `method="spearman` to the preceding instruction.

```r
cor(brain2$totvol, brain2$totsa, method = "spearman")
```

```
## [1] 0.7333
```


It is also possible to assess the statistical significance of Pearson or Spearman's correlation with `cor.test()`, as shown below.

```r
cor.test(~totvol + totsa, data = brain2)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  totvol and totsa 
## t = 3.993, df = 8, p-value = 0.003987
## alternative hypothesis: true correlation is not equal to 0 
## 95 percent confidence interval:
##  0.3834 0.9550 
## sample estimates:
##   cor 
## 0.816
```



## Regression

To fit a simple regression model, we wil use exactly the same formula as that used to display a scatterplot, namely `totvol ~ totsa`. Here are the results produced by R:

```r
m <- lm(totvol ~ totsa, data = brain2)
summary(m)
```

```
## 
## Call:
## lm(formula = totvol ~ totsa, data = brain2)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -98.45 -60.16  -1.61  40.31 173.27 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)   
## (Intercept) -186.442    328.682   -0.57    0.586   
## totsa          0.674      0.169    3.99    0.004 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
## 
## Residual standard error: 84.8 on 8 degrees of freedom
## Multiple R-squared: 0.666,	Adjusted R-squared: 0.624 
## F-statistic: 15.9 on 1 and 8 DF,  p-value: 0.00399
```


R displays the value of the regression coefficient and their associated t-tests. The slope corresponds to the parameter of interest (how does `totvol` vary when `totsa` is increased by one unit), while the intercept is the value of `totvol` when `totsa=0`.

Note that an equivalent call using the full data frame would be: 

```r
lm(totvol ~ totsa, brain, subset = order == 1)
```


It is also possible to display an ANOVA table for the regression, although most of the information was already given by R at the bottom of the preceding result.

```r
anova(m)
```

```
## Analysis of Variance Table
## 
## Response: totvol
##           Df Sum Sq Mean Sq F value Pr(>F)   
## totsa      1 114590  114590    15.9  0.004 **
## Residuals  8  57488    7186                  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


One of the assumption of this statistical model is that residuals are random normal, meaning that they do not exhibit any particular pattern depedning on the values of the observed or fitted values. A quick look at a residuals by fitted values often helps to confirm the validity of this hypothesis:

```r
xyplot(resid(m) ~ fitted(m), type = c("p", "g"), abline = list(h = 0, lty = 2), xlab = "Predicted values (totvol)", 
    ylab = "Residuals")
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 


Note that the `lattice` package has a built-in command for displaying residual plots, namely `rfs()`.

Finally, several measure of observation influence are available in R. We are usually mainly interested in (univariate) outlying values, observation exhibiting a large leverage effect (x-axis), obsrvation having a large residual in absolute values (y-axis), and observation influencing parameter estimates. See 
[SAS Influence Diagnostics](http://www.sfu.ca/sasdoc/sashtml/stat/chap55/sect38.htm)
or <a href="">Fox & Weisberg (2010)</a> for a detailed overview of influence measures. In the next figure, several indices were used, based on recommend cut-off values (see SAS guidelines). Most information used to build these graphics is given by the `fitted()`, `resid()`, and `influence.measures()` commands. Based on the results, the 8th observation seems to be the most influential observation, since it would largely alter the slope of the regression line if removed (see its large DFBETA or Cook's distance value).



![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11.png) 


## Application

Government statisticians in England conducted a [study of the relationship between smoking and lung cancer](http://lib.stat.cmu.edu/DASL/Stories/SmokingandCancer.html). The data concern 25 occupational groups and are condensed from data on thousands of individual men. The explanatory variable is the number of cigarettes smoked per day by men in each occupation relative to the number smoked by all men of the same age. This smoking ratio is 100 if men in an occupation are exactly average in their smoking, it is below 100 if they smoke less than average, and above 100 if they smoke more than average. The response variable is the standardized mortality ratio for deaths from lung cancer. It is also measured relative to the entire population of men of the same ages as those studied, and is greater or less than 100 when there are more or fewer deaths from lung cancer than would be expected based on the experience of all English men.  

Here are the raw data:

```r
smoking <- c(77, 137, 117, 94, 116, 102, 111, 93, 88, 102, 91, 104, 107, 112, 113, 
    110, 125, 133, 115, 105, 87, 91, 100, 76, 66)
mortality <- c(84, 116, 123, 128, 155, 101, 118, 113, 104, 88, 104, 129, 86, 96, 
    144, 139, 113, 146, 128, 115, 79, 85, 120, 60, 51)
```


1. Create a data frame, `d`, with the above variables. Provide a numerical summary of the data (range, mean/median, standard deviation, inter-quartile range).
2. Use a scatterplot to display the relationship between the two variables.
3. Add a lowess smoother to this scatterplot, and try different values for the `span=` parameter (e.g., 1/3, 1/2, 2/3, 3/4).
4. Compute Pearson's correlation coefficient, and give a 95% confidence interval for the parameter estimate.
5. Fit a simple regression model, with `mortality` as the response variable. Find Pearson's r from the value of the slope of the regression line.
6. Compute the squared correlation of fitted and observed values. What does this value stand for?

## References

Cleveland W (1979). "Robust locally weighted regression and smoothing
scatterplots." _Journal of the American Statistical Association_, *74*,
pp. 829-836.

Fox J and Weisberg H (2010). _An R Companion to Applied Regression_,
2nd edition. Sage Publications.

Tramo M, Loftus W, Green R, Stukel T, Weaver J and Gazzaniga M (1998).
"Brain Size, Head Size, and IQ in Monozygotic Twins." _Neurology_,
*50*, pp. 1246-1252.


