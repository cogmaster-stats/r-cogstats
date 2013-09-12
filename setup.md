


## R setup

You should already have R and RStudio. If they are not installed on your
system, please follow these instructions:

1. Go to <http://cran.r-project.org/bin/> and select a binary package for
   your system. 
2. Go to <http://www.rstudio.com/ide/download> and download RStudio
   Desktop. There is often a
   [Preview Release](http://www.rstudio.com/ide/download/preview) that
   include additional functionalities but is still considered in beta
   stage. 

Install both software as is usually done on your system. At this point, you
may want to test that everything is ok: Launch RStudio and check that the R
prompt is available in the *Console* panel (it is usually sitting on the
right). You can further check that R is working as expected by typing
(without the prompt sign, `>`)

    > 1/3 == 0.3

at the R prompt. Don't worry if the result (`FALSE`) doesn't match your
expectation, we will learn why later.

You can customize RStudio layout under File ▹ Preferences. We will make
extensive use of the
[R Markdown](http://www.rstudio.com/ide/docs/authoring/using_markdown)
language to document our working sessions. You don't need to install
anything at this point, but you may want to install
[Pandoc](http://johnmacfarlane.net/pandoc/), which is a tool for converting
among markup formats and generate HTML or PDF documents based on a Markdown
file. As an alternative to RStudio built-in facilities, you can install an
enhanced Markdwon processor:
[MultiMarkdown](http://fletcherpenney.net/multimarkdown/). 


## Pick up a good editor

Sometimes, it is easier to work directly from a text editor. There are
several good editors available for free and working on all platforms
(Windows, Un*x, and OS X), including these ones:

* [Emacs](http://www.gnu.org/s/emacs/); the
  [ESS mode](http://ess.r-project.org/) provides everything you need to
  interact with R.
* [Vim](http://vim.org/); the
  [Vim-R-plugin](http://www.vim.org/scripts/script.php?script_id=2628)
  offers allows communicating with an R process directly.
* [Sublime Text](http://www.sublimetext.com/2) 2 or 3 (free for evaluation purpose,
  $70 for continued use); syntax highlighting for R is already available,
  and the [SublimeREPL](http://sublimerepl.readthedocs.org/en/latest/)
  package also allows communicating with an R process.


## Git setup

If [Git](http://git-scm.com/) is not already installed on your system, go
download the latest version of Git. When installation is completed, check
that it is available on your system by typing (again, without the prompt
sign, `$`)

    $ git --version

in a Terminal. Windows users will need to install an Un*x-compliant
shell, e.g. [Cygwin](http://www.cygwin.com/) or ??

You can request an [educational account](https://github.com/edu) on
Github. This will allow you to create private repositories that you can use
for your course work. Or you can create an account on
[BitBucket](https://bitbucket.org/), which offers unlimited private
repositories for personal use.


## Miscellanies

Should you want to publish your R code in the cloud, you can register on
<http://rpubs.com>, which is smoothly integrated to RStudio.
