Working with data
========================================================
author: Christophe Lalanne
date: October 8th, 2013
css: custom.css




Synopsis
========================================================
type: sub-section

The plural of anecdote is (not) data.  
<small>
<http://blog.revolutionanalytics.com/2011/04/the-plural-of-anecdote-is-data-after-all.html>
</small>

> What are data • How do we collect data • How do we store data • How to process data with R

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

- Simple random sampling: each individual from the population has the same probability of being selected; this is usually done **without replacement** (e.g., surveys, psychological experiment, clinical trials).
- Systematic random sampling, (two-stage) cluster sampling, stratified sampling, etc.

In the end, we must have a **random sample** of statistical units with single or multiple observations on each unit. With this sample, we usually aim at inferring some properties at the level of the population from which this 'representative' (<span class="showtooltip" title="Selz M (2013). La représentativité en statistiques, volume 8 series M\'ethodes et Savoirs. Publications de l'INED."><a href="">Selz, 2013</a></span>) sample was drawn.


How to store data
========================================================

Better to rely on **plain text files** (space, tab or comma-delimited) or **database** (SQL family) whenever possible: 
- easy access to data (in an OS agnostic way)
- availability of reliable query languages
- recording of each data step in text files
- easy storage and sharing of data

The last two points are part of what is called **reproducible research** (<span class="showtooltip" title="Peng R (2009). 'Reproducible Research and Biostatistics.' Biostatistics, 10(3), pp. 405-408."><a href="">Peng, 2009</a></span>).

Data processing
========================================================

- full sample single CSV file ([RFC4180](http://tools.ietf.org/html/rfc4180))
- binary data files (`.mat`, `.sav`, `.dta`)
- individual data files, possibly compressed (require globbing)

Data can also be served through different files, e.g. dual files like Nifti `.hdr`+`.img`, or PLINK `.bed`+`.bim` (require merging).

Text-based data file are generally easy to process with many text processing programs, e.g., sed, awk, Perl (<span class="showtooltip" title="Chambers J (2008). Software for Data Analysis. Programming with R. Springer."><a href="">Chambers, 2008</a></span>), but we will see that R offers nice facilities for that kind of stuff too.

A ready to use data set
========================================================

Observers rated relatedness of pairs of images of children that were either siblings or not on a 11-point scale. 

<!-- html table generated in R 2.15.2 by xtable 1.7-1 package -->
<!-- Tue Oct  8 07:03:41 2013 -->
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
<!-- Tue Oct  8 07:03:41 2013 -->
<TABLE border=1>
<TR> <TH> id </TH> <TH> centre </TH> <TH> sex </TH> <TH> age </TH> <TH> session </TH> <TH> recover </TH>  </TR>
  <TR> <TD align="right"> 1017 </TD> <TD align="right">   1 </TD> <TD align="right">   1 </TD> <TD> 23 </TD> <TD> 8 </TD> <TD align="right">   0 </TD> </TR>
  <TR> <TD align="right"> 1023 </TD> <TD align="right">   1 </TD> <TD align="right">  </TD> <TD> 126 </TD> <TD> 6 </TD> <TD align="right">   1 </TD> </TR>
  <TR> <TD align="right"> 2044 </TD> <TD align="right">   2 </TD> <TD align="right">   1 </TD> <TD> 24 </TD> <TD> -1 </TD> <TD align="right">   1 </TD> </TR>
  <TR> <TD align="right"> 2086 </TD> <TD align="right">   2 </TD> <TD align="right">   2 </TD> <TD> 27 </TD> <TD> ? </TD> <TD align="right">   0 </TD> </TR>
   </TABLE>


What does `recover` = 0 or `sex` = 1 mean? Are negative values allowed for `session`? Leading zeros in IDs and centre number are lost. We need a **data dictionary**.

    $ head -n 3 data/raw.csv
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

[R](http://www.r-project.org) is a statistical package for working with data (<span class="showtooltip" title="Ihaka R and Gentleman R (1996). 'R: A language for data analysis and graphics.' Journal of Computational and Graphical Statistics, 5(3), pp. 299-314."><a href="">Ihaka & Gentleman, 1996</a></span>; <span class="showtooltip" title="Venables W and Ripley B (2002). Modern Applied Statistics with S, 4th edition. Springer. ISBN 0-387-95457-0."><a href="">Venables & Ripley, 2002</a></span>). It features most of modern statistical tools, and convenient functions to import, manipulate and visualize even high-dimensional data sets. There is usually no need to switch to another program throughout project management. 

It is open-source (GPL licence), and it has a very active community of users ([r-help](https://stat.ethz.ch/mailman/listinfo/r-help), [Stack Overflow](http://stackoverflow.com/questions/tagged/r)). 

Moreover, some mathematical or statistical packages (e.g., Mathematica, SPSS) feature built-in plugins to interact with R. It can also be used with Python ([rpy2](http://rpy.sourceforge.net/rpy2.html)). 

R is not a cliquodrome
========================================================

R is interactive ([read-eval-print loop](http://bit.ly/1axiCiM)) and can be used as a simple calculator:

```r
r <- 5
2 * pi * r^2
```

```
[1] 157.1
```


Basically, R interprets commands that are sent by the user, and returns an output (which might be nothing). 
The syntax of the language is close to that of any programming language: we process data associated to **variables** with the help of dedicated **commands** (functions).

Note that many additional **packages** are available on <http://cran.r-project.org>, and we will use few of them.

RStudio
========================================================

[RStudio](http://www.rstudio.com/) offers a clever, non-intrusive, interface to R, including specific panels for the R console, history, workspace, plots, help, packages management. 

It now features project management, version control, and it has built-in support for automatic reporting through the Markdown language.

- John Verzani (2011). [*Getting started with RStudio*](http://shop.oreilly.com/product/0636920021278.do). O'Reilly Media.
- Mark P.J. van der Loo, Edwin de Jonge (2012). [*Learning RStudio for R Statistical Computing*](http://www.packtpub.com/learning-rstudio-for-r-statistical-computing/book). Packt Publishing.


Interacting with R
========================================================

Here is a sample session. 

First, we **load some data** into R:

```r
bs <- read.table(file = "./data/brain_size.dat", 
                 header = TRUE, na.strings = ".")
head(bs, n = 2)
```

```
  Gender FSIQ VIQ PIQ Weight Height MRI_Count
1 Female  133 132 124    118   64.5    816932
2   Male  140 150 124     NA   72.5   1001121
```


Rectangular data set
========================================================

Here is how the data would look under a spreedsheat program:

![excel](./img/brain_size.png)

Variables are arranged in columns, while each line represents an individual (i.e., a statistical unit).

Querying data properties with R
========================================================

Let's look at some of the properties of the imported data set:

```r
dim(bs)
```

```
[1] 40  7
```

```r
names(bs)[1:4]
```

```
[1] "Gender" "FSIQ"   "VIQ"    "PIQ"   
```

There are 40 individuals and 7 variables. Variables numbered 1 to 4 are: gender, full scale IQ, verbal IQ, and performance IQ.

Querying data properties with R
========================================================
title: false

Now, here is how observed values for each variable are represented internally:

```r
str(bs, vec.len = 1)
```

```
'data.frame':	40 obs. of  7 variables:
 $ Gender   : Factor w/ 2 levels "Female","Male": 1 2 ...
 $ FSIQ     : int  133 140 ...
 $ VIQ      : int  132 150 ...
 $ PIQ      : int  124 124 ...
 $ Weight   : int  118 NA ...
 $ Height   : num  64.5 72.5 ...
 $ MRI_Count: int  816932 1001121 ...
```


Variables are either **numeric** (continuous or discrete) or **categorical** (with ordered or unordered levels). 

Note that there exist other representations for working with dates, censored variables, or strings.


Testing, organizing, versioning
========================================================

RStudio greatly facilitates the data analysis workflow: Rather than writing directly R commands in the console, write them in an R script and run the code from the editor.

![rstudio](./img/01-intro.png)


References
========================================================

Chambers J (2008). _Software for Data Analysis. Programming with
R_. Springer.

Ihaka R and Gentleman R (1996). "R: A language for data analysis
and graphics." _Journal of Computational and Graphical
Statistics_, *5*(3), pp. 299-314.

Peng R (2009). "Reproducible Research and Biostatistics."
_Biostatistics_, *10*(3), pp. 405-408.

Selz M (2013). _La représentativité en statistiques_, volume 8
series M\'ethodes et Savoirs. Publications de l'INED.

Venables W and Ripley B (2002). _Modern Applied Statistics with
S_, 4th edition. Springer. ISBN 0-387-95457-0.

