<div>
    <img src="images/emlyon.png" style="height:60px; float:left; padding-right:10px; margin-top:5px" />
    <span>
        <h1 style="padding-bottom:5px;"> AI Booster Week 02 - Python for Data Science </h1>
        <a href="https://masters.em-lyon.com/fr/msc-in-data-science-artificial-intelligence-strategy">[Emlyon]</a> MSc in Data Science & Artificial Intelligence Strategy (DSAIS) <br/>
         Paris | © Antoine SCHERRER
    </span>
</div>

Please make sure you have a working installation of Jupyter Notebook / Jupyter Lab, with Python 3.6+ up and running.

## Naming conventions

Since we will implement functions that are already available in python standard library or other libraries, you will have to *prefix* every function with `msds_` prefix.

For instance, the function implementing the `mean` function should be named `msds_mean`.

For every function you write, **you will need to write a test function** that should be named `test_[function_name]`.

For instance, the test function for `msds_mean` will be: `test_msds_mean`.

**don't forget to document all you function with Python docstring**

For instance:
```
def msds_my_awesome_function():
    """
    This function computes an awesome function
    """
    # Awesome code
    ...
```

All function should be in snake case (no Camel case!)

When creating classes, then follow these rules:
 - class names should be in camel case
 - method names should be in snake case
 - attribute names should be in snake case

## Exercise's difficulty

Every exercise will be prefixed with an indication of its difficulty:
 - [easy]: easy exercise, should be pretty straightforward for you
 - [moderate]: intermediate level exercise, you all should manage to solve them
 - [advanced]: for advanced students who want to go deeper/further

**Advanced exercises are not mandatory.**

## Required libraries

These are the libraries we will use (to check our computations for instance), you need to install them in your virtual environment:

 - `pandas`: data manipulation library
 - `scipy`: scientific library in Python
 - `numpy`: vector/matrix computations
 - `statistics`: statistics library
 - `matplotlib`: plotting lib
 - `seaborn`: alternative plotting lib (based on matplotlib)
 - `jupyter_black`: plugin for jupyter to allow `black` (code formatter) to run
 - `unittest`: testing library 


