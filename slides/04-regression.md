Regression models
========================================================
author: Christophe Lalanne
date: November 5, 2013
css: custom.css






Synopsis
========================================================
type: sub-section

The greatest value of a picture is when it forces us to notice what we never expected to see. John Tukey (1915-2000)

> correlation • simple linear regression • parameter estimation • diagnostic measures

**Lectures:** OpenIntro Statistics, 7.1-7.4.


Association, correlation, causality
========================================================

Linear regression allows to model the relationship between a continuous outcome and one or more variables of interest, also called predictors. Unlike correlation analysis, these variables play an asymmetrical role, and usually we are interested in quantifying the strength of this relationship, as well as the amount of variance in the response variable acounted for by the predictors.

In linear regression, we assume a causal effect of the predictor(s) on the outcome. When quantifying the degree of association between two variables, however, both variables play a symmetrical role (there's no outcome or response variable). Moreover, correlation [usually](http://stats.stackexchange.com/q/534/930) does not imply causation.

Linear correlation
========================================================

([Bravais-](http://www.amstat.org/publications/jse/v9n3/stanton.html))Pearson correlation coefficient provides a unit-less measure of linear co-variation between two numeric variables, contrary to covariance which depends linearly on the measurement scale of each variable.  

A perfect positive (negative) linear correlation would yield a value of $r=+1$ ($-1$).

$$   
r=\frac{\overbrace{\sum_{i=1}^n(x_i-\overline{x})(y_i-\overline{y})}^{\text{covariance
        (x,y)}}}{\underbrace{\sqrt{\sum_{i=1}^n(x_i-\overline{x})^2}}_{\text{std deviation of x}}\underbrace{\sqrt{\sum_{i=1}^n(y_i-\overline{y})^2}}_{\text{std deviation of y}}}
$$

It's always about explained variance
========================================================

We want to account for individual variations of a response variable, $Y$, considering one or more predictors or explanatory variables, $X_j$ (numeric or categorical).  
**Simple linear regression** considers only one continuous predictor.

---

![linmod](./img/fig-linmod.png)



A general modeling framework
========================================================

Usually, we will consider that there is a **systematic and a random (residual) part** at the level of these individual variations. The linear model allows to formalize the asymmetric relationship between response variable ($Y$) and predictors ($X_j$) while separating these two sources of variation:

$$
\text{response} = \text{predictor(s) effect} + \hskip-11ex
\underbrace{\;\;\text{noise,}}_{\text{measurement error, observation period, etc.}}
$$

Importantly, this theoretical relationship is **linear and additive**: (<span class="showtooltip" title="Draper N and Smith H (1998). Applied Regression Analysis, 3rd edition. Wiley-Interscience."><a href="">Draper & Smith, 1998</a></span>; <span class="showtooltip" title="Fox J and Weisberg H (2010). An R Companion to Applied Regression, 2nd edition. Sage Publications."><a href="">Fox & Weisberg, 2010</a></span>)

$$ \mathbb{E}(y \mid x) = f(x; \beta) $$

All model are wrong, some are useful
========================================================

... or rather, "the practical question is how wrong do they have to be to not be useful" ([Georges Box](http://goo.gl/RN2t9C)).  

"Far better an approximate answer to the right question, which is often vague, than an exact answer to the wrong question, which can always be made precise" (<span class="showtooltip" title="Tukey J (1962). 'The future of data analysis.' Annals of Mathematical Statistics, 33, pp. 1-67."><a href="">Tukey, 1962</a></span>).

But all statistical models rely on more or less stringent assumptions. In the case of linear regression, the **linearity of the relationship** and **influence of individual data points** must be carefully checked.
Alternatives do exist, though: resistant or robust (Huber, LAD, quantile) methods, [MARS](http://goo.gl/Ox2xsO), [GAM](http://goo.gl/C8MR6B), or restricted cublic splines (<span class="showtooltip" title="Marrie R, Dawson N and Garland A (2009). 'Quantile regression and restricted cubic splines are useful for exploring relationships between continuous variables.' Journal of Clinical Epidemiology, 62(5), pp. 511-517."><a href="">Marrie et al. 2009</a></span>; <span class="showtooltip" title="Harrell F (2001). Regression modeling strategies with applications to linear models, logistic regression and survival analysis. Springer."><a href="">Harrell, 2001</a></span>).

ANOVA vs. regression
========================================================

- Not so much different, in a certain sense.
- Under the GLM umbrella, we can use regression to fit an ANOVA model.

![linmod2](./img/fig-linmod2.png)

A working example
========================================================


```r
# Simulate 10 obs. assuming the true model is Y=5.1+1.8X. 
set.seed(101)
n <- 10
x <- runif(n, 0, 10)
y <- 5.1 + 1.8 * x + rnorm(n)  # add white noise
summary(m <- lm(y ~ x))
```

```

Call:
lm(formula = y ~ x)

Residuals:
    Min      1Q  Median      3Q     Max 
-1.3238 -0.6105 -0.0725  0.6958  1.1247 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)    6.083      0.662    9.19  1.6e-05
x              1.619      0.136   11.90  2.3e-06

Residual standard error: 0.875 on 8 degrees of freedom
Multiple R-squared: 0.947,	Adjusted R-squared: 0.94 
F-statistic:  142 on 1 and 8 DF,  p-value: 2.28e-06 
```


A working example (Con't)
========================================================


![plot of chunk unnamed-chunk-3](04-regression-figure/unnamed-chunk-3.png) 


---

- OLS minimizes vertical distances between observed and fitted $y$ values (residual sum of squares).
- The regression line pass through the mean point, $(\bar x, \bar y)$; $b_0=\bar y-b_1\bar x$.
- The slope of the regression line is found to be $\sum_i(y_i-\bar y)(x_i-\bar x)\big/\sum_i(x_i-\bar x)^2$. (Compare to the formula for the correlation coefficient.)


Testing significance of slope or model
========================================================


```r
summary(m)$coefficients
```

```
            Estimate Std. Error t value  Pr(>|t|)
(Intercept)    6.083     0.6618   9.192 1.586e-05
x              1.619     0.1360  11.903 2.281e-06
```

```r
2*pt(1.619/0.136, 10-2, lower.tail=FALSE) ## t-test for slope
```

```
[1] 2.279e-06
```


We might also be interested in testing the model as a whole, especially when there are more than one predictor.


```r
anova(m)
```

```
Analysis of Variance Table

Response: y
          Df Sum Sq Mean Sq F value  Pr(>F)
x          1  108.5   108.5     142 2.3e-06
Residuals  8    6.1     0.8                
```


Fitted values and residuals
========================================================

Recall that Model fit = data + residual (cf. ANOVA).


```r
coef(m)[1] + coef(m)[2] * x[1:5]  ## adjusted values
```

```
[1] 12.109  6.793 17.573 16.731 10.128
```

```r
fitted(m)[1:5]
```

```
     1      2      3      4      5 
12.109  6.793 17.573 16.731 10.128 
```

```r
y[1:5] - predict(m)[1:5]          ## residuals
```

```
      1       2       3       4       5 
 0.8647 -0.2850  0.1890  1.1247 -0.7540 
```

```r
resid(m)[1:5]
```

```
      1       2       3       4       5 
 0.8647 -0.2850  0.1890  1.1247 -0.7540 
```



Beyond the regression line
========================================================

Predicted/adjusted values are estimated conditional on regressor values, assumed to be fixed and measured without error. We need further distributional assumption to draw inference or estimate 95% CIs for the parameters, namely that residuals follows an $\mathcal{N}(0;\sigma^2)$.  
**Residual analysis shows what has not yet been 
accounted for in a model**. 

---

![](./img/fig-linreg2.png)

Influence measures
========================================================

<img src="04-regression-figure/unnamed-chunk-7.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" style="display: block; margin: auto;" />

```r
head(influence.measures(m)$infmat)  # Chambers & Hastie, 1992
```

```
    dfb.1_    dfb.x    dffit cov.r   cook.d    hat
1  0.25847 -0.12144  0.37450 1.094 0.069134 0.1118
2 -0.41418  0.36912 -0.41453 2.398 0.095677 0.4828
3 -0.06857  0.11611  0.14584 1.768 0.012057 0.2731
4 -0.30614  0.59571  0.81886 0.903 0.282742 0.2124
5 -0.42605  0.31527 -0.45927 1.263 0.106739 0.1891
6  0.03618 -0.02399  0.04194 1.530 0.001004 0.1486
```


References
========================================================

Draper N and Smith H (1998). _Applied Regression Analysis_, 3rd
edition. Wiley-Interscience.

Fox J and Weisberg H (2010). _An R Companion to Applied
Regression_, 2nd edition. Sage Publications.

Harrell F (2001). _Regression modeling strategies with
applications to linear models, logistic regression and survival
analysis_. Springer.

Marrie R, Dawson N and Garland A (2009). "Quantile regression and
restricted cubic splines are useful for exploring relationships
between continuous variables." _Journal of Clinical Epidemiology_,
*62*(5), pp. 511-517.

Tukey J (1962). "The future of data analysis." _Annals of
Mathematical Statistics_, *33*, pp. 1-67.

