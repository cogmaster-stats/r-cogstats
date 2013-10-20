Statistical models in R
========================================================
author: Christophe Lalanne
date: October 22, 2013
css: custom.css






Synopsis
========================================================
type: sub-section

The analysis of variance is not a mathematical theorem, but rather a convenient method of arranging the arithmetic. Ronald Fisher (1890-1962)

> design of experiments • split-apply-combine • one-way and two-way ANOVA • interaction

**Lectures:** OpenIntro Statistics, 4.2, 5.2, 5.5.


Design of experiments
========================================================

**Maximize precision while minimizing number of trials.**

Implementation of an organized set of experimental units to characterize the effect of certain treatments or combination of treatments, on one or more response variables. In factorial designs, for example, all levels of all experimental factors will be crossed.

Taking into account one or more nuisance factors for the establishment of experimental design: organize sources of unwanted variation so that we can say that they affect treatment equivalently, making the comparison between treatments possible.


Some examples
========================================================

* Parallel (independent) groups
* Factorial experiment
* Complete or incomplete block designs, Latin square design
* Split-plot design
* Repeated measures, including cross-over trials

Describing variables relationships
========================================================
R relies on a 'formula' to describe relation between one or multiple response variables and one or more explanatory variables, according to Wilkinson & Rogers's notation (<span class="showtooltip" title="Wilkinson G and Rogers C (1973). 'Symbolic description of factorial models for analysis of variance.' Applied Statistics, 22, pp. 392-399."><a href="">Wilkinson & Rogers, 1973</a></span>; <span class="showtooltip" title="Chambers J and Hastie T (1992). Statistical Models in S. Wadsworth \&amp; Brooks. ISBN: 0534167649."><a href="">Chambers & Hastie, 1992</a></span>). 

In the case of ANOVA and regression, the response variable is put on the left of the `~` operator, followed by 

| RHS     | Variable type    | Meaning                     | Equiv. to             |
| ------- |:----------------:|:---------------------------:|:---------------------:|
| x       | numeric          | simple linear regression    | 1 + x                 |
| x + 0   | numeric          | idem without intercept      | x - 1                 |
| a + b   | factor (numeric) | two main crossed effects    |                       |
| a * b   | factor           | idem including interaction  | 1 + a + b + a:b       |
| a / b   | factor           | nested relationship         | 1 + a + b + a %in% b  |


R's formula and data analysis
========================================================

Most of the time, the same formula can be used to perform several 'data steps' ([tidying](http://vita.had.co.nz/papers/tidy-data.pdf) and [summarizing](http://biostat.mc.vanderbilt.edu/wiki/Main/Hmisc) data, [plotting](http://dsarkar.fhcrc.org/lattice-lab/latticeLab.pdf), or [reporting](http://yihui.name/knitr/)), but it is also the core element of many statistical models in R (linear and generalized linear models, decision trees, partitioning methods, etc.).  
The use of formulae means we also need to work with a well-arranged data frame, for which **reshaping** (melting/casting) are essential tools.


```r
d <- data.frame(x1 = rnorm(n=5, mean=10, sd=1.5), 
                x2 = rnorm(n=5, mean=12, sd=1.5))
d[1:3,]  # same as head(d, n=3)
```

```
      x1    x2
1  9.511 13.76
2 10.829 12.93
3  8.988 11.83
```


R's formula and data analysis (con't)
========================================================


```r
res <- t.test(d$x1, d$x2, var.equal=TRUE)
res$p.value
```

```
[1] 0.001021
```

```r
library(reshape2)
dm <- melt(d)     # switch from wide to long format
head(dm)
```

```
  variable  value
1       x1  9.511
2       x1 10.829
3       x1  8.988
4       x1 10.322
5       x1 10.466
6       x2 13.761
```

```r
t.test(value ~ variable, data=dm, var.equal=TRUE)$p.value
```

```
[1] 0.001021
```


<small>**Note:** R's formulae (and data frames, *de facto*) have been ported to [Python](http://patsy.readthedocs.org/en/latest/) and [Julia](http://juliastats.github.io/DataFrames.jl/formulas.html).</small>


The Split-Apply-Combine strategy
========================================================

"(...) break up a big problem into manageable pieces, operate on each piece independently and then put all the pieces back together." (<span class="showtooltip" title="Wickham H (2011). 'The Split-Apply-Combine Strategy for Data Analysis.' Journal of Statistical Software, 40(1)."><a href="">Wickham, 2011</a></span>)

---

![sac](./img/split_apply_combine.png)

Split-Apply-Combine (con't)
========================================================

Here is a working example:

```r
x <- rnorm(n=15)
grp <- gl(n=3, k=5, labels=letters[1:3])
spl <- split(x, grp)      # split x by levels of grp
apl <- lapply(spl, mean)  # apply mean() to each split 
cbn <- rbind(x=apl)       # combine the means
cbn
```

```
  a       b       c       
x -0.1088 -0.7705 -0.08854
```


Shorter version (other than `by()`, `tapply()`, or `ave()`):

```r
aggregate(x ~ grp, FUN=mean)
```

```
  grp        x
1   a -0.10883
2   b -0.77052
3   c -0.08854
```


One-way ANOVA
========================================================

Let $y_{ij}$ be the $j\text{th}$ observation in group $i$ (factor
$A$, with $a$ levels). An **effect model** can be written as

$$ y_{ij} = \mu + \alpha_i + \varepsilon_{ij}, $$

where $\mu$ stands for the overall (grand) mean, $\alpha_i$ is the effect of group $i$ ($i=1,\dots,a$), and $\varepsilon_{ij}\sim \mathcal{N}(0,\sigma^2)$ reflects random error. The following restriction is usually considered: 
$\sum_{i=1}^a\alpha_i=0$. 

The **null hypothesis** reads: $H_0:\alpha_1=\alpha_2=\dots=\alpha_a$. It can be tested with an F-test with $a-1$ et $N-a$ degrees of freedom. 

Assumptions, caveats, etc.
========================================================

* This is an *omnibus test* for which the alternative hypothesis reads $\exists i,j\mid \alpha_i\neq\alpha_j,\: i, j=1,\dots,a\, (i\neq j)$. If the result is significant, it doesn't tell us which pairs of means really differ.
* Beside independence of observations, this model assumes that variances are equal in each population and that residuals (response variable in this case) are approximately normally distributed.
* As always, a statistically significant result does not necessarily mean an interesting result from a practical point of view: We need a measure of effect size.


Illustration
========================================================

![anova](./img/fig-anova.png)


Application
========================================================

Effect of different sugars on length of pea sections grown in tissue culture with auxin present. (<span class="showtooltip" title="Sokal R and Rohlf F (1995). Biometry, 3rd edition. WH Freeman and Company."><a href="">Sokal & Rohlf, 1995</a></span>)

<!-- html table generated in R 2.15.2 by xtable 1.7-1 package -->
<!-- Sun Oct 20 23:34:58 2013 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> ctrl </TH> <TH> X2G </TH> <TH> X2F </TH> <TH> X1G1F </TH> <TH> X2S </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD align="right">  75 </TD> <TD align="right">  57 </TD> <TD align="right">  58 </TD> <TD align="right">  58 </TD> <TD align="right">  62 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD align="right">  67 </TD> <TD align="right">  58 </TD> <TD align="right">  61 </TD> <TD align="right">  59 </TD> <TD align="right">  66 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD align="right">  70 </TD> <TD align="right">  60 </TD> <TD align="right">  56 </TD> <TD align="right">  58 </TD> <TD align="right">  65 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD align="right">  75 </TD> <TD align="right">  59 </TD> <TD align="right">  58 </TD> <TD align="right">  61 </TD> <TD align="right">  63 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD align="right">  65 </TD> <TD align="right">  62 </TD> <TD align="right">  57 </TD> <TD align="right">  57 </TD> <TD align="right">  64 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD align="right">  71 </TD> <TD align="right">  60 </TD> <TD align="right">  56 </TD> <TD align="right">  56 </TD> <TD align="right">  62 </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD align="right">  67 </TD> <TD align="right">  60 </TD> <TD align="right">  61 </TD> <TD align="right">  58 </TD> <TD align="right">  65 </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD align="right">  67 </TD> <TD align="right">  57 </TD> <TD align="right">  60 </TD> <TD align="right">  57 </TD> <TD align="right">  65 </TD> </TR>
  <TR> <TD align="right"> 9 </TD> <TD align="right">  76 </TD> <TD align="right">  59 </TD> <TD align="right">  57 </TD> <TD align="right">  57 </TD> <TD align="right">  62 </TD> </TR>
  <TR> <TD align="right"> 10 </TD> <TD align="right">  68 </TD> <TD align="right">  61 </TD> <TD align="right">  58 </TD> <TD align="right">  59 </TD> <TD align="right">  67 </TD> </TR>
   </TABLE>


Application (con't)
========================================================

* **Response variable**: length (in ocular units) of pea sections.
* **Explanatory variable**: treatment (control, 2% glucose, 2% fructose, 1% glucose + 1% fructose, 2% sucrose).


```r
head(peas, n=3)
```

```
  ctrl X2G X2F X1G1F X2S
1   75  57  58    58  62
2   67  58  61    59  66
3   70  60  56    58  65
```

```r
peas.melted <- melt(peas, value.name="length", 
                    variable.name="treatment")
head(peas.melted, n=3)
```

```
  treatment length
1      ctrl     75
2      ctrl     67
3      ctrl     70
```


Application (con't)
========================================================


```r
f <- function(x) c(mean=mean(x), sd=sd(x))
aggregate(length ~ treatment, data=peas.melted, f)
```

```
  treatment length.mean length.sd
1      ctrl      70.100     3.985
2       X2G      59.300     1.636
3       X2F      58.200     1.874
4     X1G1F      58.000     1.414
5       X2S      64.100     1.792
```

<img src="03-anova-figure/unnamed-chunk-9.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" style="display: block; margin: auto;" />



Application (con't)
========================================================


```r
mod <- aov(length ~ treatment, data=peas.melted)
summary(mod)
```

```
            Df Sum Sq Mean Sq F value  Pr(>F)
treatment    4   1077   269.3    49.4 6.7e-16
Residuals   45    246     5.5                
```


Two-way ANOVA
========================================================

Let $y_{ijk}$ be the $k\text{th}$ observation for level $i$ of factor $A$
($i=1,\dots,a$) and level $j$ of factor $B$ ($j=1,\dots,b$). The full model can be written as follows:

$$ y_{ijk} = \mu + \alpha_i + \beta_j + \gamma_{ij} + \varepsilon_{ijk}, $$

where $\mu$ is the overall mean, $\alpha_i$ ($\beta_j$) is the deviation of the $a$ ($b$) means from the overall mean,
$\gamma_{ij}$ is the deviation of the $A\times B$ treatments from $\mu$, and $\varepsilon_{ijk}\sim
{\cal N}(0,\sigma^2)$ is the residual term.

The $\alpha_i$ et $\beta_j$ are called **main effects**,
and $\gamma_{ij}$ is the **interaction effect**. 

Interaction between factors
========================================================

![anova](./img/fig-interaction.png)

References
========================================================

Chambers J and Hastie T (1992). _Statistical Models in S_.
Wadsworth \& Brooks. ISBN: 0534167649.

Sokal R and Rohlf F (1995). _Biometry_, 3rd edition. WH Freeman
and Company.

Wickham H (2011). "The Split-Apply-Combine Strategy for Data
Analysis." _Journal of Statistical Software_, *40*(1).

Wilkinson G and Rogers C (1973). "Symbolic description of
factorial models for analysis of variance." _Applied Statistics_,
*22*, pp. 392-399.

