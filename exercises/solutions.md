Solutions
------------------------------



Data sets used in the following exercises can be found on [Github](https://github.com/cogmaster-stats/r-cogstats/tree/master/data).

### R language and descriptive statistics

**1.** It is easy to store a series of values in a variable `x`. The missing value, coded as `NA`, is written as is (no surrounding quote).

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

**2.** Here are two methods to create a factor with a specific arrangement of levels. First, we can generate the base pattern (three `std` followed by three `new`) and replicate it to obtain the desired length:

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

**3.** The `data()` command allows to import any data set that comes with R base and add-on packages. We can either load the package using, e.g., `library(MASS)`, and then `data()`'s the data set, or use directly

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
