Exercises
------------------------------



Data sets used in the following exercises can be found on [Github](https://github.com/cogmaster-stats/r-cogstats/tree/master/data).

### R language and descriptive statistics

**1.** Consider the following series of data collected on 8 subjects:

    5.4 6.1 6.2 NA 6.2 5.6 19.0 6.3
      
Store these values in a variable named `x`. It turns out that the 7th observation is inexact and should be considered as a missing value. It is also suggested to replace the two missing values (observations 4 and 7) by the mean computed on the whole sample.
   
**2.** Create a treatment facteur, `tx`, of size 60, with balanced levels (30 `std` and 30 `new`) organized as follows:

    std std std new new new ... std std std new new new
      
Replace label `std` with `old`. Then, update this vector so that the sequence of labels starts with `new`, instead of `old` (i.e., swap the two labels of the factor). Finally, intermix the two labels randomly.
   
**3.** Load the `birthwt` data set from the `MASS` package (`data(birthwt, package="MASS")`), and compute the following quantities:

   1. The relative frequency of history of hypertension (`ht`).  
   2. The average weight of newborns whose mother was smoking (`smoke=1`) during pregnancy but was free of hypertension (`ht=0`).  
   3. The five lowest baby weights for mothers with a weight below the first quartile of maternal weights.     
   4. Draw an histogram of baby weights by taking into account the number of previous premature labours. You will consider the following recoding of the `ptl` variable: `ptl2=0` if `ptl=0`, `ptl2=1` when `ptl>0`.  
   5. Finally, show the distribution of all *numerical* variables as box and whiskers plots.
   
**4.** Based on the following artificial data of students' heights in two classrooms, indicate if the largest student comes from classroom A or B. Data were generated as follows:


```r
d <- data.frame(height = rnorm(40, 170, 10), class = sample(LETTERS[1:2], 40, rep = TRUE))
d$height[sample(1:40, 1)] <- 220
```


**5.** Load the data included in `lungcancer.txt`. This data file features several coding problems (variables type, missing values, etc.). Inspect these data (e.g., using `summary()`) and suggest appropriate corrections.

### Data exploration and two-group comparisons

**6.** Import the `reading2.csv` [data](http://lib.stat.cmu.edu/DASL/Datafiles/DRPScores.html) file using `read.csv()` or `read.csv2()` depending on the type of field delimiter (refer the on-line documentation). Details about this study are given in <a href="">Schmitt (1987)</a>. Note that the original data set was modified for the purpose of this exercise.

   1. Report the number of missing values for each treatment group (`Treated` vs. `Control`).  
   2. Report sample size for each group in a Table, while reporting all missing observations.    
   3. Plot the distribution of responses in each group with a density plot.  
   4. Do a t-test without Welch correction, and compare its results with a Wilcoxon test (see `wilcox.test`).

**7.** The `fusion.dat` file includes [data](http://lib.stat.cmu.edu/DASL/Datafiles/FusionTime.html) from an experiment on visual perception relying on the use of random-dots stereograms (<a href="">Frisby & Clatworthy, 1975</a>). The aim of this study was to verify that prior knowledge of visual shape to detect enhances processing time for fusing the two images. One group of subjects (`NV`) received either no information or verbal vue only, while the other group (`VV`) received verbal and visual cues (drawing of the target object).

   1. Display subjects' performance in each condition with a convenient graphic, and compute their means and standard deviations.  
   2. Perform a t-test assuming equality of variances and conclude with respect to the null hypothesis (no effect of the manipulated factor). Compare with a t-test that does not assume equality of variances.  
   3. Run the same 'classical' t-test on log-transformed response values, and verify if the assumption of equal variances holds (use `var.test()`).

**8.** The `IQ_Brain_Size.txt` data file contains data from a brain imaging study on brain volume and anthropometric characteristics of Monozygotic twins (<a href="">Tramo et al. 1998</a>). More details are available in the file header. It can be loaded as follows:   
   

```r
brain <- read.table("IQ_Brain_Size.txt", header = FALSE, skip = 27, nrows = 20)
```

   
This assumes that the data file sits in the current working directory (otherwise, you can change the pathname, or update the current working directory with `setwd()` or RStudio's facilities). Do read carefully the on-line help for `read.table()` to understand what the above command is actually doing.
   
   1. Provide meaningful variable names based on the available information in the source data file.  
   2. Recode variables as factors when appropriate.  
   3. How many boys and girls are there in this sample (counts and frequencies)?  
   4. What is the average IQ level, what about median IQ, and how many children do have an IQ level below (strictly) 90?  
   5. Compute the inter-quartile range for the following variables: `CCMIDSA`, `HC`, `TOTSA`, `TOTVOL`.  
   6. Draw an histogram of children weights, separately for each twin (you can consider odd and even rows to perform stratification, or directly use birth order).  
   7. For each tercile of children weights, compute the mean and standard deviation of `TOTVOL`.  
   8. Compare IQ levels of monozygotic twins with a t-test.  
   9. Compare head circumference of males vs. females with a t-test.
   
For question (8) and (9), don't just give to p-values; give informative summary of existing differences (e.g., means ± standard deviation, standardized means difference), if any.
   
### References   

Frisby J and Clatworthy J (1975). "Learning to see complex random-dot
steregrams." _Perception_, *4*, pp. 173-178.

Schmitt MC (1987). _The Effects on an Elaborated Directed Reading
Activity on the Metacomprehension Skills of Third Graders_. PhD thesis,
Purdue University.

Tramo M, Loftus W, Green R, Stukel T, Weaver J and Gazzaniga M (1998).
"Brain Size, Head Size, and IQ in Monozygotic Twins." _Neurology_,
*50*, pp. 1246-1252.

