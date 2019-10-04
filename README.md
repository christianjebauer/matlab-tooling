# MATLAB Tooling

A collection of useful functions and scripts that make working with MATLAB a breeze and even more efficient.

Care to know what this package is providing? Check out the [list of functions](FUNCTIONS.md) giving you a quick overview of all the functions available.

## Getting Started

The simplest and quickets way to getting started is by cloning this repository and then running the following MATLAB code

```matlab
p = projpath(); addpath(p{:}); startup();
```

What this will do is

1. Get the path definitions for the project from `projpath()` as a cell array
2. Add the paths required to use this project using MATLAB's built-in `addpath()` method
3. Start the project by running some startup configurations defined in the `startup()` function

That's it. You are now officially all set to use any of the functions defind in the [list of functions](FUNCTIONS.md). Happy efficiency.

## Most Used Functions

Here's a list of the top 10 of the most used functions according to heavy MATLAB user @philipp.tempel

### Data Science

Most used functions/methods inside methods when dealing with data.

1. `ascol`/`asrow`
2. `tspan`
3. `fullpath`
4. `funcnew`
5. `closest`
6. `datestr8601`
7. `progressbar`
8. `bbox`/`bbox3`
9. `evec`/`evec3`
10. `loglim`
11. `w2f`/`f2w`
12. `r2h`/`h2r`
13. `restart`

### Data Visualization

Most used methods for data visualization and data import/export

1. `anim2d`
2. `uslinestyles`
3. `usdistcolors`
4. `uslayout`
5. `distinguishableColors`
6. `plot_cyclelinestyles`
7. `plot_markers`
8. `ruler`
9. `csv2tcscope`

## Guides

* [Typesetting of MATLAB data in LaTeX documents](guides/matlab-array-typesetting.md)

## Comments

### On notation of matrices (aka. **row/column issue**)

I like to think of MATLAB dealing with the row/column issue as saying that columns contain different variables, and rows contain different observations of those variables. Thus, the rows might be different observations in time of three different temperatures, which are represented in columns A, B, and C. This is consistent with MATLAB's behaviour for sum, mean, etc., which produce "the sum of all my observations for each variable".

### On `numel` vs `length`

IMHO from a code readability viewpoint, `length` should be used on one-dimensional arrays. It is about "intentional programming", you see the code and understand what programmer had in mind when conceiving his work. So when I see `numel` I know it is used on a matrix.
@see https://stackoverflow.com/questions/3119739/difference-between-matlabs-numel-and-length-functions
