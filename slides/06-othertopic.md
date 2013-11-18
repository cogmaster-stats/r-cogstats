Mixed-effects models
========================================================
author: Christophe Lalanne
date: November 19, 2013
css: custom.css






Synopsis
========================================================
type: sub-section

Evelyn Hall: I would like to know how (if) I can extract some of the information from the summary of my nlme.  
Simon Blomberg: This is R. There is no if. Only how.  
—Evelyn Hall and Simon ‘Yoda’ Blomberg  
R-help (April 2005)

> paired samples • intraclass correlation • variance components • random effects


Mixed-effects models
========================================================

Compared to standard linear models, mixed-effect models further include random-effect terms that allow to reflect correlation between statistical units. Such **clustered data** may arise as the result of grouping of individuals (e.g., students nested in schools), within-unit correlation (e.g., longitudinal data), or a mix thereof (e.g., performance over time for different groups of subjects) (<span class="showtooltip" title="McCulloch C and Searle S (2001). Generalized, Linear, and Mixed Models. Wiley."><a href="">McCulloch & Searle, 2001</a></span>; <span class="showtooltip" title="Lindsey J (1999). Models for Repeated Measurements, 2nd edition. Oxford University Press."><a href="">Lindsey, 1999</a></span>; <span class="showtooltip" title="Gelman A and Hill J (2007). Data Analysis Using Regression and Multilevel/Hierarchical Models. Cambridge University Press."><a href="">Gelman & Hill, 2007</a></span>).

This approach belongs to **conditional models**, as opposed to **marginal** models, where we are interested in modeling population-averaged effects by assuming a working (within-unit) correlation matrix. ME models are not restricted to a single level of clustering, and they give predicted values for each cluster or level in the hierarchy.

Fixed vs. random effects
========================================================

There seems to be little agreement about [what fixed and random effects really means](http://bit.ly/Jd0EiZ) (<span class="showtooltip" title="Gelman A (2005). 'Analysis of variance-why it is more important than ever.' Annals of Statistics, 33(1), pp. 1-53."><a href="">Gelman, 2005</a></span>).  
As a general decision workflow, we can ask whether we are interested in just estimating parameters for the random-effect terms, or get predictions at the individual level.

---

![randomfixed](./img/fig-random_vs_fixed.png)

Analysis of paired data
========================================================

The famous 'sleep' study is a good illustration of the importance of using pairing information when available.


```r
a <- t.test(extra ~ group, data=sleep, var.equal=TRUE)
```

```
[1] "t(18)=-1.86, p=0.07919"
```

```r
b <- t.test(extra ~ group, data=sleep, paired=TRUE)
```

```
[1] "t(9)=-4.06, p=0.00283"
```


Generally, ignoring within-unit correlation results in a **less powerful test**: Considering that $\text{Cov}(X_1,X_2)=0$ amounts to over-estimate variance of the differences, since $\text{Cov}(X_1,X_2)$ will generally be positive.
 
Analysis of paired data (Con't)
========================================================

<img src="06-othertopic-figure/unnamed-chunk-3.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />


A positive covariance in this case means that subjects having higher values on the first level will also have higher values on the second level. 

Analysis of repeated measures
========================================================

Lack of digestive enzymes in the intestine can cause bowel absorption problems, as indicated by excess fat in the feces. Pancreatic enzyme supplements can be given to ameliorate the problem (<span class="showtooltip" title="Vittinghoff E, Glidden D, Shiboski S and McCulloch (2005). Regression Methods in Biostatistics. Linear, Logistic, Survival, and Repeated Measures Models. Springer."><a href="">Vittinghoff et al. 2005</a></span>).
<!-- html table generated in R 2.15.2 by xtable 1.7-1 package -->
<!-- Mon Nov 18 21:57:08 2013 -->
<TABLE border=1>
<TR> <TH> ID </TH> <TH> None </TH> <TH> Tablet </TH> <TH> Capsule </TH> <TH> Coated </TH>  </TR>
  <TR> <TD align="right">   1 </TD> <TD align="right"> 44.50 </TD> <TD align="right"> 7.30 </TD> <TD align="right"> 3.40 </TD> <TD align="right"> 12.40 </TD> </TR>
  <TR> <TD align="right">   2 </TD> <TD align="right"> 33.00 </TD> <TD align="right"> 21.00 </TD> <TD align="right"> 23.10 </TD> <TD align="right"> 25.40 </TD> </TR>
  <TR> <TD align="right">   3 </TD> <TD align="right"> 19.10 </TD> <TD align="right"> 5.00 </TD> <TD align="right"> 11.80 </TD> <TD align="right"> 22.00 </TD> </TR>
  <TR> <TD align="right">   4 </TD> <TD align="right"> 9.40 </TD> <TD align="right"> 4.60 </TD> <TD align="right"> 4.60 </TD> <TD align="right"> 5.80 </TD> </TR>
  <TR> <TD align="right">   5 </TD> <TD align="right"> 71.30 </TD> <TD align="right"> 23.30 </TD> <TD align="right"> 25.60 </TD> <TD align="right"> 68.20 </TD> </TR>
  <TR> <TD align="right">   6 </TD> <TD align="right"> 51.20 </TD> <TD align="right"> 38.00 </TD> <TD align="right"> 36.00 </TD> <TD align="right"> 52.60 </TD> </TR>
   </TABLE>


R's wide and long format
========================================================


```r
d <- read.table("../data/pilltype.dat", header=TRUE)
head(d)
```

```
  ID None Tablet Capsule Coated
1  1 44.5    7.3     3.4   12.4
2  2 33.0   21.0    23.1   25.4
3  3 19.1    5.0    11.8   22.0
4  4  9.4    4.6     4.6    5.8
5  5 71.3   23.3    25.6   68.2
6  6 51.2   38.0    36.0   52.6
```

```r
library(reshape2)
head(fat <- melt(d, id.vars="ID", variable.name="pilltype", value.name="fecfat"), n=7)
```

```
  ID pilltype fecfat
1  1     None   44.5
2  2     None   33.0
3  3     None   19.1
4  4     None    9.4
5  5     None   71.3
6  6     None   51.2
7  1   Tablet    7.3
```


Variance components
========================================================

There is only one predictor, Pill type, which is attached to subject and period of time (subsumed under the repeated administration of the different treatment).
Here are different ways of decomposing the total variance:

- **One-way ANOVA:**  
`aov(fecfat ~ pilltype, data=fat)`
- **Two-way ANOVA:**  
`aov(fecfat ~ pilltype + subject, data=fat)`
- **RM ANOVA:**  
`aov(fecfat ~ pilltype + Error(subject), data=fat)`


Variance components (Con't)
========================================================

The first model, which assumes independent observations, does not remove variability between subjects (about 77.8% of residual variance). 

Source    | DF  |   SS   |   MS   |      M1                |   M2*/M3
--------- | --- | ------ | ------ | ---------------------- | ---------------------
pilltype  |  3  |  2009  |  669.5 | 669.5/359.7 (p=0.17 )  | 669.5/107.0 (p=0.01)
subject   |  5  |  5588  | 1117.7 |  –                     | 1117.7/107.0 (p=0.00*)
residuals | 15  |  1605  |  107.0 |  –                     | –

The last two models incorporate subject-specific effects:

$$ 
y_{ij} = \mu + subject_i + pilltype_j +
\varepsilon_{ij},\quad \varepsilon_{ij}\sim{\cal N}(0,\sigma_{\varepsilon}^2)
$$

In the third model, we further assume $subject_i\sim{\cal N}(0,\sigma_{s}^2)$,
independent of $\varepsilon_{ij}$.

Variance components (Con't)
========================================================

The inclusion of a random effect specific to subjects allows to model several types of within-unit correlation at the level of the outcome.
What is the correlation between measurements taken from the same individual? We know that
$$
\text{Cor}(y_{ij},y_{ik})=\frac{\text{Cov}(y_{ij},y_{ik})}{\sqrt{\text{Var}(y_{ij})}\sqrt{\text{Var}(y_{ik})}}.
$$
Because $\mu$ and $pilltype$ are fixed, and $\varepsilon_{ij}\perp
subject_i$, we have
$$
\begin{align}
\text{Cov}(y_{ij},y_{ik}) &= \text{Cov}(subject_i,subject_i)\\
&= \text{Var}(subject_i) \\
&= \sigma_{s}^2,
\end{align}
$$
and variance components follow from $\text{Var}(y_{ij})=\text{Var}(subject_i)+\text{Var}(\varepsilon_{ij})=\sigma_{s}^2+\sigma_{\varepsilon}^2$, which is **assumed to hold for all observations**.

Variance components (Con't)
========================================================

So that, we have
$$
\text{Cor}(y_{ij},y_{ik})=\frac{\sigma_{s}^2}{\sigma_{s}^2+\sigma_{\varepsilon}^2}
$$
which is the proportion of the total variance that is due to subjects. It is also known as the **intraclass correlation**, $\rho$, and it measures the closeness of observations on different subjects (or within-cluster similarity).

- Subject-to-subject variability simultaneously raises or lowers all the observations on a subject.
- The variance-covariance structure in the above model is called [compound symmetry](http://homepages.gold.ac.uk/aphome/spheric.html).

Estimating $\rho$
========================================================

Observations on the same subject are modeled as correlated through their shared random subject effect. Using the **random intercept model** defined above, we can estimate $\rho$ as follows: (default method is known as REML)


```r
library(nlme)
lme.fit <- lme(fecfat ~ pilltype, data=fat, random= ~ 1 | ID)
anova(lme.fit)
```

```
            numDF denDF F-value p-value
(Intercept)     1    15  14.266  0.0018
pilltype        3    15   6.257  0.0057
```

```r
## intervals(lme.fit)
sigma.s <- as.numeric(VarCorr(lme.fit)[1,2])
sigma.eps <- as.numeric(VarCorr(lme.fit)[2,2])
sigma.s^2/(sigma.s^2+sigma.eps^2)
```

```
[1] 0.7028
```


Estimating $\rho$
========================================================

From the **ANOVA table**, we can also compute $\hat\rho$:

```r
ms <- anova(lm(fecfat ~ pilltype + ID, data=fat))[[3]]
vs <- (ms[2] - ms[3])/nlevels(fat$pilltype)
vr <- ms[3]                                
vs / (vs+vr)
```

```
[1] 0.639
```


We could also use **Generalized Least Squares**, imposing compound symmetry:

```r
gls.fit <- gls(fecfat ~ pilltype, data=fat, corr=corCompSymm(form= ~ 1 | ID))
anova(gls.fit)
```

```
Denom. DF: 20 
            numDF F-value p-value
(Intercept)     1  14.266  0.0012
pilltype        3   6.257  0.0036
```

```r
## intervals(gls.fit) # \hat\rho = 0.7025074
```


The final picture
========================================================

The imposed variance-covariance structure is clearly reflected in the predicted values.

<img src="06-othertopic-figure/unnamed-chunk-9.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" style="display: block; margin: auto;" />


Model diagnostic
========================================================

Inspection of the **distribution of the residuals** and **residuals vs. fitted values** plots are useful diagnostic tools. It is also interesting to examine the distribution of random effects (intercepts and/or slopes).

<img src="06-othertopic-figure/unnamed-chunk-10.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" style="display: block; margin: auto;" />


Some remarks
========================================================

- For a balanced design, the residual variance for the within-subject ANOVA and random-intercept model will be identical (the REML estimator is equivalent to ANOVA MSs). Likewise, Pill type effects and overall mean are identical.
- Testing the significance of fixed effects can be done using ANOVA (F-value) or by model comparison. In the latter case, we need to fit model by ML method (and not REML) because models will include differents fixed effects.


```r
## anova(lme.fit)
lme.fit <- update(lme.fit, method="ML")
lme.fit0 <- update(lme.fit, fixed= . ~ - pilltype)
anova(lme.fit, lme.fit0)
```

```
         Model df   AIC   BIC  logLik   Test L.Ratio p-value
lme.fit      1  6 202.0 209.0  -94.98                       
lme.fit0     2  3 210.6 214.1 -102.28 1 vs 2   14.61  0.0022
```


Variance-covariance structure
========================================================

Other VC matrices can be choosen, depending on study design (<span class="showtooltip" title="Pinheiro J and Bates D (2000). Mixed-Effects Models in S and S-PLUS. Springer."><a href="">Pinheiro & Bates, 2000</a></span>),
e.g. Unstructured, First-order auto-regressive, Band-diagonal, AR(1) with heterogeneous variance. 

The random-intercept model ensures that the VC structure will be constrained as desired. With repeated measures ANOVA, a common strategy is to use Greenhouse-Geisser or Huynh-Feldt correction to correct for sphericity violations, or to rely on MANOVA which is less powerful, e.g. (<span class="showtooltip" title="Abdi H (2010). 'The Greenhouse-Geisser correction.' In Salkind N (ed.). Thousand Oaks, CA: Sage."><a href="">Abdi, 2010</a></span>; <span class="showtooltip" title="Zar J (1998). Biostatistical Analysis, 4th edition. Pearson, Prentice Hall."><a href="">Zar, 1998</a></span>).

Mixed-effect models are more flexible as they allow to make inference on the correlation structure, and to perform model comparisons.

References
========================================================

Gelman A (2005). "Analysis of variance-why it is more important
than ever." _Annals of Statistics_, *33*(1), pp. 1-53.

Gelman A and Hill J (2007). _Data Analysis Using Regression and
Multilevel/Hierarchical Models_. Cambridge University Press.

Lindsey J (1999). _Models for Repeated Measurements_, 2nd edition.
Oxford University Press.

McCulloch C and Searle S (2001). _Generalized, Linear, and Mixed
Models_. Wiley.

Vittinghoff E, Glidden D, Shiboski S and McCulloch (2005).
_Regression Methods in Biostatistics. Linear, Logistic, Survival,
and Repeated Measures Models_. Springer.

