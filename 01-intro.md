Working with data
========================================================
author: Christophe Lalanne
date: October 8th, 2013





========================================================
type: sub-section

> The plural of anecdote is (not) data.

<small>
<http://blog.revolutionanalytics.com/2011/04/the-plural-of-anecdote-is-data-after-all.html>
</small>

The world of data
========================================================

Data come in various forms, and they are gathered from many different sources:

- personal daily records
- observational studies
- controlled experiments
- historical archives
- national surveys, etc.

They almost always require preprocessing, cleaning, and recoding---and this often amounts to 60% of the whole statistical project.

How to collect data
========================================================

- **simple random sampling:** each individual from the population has the same probability of being selected; this is usually done **without replacement** (e.g., surveys, psychological experiment, clinical trials).
- systematic random sampling, (two-stage) cluster sampling, stratified sampling, etc.

In the end, we must have a random sample of statistical units with single or multiple observations on each unit. With this sample, we usually aim at inferring some properties at the level of the population from which this representative sample was drawn.


How to store data
========================================================

Better to rely on **plain text files** (space, tab or comma-delimited) or **database** (SQL family) whenever possible: 
- easy access to data (in an OS agnostic way)
- availability of reliable query languages
- recording of each data step in text files
- easy storage and sharing of data

The last two points are part of what is called **reproducible research**.

Data format
========================================================

- full sample single CSV file
- binary data files (`.mat`, `.sav`, `.dta`)
- individual data files, possibly compressed (globbing)

Data can also be served through different files, e.g. dual files (e.g., Nifti `.hdr`+`.img`, or PLINK `.bed`+`.bim`).

A ready to use data set
========================================================

Observers rated relatedness of pairs of images of children that were either siblings or not on a 11-point scale. 

<!-- html table generated in R 2.15.2 by xtable 1.7-1 package -->
<!-- Tue Sep 10 16:15:28 2013 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> SimRating </TH> <TH> sibs </TH> <TH> agediff </TH> <TH> gendiff </TH> <TH> Obs </TH> <TH> Image </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD align="right"> 10.00 </TD> <TD> 1 </TD> <TD align="right"> 29.00 </TD> <TD> diff </TD> <TD> S1 </TD> <TD> Im1 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD align="right"> 10.00 </TD> <TD> 1 </TD> <TD align="right"> 37.00 </TD> <TD> diff </TD> <TD> S1 </TD> <TD> Im2 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD align="right"> 6.00 </TD> <TD> 1 </TD> <TD align="right"> 47.00 </TD> <TD> diff </TD> <TD> S1 </TD> <TD> Im3 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD align="right"> 1.00 </TD> <TD> 1 </TD> <TD align="right"> 44.00 </TD> <TD> diff </TD> <TD> S1 </TD> <TD> Im4 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD align="right"> 10.00 </TD> <TD> 1 </TD> <TD align="right"> 25.00 </TD> <TD> diff </TD> <TD> S1 </TD> <TD> Im5 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD align="right"> 9.00 </TD> <TD> 1 </TD> <TD align="right"> 0.00 </TD> <TD> same </TD> <TD> S1 </TD> <TD> Im6 </TD> </TR>
   </TABLE>


<small>Maloney, L. T., and Dal Martello, M. F. (2006). Kin recognition and the perceived facial similarity of children. Journal of Vision, 6(10):4, 1047–1056, http://journalofvision.org/6/10/4/.</small>

Real-life data
========================================================

Raw data generally require [**data cleansing**](http://bit.ly/19BqCen).

<!-- html table generated in R 2.15.2 by xtable 1.7-1 package -->
<!-- Tue Sep 10 16:15:28 2013 -->
<TABLE border=1>
<TR> <TH> id </TH> <TH> centre </TH> <TH> sex </TH> <TH> age </TH> <TH> session </TH> <TH> recover </TH>  </TR>
  <TR> <TD align="right"> 1017 </TD> <TD align="right">   1 </TD> <TD align="right">   1 </TD> <TD> 23 </TD> <TD> 8 </TD> <TD align="right">   0 </TD> </TR>
  <TR> <TD align="right"> 1023 </TD> <TD align="right">   1 </TD> <TD align="right">  </TD> <TD> 126 </TD> <TD> 6 </TD> <TD align="right">   1 </TD> </TR>
  <TR> <TD align="right"> 2044 </TD> <TD align="right">   2 </TD> <TD align="right">   1 </TD> <TD> 24 </TD> <TD> -1 </TD> <TD align="right">   1 </TD> </TR>
  <TR> <TD align="right"> 2086 </TD> <TD align="right">   2 </TD> <TD align="right">   2 </TD> <TD> 27 </TD> <TD> ? </TD> <TD align="right">   0 </TD> </TR>
   </TABLE>


What does `recover` = 0 mean? Are negative values allowed for `session`? Leading zeros in IDs are lost.

    id,centre,sex,age,session,recover
    ,,,,years,
    01017,01,1,23,8,0

Data analysis as an iterative process
========================================================

![](./img/fig-repl_stats.png)
***
- importing
- manipulating
- plotting
- transforming
- aggregating
- summarizing
- modelling
- reporting


Getting started with R
========================================================

[R](http://www.r-project.org) is a statistical package for working with data (<span class="showtooltip" title="Ihaka R and Gentleman R (1996). 'R: A language for data analysis and graphics.' Journal of Computational and Graphical Statistics, 5(3), pp. 299-314."><a href="">Ihaka & Gentleman, 1996</a></span>; <span class="showtooltip" title="Venables W and Ripley B (2002). Modern Applied Statistics with S, 4ème edition. Springer. ISBN 0-387-95457-0."><a href="">Venables & Ripley, 2002</a></span>). It features most of modern statistical tools, and convenient functions to import, manipulate and visualize even high-dimensional data sets. There is usually no need to switch to another program throughout project management. 

It is open-source (GPL licence), and it has a very active community of users ([r-help](https://stat.ethz.ch/mailman/listinfo/r-help), [Stack Overflow](http://stackoverflow.com/questions/tagged/r)). 

Moreover, some mathematical or statistical packages (e.g., Mathematica, SPSS) feature built-in plugins to interact with R. It can also be used with Python ([rpy2](http://rpy.sourceforge.net/rpy2.html)). 

This is not a cliquodrome
========================================================

R is interactive ([read-eval-print loop](http://bit.ly/1axiCiM)) and can be used as a simple calculator, but there is no single point-and-click UI:

```r
r <- 5
2*pi*r^2
```

```
[1] 157.1
```


Basically, R interprets commands that are sent by the user, and returns an output (which might be nothing). 

Many additional **packages** are available on <http://cran.r-project.org>, but we will limit ourselves to the core facilities.

RStudio
========================================================

[RStudio](http://www.rstudio.com/) offers a clever, non-intrusive, interface to R, including specific panels for the R console, history, workspace, plots, help, packages management. 

It now features project management, version control, and it has built-in support for automatic reporting through the Markdown language.

- John Verzani (2011). [*Getting started with RStudio*](http://shop.oreilly.com/product/0636920021278.do). O'Reilly Media.
- Mark P.J. van der Loo, Edwin de Jonge (2012). [*Learning RStudio for R Statistical Computing*](http://www.packtpub.com/learning-rstudio-for-r-statistical-computing/book). Packt Publishing.


Interacting with R
========================================================

The syntax of the language is close to that of any programming language: we process data associated to **variables** with the help of dedicated **commands** (functions, in R parlance).






Compute the frequency of head
========================================================
type: prompt

Let's say we are rolling a fair dice several times. Heads are codes as 1, tails as 0. 

Given the following sequence, what is the number of zeros?

```r
x <- sample(c(0,1), 10, replace=TRUE)
print(x)
```

```
 [1] 1 0 0 1 0 0 0 1 1 0
```


References
========================================================

Ihaka R and Gentleman R (1996). "R: A language for data analysis
and graphics." _Journal of Computational and Graphical
Statistics_, *5*(3), pp. 299-314.

Venables W and Ripley B (2002). _Modern Applied Statistics with
S_, 4ème edition. Springer. ISBN 0-387-95457-0.

