Lab 1 : Getting started with R
------------------------------



This document is written using R Markdown. The source code is available in [01-intro-lab.R](01-intro-lab.R).

#### Learning objectives

> * Create and manipulate vectors (numeric and factor)
> * Compute basic summary statistics
> * Manipulate rectangular data structure (data frames)
> * Interact with external data sets

## Basic data management

There are several types of `objects' in R. For the time being, we will
mainly focus on **vectors** and **data frames**.


### Working with vectors
Suppose that we recorded the following reaction times in a simple
psychophysical experiment: (<a href="http://cran.r-project.org/web/packages/retimes/">Heathcote, 1996</a>)

    474.688  506.445  524.081  530.672  530.869
    566.984  582.311  582.940  603.574  792.358

We can represent this series of measurements as follows:

```r
x <- c(474.688, 506.445, 524.081, 530.672, 530.869, 566.984, 582.311, 582.94, 603.574, 
    792.358)
```


Note that the decimal point follows English notation. It is also [recommended](http://stackoverflow.com/q/1741820/420055) to use `<-` instead of `=` for variable assignment.
Now, to display the values, we can simply type `x` at the R prompt:

```r
x
```

```
##  [1] 474.7 506.4 524.1 530.7 530.9 567.0 582.3 582.9 603.6 792.4
```


We can access the first or third element of `x` (i.e., the first observation) by using the corresponding index position (integer starting at 1) enclosed in square brackets:

```r
x[1]
```

```
## [1] 474.7
```

```r
x[3]
```

```
## [1] 524.1
```


We could also display the first three observations using range notation or by giving explicit values, e.g.

```r
x[1:3]
```

```
## [1] 474.7 506.4 524.1
```

```r
x[c(1, 2, 3)]
```

```
## [1] 474.7 506.4 524.1
```

The `c()` (concatenate) command tells R to group together values in a vector. We call such operation **indexation**. When values correspond to different statistical units, this allow to perform individual selection.

It is also possible to use **logical filters** to select part of a variable. For example, if we want to keep only values that are less or equal to 600, we would use:

```r
x[x <= 600]
```

```
## [1] 474.7 506.4 524.1 530.7 530.9 567.0 582.3 582.9
```

This instruction will return those values of `x` that fulfill the criterion `x less or equal to 600`. If we are interested in returning the position (index) of these values in `x`, we can use

```r
which(x[x <= 600])
```

```
## Error: l'argument 'which' doit être de type logique
```


We can check that there are 10 observations in total, and what are the minimum and maximum values of `x`, for instance, using built-in R functions:

```r
length(x)
```

```
## [1] 10
```

```r
min(x)
```

```
## [1] 474.7
```

```r
max(x)
```

```
## [1] 792.4
```

The latter can be grouped together using `c()` as seen before, e.g.

```r
c(min(x), max(x))
```

```
## [1] 474.7 792.4
```

or, in shorter form, 

```r
range(x)
```

since the `range()` function returns the minimum and maximum values of a list of numbers. 

Moreover, we can save the above results in another variable, say, `res`:

```r
res <- c(min(x), max(x))
```

To display values stored in `res`, we would just type the name of the variable at R prompt or use `print(res)`. However, in interactive mode, we rarely need to use a `print()` statement:

```r
res
print(res)
```


R has a lot of built-in commands, including functions for basic data transformation and arithmetic operations.

```r
x[1] + x[2]
```

```
## [1] 981.1
```

or equivalently

```r
sum(x[1:2])
```

To convert values stored in `x` to their log counterpart (by default, natural logarithm), we would use:

```r
log(x)
```

```
##  [1] 6.163 6.227 6.262 6.274 6.275 6.340 6.367 6.368 6.403 6.675
```

The base for the logarithm can be changed by using the named parameter `base=` when calling the function, e.g. `log(100, base=10)`.

In most cases, it is useless to write an explicit loop when we can benefit from R vectorized operations. (In the following example the `print()` statement is mandatory.)

```r
for (i in 1:10) print(log(x[i]))
```

```
## [1] 6.163
## [1] 6.227
## [1] 6.262
## [1] 6.274
## [1] 6.275
## [1] 6.34
## [1] 6.367
## [1] 6.368
## [1] 6.403
## [1] 6.675
```


Variables live in R workspace, and they can be updated at any time. Using a statement like

```r
x <- log(x)
```

would replace all values of `x` by their log, and old values would be lost.

**Missing values** are represented by the symbol `NA` (not available). 


```r
x[5]
```

```
## [1] 530.9
```

```r
x[5] <- NA
x
```

```
##  [1] 474.7 506.4 524.1 530.7    NA 567.0 582.3 582.9 603.6 792.4
```


We can check at any time what variables are available in R workspace with `ls()`: (You can safely ignore the `bib` variable.)

```r
ls()
```

```
## [1] "bib" "i"   "res" "x"
```

Don't forget the parentheses! To delete a variable, we can use `rm(x)`, for example.

#### Your turn

> 1. Display the last two observations of `x`.
> 2. Compute the minimum and maximum values of the updated variable `x`. See `help(min)` or `help(max)`.
> 3. How would you replace the 5th observation (set to missing) with the mean computed from the remaining observations. See `help(mean)`.


### Categorical variables and factors

In the preceding section, we have discussed the representation of numerical values in R. Categorical variables are best expressed as **factors** in R, rather than simple strings.

In the following example, we generate 10 random values (`male` or `female`) for a variable `gender`. Sampling is done with replacement.

```r
gender <- sample(c("male", "female"), size = 10, replace = TRUE)
gender
```

```
##  [1] "female" "female" "female" "male"   "female" "female" "female" "male"  
##  [9] "female" "female"
```

```r
str(gender)
```

```
##  chr [1:10] "female" "female" "female" "male" "female" "female" ...
```


As `gender` is just a vector of strings, we will convert it to a factor using the `factor()`: R will now associate levels to unique values found in `gender`.

```r
gender <- factor(gender)
str(gender)
```

```
##  Factor w/ 2 levels "female","male": 1 1 1 2 1 1 1 2 1 1
```


We can tabulate `gender`'s levels using `table()`:

```r
table(gender)
```

```
## gender
## female   male 
##      8      2
```


Here is another example where we start with numeric codes, and then associate labels to each code.

```r
cond <- c(1, 2, 1, 2, 2, 2, 1, 1, 2)
table(cond)
```

```
## cond
## 1 2 
## 4 5
```

```r
cond <- factor(cond, levels = c(1, 2), labels = c("A", "B"))
table(cond)
```

```
## cond
## A B 
## 4 5
```


To sum up, factors are represented as numerical codes, but it is always a good idea to associate labels to them.


### More complex data structure

**Data frames** are special R objects that can hold mixed data type (numeric and factor). This is a convenient placeholder for rectangular data sets as we will see later during the course.

Suppose you are now given two series of RTs, which were collected in two separate sessions on the same 10 subjects: (example from `help(timefit, package=retimes)`)

```r
x1 <- c(451.536, 958.612, 563.538, 505.735, 1266.825, 860.663, 457.707, 268.679, 
    587.303, 669.594)
x2 <- c(532.474, 525.185, 1499.471, 480.732, 631.752, 672.419, 322.341, 571.356, 
    428.832, 680.848)
```


It is easy to manipulate these two vectors separately. To compute the mean in each condition, we would use

```r
mean(x1)
```

```
## [1] 659
```

```r
mean(x2)
```

```
## [1] 634.5
```


Likewise, to get reaction times for the first individual we would write

```r
x1[1]
```

```
## [1] 451.5
```

```r
x2[1]
```

```
## [1] 532.5
```


However, a more elegant way to represent such data is to make it explicit that data are ordered and that each pair of values correspond to the same subject. A first attempt would be to simply create a 2-column matrix, like this

```r
x12 <- cbind(x1, x2)
head(x12, n = 3)  # or x12[1:3,]
```

```
##         x1     x2
## [1,] 451.5  532.5
## [2,] 958.6  525.2
## [3,] 563.5 1499.5
```


In this case, line numbers (row names in R parlance) would help to identify each subject. However, it would be more handy to create a variable holding subjects' ID.


```r
id <- paste("id", 1:10, sep = "")
id
```

```
##  [1] "id1"  "id2"  "id3"  "id4"  "id5"  "id6"  "id7"  "id8"  "id9"  "id10"
```

```r
d <- data.frame(id, x1, x2)
head(d)
```

```
##    id     x1     x2
## 1 id1  451.5  532.5
## 2 id2  958.6  525.2
## 3 id3  563.5 1499.5
## 4 id4  505.7  480.7
## 5 id5 1266.8  631.8
## 6 id6  860.7  672.4
```


#### Your turn

> 1. Display the second RT for the 8th subject.
> 2. Compute the range of observed values for the first session (`x1`).
> 3. Check whether all individual values are greater in the second session, compared to the first session.

Here is an alternate way for representing the same data set, this time using two variables to code for subjects and condition number, and one variable holding associated RTs. Note that we will use an external package that should be installed first in R directory (this is done automatically by the system, though).

```r
if (!require(reshape2)) install.packages("reshape2")
```

```
## Loading required package: reshape2
```

```r
dm <- melt(d)
```

```
## Using id as id variables
```

```r
head(dm)
```

```
##    id variable  value
## 1 id1       x1  451.5
## 2 id2       x1  958.6
## 3 id3       x1  563.5
## 4 id4       x1  505.7
## 5 id5       x1 1266.8
## 6 id6       x1  860.7
```


Note that if the package is already installed on your system, you can simply type

```r
library(reshape2)
```


Our data frame now has 20 lines, instead of 10 (`d`).

```r
summary(dm)
```

```
##        id    variable     value     
##  id1    :2   x1:10    Min.   : 269  
##  id10   :2   x2:10    1st Qu.: 475  
##  id2    :2            Median : 567  
##  id3    :2            Mean   : 647  
##  id4    :2            3rd Qu.: 674  
##  id5    :2            Max.   :1500  
##  (Other):8
```

```r
str(dm)
```

```
## 'data.frame':	20 obs. of  3 variables:
##  $ id      : Factor w/ 10 levels "id1","id10","id2",..: 1 3 4 5 6 7 8 9 10 2 ...
##  $ variable: Factor w/ 2 levels "x1","x2": 1 1 1 1 1 1 1 1 1 1 ...
##  $ value   : num  452 959 564 506 1267 ...
```


We can access any variable by using the name of the data frame, followed by the name of the variable as follows:

```r
dm$variable
```

```
##  [1] x1 x1 x1 x1 x1 x1 x1 x1 x1 x1 x2 x2 x2 x2 x2 x2 x2 x2 x2 x2
## Levels: x1 x2
```

The `$` operator is used to select a specific variable in a data frame, hence the need to have variables names.

Among other things, it is now possible to index values of the response variable depending on the values taken by other variables, like in a dictionnary (key-value). E.g., 

```r
dm$value[dm$variable == "x1"]
```

```
##  [1]  451.5  958.6  563.5  505.7 1266.8  860.7  457.7  268.7  587.3  669.6
```

or

```r
dm$variable[dm$value > 567]  # dm$variable[dm$value > median(dm$variable)]
```

```
##  [1] x1 x1 x1 x1 x1 x2 x2 x2 x2 x2
## Levels: x1 x2
```


Finally, should we want to update variable names, we could use:

```r
names(dm) <- c("subject", "condition", "RT")
head(dm, n = 3)
```

```
##   subject condition    RT
## 1     id1        x1 451.5
## 2     id2        x1 958.6
## 3     id3        x1 563.5
```


#### Your turn

> 1. There is a 'slight' problem with the way subjects' ID were handled. Can you fix it? See `help(factor)` and the `ordered=` parameter.
> 2. Display all observed values for the second subject.
> 3. Compute the range of observed values in the second session.

## Read-write operations

R has a built-in data format to save data files. 

```r
save(dm, file = "data_lab1.rda")
```

We can also use the `.RData` extension. To load data saved as RData files, we can use `load()`. The full pathname should be given to this command. Otherwise, we might want to change our current working directory (`setwd()`, or `Session > Set Working Directory > Choose Directory` in RStudio).

```r
load("data_lab.rda")
```

```
## Warning: impossible d'ouvrir le fichier compressé 'data_lab.rda', cause
## probable : 'No such file or directory'
```

```
## Error: impossible d'ouvrir la connexion
```


To save data in CSV format, we will replace `save()` by `write.csv()`. The default settings for this command correspond to English conventions (dot as decimal separator, comma as record separator). A localized version (French) is available with `read.csv2()`.

```r
write.csv(dm, file = "data_lab1.csv")
dir(pattern = ".csv")
```

```
## [1] "data_lab1.csv"
```


To read a CSV file, we just replace `write.csv()` with `read.csv()`.

```r
rm(dm)  # clean up the workspace
dm <- read.csv("data_lab1.csv")
ls()
```

```
##  [1] "bib"    "cond"   "d"      "dm"     "gender" "i"      "id"     "res"   
##  [9] "x"      "x1"     "x12"    "x2"
```


More generally, the `read.table()` command can be used to process a large majority of data files (tab or space delimited files, specific codes for missing values, etc.). See `help(read.table)` for more information.

------

## Application 1

Here are the number of words recalled by 5 subjects. Factor levels are given as: Neg, Neu, Pos (http://personality-project.org/).

    Jim, 32, 15, 45
    Victor, 30, 13, 40
    Faye, 26, 12, 42
    Ron, 22, 10, 38
    Jason, 29, 8, 35

1. Create a data frame to store the above data. The data frame, say `dfrm`, will have 3 columns named `subject`, `condition`, and `words`.
2. Compute the mean number of words recalled by Victor.
3. Compute means per condition and all pairwise differences.

If you feel comfortable with IO operations in R, you can work directly with the data file [words.dat](./data/words.dat).

## Application 2

The file [brain_size.csv](./data/brain_size.csv) contains data from a study on the relationship between brain size and weight and intelligence (<a href="">Willerman et al. 1991</a>).

1. Load the data file.
2. Report any missing value (number, variables, etc.).
3. How many males/females were included in this study?
4. What is the mean value for full IQ?
5. What is the mean value for full IQ in males? In females?
6. What is the average value of MRI counts expressed in log units?

## References

Heathcote A (1996). "RTSYS: A DOS application for the analysis of
reaction time data." _Behavior Research Methods, Instruments, \&
Computers_, *28*(3), pp. 427-445. <URL:
http://cran.r-project.org/web/packages/retimes/>.

Willerman L, Schultz R, Rutledge J and Bigler E (1991). "In Vivo Brain
Size and Intelligence." _Intelligence_, *15*, pp. 223-228.



