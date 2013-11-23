<!--- Time-stamp: <2013-11-23 20:48:50 chl> -->

<!--- To generate HTML output:
library(knitr)
library(markdown)
knit("hmisc.rmd")
markdownToHTML("hmisc.md", "hmisc.html", stylesheet = "styles.css")
-->





# The Hmisc and rms packages

The [Hmisc][1] and [rms][2] packages provide a wide range of tools for data
transformation, aggregated visual and numerical summaries, and enhanced R's
output for most common biostatistical models (linear regression, logistic or
Cox regression).


## Data preparation

Text-based data file (comma- or tab-delimited files) can be imported using
`read.csv()` or the more generic command `read.table()`. The [foreign][3]
package can be used to process binary data files from other statistical
packages. See also [R Data Import/Export][4]. `Hmisc` offers extended
support for foreign data files, including CSV (`csv.get()`), SAS
(`sas.get()`), SPSS (`spss.get()`), or Stata (`stata.get()`). Variables
names are automatically converted to lowercase, dates are generally better
handled. Documentation and additional information on the
[Hmisc website][5]. Various dataset can be download from a
[public repository][6] via the `getHdata()` command.

As always, before using any package in R, it must be loaded first:

```r
library(Hmisc)
## help(package = Hmisc)
```


In what follows, we will be using `birthwt` data set from the `MASS`
package. The low birth weight study is one of the datasets used throughout
Hosmer and Lemeshow's textbook on Applied Logistic Regression (2000, Wiley,
2nd ed.). The goal of this prospective study was to identify risk factors
associated with giving birth to a low birth weight baby (weighing less than
2,500 grams). Data were collected on 189 women, 59 of which had low birth
weight babies and 130 of which had normal birth weight babies. Four
variables which were thought to be of importance were age, weight of the
subject at her last menstrual period, race, and the number of physician
visits during the first trimester of pregnancy. It can be loaded as shown
below:

```r
data(birthwt, package = "MASS")
## help(birthwt)
```


In this data set there is no missing observations, but let introduce
some `NA` values. Note that variable names are relatively short and poorly
informative. Shorter names are, however, easy to manipulate with R. `Hmisc`
provides specific command for labeling (`label()`) and adding units of
measurement (`units()`) as additional attributes to a given variable (or
data frame). We will also convert some of the variables as factor with
proper label (rather than 0/1 values) to facilitate reading of summary
tables or subsequent graphics.

```r
birthwt$age[5] <- NA
birthwt$ftv[sample(1:nrow(birthwt), 5)] <- NA
yesno <- c("No", "Yes")
birthwt <- within(birthwt, {
    smoke <- factor(smoke, labels = yesno)
    low <- factor(low, labels = yesno)
    ht <- factor(ht, labels = yesno)
    ui <- factor(ui, labels = yesno)
    race <- factor(race, levels = 1:3, labels = c("White", "Black", "Other"))
    lwt <- lwt/2.2  ## weight in kg
})
label(birthwt$age) <- "Mother age"
units(birthwt$age) <- "years"
label(birthwt$bwt) <- "Baby weight"
units(birthwt$bwt) <- "grams"
label(birthwt, self = TRUE) <- "Hosmer & Lemeshow's low birth weight study."
list.tree(birthwt)  ## equivalent to str(birthwt)
```

```
##  birthwt = list 10 (24584 bytes)( data.frame )
## .  low = integer 189= category (2 levels)( factor )= No No No No No No ...
## .  age = integer 189( labelled )= 19 33 20 21 NA 21 ...
## . A  label = character 1= Mother age 
## . A  units = character 1= years 
## .  lwt = double 189= 82.727 70.455 47.727 ...
## .  race = integer 189= category (3 levels)( factor )= Black Other White ...
## .  smoke = integer 189= category (2 levels)( factor )= No No Yes Yes Yes ...
## .  ptl = integer 189= 0 0 0 0 0 0 0 0 ...
## .  ht = integer 189= category (2 levels)( factor )= No No No No No No ...
## .  ui = integer 189= category (2 levels)( factor )= Yes No No Yes Yes ...
## .  ftv = integer 189= 0 3 1 2 0 0 1 1 ...
## .  bwt = integer 189( labelled )= 2523 2551 2557 2594 ...
## . A  label = character 1= Baby weight 
## . A  units = character 1= grams 
## A  row.names = character 189= 85 86 87 88 89 91 92  ... 
## A  label = character 1= Hosmer & Lemeshow's lo
```


The `contents()` command offers a quick summary of data format and missing
values, and it provides a list of labels associated to variables treated as
factor by R.

```r
contents(birthwt)
```

```
## 
## Data frame:birthwt	189 observations and 10 variables    Maximum # NAs:5
## 
##            Labels Units Levels Storage NAs
## low                          2 integer   0
## age    Mother age years        integer   1
## lwt                             double   0
## race                         3 integer   0
## smoke                        2 integer   0
## ptl                            integer   0
## ht                           2 integer   0
## ui                           2 integer   0
## ftv                            integer   5
## bwt   Baby weight grams        integer   0
## 
## +--------+-----------------+
## |Variable|Levels           |
## +--------+-----------------+
## |  low   |No,Yes           |
## |  smoke |                 |
## |  ht    |                 |
## |  ui    |                 |
## +--------+-----------------+
## |  race  |White,Black,Other|
## +--------+-----------------+
```


Another useful command is `describe()`, which gives detailed summary
statistics for each variable in a given data frame. It can be printed as
HTML, or as PDF (by using the `latex()` backend), and in the latter case
small graphics are added that depict distribution of continuous variables.

```r
describe(birthwt, digits = 3)
```

```
## birthwt 
## 
##  10  Variables      189  Observations
## ------------------------------------------------------------------------------------------
## low 
##       n missing  unique 
##     189       0       2 
## 
## No (130, 69%), Yes (59, 31%) 
## ------------------------------------------------------------------------------------------
## age : Mother age [years] 
##       n missing  unique    Mean     .05     .10     .25     .50     .75     .90     .95 
##     188       1      24    23.3      16      17      19      23      26      31      32 
## 
## lowest : 14 15 16 17 18, highest: 33 34 35 36 45 
## ------------------------------------------------------------------------------------------
## lwt 
##       n missing  unique    Mean     .05     .10     .25     .50     .75     .90     .95 
##     189       0      75      59    42.9    45.3    50.0    55.0    63.6    77.3    85.5 
## 
## lowest :  36.4  38.6  40.5  40.9  41.4, highest:  97.7 104.1 106.8 109.5 113.6 
## ------------------------------------------------------------------------------------------
## race 
##       n missing  unique 
##     189       0       3 
## 
## White (96, 51%), Black (26, 14%), Other (67, 35%) 
## ------------------------------------------------------------------------------------------
## smoke 
##       n missing  unique 
##     189       0       2 
## 
## No (115, 61%), Yes (74, 39%) 
## ------------------------------------------------------------------------------------------
## ptl 
##       n missing  unique    Mean 
##     189       0       4   0.196 
## 
## 0 (159, 84%), 1 (24, 13%), 2 (5, 3%), 3 (1, 1%) 
## ------------------------------------------------------------------------------------------
## ht 
##       n missing  unique 
##     189       0       2 
## 
## No (177, 94%), Yes (12, 6%) 
## ------------------------------------------------------------------------------------------
## ui 
##       n missing  unique 
##     189       0       2 
## 
## No (161, 85%), Yes (28, 15%) 
## ------------------------------------------------------------------------------------------
## ftv 
##       n missing  unique    Mean 
##     184       5       6   0.799 
## 
##            0  1  2 3 4 6
## Frequency 97 46 29 7 4 1
## %         53 25 16 4 2 1
## ------------------------------------------------------------------------------------------
## bwt : Baby weight [grams] 
##       n missing  unique    Mean     .05     .10     .25     .50     .75     .90     .95 
##     189       0     131    2945    1801    2038    2414    2977    3487    3865    3997 
## 
## lowest :  709 1021 1135 1330 1474, highest: 4167 4174 4238 4593 4990 
## ------------------------------------------------------------------------------------------
```


Of course, it is also possible to describe only a subset of the data or
specific data.

```r
describe(subset(birthwt, select = c(age, race, bwt, low)))
```


`Hmisc` has several helper functions to work with categorical variables,
like `dropUnusedLevels()` to remove missing levels or `Cs()` to convert
unquoted list of variables names to characters. It also provides a
replacement for R's `cut()` function with better default options (especially
the infamous `include.lowest=FALSE`) to discretize a continuous
variable. Here are some examples of use:

```r
table(cut2(birthwt$lwt, g = 4))
```

```
## 
## [36.4, 50.9) [50.9, 55.5) [55.5, 64.1) [64.1,113.6] 
##           53           43           46           47
```

```r
table(cut2(birthwt$age, g = 3, levels.mean = TRUE))
```

```
## 
## 18.074 23.091 30.019 
##     68     66     54
```


Using `levels.mean=TRUE` will return class center, instead of class
intervals.

There are also a bunch of command dedicated to variables clustering,
analysis of missing patterns, or simple (`impute()`) or multiple
(`aregImpute()`, `transcan()`) imputation methods. Here is how we would
impute missing values with the median in the case of a continuous variable: 

```r
lwt <- birthwt$lwt
lwt[sample(length(lwt), 10)] <- NA
lwt.i <- impute(lwt)
summary(lwt.i)
```

```
## 
##  10 values imputed to 55.45
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    36.4    50.0    55.5    59.1    63.6   114.0
```


Missing observations will be marked with an asterisk when we print the whole
object in R. To use the mean instead of the median, we just have to add the
`fun=mean` option.



## Visual and numerical summaries

There are three useful commands that provide summary statistics for a list of
variable. The first one, `summarize()`, can be seen as an equivalent to R's
`aggregate()` command. Given a response variable and one or more
classification factors, it applies a specific function to all data chunk,
where each chunk is defined based on factor levels. The results are stored
in a matrix, which can easily be coerced to a data frame (`as.data.frame()`
or `Hmisc::matrix2dataFrame()`).


```r
f <- function(x, na.opts = TRUE) c(mean = mean(x, na.rm = na.opts), sd = sd(x, na.rm = na.opts))
out <- with(birthwt, summarize(bwt, race, f))
prn(out, "Average baby weight by ethnicity")
```

```
## 
## Average baby weight by ethnicity   out
## 
##    race  bwt    sd
## 3 White 3103 727.9
## 1 Black 2720 638.7
## 2 Other 2805 722.2
```


Contrary to `aggregate()`, this command provides multiway data structure in
case we ask to compute more than one quantity, as the following command will
confirm: 

```r
dim(out)  ## should have 3 columns
```

```
## [1] 3 3
```

```r
dim(aggregate(bwt ~ race, data = birthwt, f))
```

```
## [1] 3 2
```


Summarizing multivariate responses or predictors is also possible, with
either `summarize()` or `mApply()`. Of course, any built-in functions, such
as `colMeans()` could be used in place of our custom summary command.

```r
with(birthwt, summarize(bwt, llist(race, smoke), f))
```

```
##    race smoke  bwt    sd
## 5 White    No 3429 710.1
## 6 White   Yes 2827 626.5
## 1 Black    No 2854 621.3
## 2 Black   Yes 2504 637.1
## 3 Other    No 2816 709.3
## 4 Other   Yes 2757 810.0
```

```r
with(birthwt, mApply(cbind(bwt, lwt), llist(race, smoke), colMeans))
```

```
##       bwt   lwt
## [1,] 3429 63.11
## [2,] 2854 67.93
## [3,] 2816 54.16
## [4,] 2827 57.41
## [5,] 2504 64.82
## [6,] 2757 56.36
```


The second command, `bystats()`, (or `bystats2()` for two-way tabular
output) allows to describe with any custom or built-in function one or
multiple outcome by two explanatory variables, or even more. Sample size and
the number of missing values are also printed.

```r
with(birthwt, bystats(cbind(bwt, lwt), smoke, race))
```

```
## 
##  Mean of cbind(bwt, lwt) by smoke 
## 
##             N  bwt   lwt
## No White   44 3429 63.11
## Yes White  52 2827 57.41
## No Black   16 2854 67.93
## Yes Black  10 2504 64.82
## No Other   55 2816 54.16
## Yes Other  12 2757 56.36
## ALL       189 2945 59.01
```

```r
with(birthwt, bystats2(lwt, smoke, race))
```

```
## 
##  Mean of lwt by smoke 
## 
## +----+
## |N   |
## |Mean|
## +----+
## +---+-----+-----+-----+-----+
## |No | 44  | 16  | 55  |115  |
## |   |63.11|67.93|54.16|59.50|
## +---+-----+-----+-----+-----+
## |Yes| 52  | 10  | 12  | 74  |
## |   |57.41|64.82|56.36|58.24|
## +---+-----+-----+-----+-----+
## |ALL| 96  | 26  | 67  |189  |
## |   |60.02|66.73|54.55|59.01|
## +---+-----+-----+-----+-----+
```


The third and last command is `summary.formula`()`, which can be abbreviated
as `summary()` as long as formula is used to describe variables
relationships.

Here are some examples of use.

```r
summary(bwt ~ race + ht + lwt, data = birthwt)
```

```
## Baby weight    N=189
## 
## +-------+------------+---+----+
## |       |            |N  |bwt |
## +-------+------------+---+----+
## |race   |White       | 96|3103|
## |       |Black       | 26|2720|
## |       |Other       | 67|2805|
## +-------+------------+---+----+
## |ht     |No          |177|2972|
## |       |Yes         | 12|2537|
## +-------+------------+---+----+
## |lwt    |[36.4, 50.9)| 53|2656|
## |       |[50.9, 55.5)| 43|3059|
## |       |[55.5, 64.1)| 46|3075|
## |       |[64.1,113.6]| 47|3038|
## +-------+------------+---+----+
## |Overall|            |189|2945|
## +-------+------------+---+----+
```

```r
summary(cbind(lwt, age) ~ race + bwt, data = birthwt, method = "cross")
```

```
## 
##  mean by race, bwt 
## 
## +-------+
## |N      |
## |Missing|
## |lwt    |
## |age    |
## +-------+
## +-----+-----------+-----------+-----------+-----------+-----+
## | race|[ 709,2424)|[2424,3005)|[3005,3544)|[3544,4990]| ALL |
## +-----+-----------+-----------+-----------+-----------+-----+
## |White|    19     |    23     |    20     |    33     | 95  |
## |     |   0       |   1       |   0       |   0       |1    |
## |     |   55.55   |   57.67   |   62.23   |   63.25   |60.14|
## |     |   22.74   |   24.78   |   24.50   |   24.91   |24.36|
## +-----+-----------+-----------+-----------+-----------+-----+
## |Black|     9     |     9     |     6     |     2     | 26  |
## |     |   0       |   0       |   0       |   0       |0    |
## |     |   65.10   |   59.70   |   70.83   |   93.41   |66.73|
## |     |   23.44   |   20.89   |   20.00   |   20.50   |21.54|
## +-----+-----------+-----------+-----------+-----------+-----+
## |Other|    20     |    16     |    19     |    12     | 67  |
## |     |   0       |   0       |   0       |   0       |0    |
## |     |   51.23   |   52.95   |   58.90   |   55.34   |54.55|
## |     |   22.20   |   22.69   |   22.26   |   22.50   |22.39|
## +-----+-----------+-----------+-----------+-----------+-----+
## |ALL  |    48     |    48     |    45     |    47     |188  |
## |     |   0       |   1       |   0       |   0       |1    |
## |     |   55.54   |   56.48   |   61.97   |   62.51   |59.06|
## |     |   22.65   |   23.35   |   22.96   |   24.11   |23.27|
## +-----+-----------+-----------+-----------+-----------+-----+
```

```r
summary(low ~ race + ht, data = birthwt, fun = table)
```

```
## low    N=189
## 
## +-------+-----+---+---+---+
## |       |     |N  |No |Yes|
## +-------+-----+---+---+---+
## |race   |White| 96| 73|23 |
## |       |Black| 26| 15|11 |
## |       |Other| 67| 42|25 |
## +-------+-----+---+---+---+
## |ht     |No   |177|125|52 |
## |       |Yes  | 12|  5| 7 |
## +-------+-----+---+---+---+
## |Overall|     |189|130|59 |
## +-------+-----+---+---+---+
```

```r
out <- summary(low ~ race + age + ui, data = birthwt, method = "reverse", overall = TRUE)
print(out, prmsd = TRUE, digits = 2)
```

```
## 
## 
## Descriptive Statistics by low
## 
## +------------------+---+---------------------------+---------------------------+---------------------------+
## |                  |N  |No                         |Yes                        |Combined                   |
## |                  |   |(N=130)                    |(N=59)                     |(N=189)                    |
## +------------------+---+---------------------------+---------------------------+---------------------------+
## |race : White      |189|          56% (73)         |          39% (23)         |          51% (96)         |
## +------------------+---+---------------------------+---------------------------+---------------------------+
## |    Black         |   |          12% (15)         |          19% (11)         |          14% (26)         |
## +------------------+---+---------------------------+---------------------------+---------------------------+
## |    Other         |   |          32% (42)         |          42% (25)         |          35% (67)         |
## +------------------+---+---------------------------+---------------------------+---------------------------+
## |Mother age [years]|188|19.0/23.0/28.0  23.7+/- 5.6|19.5/22.0/25.0  22.3+/- 4.5|19.0/23.0/26.0  23.3+/- 5.3|
## +------------------+---+---------------------------+---------------------------+---------------------------+
## |ui : Yes          |189|         11% ( 14)         |         24% ( 14)         |         15% ( 28)         |
## +------------------+---+---------------------------+---------------------------+---------------------------+
```


Note also that tabular output can be converted to graphical displays by
using `plot()` like in, e.g.,


```r
plot(out)
```

![plot of chunk plot.summary](figure/plot_summary1.png) ![plot of chunk plot.summary](figure/plot_summary2.png) 


`Hmisc` provides replacement for some [lattice][7] commands, in particular
`xYplot()` and `dotchart2()`.


## Model fitting and diagnostic

[1]: http://cran.r-project.org/web/packages/Hmisc
[2]: http://cran.r-project.org/web/packages/rms
[3]: http://cran.r-project.org/web/packages/foreign
[4]: http://cran.r-project.org/doc/manuals/r-release/R-data.html
[5]: http://biostat.mc.vanderbilt.edu/wiki/Main/Hmisc
[6]: http://biostat.mc.vanderbilt.edu/wiki/Main/DataSets
[7]: http://cran.r-project.org/web/packages/lattice


<!---
Ces étiquettes peuvent ensuite être associées automatiquement dans les
tableaux, graphiques ou résumés produits par \texttt{Hmisc}. La commande
\verb|describe| fournit une synthèse descriptive de l'ensemble des variables
d'un \verb|data.frame| ou d'une liste de variables, à l'image d'un \og
codebook\fg. 
<<>>=
@ 


\subsection*{Statistiques descriptives}
La commande \verb|summarize| fonctionne sur le même principe que
\verb|aggregate| et permet de fournir pour une variable
numérique des résumés stratifiés selon une ou plusieurs variables
qualitatives. À la différence de \verb|aggregate|, il est possible de
calculer plusieurs statistiques et de les stocker dans des colonnes
différents d'un même tableau de résultats (\verb|aggregate| stocke en fait
tous ses résultats dans une seule et même colonne, ce qui n'est pas gênant
pour l'affichage mais ne facilite pas l'exploitation des résultats).
<<>>=
f <- function(x) c(mean=mean(x), sd=sd(x))
with(birthwt, summarize(bwt, race, f))
@ 

La commande \verb|summary| (en fait, \verb|summary.formula|) peut s'utiliser
avec une notation par formule décrivant les relations entre plusieurs
variables. On distingue trois principales méthodes (\verb|method=|) :
\verb|"response"|, où l'on résume une variable numérique selon les niveaux
d'une ou plusieurs variables (dans le cas de variables numériques,
\texttt{Hmisc} recodera automatiquement la variable en 4 classes
équilibrées), \verb|"cross"| pour calculer moyennes conditionnelles et
marginales d'une ou plusieurs variables réponse en fonction de variables
qualitatives ou numériques (3 au maximum), et \verb|"reverse"| pour résumer
de manière univariée un ensemble de variables numériques (trois quartiles)
ou qualitatives (effectif et proportion) selon les niveaux d'un facteur. La
position des variables par rapport à l'opérateur de liaison \verb|~| de la
formule joue un rôle particulièrement important pour déterminer le type de
résumé à réaliser selon la méthode sélectionnée. Pour les méthodes
\verb|"response"| et \verb|"reverse"|, on peut coupler la commande
\verb|plot| directement avec le résultat renvoyé par \verb|summary| pour
avoir une représentation graphique des résultats. On peut également fournir
une formule et indiquer à \R quelle commande appliquer pour résumer la
structure de données. Par exemple, dans le cas \verb|low ~ race + ht|,
l'option \verb|fun=table| permettra de construire automatiquement les deux
tableaux de contingence correspondant au croisement des variables
\texttt{low} avec \texttt{race} et \texttt{low} avec \texttt{ht}.

Voici quelques illustrations :
<<>>=
library(Hmisc)
summary(bwt ~ race + ht + lwt, data=birthwt)
summary(cbind(lwt, age) ~ race + bwt, data=birthwt, method="cross")
summary(low ~ race + age + ui, data=birthwt, method="reverse", overall=TRUE)
summary(low ~ race + ht, data=birthwt, fun=table)
plot(summary(bwt ~ race + ht + lwt, data=birthwt))
@ 

Lorsque l'on utilise \verb|method="reverse"|, il est possible d'ajouter
l'option \verb|test=TRUE| pour obtenir automatiquement un test de
comparaison de moyenne ou de fréquence entre les groupes définis par la
variable de stratification. Il est également possible d'exporter
automatiquement les tableaux produits au format \LaTeX ou PDF.

\subsection*{Commandes graphiques}
Le package \texttt{Hmisc} repose pour l'essentiel sur les graphiques
\texttt{lattice}, mais il fournit des commandes \og plus intégrées\fg. Parmi
les commandes graphiques fournies par \texttt{Hmisc}, on distingue les
diagrammes en points (\verb|Dotplot| et \verb|dotchart2|), les diagrammes en
boîtes à moustaches (\verb|panel.bpplot| à utiliser avec la commande usuelle
\verb|bwplot|) et les diagrammes de dispersion (\verb|xyplot|). On se
contentera de présenter un exemple pour ce dernier cas.

<<>>=
f <- function(x) c(mean(x), mean(x) + c(-1, 1) * sd(x)/sqrt(length(x)))
bwtmeans <- with(birthwt, summarize(bwt, llist(race, smoke), f))
names(bwtmeans)[4:5] <- c("lwr", "upr")
bwtmeans
xYplot(Cbind(bwt, lwr, upr) ~ numericScale(race, label="Ethnicité de la mère") | smoke,
       data=bwtmeans, type="b", ylim=c(2200, 3600),
       scales=list(x=list(at=1:3, labels=levels(birthwt$race))))
@
On notera que \verb|Cbind| prend un \og c\fg\ majuscule, pour différencier
cette commande de la commande de base, et que si elle existe l'étiquette de
la variable remplace automatiquement le nom de la variable (c'est le cas ici
pour la variable \texttt{bwt}). Il est également possible de libeller
automatiquement les diféfrentes courbes, segments ou points définis par une
variable de conditionnement à l'aide de l'option \verb|keys=|, comme dans
l'exemple suivant.
<<eval=FALSE>>=
xYplot(Cbind(bwt, lwr, upr) ~ numericScale(race), groups= smoke,
       data=bwtmeans, type="l", keys="lines")
@ 


\section*{Les commandes essentielles de rms}
Pour utiliser les commandes du package \texttt{rms}, on chargera au
préalable le package à l'aide de la commande \verb|library|. Notons que ce
package charge automatiquement le package \texttt{Hmisc}.
<<>>=
library(rms)
@ 

Pour la régression linéaire, il s'agit de la commande \verb|ols|. Le
principe d'utilisation reste le même que pour la commande \verb|lm| : on
spécifie à l'aide d'une formule le rôle de chaque variable (variable réponse
\verb|~| variables explicatives) et le \verb|data.frame| dans lequel
chercher les données. Dans son usage le plus simple, on se contente
d'afficher les résultats renvoyés par \verb|ols| avec la commande
\verb|print| ou en tapant simplement le nom de la variable auxiliaire dans
laquelle on a stocké les résultats du modèle. Pour obtenir des informations
additionnelles, en particulier concernant les effets marginaux, les résidus
du modèle, et profiter de fonctionnalités graphiques étendues, il est
nécessaire d'utiliser la commande \verb|datadist| pour stocker les
prédicteurs du modèle dans une structure à part. On disposera alors de 
commandes telles que \verb|summary| ou \verb|plot|.

\paragraph{Exemple.} Modélisation du poids des bébés en fonction de
différents indicateurs de risque chez la mère.
<<>>=
m <- ols(bwt ~ age + lwt + race + ftv, data=birthwt, x=TRUE)
m
@ 

Pour la régression logistique (simple, multiple ou ordinale), on utilise la
commande \verb|lrm|. Cette commande choisit automatiquement le modèle selon
le nombre de niveaus de la variable réponse : dans le cas où il y en a plus
de deux, un modèle à odds proportionnels est utilisé.

% clean-up
<<echo=FALSE>>=
rm(list=ls())
data(birthwt, package="MASS")
birthwt <- within(birthwt, {
  low <- factor(low, labels=c("No","Yes"))
  race <- factor(race, labels=c("White","Black","Other"))
  smoke <- factor(smoke, labels=c("No","Yes"))
  ui <- factor(ui, labels=c("No","Yes"))
  ht <- factor(ht, labels=c("No","Yes"))
})
@

\paragraph{Exemple.} Modélisation du poids des bébés (0/1) en fonction des
mêmes variables explicatives.
<<eval=FALSE>>=
ddist <- datadist(birthwt)
options(datadist='ddist')             
m <- lrm(low ~ age + lwt + race + ftv, data=birthwt)
print(m)
summary(m)
m2 <- update(m, . ~ . - age - ftv)
lrtest(m2, m)
anova(m2)
pm2 <- Predict(m2, lwt=seq(80, 250, by=10), race)
print(xYplot(Cbind(yhat,lower,upper) ~ lwt | race, data=pm2,
             method="filled bands", type="l", col.fill=gray(.95)))
@

\centerline{\includegraphics[width=0.5\textwidth]{lwb-fig14}}
\vskip1.5em

Enfin, pour la régression de Cox, il s'agit de la commande \verb|cph|. La
représentation des données de survie passe toujours par une étape préalable
de conversion avec la commande \verb|Surv|.


\section*{Pour aller plus loin}
Il existe un très bon tutoriel sur \verb|Hmisc| (anciennement
\verb|Design|), \emph{An Introduction to S and the Hmisc and Design Libraries; CF
Alzola and FE Harrell} (PDF, 310 pages), disponible à l'adresse suivante :
\url{http://biostat.mc.vanderbilt.edu/Hmisc}. On y trouvera également
d'autres resources documentaires. 

La référence bibliographique concernant le package \verb|rms| est :
\begin{quote}
  Harrell, F.E., Jr (2001). \emph{Regression Modeling Strategies, With
  Applications to Linear Models, Logistic Regression, and Survival Analysis.}
  Springer. (600 pages)
\end{quote}
Le cours en ligne suivant repose cet ouvrage et fournit l'essentiel des
idées dans un document PDF :
\url{http://biostat.mc.vanderbilt.edu/wiki/Main/CourseBios330}. Le livre
\emph{Clinical Prediction Models} de E.W. Steyerberg repose en partie sur le
package \verb|rms| et constitue un bon complément à l'ouvrage ci-dessus. Le
site companion du livre est : \url{http://www.clinicalpredictionmodels.org}.
-->
