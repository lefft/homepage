in this folder you'll find:

- `week3_script.r` -- an R file with some code in it that you can run interactively to practice; 
- `week3_script.html` -- a browser-viewable version of the script, including the output you should be getting if you run the script yourself;

- `README.md` -- this file; 
- `README.html` -- a browser-viewable version of this file; 

- `output/` -- an empty directory that stuff will get saved to as you run lines of `week3_script.r`; and

- `datasets/` -- a folder containing GSS datasets:
    + `datasets/gss_2012_test.csv` -- 2012 GSS sample data
    + `datasets/gss_2014_test.csv` -- 2014 GSS sample data
    + `datasets/gss_2016_test.csv` -- 2016 GSS sample data
    + `datasets/gss_complete_test.csv` -- all three years combined
    + `datasets/gss_codebook-raw.txt` -- correspondence between numeric codes and categories they correspond to
    + `datasets/lookup_income.csv` -- a .csv table that you'll read in in week3_script.r to modify the "income" columns of the GSS sample dataset you're looking at
    + `datasets/lookup_race.csv` -- a .csv table that you'll read in in week3_script.r to modify the "race" columns of the GSS sample dataset you're looking at.

**note**: to make sure your directory situation is ready to roll, take the following steps:

- close R Studio (if it's already open)
- go to the unzipped `week3_materials/` folder
- open the file `week3_script.r` (just double click if R Studio is the default program for `.r` files; otherwise right-click and "open with" R Studio)
- you can check your directory with `getwd()` once R Studio is fired up!

if you have problems, try checking through the week 1 notes and slides on [the course page](http://lefft.xyz/r_minicourse)


