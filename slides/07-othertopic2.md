ANOVA and the linear model (2)
========================================================
author: Christophe Lalanne
date: November 19, 2013
css: custom.css






Synopsis
========================================================
type: sub-section

The analysis of variance is not a mathematical theorem, but rather a convenient method of arranging the arithmetic. Ronald Fisher (1890-1962)

> orthogonal contrasts • post-hoc comparisons • unbalanced data

The ANOVA model
========================================================

One-way ANOVA:
$$
y_{ij} = \mu + \alpha_i + \varepsilon_{ij},\quad \varepsilon_{ij}\sim {\cal N}(0,\sigma^2).
$$

Two-way ANOVA
$$
y_{ijk} = \mu + \alpha_i + \beta_j + \gamma_{ij} + \varepsilon_{ijk},\quad \varepsilon_{ijk}\sim {\cal N}(0,\sigma^2).
$$

When a factor has more than 2 levels, or when the interaction between the two factors is of interest, this involves *post-hoc* **multiple comparisons** of pairs of means.

Orthogonal contrasts
========================================================

With $k$ samples (treatments), we can define $k-1$ orthogonal contrasts
$$
\phi = \sum_{i=1}^kc_i\overline{x}_i,\quad \sum_ic_i=0\; \text{et}\; \phi_u^t\phi_v^{\phantom{t}}=0
$$
and use as a test statistic $\frac{\phi}{s_{\phi}}$, where $s_{\phi}^2=s^2\sum_i\frac{c_i^2}{n_i}$, which is distributed as a Student's t.

- `contr.treatment`: treatment contrast (dummy coding), $k-1$ last levels compared to baseline category
- `contr.sum`: deviation contrast, $k-1$ first levels compared to the mean of the group means
- `contr.poly`: polynomial contrast (factor with ordered levels only), to test for linear, quadratic, cublic trend.

Orthogonal contrasts (Con't)
========================================================


```r
contr.treatment(levels(grp <- gl(3, 2, 36, c("A","B","C"))))
```

```
  B C
A 0 0
B 1 0
C 0 1
```

```r
y <- 0.5 * as.numeric(grp) + rnorm(36); 
coef(lm(y ~ grp))
```

```
(Intercept)        grpB        grpC 
     0.3611      0.6081      1.1492 
```

```r
coef(lm(y ~ grp, contrasts=list(grp="contr.sum")))
```

```
(Intercept)        grp1        grp2 
    0.94689    -0.58576     0.02231 
```


Application
========================================================

Consider a factor A with 4 levels and 8 observations per group.

```r
set.seed(101)
n <- 8
A <- gl(4, n, 4*n, labels=paste("a", 1:4, sep=""))
y <- 0.5 * as.numeric(A) + rnorm(4*n)
d <- data.frame(y, A)
print(mm <- tapply(y, A, mean))
```

```
    a1     a2     a3     a4 
0.7196 0.9945 0.8942 2.2277 
```

One-way ANOVA model:  
$H_0:\mu_1=\mu_2=\mu_3=\mu_4$, SS=11.38, F(3,28)=6.036 (p=0.00264).  
Let us assume that we are interested in the following comparisons: $H_0^{(1)}:(\mu_1+\mu_2)/2=(\mu_3+\mu_4)/2$, $H_0^{(2)}:\mu_1=\mu_2$ and $H_0^{(3)}:\mu_3=\mu_4$.

Application (Con't)
========================================================


```r
cm <- cbind(c(-1,-1,1,1), c(-1,1,0,0), c(0,0,-1,1))
contrasts(d$A) <- cm
summary(lm(y ~ A, data=d))
```

```

Call:
lm(formula = y ~ A, data = d)

Residuals:
    Min      1Q  Median      3Q     Max 
-1.6380 -0.3360  0.0713  0.4607  1.4332 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)    1.209      0.140    8.63  2.2e-09
A1             0.352      0.140    2.51   0.0181
A2             0.137      0.198    0.69   0.4935
A3             0.667      0.198    3.36   0.0022

Residual standard error: 0.793 on 28 degrees of freedom
Multiple R-squared: 0.393,	Adjusted R-squared: 0.328 
F-statistic: 6.04 on 3 and 28 DF,  p-value: 0.00264 
```


Application (Con't)
========================================================


```r
as.numeric((t(cm) %*% mm) / c(4, 2, 2))
```

```
[1] 0.3519 0.1375 0.6667
```

```r
library(multcomp)
summary(glht(aov(y ~ A, d), linfct = mcp(A = c("a1 - a2 = 0"))))
```

```

	 Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: User-defined Contrasts


Fit: aov(formula = y ~ A, data = d)

Linear Hypotheses:
             Estimate Std. Error t value Pr(>|t|)
a1 - a2 == 0   -0.275      0.396   -0.69     0.49
(Adjusted p values reported -- single-step method)
```


Multiples comparisons
========================================================

With $k$ samples, there are $k(k-1)/2$ pairs of means to compare. With $k=4$ and  $\alpha=0.05$, the family wise error rate (FWER) becomes $1-(1-0.05)^6=0.265$, assuming tests are independent.

There are two general (and conservative) strategies to control the inflation of Type I errors: (<span class="showtooltip" title="Christensen R (2002). Plane Answers to Complex Questions: The Theory of Linear Models, 3rd edition. Springer."><a href="">Christensen, 2002</a></span>)

- consider a different test statistic (e.g., HSD Tukey)
- consider a different nominal Type I error (e.g., Bonferroni correction)


```r
p.adjust.methods
```

```
[1] "holm"       "hochberg"   "hommel"     "bonferroni" "BH"        
[6] "BY"         "fdr"        "none"      
```


Application
========================================================

Usually, Bonferroni correction is applied to unplanned comparisons, and it can be restricted to a subset of all possible tests.

```r
pairwise.t.test(y, A, p.adjust.method="bonf")
```

```

	Pairwise comparisons using t tests with pooled SD 

data:  y and A 

   a1     a2     a3    
a2 1.0000 -      -     
a3 1.0000 1.0000 -     
a4 0.0042 0.0255 0.0134

P value adjustment method: bonferroni 
```


Application (Con't)
========================================================

Tukey HSD tests usually follow a significant ANOVA, and they are applied to all pairs of means.

```r
TukeyHSD(aov(y ~ A, d))
```

```
  Tukey multiple comparisons of means
    95% family-wise confidence level

Fit: aov(formula = y ~ A, data = d)

$A
         diff     lwr    upr  p adj
a2-a1  0.2750 -0.8071 1.3571 0.8986
a3-a1  0.1746 -0.9075 1.2567 0.9709
a4-a1  1.5081  0.4260 2.5902 0.0037
a3-a2 -0.1003 -1.1824 0.9818 0.9942
a4-a2  1.2331  0.1510 2.3152 0.0209
a4-a3  1.3335  0.2514 2.4156 0.0113
```

```r
## plot(TukeyHSD(aov(y ~ A, d)))
```


Unbalanced data
========================================================

When the number of observations differ in each treatment, we are more concerned with how to compute sum of squares (<span class="showtooltip" title="Herr D (1986). 'On the History of ANOVA in Unbalanced, Factorial Designs: The First 30 Years.' The American Statistician, 40(4), pp. 265-270."><a href="">Herr, 1986</a></span>).

For two factors, A and B:

- Type I (default): SS($A$), SS($B|A$), then SS($AB|B$, $A$)
- Type II: SS($A|B$), then SS($B|A$) (no interaction)
- Type III: SS($A|B$, $AB$), SS($B|A$, $AB$) (interpret each main effect after having accounted for other main effects and the interaction)



References
========================================================

Christensen R (2002). _Plane Answers to Complex Questions: The
Theory of Linear Models_, 3rd edition. Springer.

Herr D (1986). "On the History of ANOVA in Unbalanced, Factorial
Designs: The First 30 Years." _The American Statistician_,
*40*(4), pp. 265-270.


