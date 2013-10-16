Exercises
------------------------------



Data sets used in the following exercises can be found on [Github](https://github.com/cogmaster-stats/r-cogstats/tree/master/data).

### R language and descriptive statistics

1. Consider the following series of data collected on 8 subjects:

        5.4 6.1 6.2 NA 6.2 5.6 19.0 6.3
      
   Store these values in a variable named `x`. It turns out that the 7th observation is inexact and should be considered as a missing value. It is also suggested to replace the two missing values (observations 4 and 7) by the mean computed on the whole sample.
   
2. Create a treatment facteur, `tx`, of size 60, with balanced levels (30 `std` and 30 `new`) organized as follows:

        std std std new new new ... std std std new new new
      
   Replace label `std` with `old`. Then, update this vector so that the sequence of labels starts with `new`, instead of `old` (i.e., swap the two labels of the factor). Finally, intermix the two labels randomly.
   
3. Load the `birthwt` data set from the `MASS` package (`data(birthwt, package="MASS")`), and compute the following quantities:

   a. The relative frequency of history of hypertension (`ht`).  
   b. The average weight of newborns whose mother was smoking (`smoke=1`) during pregnancy but was free of hypertension (`ht=0`).  
   c. The five lowest baby weights for mothers with a weight below the first quartile of maternal weights.
   
   Draw an histogram of baby weights by taking into account the number of previous premature labours. You will consider the follwoing recoding of the `ptl` variable: `ptl2=0` if `ptl=0`, `ptl2=1` when `ptl>0`. Finally, show the distribution of all *numerical* variables as box and whiskers plots.
   
4. Based on the following artificial data of students' heights in two classrooms, indicate if the largest student comes from classroom A or B. Data were generated as follows:

   
   ```r
   d <- data.frame(height = rnorm(40, 170, 10), class = sample(LETTERS[1:2], 40, rep = TRUE))
   d$height[sample(1:40, 1)] <- 220
   ```


5. Load the data included in `lungcancer.txt`. This data file features several coding problems (variables type, missing values, etc.). Inspect these data (e.g., using `summary()`) and suggest appropriate corrections.
