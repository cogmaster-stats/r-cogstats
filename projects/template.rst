Project xxx: Short title goes here
==============================================================

:Author: Author
:Date: Today

A summary of reStructuredText (reST) syntax can be found on the
`docutils <http://docutils.sourceforge.net/rst.html>`_ website (to install
``docutils``, just type ``pip install -U docutils`` or ``easy_install -U
docutils`` in a Python shell). A comparison of Markdown and reST syntax can
be found on `Pandoc Markdown and ReST Compared <http://goo.gl/NS2kUu>`_. The
syntax is close to R Markdown (in fact, more to that of Sweave), except that
code chinks are delimited by ``<<>>= (...) @`` instead of `````{r} (...)
````` blocks.

To compile this document, you can use the following command at a shell
prompt:

::

    Pweave -f rst --figure-directory=_static template.Pnw
    rst2html template.rst > template.html

You will probably have to install `Pweave <http://mpastell.com/pweave/>`_ as
described on the main website (``easy_install -U Pweave``). In case
``rst2html`` is not available on your system, try ``rst2html.py`` instead.

Importing data
--------------

The following Python code is based on the **first project**. 

Without further option, the following code chunk will be printed and
executed. The ``term = True`` option allow to display Python Input and
Output. 


>>> import pandas.rpy.common as com
>>> filename = "01-weights.sav"
>>> w = com.robj.r('foreign::read.spss("%s", to.data.frame=TRUE)' % filenam
e)
>>> w = com.convert_robj(w)
>>> w.head()
     ID  WEIGHT  LENGTH  HEADC  GENDER  EDUCATIO              PARITY
1  L001    3.95    55.5   37.5  Female  tertiary  3 or more siblings
2  L003    4.63    57.0   38.5  Female  tertiary           Singleton
3  L004    4.75    56.0   38.5    Male    year12          2 siblings
4  L005    3.92    56.0   39.0    Male  tertiary         One sibling
5  L006    4.56    55.0   39.5    Male    year10          2 siblings





The following chunk will, however, not be displayed, but expressions will be
evaluated and results available for later use.



Overview
--------

Here is a brief sketch of the data, number and type of variables, number of
observations, etc.

Formatted tables can be created by enclosing instructions in a code chunk
and adding a ``csv-table`` directive just before the code chunk.

.. csv-table::
   :header: "value", "square"

   0 , 0
   1 , 2
   2 , 4
   3 , 6
   4 , 8
   5 , 10
   6 , 12
   7 , 14
   8 , 16
   9 , 18



Figures are displayed easily too, and there are various custom settings that
can be used, see the Pweave `Code Chunks Options
<http://mpastell.com/pweave/usage.html#code-chunk-options>`_. 

::

    # example from http://matplotlib.org/users/pyplot_tutorial.html
    import numpy as np
    import matplotlib.pyplot as plt
    
    mu, sigma = 100, 15
    x = mu + sigma * np.random.randn(10000)
    
    # the histogram of the data
    n, bins, patches = plt.hist(x, 50, normed=1, facecolor='g', alpha=0.75)
    
    plt.xlabel('Smarts')
    plt.ylabel('Probability')
    plt.title('Histogram of IQ')
    plt.text(60, .025, r'$\mu=100,\ \sigma=15$')
    plt.axis([40, 160, 0, 0.03])
    plt.grid(True)
    plt.show()
    
    

.. image:: _static/template_figure4_1.png
   :width: 450




Finally, external figures can be included using standard reST syntax:
``.. image:: filename``.

.. image:: ./ens.jpg