Solutions
------------------------------



Data sets used in the following exercises can be found on [Github](https://github.com/cogmaster-stats/r-cogstats/tree/master/data).

### R language and descriptive statistics

**Exercise 1.** It is easy to store a series of values in a variable `x`. The missing value, coded as `NA`, is written as is (no surrounding quote).

```r
x <- c(5.4, 6.1, 6.2, NA, 6.2, 5.6, 19, 6.3)
x
```

```
## [1]  5.4  6.1  6.2   NA  6.2  5.6 19.0  6.3
```


To replace the 7th value, we can do

```r
x[7] <- NA
x
```

```
## [1] 5.4 6.1 6.2  NA 6.2 5.6  NA 6.3
```


There are now two missing values. The command `mean(x, na.rm=TRUE)` would compute the mean on all observations, and it can be used to impute missing values like this:

```r
x[is.na(x)] <- mean(x, na.rm = TRUE)
x
```

```
## [1] 5.400 6.100 6.200 5.967 6.200 5.600 5.967 6.300
```

It would be possible to write `x[c(4,7)] <- mean(x, na.rm=TRUE)`, but this means we know the index position of the missing values. Using `is.na()` returns a boolean, which can be used to affect every `TRUE` values, for example.

**Exercise 2.** Here are two methods to create a factor with a specific arrangement of levels. First, we can generate the base pattern (three `std` followed by three `new`) and replicate it to obtain the desired length:

```r
tx <- factor(rep(rep(c("std", "new"), each = 3), 10))
```


However, since allocation of levels follows a regular pattern, it is easier to use the `gl()` command. E.g., 

```r
tx <- gl(2, 3, 60, labels = c("std", "new"))
head(tx, n = 7)
```

```
## [1] std std std new new new std
## Levels: std new
```


To work with levels, there are two dedicated commands in R: `levels()` and `relevel()`. Here are some examples of use:

```r
levels(tx)[1] <- "old"
tx <- relevel(tx, ref = "new")
head(tx <- sample(tx), n = 7)
```

```
## [1] new old new old old new old
## Levels: new old
```


It is important to note that we don't have to (and we shouldn't) work with the whole vector, but only update the factor levels. In R, factor are stored as numbers (starting with 1), and labels are just strings associated to each number. Also, variable assignation (`<-`) can be done inside another expression, as shown in the last command.

**Exercise 3.** The `data()` command allows to import any data set that comes with R base and add-on packages. We can either load the package using, e.g., `library(MASS)`, and then `data()`'s the data set, or use directly

```r
data(birthwt, package = "MASS")
```


It is always a good idea to look for the associated help file, if it exists, with the `help()` command:

```r
help(birthwt, package = "MASS")
```


There are a number of binary variables, taking values in {0,1}. They might be kept as numeric but once converted them to factors with readable labels it is easier to work with them. Note that the `within()` command allows to update variables inside a data frame without prefixing them systematically with the `$` operator. Finally, we will also convert mothers' weight in kilograms.

```r
yesno <- c("No", "Yes")
ethn <- c("White", "Black", "Other")
birthwt <- within(birthwt, {
    low <- factor(low, labels = yesno)
    race <- factor(race, labels = ethn)
    smoke <- factor(smoke, labels = yesno)
    ui <- factor(ui, labels = yesno)
    ht <- factor(ht, labels = yesno)
})
birthwt$lwt <- birthwt$lwt/2.2
```


The frequency of history of hypertension (`ht`) can be computed based on the results of the `table()` command (divide counts by total number of cases), but there's a more convenient function that will do this automatically: `prop.table()`.

```r
table(birthwt$ht)
```

```
## 
##  No Yes 
## 177  12
```

```r
prop.table(table(birthwt$ht))
```

```
## 
##      No     Yes 
## 0.93651 0.06349
```


The average weight of newborns whose mother was smoking (`smoke=1`, now `smoke="Yes"`) during pregnancy but was free of hypertension (`ht=0`, now `ht="No"`) can be obtained by filtering rows and selecting the column of interest:

```r
mean(birthwt[birthwt$smoke == "Yes" & birthwt$ht == "No", "bwt"])
```

```
## [1] 2787
```

Another way to perform the same operation relies on the use of `subset()`, which extracts a specific part of a given data set: (Note that in this case there's no need to quote variable names.)

```r
sapply(subset(birthwt, smoke == "Yes" & ht == "No", bwt), mean)
```

```
##  bwt 
## 2787
```

The use of `sapply()` is now the recommended way to do the above operation, but westill can use `mean(subset(birthwt, smoke == "Yes" & ht == "No", bwt))`, although it will trigger a warning.

To get the five lowest baby weights for mothers with a weight below the first quartile of maternal weights, we need a two-step approach: First, we subset data fulfilling the condition on maternal weights, then sort the results in ascending order.

```r
wk.df <- subset(birthwt, lwt < quantile(lwt, probs = 0.25), bwt)
sapply(wk.df, sort)[1:5]
```

```
## [1] 1330 1474 1588 1818 1885
```

So, the first command select only rows of the data frame where `lwt` is below the first quartile, as computed by `quantile()`, and then we apply the `sort()` function to the filtered data frame. Again, we use the `sapply()` command, but this last command is equivalent to `sort(wk.df$bwt)` (`subset()` returns a data frame with only one column, named `bwt`, as requested).

To recode the `ptl` variable ("number of previous premature labours"), we can proceed as follows:

```r
birthwt$ptl2 <- ifelse(birthwt$ptl > 0, 1, 0)
birthwt$ptl2 <- factor(birthwt$ptl2, labels = c("0", "1+"))
with(birthwt, table(ptl2, ptl))
```

```
##     ptl
## ptl2   0   1   2   3
##   0  159   0   0   0
##   1+   0  24   5   1
```

The `ifelse()` statement is used to map every strictly positive value of `ptl` to the value 1 ("if"), 0 otherwise ("else"). This new binary variable is also converted to a fator with meaningful labels. Lastly, we check that everything went ok by cross-classifying both variables.

Assuming the `lattice` package has been loaded using `library(lattice)`, the distribution of individual values can be visualized as follows:

```r
histogram(~bwt | ptl2, data = birthwt, xlab = "Baby weight (g)")
```

![plot of chunk unnamed-chunk-15](figure/unnamed-chunk-15.png) 


Finally, here is a possible solution to display all continuous variables as boxplots:

```r
is.num <- sapply(birthwt, is.numeric)
wk.df <- birthwt[, which(is.num)]
wk.df <- sapply(wk.df, scale)
library(reshape2)
bwplot(value ~ variable, melt(data.frame(wk.df)))
```


> Try to "read" the above code: what do `is.numeric()` returns, how would you write the second command using `subset()`, why do we `scale()` the data, whta is the purpose of the `reshape()` command?

**Exercise 4.** The simulated data set is reproduced below.

```r
d <- data.frame(height = rnorm(40, 170, 10), class = sample(LETTERS[1:2], 40, rep = TRUE))
d$height[sample(1:40, 1)] <- 220
```


A first way to tackle this problem is to rely on indexation:

```r
d$class[which(d$height == max(d$height))]
```

```
## [1] B
## Levels: A B
```

We first inspect which element corresponds to the maximum value of `height`: `d$height == max(d$height)` returns a vector of booleans of length `length(d$height)`. We then ask for the position of the only TRUE value using `which()`.

It is also possible to sort the entire data frame, and return the last element of the `class` column. See the online help for `order()` for more information about sorting strategies in R.

```r
d[do.call(order, d), "class"][40]
```

```
## [1] B
## Levels: A B
```


**Exercise 5.** As with many "unknown" data sets, it is recommended to first check how data were stored (header, record separator, decimal point, etc.), how variables were recorded (numeric or factor), and if there are some unexpected values. In what follows, we won't be concerned with incongruous values: we will just discard them and set them to missing.

```r
WD <- "../data"
lung <- read.table(paste(WD, "lungcancer.txt", sep = "/"), header = TRUE, na.strings = ".")
str(lung)
```

```
## 'data.frame':	131 obs. of  4 variables:
##  $ time       : int  0 4 21 40 89 113 139 170 201 238 ...
##  $ age        : int  74 66 73 56 64 73 56 71 64 63 ...
##  $ cens       : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ vital.capac: Factor w/ 3 levels "high","low","low ": 1 1 1 1 1 1 1 1 1 1 ...
```

```r
summary(lung)
```

```
##       time          age          cens       vital.capac
##  Min.   : -2   Min.   : 5   Min.   :0.000   high:95    
##  1st Qu.: 73   1st Qu.:53   1st Qu.:0.000   low :35    
##  Median :167   Median :59   Median :1.000   low : 1    
##  Mean   :186   Mean   :59   Mean   :0.519              
##  3rd Qu.:275   3rd Qu.:66   3rd Qu.:1.000              
##  Max.   :558   Max.   :78   Max.   :2.000              
##  NA's   :2     NA's   :2
```

```r
head(sort(lung$time))
```

```
## [1] -2  0  0  1  1  2
```

```r
head(sort(lung$age))
```

```
## [1]  5 35 36 38 39 40
```

```r
table(lung$cens)
```

```
## 
##  0  1  2 
## 64 66  1
```

```r
table(lung$vital.capac)
```

```
## 
## high  low low  
##   95   35    1
```

```r
lung <- within(lung, {
    time[time < 0] <- NA
    age[age == 5] <- NA
    cens[cens == 2] <- NA
    cens <- factor(cens)
    levels(vital.capac)[2:3] <- "low"
})
summary(lung)
```

```
##       time            age         cens    vital.capac
##  Min.   :  0.0   Min.   :35.0   0   :64   high:95    
##  1st Qu.: 74.5   1st Qu.:53.0   1   :66   low :36    
##  Median :167.5   Median :59.5   NA's: 1              
##  Mean   :187.6   Mean   :59.4                        
##  3rd Qu.:277.0   3rd Qu.:66.0                        
##  Max.   :558.0   Max.   :78.0                        
##  NA's   :3       NA's   :3
```


> Study the above code and try to translate it into your own words.

### Data exploration and two-group comparisons

**Exercise 6.** Like in Exercice 5, it is always a good idea to look at the raw data, or a subset thereof (especially when data files are really big), in a simple text editor. The `reading2.csv` file looks like this:

    Treatment,Response
    Treated,24
    Treated,43
    Treated,58
    Treated,71
    Treated,43
    Treated,49
    Treated,61
    Treated,44
    Treated,.

It can be seen that: there is a header line (names of the variables), each line corresponds to one observation, with current status (Treated or not) and a value for the response variable; missing value seems to be coded as ".". Thus, a command like this should work:

```r
reading <- read.csv("../data/reading2.csv", na.strings = ".")
head(reading)
```

```
##   Treatment Response
## 1   Treated       24
## 2   Treated       43
## 3   Treated       58
## 4   Treated       71
## 5   Treated       43
## 6   Treated       49
```

```r
summary(reading)
```

```
##    Treatment     Response   
##  Control:23   Min.   :17.0  
##  Treated:21   1st Qu.:42.0  
##               Median :48.5  
##               Mean   :48.0  
##               3rd Qu.:56.8  
##               Max.   :85.0  
##               NA's   :6
```


The `head()` and `summary()` commands are used to get a basic feeling of how the data look like once imported in R. The latter also provides the number of missing values for each variable. Another way to compute missing observations is to use the `is.na()` function: it returns a boolean value for every observation, and we can simply count the number of positive matches (`TRUE`) using the `sum()`, as illustrated below:

```r
sum(is.na(reading$Response))
```

```
## [1] 6
```

If we want to compute the number of missing data for the two groups, we could use

```r
sum(is.na(reading$Response[reading$Treatment == "Control"]))
```

```
## [1] 4
```

```r
sum(is.na(reading$Response[reading$Treatment == "Treated"]))
```

```
## [1] 2
```

but it is easier to rely on aggregating functions, like `tapply()` or `by()`. However, since we used a combination of two commands (`sum()` and `is.na()`), we need to write a little helper function, say `nmiss()`, which will compute the number of missing data for a given vector of values.

```r
nmiss <- function(x) sum(is.na(x))
tapply(reading$Response, reading$Treatment, nmiss)
```

```
## Control Treated 
##       4       2
```

It is also possible to use `aggregate()`, but we must remind that this function automatically discard missing values for its computation. So we would need to call it like this:

```r
aggregate(Response ~ Treatment, reading, nmiss, na.action = na.pass)
```


Sample size is readily obtained using the `table()` command:

```r
table(reading$Treatment)
```

```
## 
## Control Treated 
##      23      21
```


Assuming the `lattice` package is already loaded, we can use a density plot as follows:

```r
densityplot(~Response, data = reading, groups = Treatment, auto.key = TRUE)
```

![plot of chunk unnamed-chunk-27](figure/unnamed-chunk-27.png) 

The `auto.key=TRUE` option ensures that R will draw the corresponding legend.

A Student t-test can be done as shown below:

```r
t.test(Response ~ Treatment, data = reading, var.equal = TRUE)
```

```
## 
## 	Two Sample t-test
## 
## data:  Response by Treatment 
## t = -1.694, df = 36, p-value = 0.099
## alternative hypothesis: true difference in means is not equal to 0 
## 95 percent confidence interval:
##  -15.961   1.435 
## sample estimates:
## mean in group Control mean in group Treated 
##                 44.37                 51.63
```

The results suggest that there is no evidence of a statistically significant difference (at the 5% level) in average response between the two groups for this particular sample. 

We can further verify group variances and distributions as follows:

```r
aggregate(Response ~ Treatment, data = reading, var)
```

```
##   Treatment Response
## 1   Control    247.2
## 2   Treated    102.2
```

```r
bwplot(Response ~ Treatment, data = reading, pch = "|")
```

![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29.png) 


The Wilcoxon-Mann-Whitney test, which is a non-parametric procedure relying on ranks of the observations and testing for a location shift between two samples, is available in the `wilcox.test()` command:

```r
wilcox.test(Response ~ Treatment, data = reading)
```

```
## 
## 	Wilcoxon rank sum test with continuity correction
## 
## data:  Response by Treatment 
## W = 105.5, p-value = 0.02944
## alternative hypothesis: true location shift is not equal to 0
```


> How would you explain that the two tests give different outcome with this data set?

**Exercise 7.** The 'fusion' data can be imported in R using the `read.table()` command; records are separated by blanks (tab or space, it doesn't really matter here), and there's no header.

```r
fus <- read.table("../data/fusion.dat", header = FALSE)
names(fus) <- c("resp", "grp")
str(fus)
```

```
## 'data.frame':	78 obs. of  2 variables:
##  $ resp: num  47.2 22 20.4 19.7 17.4 ...
##  $ grp : Factor w/ 2 levels "NV","VV": 1 1 1 1 1 1 1 1 1 1 ...
```


Two informative graphical displays are box and whiskers chart or so called strip plot. The latter offer the advantage to show all data points, possibly with some horizontal or vertical jittering to avoid data overlap and/or alpha transparency.

```r
## bwplot(resp ~ grp, data = fus)
stripplot(resp ~ grp, data = fus, jitter.data = TRUE, grid = "h", alpha = 0.5)
```

![plot of chunk unnamed-chunk-32](figure/unnamed-chunk-32.png) 


To summarize the data, we can write a little helper function that combines the `mean()` and `sd()` commands. For a given vector `x`, the following `f()` function will return the mean and standard deviation of all observations, with a default option to handle missing data.

```r
f <- function(x, na.rm = TRUE) c(mean = mean(x, na.rm = na.rm), s = sd(x, na.rm = na.rm))
aggregate(resp ~ grp, data = fus, FUN = f)
```

```
##   grp resp.mean resp.s
## 1  NV     8.560  8.085
## 2  VV     5.551  4.802
```


As can be seen, the standard deviation for the first group is very large compare to the first group, which also has the highest mean. This confirms the right-skewness of the distributions depicted in the preceding figure.

Results from Student and Welch t-test are given below.

```r
t.test(resp ~ grp, data = fus, var.equal = TRUE)
```

```
## 
## 	Two Sample t-test
## 
## data:  resp by grp 
## t = 1.94, df = 76, p-value = 0.05615
## alternative hypothesis: true difference in means is not equal to 0 
## 95 percent confidence interval:
##  -0.08094  6.09901 
## sample estimates:
## mean in group NV mean in group VV 
##            8.560            5.551
```

```r
t.test(resp ~ grp, data = fus)$p.value
```

```
## [1] 0.04529
```

The classical test, which assumes equality of variance, does not reach the 5% significance level, contrary to Welch t-test with this particular sample.

To get a more symmetric distribution, a log-transformation can be applied to the raw data. This often helps to stabilize the variance as well.

```r
fus$resp.log <- log10(fus$resp)
aggregate(resp.log ~ grp, data = fus, FUN = f)
```

```
##   grp resp.log.mean resp.log.s
## 1  NV        0.7904     0.3534
## 2  VV        0.6034     0.3552
```

```r
histogram(~resp + resp.log | grp, data = fus, breaks = "Sturges", scales = list(relation = "free"))
```

![plot of chunk unnamed-chunk-35](figure/unnamed-chunk-35.png) 

```r
t.test(resp.log ~ grp, data = fus, var.equal = TRUE)
```

```
## 
## 	Two Sample t-test
## 
## data:  resp.log by grp 
## t = 2.319, df = 76, p-value = 0.02308
## alternative hypothesis: true difference in means is not equal to 0 
## 95 percent confidence interval:
##  0.02639 0.34758 
## sample estimates:
## mean in group NV mean in group VV 
##           0.7904           0.6034
```


**Remark:** A more precise procedure, the [Box-Cox transformation](http://en.wikipedia.org/wiki/Power_transform), would yield an optimal value close to 0, therefore compatible with a log transformation.

**Exercise 8.** First, we load the data using the supplied command:

```r
brain <- read.table("../data/IQ_Brain_Size.txt", header = FALSE, skip = 27, nrows = 20)
head(brain, 2)
```

```
##     V1 V2   V3 V4 V5 V6   V7   V8    V9
## 1 6.08 96 54.7  1  1  2 1914 1005 57.61
## 2 5.73 89 54.2  2  1  2 1685  963 58.97
```

The data file indicates that the variables are given in the following order:

    CCMIDSA: Corpus Collasum Surface Area (cm2)
    FIQ: Full-Scale IQ
    HC: Head Circumference (cm)
    ORDER: Birth Order
    PAIR: Pair ID (Genotype)
    SEX: Sex (1=Male 2=Female)
    TOTSA: Total Surface Area (cm2)
    TOTVOL: Total Brain Volume (cm3)
    WEIGHT: Body Weight (kg)  

We can update our data frame with correct labels for variables, and display a brief summary of data types and values.

```r
names(brain) <- tolower(c("CCMIDSA", "FIQ", "HC", "ORDER", "PAIR", "SEX", "TOTSA", 
    "TOTVOL", "WEIGHT"))
str(brain)
```

```
## 'data.frame':	20 obs. of  9 variables:
##  $ ccmidsa: num  6.08 5.73 6.22 5.8 7.99 8.42 7.44 6.84 6.48 6.43 ...
##  $ fiq    : int  96 89 87 87 101 103 103 96 127 126 ...
##  $ hc     : num  54.7 54.2 53 52.9 57.8 56.9 56.6 55.3 53.1 54.8 ...
##  $ order  : int  1 2 1 2 1 2 1 2 1 2 ...
##  $ pair   : int  1 1 2 2 3 3 4 4 5 5 ...
##  $ sex    : int  2 2 2 2 2 2 2 2 2 2 ...
##  $ totsa  : num  1914 1685 1902 1860 2264 ...
##  $ totvol : int  1005 963 1035 1027 1281 1272 1051 1079 1034 1070 ...
##  $ weight : num  57.6 59 64.2 58.5 64 ...
```


The `order`, `pair`, and `sex` variables are categorical, but they are seen as integers by R. They need to be converted as R factors. We will also add more informative label for gender:

```r
brain$order <- factor(brain$order)
brain$pair <- factor(brain$pair)
brain$sex <- factor(brain$sex, levels = 1:2, labels = c("Male", "Female"))
summary(brain)
```

```
##     ccmidsa          fiq              hc       order       pair       sex    
##  Min.   :5.73   Min.   : 85.0   Min.   :52.9   1:10   1      :2   Male  :10  
##  1st Qu.:6.29   1st Qu.: 92.0   1st Qu.:54.8   2:10   2      :2   Female:10  
##  Median :6.71   Median : 96.5   Median :56.8          3      :2              
##  Mean   :6.99   Mean   :101.0   Mean   :56.1          4      :2              
##  3rd Qu.:7.63   3rd Qu.:105.5   3rd Qu.:57.2          5      :2              
##  Max.   :8.76   Max.   :127.0   Max.   :59.2          6      :2              
##                                                       (Other):8              
##      totsa          totvol         weight     
##  Min.   :1685   Min.   : 963   Min.   : 57.6  
##  1st Qu.:1772   1st Qu.:1035   1st Qu.: 61.6  
##  Median :1864   Median :1079   Median : 76.0  
##  Mean   :1906   Mean   :1126   Mean   : 77.8  
##  3rd Qu.:1984   3rd Qu.:1181   3rd Qu.: 85.0  
##  Max.   :2264   Max.   :1439   Max.   :133.4  
## 
```


To compute counts or frequencies of boys and girls, we can use `table()` and/or `prop.table()`. The latter is usually to be preferred.

```r
table(brain$sex)
```

```
## 
##   Male Female 
##     10     10
```

```r
## table(brain$sex)/sum(table(brain$sex))
prop.table(table(brain$sex))
```

```
## 
##   Male Female 
##    0.5    0.5
```


Average and median IQ level are available with `summary(brain)`, but they are easily computed as

```r
mean(brain$fiq)
```

```
## [1] 101
```

```r
median(brain$fiq)
```

```
## [1] 96.5
```

The number of children with an IQ < 90 can be found using `table()`:

```r
table(brain$fiq < 90)
```

```
## 
## FALSE  TRUE 
##    15     5
```

Alternatively, we could use `sum(brain$fiq < 90)`.

Anatomical quantities were also partly summarized with `summary(brain)`. We can find the values of the first and third quartile of CCMIDSA like this:

```r
quantile(brain$ccmidsa, probs = c(0.25, 0.75))
```

```
##   25%   75% 
## 6.295 7.633
```

```r
diff(quantile(brain$ccmidsa, probs = c(0.25, 0.75)))
```

```
##   75% 
## 1.338
```

```r
IQR(brain$ccmidsa)
```

```
## [1] 1.338
```

The inter-quartile range is simply the difference between the third and first quartile, and R already offers a dedicated command: `IQR()`. This command could be applied to each variable. Of note, here is a way to serialize such an operation:

```r
sapply(brain[, c("ccmidsa", "hc", "totsa", "totvol")], IQR)
```

```
## ccmidsa      hc   totsa  totvol 
##   1.338   2.425 211.190 146.000
```


The distribution of children weight according to twins number can be summarized with an histogram as shown below.

```r
histogram(~weight | order, data = brain, type = "count", xlab = "Weight (kg)", ylab = "Counts")
```

![plot of chunk unnamed-chunk-44](figure/unnamed-chunk-44.png) 


Terciles are readily obtained using the same `quantile()` command:

```r
quantile(brain$weight, probs = 0:3/3)
```

```
##     0% 33.33% 66.67%   100% 
##  57.61  62.75  82.56 133.36
```

and they can be used to create a three-class variable thanks to the `cut()` command.

```r
weight.terc <- cut(brain$weight, breaks = quantile(brain$weight, probs = 0:3/3), 
    include.lowest = TRUE)
table(weight.terc)
```

```
## weight.terc
## [57.6,62.7] (62.7,82.6]  (82.6,133] 
##           7           6           7
```

```r
aggregate(totvol ~ weight.terc, data = brain, FUN = function(x) c(mean(x), sd(x)))
```

```
##   weight.terc totvol.1 totvol.2
## 1 [57.6,62.7]  1079.00   107.82
## 2 (62.7,82.6]  1135.50    98.89
## 3  (82.6,133]  1164.71   158.87
```

The `breaks=` options is used to indicate how to break the continuous variable into class intervals. Importantly, one must specify `include.lowest=TRUE` in order to include the minimum value of the variable, because default intervals are opened on the left. Finally, although we could reuse our preceding `f()` function (Exercice 7), notice that we can provide inline function to the `aggregate()` command.

Since we are working with monozygotic twins who share all their genes, and given that the characteristics under study are neuropsychological traits thought to be highly heritable, we can safely assume a paired t-test whose results are given below:

```r
aggregate(fiq ~ order, data = brain, function(x) c(mean(x), sd(x)))
```

```
##   order  fiq.1  fiq.2
## 1     1 100.40  14.50
## 2     2 101.60  12.55
```

```r
t.test(fiq ~ order, data = brain, paired = TRUE)
```

```
## 
## 	Paired t-test
## 
## data:  fiq by order 
## t = -0.4537, df = 9, p-value = 0.6608
## alternative hypothesis: true difference in means is not equal to 0 
## 95 percent confidence interval:
##  -7.183  4.783 
## sample estimates:
## mean of the differences 
##                    -1.2
```

This confirms that the observed data do not allow us to reject the null hypothesis (no difference between twins regarding IQ level).

Comparing head circumference of males vs. females could rely on a t-test for independent samples if we are willing to assume that boys and girls have different anthropometrical characteristics at birth.

```r
aggregate(hc ~ sex, data = brain, function(x) c(mean(x), sd(x)))
```

```
##      sex    hc.1    hc.2
## 1   Male 57.3200  0.9426
## 2 Female 54.9300  1.7269
```

```r
t.test(hc ~ sex, data = brain)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  hc by sex 
## t = 3.841, df = 13.93, p-value = 0.001814
## alternative hypothesis: true difference in means is not equal to 0 
## 95 percent confidence interval:
##  1.055 3.725 
## sample estimates:
##   mean in group Male mean in group Female 
##                57.32                54.93
```


Finally, here is an alternative to strip plots, which relies on [Cleveland's dotplot](http://goo.gl/iSrlOh):

```r
dotplot(hc ~ sex, data = brain, groups = order, type = c("p", "a"), jitter.x = TRUE, 
    auto.key = list(title = "Birth order", cex = 0.8, cex.title = 1, columns = 2))
```

![plot of chunk unnamed-chunk-49](figure/unnamed-chunk-49.png) 

Points are colored according to `order` levels, and the `type=c("p", "a")` option asks R to show individual values and average values for each subgroups (i.e., cross-classifying `sex` and `order` levels). This confirms that there seems to be little variation between twins, but that girls generally have a smaller head circumference.

> How would you compute standardized mean difference (Cohen's d) in each case?

### One-way and two-way ANOVA

**Exercise 9.** The working data set is reproduced below.


```r
set.seed(101)
k <- 3  # number of groups 
ni <- 10  # number of observations per group
mi <- c(10, 12, 8)  # group means
si <- c(1.2, 1.1, 1.1)  # group standard deviations
grp <- gl(k, ni, k * ni, labels = c("A", "B", "C"))
resp <- c(rnorm(ni, mi[1], si[1]), rnorm(ni, mi[2], si[2]), rnorm(ni, mi[3], si[3]))
```


A very basic descriptive summary of the data is provided by `summary()` and group-wise operations:

```r
d <- data.frame(grp, resp)
rm(grp, resp)
summary(d)
```

```
##  grp         resp      
##  A:10   Min.   : 6.39  
##  B:10   1st Qu.: 8.61  
##  C:10   Median :10.06  
##         Mean   : 9.92  
##         3rd Qu.:11.10  
##         Max.   :13.57
```

```r
aggregate(resp ~ grp, data = d, mean)
```

```
##   grp   resp
## 1   A 10.294
## 2   B 11.516
## 3   C  7.941
```

We created a data frame and deleted intermediate variable to keep a clean workspace. The `aggregate()` command returns a data frame; we can store it in a new variable for later use, e.g.

```r
resp.means <- aggregate(resp ~ grp, data = d, mean)
```


In particular, we can now use this variable to compute differences between group means (available in column headed `resp` in the `resp.means` data frame) and the grand mean:

```r
resp.means$resp - mean(d$resp)
```

```
## [1]  0.377  1.599 -1.976
```

These results suggest that the largest difference is between group B and C.

A boxplot is easily drawn using `bwplot()` and the same formula that we used to summarize the data by group:

```r
bwplot(resp ~ grp, data = d)
```

![plot of chunk unnamed-chunk-54](figure/unnamed-chunk-54.png) 


To compute the ANOVA table, we will again use the `resp ~ grp` formula:

```r
m <- aov(resp ~ grp, data = d)
summary(m)
```

```
##             Df Sum Sq Mean Sq F value  Pr(>F)    
## grp          2   66.1    33.0    39.9 8.7e-09 ***
## Residuals   27   22.4     0.8                    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

This significant result suggest that the observed data are not compatible with the null hypothesis. The F-statistic can be computed as follows:

```r
fval <- 33.031/0.828  ## MS grp / MS residual, see print(summary(m), digits=5)
pval <- pf(fval, 2, 27, lower.tail = FALSE)
format(pval, digits = 5)
```

```
## [1] "8.68e-09"
```


If we want to discard the `C` level for factor `grp`, we can either subset the whole data frame (e.g., `subset(d, grp != "C")`), or call the `aov()` command with a `subset=` option as shown below:

```r
m2 <- aov(resp ~ grp, data = d, subset = grp != "C")
summary(m2)
```

```
##             Df Sum Sq Mean Sq F value Pr(>F)   
## grp          1   7.47    7.47    8.88  0.008 **
## Residuals   18  15.14    0.84                  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


Since we are working with only two groups, this is strictly equivalent to carrying out a Student t-test (assuming equal variance), and the F-statistic is just the square of the t-statistic (p-values will be strictly identical). Here are two ways to write the test for the first two groups:

```r
t.test(d$resp[d$grp == "A"], d$resp[d$grp == "B"], var.equal = TRUE)
```

```
## 
## 	Two Sample t-test
## 
## data:  d$resp[d$grp == "A"] and d$resp[d$grp == "B"] 
## t = -2.98, df = 18, p-value = 0.00803
## alternative hypothesis: true difference in means is not equal to 0 
## 95 percent confidence interval:
##  -2.0841 -0.3605 
## sample estimates:
## mean of x mean of y 
##     10.29     11.52
```

```r
## t.test(resp ~ grp, data = subset(d, grp != "C"), var.equal = TRUE)
```

(Another option for subsetting would be to use `subset(d, subset=grp %in% c("A","B"))`.)

**Exercise 10.** The `taste.dat` file is a simple tab-delimited text file, with names of the variables on first line. It can be imported using `read.table()`.

```r
taste <- read.table("../data/taste.dat", header = TRUE)
summary(taste)
```

```
##      SCORE            SCR           LIQ     
##  Min.   : 16.0   Min.   :0.0   Min.   :0.0  
##  1st Qu.: 38.0   1st Qu.:0.0   1st Qu.:0.0  
##  Median : 64.5   Median :0.5   Median :0.5  
##  Mean   : 64.6   Mean   :0.5   Mean   :0.5  
##  3rd Qu.: 88.0   3rd Qu.:1.0   3rd Qu.:1.0  
##  Max.   :129.0   Max.   :1.0   Max.   :1.0
```


As can be seen, R did not recognize columns 2 and 3 as factors, hence this quick post-processing:

```r
taste$SCR <- factor(taste$SCR, levels = 0:1, labels = c("coarse", "fine"))
taste$LIQ <- factor(taste$LIQ, levels = 0:1, labels = c("low", "high"))
names(taste) <- tolower(names(taste))
summary(taste)
```

```
##      score           scr      liq   
##  Min.   : 16.0   coarse:8   low :8  
##  1st Qu.: 38.0   fine  :8   high:8  
##  Median : 64.5                      
##  Mean   : 64.6                      
##  3rd Qu.: 88.0                      
##  Max.   :129.0
```


A detailed overview for the arrangement of experimental units can be obtained with `replications()`:

```r
fm <- score ~ scr * liq
replications(fm, data = taste)
```

```
##     scr     liq scr:liq 
##       8       8       4
```

Note that since we will be reusing the same formula for the ANOVA model, we can associate it to a dedicated variable. Using `*` instead of `+` is not a problem with `aggregate()`. Again, let's define a little helper function that returns sample size, mean, and standard deviation.

```r
f <- function(x) c(n = length(x), mean = mean(x), sd = sd(x))
res <- aggregate(fm, data = taste, f)
res
```

```
##      scr  liq score.n score.mean score.sd
## 1 coarse  low    4.00      41.75    25.55
## 2   fine  low    4.00     103.50    18.91
## 3 coarse high    4.00      36.00    17.83
## 4   fine high    4.00      77.25    15.09
```


Since `aggregate()` always returns a data frame with a column for the numerical quantity of interest (note that there should be only one value, unlike the results produced above) , a dot chart can be drawn by embedding the command directly in the `data=` argument as follows:

```r
dotplot(score ~ scr, data = aggregate(fm, taste, mean), groups = liq, type = "l")
```

However, most `lattice` functions are able to compute average values thanks to the `type="a"` option, so the above instruction is equivalent to:

```r
dotplot(score ~ scr, data = taste, groups = liq, type = c("a"), auto.key = TRUE)
```

![plot of chunk unnamed-chunk-64](figure/unnamed-chunk-64.png) 


Box and wiskers charts of scores for the 4 treatments are obtained easily using a simpler formula:

```r
bwplot(score ~ scr + liq, taste, ablie = list(h = mean(taste$score), lty = 2))
```

![plot of chunk unnamed-chunk-65](figure/unnamed-chunk-65.png) 

The grand mean has been added to the above plot to allow comparison of groups relative to a baseline.

The saturated model is shown below. It appears that the interaction is not significant at the 5% level, suggesting that this term could be removed from the model yielding a simpler model with two main effects (`scr + liq`). Likewise, the effect of `liq` is not significant, but it is better to keep it in the ANOVA table since it was included in the original experimental design.

```r
m0 <- aov(fm, data = taste)  ## full model
summary(m0)
```

```
##             Df Sum Sq Mean Sq F value  Pr(>F)    
## scr          1  10609   10609   27.27 0.00021 ***
## liq          1   1024    1024    2.63 0.13068    
## scr:liq      1    420     420    1.08 0.31914    
## Residuals   12   4668     389                    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


Although we could simply write down `aov(score ~ scr + fiq, taste)`, here is a way to update the previous model which happens to be very handy in regression models including many terms:

```r
m1 <- update(m0, . ~ . - scr:liq)  ## reduced model
summary(m1)
```

```
##             Df Sum Sq Mean Sq F value  Pr(>F)    
## scr          1  10609   10609   27.10 0.00017 ***
## liq          1   1024    1024    2.62 0.12979    
## Residuals   13   5089     391                    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


Obviously, sum of squares remain identical to those computed in the saturated model, only the resiudal term get 1 additional degree of freedom for the two F-tests.

A Bartlett test for the homogeneity of variances could be used to check the assumption of equal variance (although it is barely useful to test a null hypothesis that we cannot accept, and without any *a priori* idea of the parameter location under the alternative). Since the original model include two factors interacting each other, the test should be carried out at the level of the treatment (3 DF), and not for each group separately:

```r
bartlett.test(score ~ interaction(liq, scr), data = taste)
```

```
## 
## 	Bartlett test of homogeneity of variances
## 
## data:  score by interaction(liq, scr) 
## Bartlett's K-squared = 0.8011, df = 3, p-value = 0.8492
```

(An alternative test, the Levene test, is available in the `car` package. Its syntax is closer to the one used to fit the ANOVA model (`leveneTest(fm, data=taste)`).)

The above results suggest that the data do not suggest strong departure from the null hypothesis of equal variances.

Finally, to summarize the effect of `scr`, we can compute the partial $\eta^2$ as follows: (Here we are using the residual SS from the second model.)

```r
10609/(10609 + 5089)  ## 68% of explained variance
```

```
## [1] 0.6758
```


Note that we would reach a similar conclusion (large effect of the `scr` factor) using a standardized mean difference or a two-group comparison:

```r
t.test(score ~ scr, data = taste, var.equal = TRUE)
```

```
## 
## 	Two Sample t-test
## 
## data:  score by scr 
## t = -4.929, df = 14, p-value = 0.0002218
## alternative hypothesis: true difference in means is not equal to 0 
## 95 percent confidence interval:
##  -73.91 -29.09 
## sample estimates:
## mean in group coarse   mean in group fine 
##                38.88                90.38
```

```r
library(MBESS)
with(taste, smd(score[scr == "coarse"], score[scr == "fine"]))
```

```
## [1] -2.465
```



