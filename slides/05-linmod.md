ANOVA and the linear model
========================================================
author: Christophe Lalanne
date: November 12, 2013
css: custom.css






Synopsis
========================================================
type: sub-section

Statistical models are sometimes misunderstood in epidemiology. Statistical models for data are never true. The question whether a model is true is irrelevant. A more appropriate question is whether we obtain the correct scientific conclusion if we pretend that the process under study behaves according to a particular statistical model. Scott Zeger (1991)

> model comparisons • coding of categorical predictors • multiple comparisons • contrasts


ANOVA vs. regression
========================================================

**ANOVA:** Explain variations observed on a numerical response variable by taking into account manipulated or fixed values (levels) of some factors. We may also assume random effects for the factors under study.

**Regression:** Explain variations observed on a numerical response variable, or predict future values, based on a set of $k$ predictors (explanatory variables), which might be either numerical or categorical.

$$ y_i=\beta_0+\sum_{j=1}^k\beta_jx_i $$

A model comparison approach
========================================================

Base (null) model: no factors/predictors involved, only the grand mean or intercept, and residual variations around this constant value.

Comparing M1 vs. M0 allows to quantify and test the variance accounted for by the factor included in M1, or, equivalently, **reduction in RSS** (unexplained variance).

---

![model](./img/fig-modelcomp.png)


A model comparison approach (Con't)
========================================================


```r
data(ToothGrowth)
fm <- len ~ supp
m1 <- aov(fm, data = ToothGrowth)
summary(m1)
```

```
            Df Sum Sq Mean Sq F value Pr(>F)
supp         1    205     205    3.67   0.06
Residuals   58   3247      56               
```


Model with the `supp` factor vs. grand mean only:

```r
m0 <- update(m1, . ~ - supp)
anova(m0, m1)
```

```
Analysis of Variance Table

Model 1: len ~ 1
Model 2: len ~ supp
  Res.Df  RSS Df Sum of Sq    F Pr(>F)
1     59 3452                         
2     58 3247  1       205 3.67   0.06
```


Coding of categorical variables
========================================================


```r
n <- 6
x <- gl(2, 1, n, labels=letters[1:2])          ## x={a,b}
y <- 1.1 + 0.5 * (as.numeric(x)-1) + rnorm(n)  ## x={0,1}
m <- lm(y ~ x)
formula(m)
```

```
y ~ x
```

```r
model.matrix(m)
```

```
  (Intercept) xb
1           1  0
2           1  1
3           1  0
4           1  1
5           1  0
6           1  1
attr(,"assign")
[1] 0 1
attr(,"contrasts")
attr(,"contrasts")$x
[1] "contr.treatment"
```


Regression or t-test?
========================================================

<img src="05-linmod-figure/unnamed-chunk-5.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" style="display: block; margin: auto;" />


Writing down regression equations
========================================================

When the explanatory variable is numerical, the linear regression model reads $y_i=\beta_0+\beta_1x_i+\varepsilon_i$, where $\beta_0$ is the intercept, $\beta_1$ the slope of the regression line, and $\varepsilon_i$ are random errors (assumed to follow $\mathcal{N}(0;\sigma^2)$).  
Let $x$ be a categorical variable ($x=a$ or $x=b$), we can then write
$$ y = \beta_0+\beta_1\mathbb{I}(x=b) $$
with $\mathbb{I}(x=b)=1$ if $x=b$, 0 otherwise. Whence,
$$
\begin{align}
y &= \beta_0 & (x=a)\\
  &= \beta_0 + \beta_1 & (x=b)
\end{align}
$$
The interpretation of $\beta_1$ remains the same: it reflects the increase in $y$ when $x$ increases by 1 unit ($a\rightarrow b$). Regarding $\beta_0$, it is the average value of $y$ when $x=0$ (i.e., $x=a$).

Illustration
========================================================
Let us consider data on birth weight (<span class="showtooltip" title="Hosmer D and Lemeshow S (1989). Applied Logistic Regression. New York: Wiley."><a href="">Hosmer & Lemeshow, 1989</a></span>).


```r
data(birthwt, package="MASS")
ethn <- c("White","Black","Other")
birthwt$race <- factor(birthwt$race, labels=ethn)
birthwt$race <- relevel(birthwt$race, ref="White")
xyplot(bwt ~ race, data=birthwt, jitter.x=TRUE, alpha=.5)
```

<img src="05-linmod-figure/unnamed-chunk-6.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" style="display: block; margin: auto;" />


Regression of ethnicity on weight
========================================================


```r
m <- lm(bwt ~ race, data=birthwt)
summary(m)
```

```

Call:
lm(formula = bwt ~ race, data = birthwt)

Residuals:
    Min      1Q  Median      3Q     Max 
-2096.3  -502.7   -12.7   526.3  1887.3 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)   3102.7       72.9   42.55   <2e-16
raceBlack     -383.0      158.0   -2.42   0.0163
raceOther     -297.4      113.7   -2.61   0.0097

Residual standard error: 714 on 186 degrees of freedom
Multiple R-squared: 0.0502,	Adjusted R-squared: 0.04 
F-statistic: 4.91 on 2 and 186 DF,  p-value: 0.00834 
```


ANOVA Table for weight ~ ethnicity
========================================================


```r
anova(m)
```

```
Analysis of Variance Table

Response: bwt
           Df   Sum Sq Mean Sq F value Pr(>F)
race        2  5015725 2507863    4.91 0.0083
Residuals 186 94953931  510505               
```


Using `summary(aov(bwt ~ race, data=birthwt))` would yield exactly the same results. 

Contrast coding in R
========================================================

http://www.ats.ucla.edu/stat/r/library/contrast_coding.htm


```r
options("contrasts")
```

```
$contrasts
        unordered           ordered 
"contr.treatment"      "contr.poly" 
```

```r
coef(m)
```

```
(Intercept)   raceBlack   raceOther 
     3102.7      -383.0      -297.4 
```

```r
options(contrasts=c("contr.sum", "contr.poly"))
m2 <- lm(bwt ~ race, data=birthwt)
coef(m2)
```

```
(Intercept)       race1       race2 
     2875.9       226.8      -156.2 
```


Contrast coding in R (Con't)
========================================================


```r
grp.means <- with(birthwt, tapply(bwt, race, mean))
grp.means
```

```
White Black Other 
 3103  2720  2805 
```

```r
grp.means[2:3] - grp.means[1]     ## m  "contr.treatment"
```

```
 Black  Other 
-383.0 -297.4 
```

```r
grp.means[1:2] - mean(grp.means)  ## m2 "contr.sum"
```

```
 White  Black 
 226.8 -156.2 
```


Contrast coding in R (Con't)
========================================================

<img src="05-linmod-figure/unnamed-chunk-11.png" title="plot of chunk unnamed-chunk-11" alt="plot of chunk unnamed-chunk-11" style="display: block; margin: auto;" />



References
========================================================

Hosmer D and Lemeshow S (1989). _Applied Logistic Regression_. New
York: Wiley.

