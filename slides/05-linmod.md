ANOVA and the linear model
========================================================
author: Christophe Lalanne
date: November 12, 2013
css: custom.css






Synopsis
========================================================
type: sub-section

Statistical models are sometimes misunderstood in epidemiology. Statistical models for data are never true. The question whether a model is true is irrelevant. A more appropriate question is whether we obtain the correct scientific conclusion if we pretend that the process under study behaves according to a particular statistical model. Scott Zeger (1991)

> model comparisons • coding of categorical predictors • contrasts • analysis of covariance


ANOVA vs. regression
========================================================

**ANOVA:** Explain variations observed on a numerical response variable by taking into account manipulated or fixed values (levels) for some factors. We may also assume random effects for the factors under study.

**Regression:** Explain variations observed on a numerical response variable, or predict future values, based on a set of $k$ predictors (explanatory variables), which might be either numerical or categorical.

$$ y_i=\beta_0+\sum_{j=1}^k\beta_jx_i $$

A model comparison approach
========================================================

Base (null) model, M0: no factors/predictors involved, only the grand mean or intercept, and residual variations around this constant value.

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


Analysis of covariance
========================================================

Analysis of covariance consists in testing the effect of different levels of a factor on a numerical response when other numerical covariates are also considered. The response variable is 'associated' to the numerical covariate. The idea is to get an estimate of the average response corrected for the possible between-group differences (at the level of the covariates).

Such analyses are frequently carried out on pre/post measurements, and they can generally be seen as a post-hoc adjustment method (<span class="showtooltip" title="Miller G and Chapman J (2001). 'Misunderstanding Analysis of Covariance.' Journal of Abnormal Psychology, 110(1), pp. 40-48."><a href="">Miller & Chapman, 2001</a></span>; <span class="showtooltip" title="Senn S (2006). 'Change from baseline and analysis of covariance revisited.' Statistics in Medicine, 25(24), pp. 4334-4344."><a href="">Senn, 2006</a></span>).

Analysis of covariance (Con't)
========================================================

Let $y_{ij}$ be the $j$ th observation in group $i$, the ANCOVA model with one covariate can be written as 

$$ y_{ij} = \mu+\alpha_i+\beta(x_{ij}-\overline{x})+\varepsilon_{ij}, $$

where $\beta$ is the regression coefficient connecting the response $y$ to the cofactor $x$ (numerical), and $\overline{x}$ is the mean of the $x_{ij}$. As usual, $\varepsilon_{ij}$ is a random term distributed as $\mathcal{N}(0, \sigma^2)$.

Note that it is assumed that $\beta$ is the same in each group. This hypothesis ('parallelism' of regression slopes) can be verifed by testing the interaction term $\alpha\beta$.

Analysis of covariance (Con't)
========================================================

![ancova](./img/fig-ancova.png)

Illustration
========================================================

The `anorexia` data set includes weight change data for young female anorexia patients following different treatment regimen (Cognitive Behavioural treatment, Family treatment, or Control) (<span class="showtooltip" title="Hand D, Daly F, McConway K and Ostrowski E (1993). A Handbook of Small Data Sets. Chapman \&amp; Hall. Data set 285, p.~ 229."><a href="">Hand et al. 1993</a></span>).


```r
data(anorexia)
anorexia$Treat <- relevel(anorexia$Treat, ref="Cont")
f <- function(x) c(mean=mean(x), sd=sd(x))
aggregate(cbind(Prewt, Postwt) ~ Treat, data=anorexia, f)
```

```
  Treat Prewt.mean Prewt.sd Postwt.mean Postwt.sd
1  Cont     81.558    5.707      81.108     4.744
2   CBT     82.690    4.845      85.697     8.352
3    FT     83.229    5.017      90.494     8.475
```


Illustration (Con't)
========================================================

<img src="05-linmod-figure/unnamed-chunk-13.png" title="plot of chunk unnamed-chunk-13" alt="plot of chunk unnamed-chunk-13" style="display: block; margin: auto;" />


Illustration (Con't)
========================================================


```r
## Model considering identical slopes per group
m0 <- aov(Postwt ~ Prewt + Treat, data=anorexia)  
## Model considering different slopes per group
m1 <- aov(Postwt ~ Prewt * Treat, data=anorexia)  
anova(m0, m1)
```

```
Analysis of Variance Table

Model 1: Postwt ~ Prewt + Treat
Model 2: Postwt ~ Prewt * Treat
  Res.Df  RSS Df Sum of Sq    F Pr(>F)
1     68 3311                         
2     66 2845  2       466 5.41 0.0067
```


The comparison between the two **nested models** corresponds to a test of the interaction term. It should be kept as including it in the model results in a significant decrease in RSS (cf. `summary(m1)`). 

Illustration (Con't)
========================================================

The model without interaction writes down:

$$
\begin{align}
\tilde y_i &= 45.67 + 0.43\times\text{Prewt}_i
+4.10\times\mathbb{I}(\text{Treat}_i=\text{CBT})\\
&\phantom{= 45.67 }+8.66\times\mathbb{I}(\text{Treat}_i=\text{FT}).
\end{align}
$$

For the control group (`CTRL`), $$\tilde y_i = 45.67 +
0.43\times\text{Prewt}_i,$$ while for the `FT` group $$\tilde y_i =
45.67 + 0.43\times\text{Prewt}_i+8.66.$$ The effect of `Prewt` is the same for all patients, and the grouping factor only introduces a mean change (+4.10 ou +8.66) with respect to the control group.

Illustration (Con't)
========================================================

On the contrary, the model with interaction implies

$$
\begin{align}
\tilde y_i &= 80.99 - 0.13\times\text{Prewt}_i \\
&\phantom{80.99 -}+4.46\times\mathbb{I}(\text{Treat}_i=\text{CBT})\\
&\phantom{80.99 -}+8.75\times\mathbb{I}(\text{Treat}_i=\text{FT})\\
&\phantom{80.99 -}+0.98\times\text{Prewt}_i\times\mathbb{I}(\text{Treat}_i=\text{CBT})\\
&
\phantom{80.99 -}+1.04\times\text{Prewt}_i\times\mathbb{I}(\text{Treat}_i=\text{FT}).
\end{align}
$$

References
========================================================

Hand D, Daly F, McConway K and Ostrowski E (1993). _A Handbook of
Small Data Sets_. Chapman \& Hall. Data set 285, p.~ 229.

Hosmer D and Lemeshow S (1989). _Applied Logistic Regression_. New
York: Wiley.

Miller G and Chapman J (2001). "Misunderstanding Analysis of
Covariance." _Journal of Abnormal Psychology_, *110*(1), pp.
40-48.

Senn S (2006). "Change from baseline and analysis of covariance
revisited." _Statistics in Medicine_, *25*(24), pp. 4334-4344.

