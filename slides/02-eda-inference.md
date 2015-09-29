Data analysis and statistical inference
========================================================
author: Christophe Lalanne
date: October 6, 2015
css: custom.css





Synopsis
========================================================
type: sub-section

To call in the statistician after the experiment is done may be no more than asking him to perform a post-mortem examination: he may be able to say what the experiment died of. Ronald Fisher (1890-1962)
      

> Descriptive statistics • Exploratory Data Analysis • Statistical inference • Statistical models • Student t test

**Lectures:** OpenIntro Statistics, 1.3-1.7, 4.1, 4.3, 4.6, 5.4.

Statistics are and statistics is
========================================================

"Statisticians are applied philosophers. Philosophers argue how many angels can dance on the head of a needle; statisticians *count* them. (...) We can predict nothing with certainty but we can predict how uncertain our predictions will be, on average that is. Statistics is the science that tells us how."  Senn (2003)

* Providing appropriate (meaningful and robust) numerical and visual summary of the data.
* Summarizing associations, spotting unusual observations.
* Modeling and testing, while reporting honest estimates of uncertainty for model parameters.

Basic summary statistics
========================================================

Descriptive statistics are a fundamental step before any attempt at modeling. It is very important to summarize the distribution of each variable (univariate approach) and pairwise relationships between variables (bivariate approach).

* Central tendency: mean, median, mode
* Dispersion: standard deviation, inter-quartile range, range
* Distribution: histogram (or density estimate), quantile plot, cumulative distribution function, table of relative frequencies
* Association: correlation (linear or rank-based), odds-ratio, standardized mean difference

Always look at the data before
========================================================

**Anscombe's Quartet**  
Pearson's correlations:
<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Mon Oct 13 12:01:58 2014 -->
<table border=1>
<tr> <th> x1-y1 </th> <th> x2-y2 </th> <th> x3-y3 </th> <th> x4-y4 </th>  </tr>
  <tr> <td align="right"> 0.816 </td> <td align="right"> 0.816 </td> <td align="right"> 0.816 </td> <td align="right"> 0.817 </td> </tr>
   </table>

Pearson's correlation, as a measure of linear association, is meaningful in case (a) only. The assumption of linearity must be carefully checked.

---

![plot of chunk anscombe](02-eda-inference-figure/anscombe.png) 


Exploratory Data Analysis
========================================================

EDA is about exploring data for patterns and relationships without requiring prior hypotheses and using resistant methods (Tukey, 1977). This iterative approach makes heavy use of graphical methods to suggest hypotheses and check model assumptions. 

The main ideas down to: (Hoaglin, Mosteller, and Tukey, 1985)

- resistance (unheeded local misfit)
- residuals (data minus model fit)
- re-expression (data transformation)
- revelation (informative display)


Hypothesis testing
========================================================

We focus on a **single hypothesis** (null hypothesis) and calculate the probability that the data would have been observed if the null hypothesis were true. If this probability is small enough (usually, [0.05](http://www.jerrydallal.com/LHSP/p05.htm)), then we "reject" the null. The statistical power associated with such a test is the probability that if the null were actually false we would reject it (given the same data).

In sum, the idea is to confront a single hypothesis with the data, through a designed experiment, with falsification as the only "truth." This approach follows from Popper's philosophical development and was implemented by Fisher, and Neyman & Pearson's NHST framework. See Hilborn and Mangel (1997) for more discussion.


Alternative paradigms
========================================================

- **Likelihood approach:** Use the data to arbitrate between two models. Given the data and a mathematical formulation of two competing models, we can ask, "How likely are the data, given the model?"
- **Bayesian approach:** Use external information that allows to judge *a priori* which model is more likely to be true, i.e. use a prior probability that can be "updated" to yield a posterior probability, given the data. See Ashby (2006) for a review in biomedical research, and [A Good P–value is Hard to Find: Why I’m a Bayesian When Time Allows](http://biostat.mc.vanderbilt.edu/wiki/pub/Main/FHHandouts/whyBayesian.pdf) (FE Harrell Jr, 2013).


We would rather like to know $P(H_0\mid\text{data})$ than $P(|S|>|s|)$ under the null–even if '[the earth is round (p < .05)](http://mark.reid.name/blog/the-earth-is-round.html).'


A motivating example
========================================================

<small>"Four of these dishes were filled with a conventional nutrient solution and four held an experimental 'life-extending' solution to which vitamin E had been added. I waited three weeks with fingers crossed that there was no contamination of the cell cultures, but at the end of this test period three dishes of each type had survived. My technician and I transplanted the cells, let them grow for 24 hours in contact with a radioactive label, and then fixed and stained them before covering them with a photographic emulsion. Ten days passed and we were ready to examine the autoradiographs. Two years had elapsed since I first envisioned this experiment and now the results were in: I had the six numbers I needed. 'I've lost the labels,' my technician said as she handed me the results. This was a dire situation. Without the labels, I had no way of knowing which cell cultures had been treated with vitamin E and which had not." (Good, 2005) </small>

    121, 118, 110, 34, 12, 22
    
The process of hypothesis testing
========================================================
    
1. Define the null hypothesis ($H_0$), its alternative, and risks associated to a decision.
2. Choose a test statistic, $S$.
3. Compute the value of $S$.
4. Define the sampling distribution of $S$ under $H_0$.
5. Conclude based on this distribution.

Let $H_0$: 'vitamin E does not impact culture growth.' Under the null, the two labels (treated, not treated) do not bring any information about the response. Let us consider the total number of cells in each batch.

A permutation testing approach
========================================================

There are ${6 \choose 3}$ to arrange 3 elements (`X1` to `X3`) taken among a total of 6 elements. Let $s$ be the sum of their values. The observed sum `S=121+118+110=349`. How many times do we observe such an extreme statistic? 
<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Mon Oct 13 12:01:58 2014 -->
<table border=1>
<tr> <th>  </th> <th> X1 </th> <th> X2 </th> <th> X3 </th> <th> s </th>  </tr>
  <tr> <td align="right"> 1 </td> <td align="right"> 121.00 </td> <td align="right"> 118.00 </td> <td align="right"> 110.00 </td> <td align="right"> 349.00 </td> </tr>
  <tr> <td align="right"> 2 </td> <td align="right"> 121.00 </td> <td align="right"> 118.00 </td> <td align="right"> 34.00 </td> <td align="right"> 273.00 </td> </tr>
  <tr> <td align="right"> 3 </td> <td align="right"> 121.00 </td> <td align="right"> 118.00 </td> <td align="right"> 12.00 </td> <td align="right"> 251.00 </td> </tr>
  <tr> <td align="right"> 18 </td> <td align="right"> 110.00 </td> <td align="right"> 34.00 </td> <td align="right"> 22.00 </td> <td align="right"> 166.00 </td> </tr>
  <tr> <td align="right"> 19 </td> <td align="right"> 110.00 </td> <td align="right"> 12.00 </td> <td align="right"> 22.00 </td> <td align="right"> 144.00 </td> </tr>
  <tr> <td align="right"> 20 </td> <td align="right"> 34.00 </td> <td align="right"> 12.00 </td> <td align="right"> 22.00 </td> <td align="right"> 68.00 </td> </tr>
   </table>

Comparing two means
========================================================

Student's t-test can be used to compare two means estimated from small to moderate sized samples. The idea is to refer the test statistic (parameter estimate divided by its standard error, often times assuming a pooled variance estimated from the whole sample) to a T distribution with $\nu=n_1+n_2-2$ degrees of freedom.
By default, **R's `t.test()` does not assume equality of variance** when performing this test and makes use of Welch-Satterthwaite correction ([Behrens-Fisher problem](http://en.wikipedia.org/wiki/Behrens%E2%80%93Fisher_problem)).


```
function (x, y = NULL, alternative = c("two.sided", "less", "greater"), 
    mu = 0, paired = FALSE, var.equal = FALSE, conf.level = 0.95, 
    ...) 
NULL
```

The case of paired samples
========================================================

Effect of two soporific drugs (1: D. hyoscyamine hydrobromide vs. 2: L. hyoscyamine hydrobromide) measured as increase in hours of sleep compared to control on 10 patients. (William Sealy Gosset, 1876-1937, *nom de plume* Student).


```r
data(sleep)
help(sleep)
head(sleep, n=3)
```

```
  extra group ID
1   0.7     1  1
2  -1.6     1  2
3  -0.2     1  3
```

```r
aggregate(extra ~ group, data=sleep, mean)
```

```
  group extra
1     1  0.75
2     2  2.33
```


The case of paired samples (con't)
========================================================


```r
t.test(extra ~ group, data=sleep, paired=TRUE)
```

```

	Paired t-test

data:  extra by group
t = -4.062, df = 9, p-value = 0.002833
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -2.4599 -0.7001
sample estimates:
mean of the differences 
                  -1.58 
```

<img src="02-eda-inference-figure/unnamed-chunk-6.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" style="display: block; margin: auto;" />

The case of paired samples (con't)
========================================================

<img src="02-eda-inference-figure/unnamed-chunk-7.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" style="display: block; margin: auto;" />

---

<img src="02-eda-inference-figure/unnamed-chunk-8.png" title="plot of chunk unnamed-chunk-8" alt="plot of chunk unnamed-chunk-8" style="display: block; margin: auto;" />

Student's t vs. Gaussian distribution
========================================================

As $n$ increases ($\nu\propto n$), the T distribution approaches that of the standard Normal. 
For small $n$, the corresponding T distribution exhibits thicker tails (accounting for unusual but expected large results in small samples).

---

![plot of chunk unnamed-chunk-9](02-eda-inference-figure/unnamed-chunk-9.png) 

One-sided vs. two-sided tests
========================================================


![plot of chunk unnamed-chunk-10](02-eda-inference-figure/unnamed-chunk-10-1.png) 

---

$H_0: \mu_1=\mu_2$, or equivalently $\mu_1-\mu_2=0$ (no difference in population means, i.e. the two samples come from the same population) vs. $H_1: \mu_1\neq\mu_2$ (differences can be in either direction) or $H_1: \mu_1\lessgtr\mu_2$ 

Comparing two proportions
========================================================

We tossed a coin 10 times and observed the following outcomes: `TTTTHHHTHT`. Suppose that the events are all independent. Some questions we may want to ask:

- Is this is a fair coin?
- What is the probability of observing a first Head at the 5th trial in
this particular sequence, assuming a fair dice?
- If I repeat the same experiment, what’s the likely range for observing the same number of Heads?

These are very different questions which call for a **decision test**, simple **probability calculus**, and a **confidence interval** for our estimate. In all cases, however, we  need to rely on a known statistical distribution.

Comparing two proportions (con't)
========================================================

To answer the first question, the statistician would say:

"Assuming a fair coin and independent events, the expected number of Heads is $10 × 0.5 = 5$. The observed frequency of Heads is $4/10 = 0.4$.  
We can formulate our null as $H_0: p=0.5$, and use a binomial test to test whether the observed frequency significantly differs from the expected frequency, considering a risk $\alpha = 5$%.  
The results suggest that this series of H and T’s is not incompatible with the hypothesis of equal probability."

Comparing two proportions (con't)
========================================================


```r
binom.test(x=4, n=10)
```

```

	Exact binomial test

data:  4 and 10
number of successes = 4, number of trials = 10, p-value = 0.7539
alternative hypothesis: true probability of success is not equal to 0.5
95 percent confidence interval:
 0.1216 0.7376
sample estimates:
probability of success 
                   0.4 
```

Compare to the following test which relies on a Gaussian approximation:

```r
prop.test(x=4, n=10)
```


References
========================================================

<small>
[1] D. Ashby. "Bayesian statistics in medicine: a 25 year review".
In: _Statistics in Medicine_ 25.21 (2006), pp. 3589-3631.

[2] P. Good. _Permutation, Parametric and Bootstrap Tests of
Hypothesis_. 3rd. Springer, 2005.

[3] R. Hilborn and M. Mangel. _The ecological detective.
Confronting models with data_. Princeton University Press, 1997.

[4] D. Hoaglin, F. Mosteller and K. Tukey. _Understanding Robust
and Exploratory Data Analysis_. New York: Wiley, 1985.

[5] S. Senn. _Dicing with death. Chance, Risk and Health_.
Cambridge University Press, 2003.

[6] J. Tukey. _Exploratory Data Analysis_. Addison-Wesley, 1977.
</small>
