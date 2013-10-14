Lab 1 : Answers to exercices
------------------------------



This document is written using [R Markdown](http://www.rstudio.com/ide/docs/r_markdown). The source code is available in `01-intro-lab-answers.R`.

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

If you feel comfortable with IO operations in R, you can work directly with the data file `words.dat`.

-----

There are three variables in total, and `subject` and `condition` are considered as categorical variables. Each subject has three records for `words`. The best way to store such data is to create a data frame with three columns, but we will need to repeat conditions across subjects. This can be done using the `rep()` command.

```r
subject <- factor(rep(c("Jim", "Victor", "Faye", "Ron", "Jason"), each = 3))
cond <- factor(rep(c("Neg", "Neu", "Pos"), 5))
words <- c(32, 15, 45, 30, 13, 40, 26, 12, 42, 22, 10, 38, 29, 8, 35)
dfrm <- data.frame(subject, cond, words)
head(dfrm)
```

```
##   subject cond words
## 1     Jim  Neg    32
## 2     Jim  Neu    15
## 3     Jim  Pos    45
## 4  Victor  Neg    30
## 5  Victor  Neu    13
## 6  Victor  Pos    40
```


We can subset the data frame by filtering data matching the following criteria:

```r
dfrm[subject == "Victor", ]
```

```
##   subject cond words
## 4  Victor  Neg    30
## 5  Victor  Neu    13
## 6  Victor  Pos    40
```


Note that this filter applies on rows, hence it appears before the comma in brackets. Leaving right part (after the comma) blank means that R will return all columns of the data frame. If we only want a specific column, we can use an expression like this:

```r
dfrm[subject == "Victor", "words"]
```

```
## [1] 30 13 40
```

```r
mean(dfrm[subject == "Victor", "words"])
```

```
## [1] 27.67
```


As we will see later, it is more convenient to use the `subset()` command, which allows to apply filters on rows and columns in a friendly manner, e.g.

```r
subset(dfrm, subject == "Victor", "words")
```


To compute means for each condition, we can use the same process and filter the data frame with logical operators. For instance, to get the mean in the neutral condition (`Neu`), we would use

```r
mean(dfrm[cond == "Neu", "words"])
```

```
## [1] 11.6
```

However, we would need to repeat this instruction three times (i.e., for each level of the factor). A faster way to compute marginal means is to aggregate the data like this:

```r
aggregate(words ~ cond, data = dfrm, FUN = mean)
```

```
##   cond words
## 1  Neg  27.8
## 2  Neu  11.6
## 3  Pos  40.0
```


**Remark:** It is possible to read the data directly rather than creating a data frame manually. Here is a possible solution :

```r
tmp <- read.table("../data/words.dat", sep = ",", skip = 2, header = FALSE, col.names = c("subject", 
    "Neg", "Neu", "Pos"))
```

```
## Warning: readTableHeader a trouvé une ligne finale incomplète dans
## '../data/words.dat'
```

```r
library(reshape2)
dfrm <- melt(tmp)
```

```
## Using subject as id variables
```

```r
head(dfrm)
```

```
##   subject variable value
## 1     Jim      Neg    32
## 2  Victor      Neg    30
## 3    Faye      Neg    26
## 4     Ron      Neg    22
## 5   Jason      Neg    29
## 6     Jim      Neu    15
```




## Application 2

The file `brain_size.csv` contains data from a study on the relationship between brain size and weight and intelligence (<a href="">Willerman et al. 1991</a>).

1. Load the data file.
2. Report any missing value (number, variables, etc.).
3. How many males/females were included in this study?
4. What is the mean value for full IQ?
5. What is the mean value for full IQ in males? In females?
6. What is the average value of MRI counts expressed in log units?

-----

The data are stored in a CSV file, where records (fileds) are separated by semicolons. The first six lines of `brain_size.csv` are displayed below:

    "";"Gender";"FSIQ";"VIQ";"PIQ";"Weight";"Height";"MRI_Count"
    "1";"Female";133;132;124;"118";"64.5";816932
    "2";"Male";140;150;124;".";"72.5";1001121
    "3";"Male";139;123;150;"143";"73.3";1038437
    "4";"Male";133;129;128;"172";"68.8";965353
    "5";"Female";137;132;134;"147";"65.0";951545
    "6";"Female";99;90;110;"146";"69.0";928799

The `read.csv2()` command can be used to read this kind of file. If comma were to be used to separate records, we would use `read.csv()` instead. You will have to change the pathname depending on where `brain_size.csv` is located in your file system. Alternatively, you can update the working directory to point to the folder where this file was saved.

```r
d <- read.csv2("../data/brain_size.csv")
head(d)
```

```
##   X Gender FSIQ VIQ PIQ Weight Height MRI_Count
## 1 1 Female  133 132 124    118   64.5    816932
## 2 2   Male  140 150 124      .   72.5   1001121
## 3 3   Male  139 123 150    143   73.3   1038437
## 4 4   Male  133 129 128    172   68.8    965353
## 5 5 Female  137 132 134    147   65.0    951545
## 6 6 Female   99  90 110    146   69.0    928799
```

As can be seen, the first column is not really interesting and can be safely removed.

```r
d <- d[, -1]
head(d)
```

```
##   Gender FSIQ VIQ PIQ Weight Height MRI_Count
## 1 Female  133 132 124    118   64.5    816932
## 2   Male  140 150 124      .   72.5   1001121
## 3   Male  139 123 150    143   73.3   1038437
## 4   Male  133 129 128    172   68.8    965353
## 5 Female  137 132 134    147   65.0    951545
## 6 Female   99  90 110    146   69.0    928799
```

Note that R automatically creates unique identifier for statistical units arranged in rows: they are called `rownames`. Variables are stored as columns headers and are known as `colnames`, or `names` in the case of a data frame:

```r
names(d)
```

```
## [1] "Gender"    "FSIQ"      "VIQ"       "PIQ"       "Weight"    "Height"   
## [7] "MRI_Count"
```


A convenient command to display a general summary of the data is the `summary()` function. For categorical data, il will display a table of counts, and for numerical variables a 6-number summary (range, IQR and measures of central tendency). The `summary()` command is also useful to spot possible coding problem.

```r
summary(d)
```

```
##     Gender        FSIQ            VIQ           PIQ            Weight  
##  Female:20   Min.   : 77.0   Min.   : 71   Min.   : 72.0   .      : 2  
##  Male  :20   1st Qu.: 89.8   1st Qu.: 90   1st Qu.: 88.2   118    : 2  
##              Median :116.5   Median :113   Median :115.0   127    : 2  
##              Mean   :113.5   Mean   :112   Mean   :111.0   143    : 2  
##              3rd Qu.:135.5   3rd Qu.:130   3rd Qu.:128.0   146    : 2  
##              Max.   :144.0   Max.   :150   Max.   :150.0   155    : 2  
##                                                            (Other):28  
##      Height     MRI_Count      
##  64.5   : 4   Min.   : 790619  
##  66.5   : 3   1st Qu.: 855918  
##  68.0   : 3   Median : 905399  
##  69.0   : 3   Mean   : 908755  
##  63.0   : 2   3rd Qu.: 950078  
##  66.0   : 2   Max.   :1079549  
##  (Other):23
```

In this case, we can notice that some variables are not treated as numerical variables by R, e.g. `Weight` and `Height`. This can be explained by the presence of missing values encoded as ".", whereas R usually expects `NA` or blanks. We could update the reading command to specify how missing data are coded. In this case, we would write

```r
d <- read.csv2("../data/brain_size.csv", na.strings = ".")
```

However, it is still possible to convert these two variables as `numeric` as follows:

```r
d$Weight <- as.numeric(as.character(d$Weight))
```

```
## Warning: NAs introduits lors de la conversion automatique
```

```r
d$Height <- as.numeric(as.character(d$Height))
```

```
## Warning: NAs introduits lors de la conversion automatique
```

```r
summary(d)
```

```
##     Gender        FSIQ            VIQ           PIQ            Weight   
##  Female:20   Min.   : 77.0   Min.   : 71   Min.   : 72.0   Min.   :106  
##  Male  :20   1st Qu.: 89.8   1st Qu.: 90   1st Qu.: 88.2   1st Qu.:135  
##              Median :116.5   Median :113   Median :115.0   Median :146  
##              Mean   :113.5   Mean   :112   Mean   :111.0   Mean   :151  
##              3rd Qu.:135.5   3rd Qu.:130   3rd Qu.:128.0   3rd Qu.:172  
##              Max.   :144.0   Max.   :150   Max.   :150.0   Max.   :192  
##                                                            NA's   :2    
##      Height       MRI_Count      
##  Min.   :62.0   Min.   : 790619  
##  1st Qu.:66.0   1st Qu.: 855918  
##  Median :68.0   Median : 905399  
##  Mean   :68.5   Mean   : 908755  
##  3rd Qu.:70.5   3rd Qu.: 950078  
##  Max.   :77.0   Max.   :1079549  
##  NA's   :1
```

It is important to first recode raw values to characters, and then to numeric values. Now, we can confirm that there are 3 missing observations in total. Another way to count missing data is to rely on the `is.na()` command. It returns `TRUE` (value is set as missing) or `FALSE`, which can be counted in R as any integer (`TRUE=1`). E.g.,

```r
sum(is.na(d$Weight))
```

```
## [1] 2
```

```r
table(is.na(d$Weight))
```

```
## 
## FALSE  TRUE 
##    38     2
```



The `summary()` command also gives the number of males and females. We could also use `table()` directly:

```r
table(d[, "Gender"])  # or table(d[,1])
```

```
## 
## Female   Male 
##     20     20
```


Average full IQ is computed as follows:

```r
mean(d$FSIQ)
```

```
## [1] 113.5
```

Since there's no missing data, we do not have to add the `add.rm=TRUE` option. If we want to restrict the analysis to males, we can use the following command:

```r
mean(d$FSIQ[d$Gender == "Male"])
```

```
## [1] 115
```

Likewise, we would use `mean(d$FSIQ[d$Gender == "Female"])` to compute mean FSQI for females. But, as described in Application 1, it is often easier to use built-in aggregating command like this:

```r
aggregate(FSIQ ~ Gender, d, mean)
```

```
##   Gender  FSIQ
## 1 Female 111.9
## 2   Male 115.0
```


Finally, average MRI counts in log units can be computed as follows:

```r
mean(log(d$MRI_Count, base = 10))  # or we can use log10
```

```
## [1] 5.957
```




## References

Willerman L, Schultz R, Rutledge J and Bigler E (1991). "In Vivo Brain
Size and Intelligence." _Intelligence_, *15*, pp. 223-228.

