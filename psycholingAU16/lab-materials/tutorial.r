#### HEADER ###################################################################
# === === === === === === === === === === === === === === === === === ===
# tutorial.r
# tim leffel (tjleffel@gmail.com)
# nov16/2016
#   >> this script introduces basic concepts of programming and
#      data analysis using R -- the R Studio GUI is recommended 
#   >> originally written for use in LING/PSYC 27010, fall 2016
#   >> requires package ggplot2::
# === === === === === === === === === === === === === === === === === ===


#### SECTION 0: CONCEPTUAL PRELIMINARIES ######################################
# === === === === === === === === === === === === === === === === === ===
# === === === === === === === === === === === === === === === === === ===

# welcome to your first R script!

# an R script is just a text file with extension ".R" or ".r"

# a "script" is basically just a "program"

# R works with an interpreter, which means that you can *RUN*, aka *EXECUTE*, 
# a single *COMMAND* at a time

# a command is just a line or *BLOCK* of actual code -- in other words,
# a command is just a line or block of a script that doesn't start with '#'

# to run a command is to send it to the interpreter

# lines that start with '#' are called *COMMENTS*, and are intended to be
# interpreted by other humans (or yourself at a later time) -- comments are
# ignored by the interperter if you run the entire script at once

# you'll notice that i start a new line before the text reaches 80 characters
# that is just for good coding etiquette -- we could continue a line indefinitely and nothing bad would happen, except that the line starts wrapping and the script is not as easy to navigate. this is the only line that we will allow to extend beyond 80 characters (even this is making me *shudder*)

# when you run a command, the output (if there's any) will appear 
# in the *CONSOLE*, aka *COMMAND LINE*, which you can see below in RStudio

# now we'll start a *SECTION*, which is not necessary but is good practice
# we just visually separate it using a bunch of meaningless characters like '='


#### SECTION 1: OUR FIRST COMMANDS, AND INSTALLING/LOADING PACKAGES ###########
# === === === === === === === === === === === === === === === === === ===
# === === === === === === === === === === === === === === === === === ===

# let's start with some basic commands

# here is our first command -- *RUN*/*EXECUTE* it with cmd+Enter on Mac, or 
# ctrl+Enter on PC:
3 + 5

# the result should be...*drumroll pls* 

# > 3 + 5
# [1] 8

# the top line is just the command appearing in the command line, preceded
# by the *COMMAND PROMPT SYMBOL* "> "

# the second line indicates that the first element ("[1] ") of the output is "8"

# so the interpreter *RETURNED* the number '8' given the command '5+3'. nice.

# we can do all kinds of mathematical calculations, e.g.
3 + ((1 - (5 * 2)) / (3 ^ 2))

# in R, '+', '-', '/', '*', and '^' are *FUNCTIONS* -- these functions take
# two *ARGUMENTS* which are numbers, and return a third number -- the *VALUE*

# but most functions have a different syntax -- they take their arguments in
# a more function-y notation. for example sqrt() takes one argument and 
# returns the square root of that argument:
sqrt(9) 

# max() and min() can take any number of arguments, and return the 
# highest/lowest of them
max(1, 2, 3, 5, 4, 5, 6, 6, -10)
min(1, 2, 3, 5, 4, 5, 6, 6, -10)

# you can always pull up the help page for a function
# by saying ?<function-name>(). you can search help pages with ??<topic>
?max()
??linguistics

# one of the best things about R is that anyone can contribute helfpul, 
# new user-defined functions and methods

# *PACKAGES* are collections of functions and other stuff that aren't part
# of what automatically comes with R when you install it 

# you should check out the 'languageR' package, which is a companion to the 
# excellent 2007 textbook by Harald Baayen,
# _Analyzing Linguistic Data: A Practical Introduction to Statistics_ 
# (psa: you juuuust might be able to find a bootleg version if you look online)

# if you are using a particular package for the first time, you will
# have to install it, which can be done with install.packages("<package name>")
# note quotes around the name, which are necessary when installing
### install.packages("languageR")

# after a package is installed, you load it with library()
library("languageR") 

# you can see your library -- a list of your *INSTALLED* packages -- by saying
library() # no output in .html version -- don't worry

# you can see which packages are currently *LOADED* with
search()

# we will use some functions from non-base packages in section 6 below


#### SECTION 2: VARIABLES AND ASSIGNMENTS #####################################
# === === === === === === === === === === === === === === === === === ===
# === === === === === === === === === === === === === === === === === ===

# most of the time we don't just want to calculate something, but we want to 
# calculate something and *STORE* the result for later use

# we do this by *ASSIGNING* the result of a command to a *VARIABLE*
# such as 'x' by using the *ASSIGNMENT* operator "=" or "<-"
x = 5 + 3

# it is safer to use "<-" for assignment than "=", but i think "=" is more
# intuitive, so we will use it here (see sec 7 for discussion)


# notice in the upper right pane of RStudio, we can now see 'x' is saved
# we can look at the *VALUE* of the variable 'x'  
# by simply sending 'x' to the interpreter
x

# we can store the results of basically anything in a variable, and
# we can (*and should*) use useful names for variables
biggest <- max(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
biggest

# make sure your variable names don't contain math operators like "-" or "+",
# and make sure they don't start with a number:
# we can name a var 'var1'
var1 = 1 + 1

# but we can't name a var '1stVar' bc it starts with a number
### if we try:    1stVar = 1 + 1
### we will get:  Error: unexpected symbol in "1stVar"

# errors and error messages are annoying but extremely important + useful! 

# to avoid clutter, we can remove vars from the workspace 
# when we are done working w them
rm(var1)
rm(biggest)
rm(x)

# a common mistake is to confuse '=' (assignment) with '==' (equals)
### if we try:    5 + 3 = 8
### we will get:  
###  Error in 5 + 3 = 8 : target of assignment expands to non-language object

# to say what we meant, we would use '=='
5 + 3 == 8
# [1] TRUE



#### SECTION 3: DATA TYPES AND DATA STRUCTURES ################################
# === === === === === === === === === === === === === === === === === ===
# === === === === === === === === === === === === === === === === === ===

# we've done some basic math, which is basically manipulating *NUMBERS*

# but usually we want to do a lot more than that -- 
# we want to manipulate character strings (e.g. words) too. 
# this is made possible by the existence of different *DATA TYPES*

# we can see the type of an object by using
x = 5
class(x)

# let's give x a new value + see its type (character string)
x = "boosh"
class(x)

# logical (true/false; binary) is also a basic data type:
x = TRUE
class(x)

# usually we work with more complicated *DATA STRUCTURES* than strings or nums

# like vectors
vec1 = c("boosh1","boosh2","boosh3")
vec1

# and lists
lis1 = list("boosh1","boosh2","boosh3")
identical(vec1,lis1)
lis1


# but the most important data structure in R is the *DATAFRAME*
df = data.frame(
  col1=letters[1:6],                      # gives us c("a","b","c","d","e","f")
  col2=1:6,                               # same as c(1,2,3,4,5,6)
  col3=rep(c("group1","group2"), times=3) # repeat "group1","group2" thrice
)
# NOTE: argument places have *NAMES*, e.g. the function rep() has an 
#       argument called 'times', which we saturated with 3 above

# a data.frame() is technically just a list of vectors v1,v2,...,vn such that
# length(v1)==length(v2)==...==length(vn)
is.list(df)
# [1] TRUE
is.data.frame(df)
# [1] TRUE

# but you should think of a dataframe as a spreadsheet that contains *DATA*,
# usually where each row is a sequence of facts about a single thing
df
#     col1 col2   col3
#      a    1    group1
#      b    2    group2
#      c    3    group1
#      d    4    group2
#      e    5    group1
#      f    6    group2

# now let's clean up the workspace before moving on 
# (doing this saves memory + can help keep your agenda clear)
# instead of starting a new line, we can indicate the end of a command with ";"
rm(df); rm(lis1); rm(vec1); rm(x)


#### SECTION 4: DATAFRAMES AND READING FILES ##################################
# === === === === === === === === === === === === === === === === === ===
# === === === === === === === === === === === === === === === === === ===

# let's check out the frequency list we used for homework #4
# we'll read it in with read.csv() and store it in a var called 'words'
words <- read.csv(file="top5k-word-frequency-dot-info.csv",
                  sep=",", header=TRUE)

# read.csv() gives us a dataframe, henceforth "df"
class(words)
# [1] "data.frame"

# the first thing we should do when reading in a new df is check it out
str(words)     # see the structure of the df -- info on each column ("col")
summary(words) # get a summary of each col of the df

# we can also look at the first n rows by calling head() and specifying n
head(words, n=5)

# *in RStudio only* we can use View() to see the whole thing in a window
# (can also click on the df in the upper righthand pane)
View(words)


#### SECTION 5: BASIC OPERATIONS ON DATAFRAMES ################################
# === === === === === === === === === === === === === === === === === ===
# === === === === === === === === === === === === === === === === === ===

# the individual cols of a df are referred to "variables" (confusing, ik!)
# and they can be accessed by name with the $ operator
wordCol <- words$Word

# just view the first 10 elements of a vector with <vec-name>[1:10]
wordCol[1:10]

rm(wordCol)

# we can access a row or range of rows using [] (before the comma)
words[1:2,]

# also works for cols (after the comma)
head(words[,1:2])

# we can add new cols by combining $ with the assignment operator
words$newCol <- words$Frequency / words$Rank 

head(words, n=5)

# we can remove cols we no longer need or don't want by assigning them to NULL
words$newCol <- NULL

# we can also change the data type of a given col
# words$PartOfSpeech is a *FACTOR*, meaning a discrete category with 
# a specified set of possible values -- i.e. *LEVELS*
class(words$PartOfSpeech)
levels(words$PartOfSpeech)

# we could change p.o.s. to character type with
words$PartOfSpeech <- as.character(words$PartOfSpeech)

class(words$PartOfSpeech)

# but we should change it back because p.o.s. actually is a factor
words$PartOfSpeech <- as.factor(words$PartOfSpeech)


# it is often useful to *SUBSET* a df if we are interested in only 
# some part of it -- usually some subset of the rows

# suppose we only want to look at info about the 100 most frequent words
# we could carve out the top 100 by saying any of the following:
frequentWords <- subset(words, Rank %in% 1:100)
frequentWords <- subset(words, Rank < 101)
frequentWords <- subset(words, Rank <= 100)

# there are several functions that can be used for subsetting
# we can also use a more primitive (but safer + ultimately better) way:
frequentWords <- words[words$Rank %in% 1:100, ]
frequentWords <- words[words$Rank < 101, ]
frequentWords <- words[words$Rank <= 100, ]

rm(frequentWords)

# you can see that these methods yield the same result:
identical(subset(words, Rank < 101), words[words$Rank < 101, ])

# now suppose we only want to look at nouns. then we could define 'nouns' as
nouns <- subset(words, PartOfSpeech=="n")

# here is a *TRICKY* fact: when you subset a df, you retain all
# original factor levels, even if they aren't instantiated in the subset
levels(nouns$PartOfSpeech)
levels(nouns$Word)[1:10]

# we usually want to eliminate factor levels that do not occur in the subset:
nouns <- droplevels(nouns)

# you can also wrap subset() with droplevels() in the subsetting call itself:
nouns <- droplevels(subset(words, PartOfSpeech=="n"))



#### SECTION 6: SUMMARY STATISTICS AND VISUALIZING DATA #######################
# === === === === === === === === === === === === === === === === === ===
# === === === === === === === === === === === === === === === === === ===

# we can get the average of a numeric vector (incl. a df column) using mean()
mean(words$Rank)

# sometimes df's will have *MISSING VALUES*, indicated with 'NA'
# if we try to take the mean of a vector containing NA's, we get NA
mean(c(1,2,3,NA))

# so it is often safest to set the na.rm argument to TRUE
mean(c(1,2,3,NA), na.rm=TRUE)


# we can also see more detailed info of a col with summary()
summary(words$Frequency)


# we can look at a table of a factor col or see a summary
table(words$PartOfSpeech)


# we can look at the distribution of a numeric var with a histogram:
hist(log(words$Frequency)) # easier to see distribution if we take the log

# we can make a scatterplot of two numeric variables
# (easier to see w a subset)

nounsFreq <- subset(nouns, Rank < 500)

plot(nounsFreq$Rank, nounsFreq$Frequency)

# waow looks like a strong relationship...
# actually, we are looking at a visual example of *ZIPF'S LAW*!!!
plot(log(nounsFreq$Rank), log(nounsFreq$Frequency))


# and see what their linear correlation is
cor(nounsFreq$Rank, nounsFreq$Frequency)

# as expected from zipf, their logs are almost *perfectly* inversely related
cor(log(nounsFreq$Rank), log(nounsFreq$Frequency))


# we can also plot subsets of a numeric variable for each level of a factor
plot(words$PartOfSpeech,words$Rank)

# but what about something easier to understand, like a bar graph?
# what would be nice is if for each part of speech, we had a bar whose
# height is equal to the average rank of words with that part of
# speech, within our dataset

# to make the visualizations more meaningful, let's cut the df so that
# it contains only: 
#     nouns, verbs, adjectives, prepositions, articles, and pronouns
nvap <- subset(words, PartOfSpeech %in% c("n","v","j","i","a","p"))

# first we need to calculate the means for each part of speech
# there are many ways to do this. here is one:
meanRanks <- aggregate(Rank ~ PartOfSpeech, FUN="mean", data=nvap)

# if you ever get more into R, you will want to use 
# the amazing visualization library ggplot2:: 
# (for "grammar of graphics")
library(ggplot2)

ggplot(data=meanRanks, aes(x=PartOfSpeech,y=Rank)) +
  geom_bar(stat="identity")

# interesting...what does the plot tell us about frequency and parts of speech?


# sec 6 cleanup
rm(nvap); rm(meanRanks); rm(nounsFreq); rm(nouns)

#### SECTION 7: STUFF TO KNOW ABOUT R SYNTAX #######################
# === === === === === === === === === === === === === === === === === ===
# === === === === === === === === === === === === === === === === === ===

# using '=' for var assignment is actually not a good practice (for reasons you
# don't need to understand at this point -- ask me if you're interested)

# we *should* use '<-', which is unfortunate bc it less obvious + intuitive
x <- 5 + 3

# *however*, you should still use '=' when you are specifying
# an argument in a function call, e.g. in the following say n=10, not n<-10
head(words, n=3)

# generally speaking, spaces and brackets are optional but make code readable
5+3/2^2-4 == 5 + (3 / 2^2) - 4

identical(x<-5+3, x <- 5 + 3)

identical(max(1, 2, 3), max(1,2,3))

# but be careful! the assignment operator '<-' is a unit + can't be split up

# this will be interpreted as the (false) statement that the value of 
# the variable 'x' is less than the sum of -5 an 3 (i.e. -2):
x <- -5+3 # gives -2
x< -5+3   # gives FALSE!


# you can start new lines in the middle of commands too, which sometimes makes
# for cleaner + easier to read code (note the auto-indenting of RStudio)
theWords <-
  c("theFirstWord","theSecondWord","theThirdWord","theFourthWord",
    "theFifthWord","theSixthWord","theSeventhWord")

# but again, be careful!
### if we try:
### theWords
###   <-   c("theFirstWord","theSecondWord","theThirdWord","theFourthWord",
###        "theFifthWord","theSixthWord","theSeventhWord")
###
### we will get:
### Error: unexpected ',' in "       "theFifthWord","


# this won't throw an error, but will insert a newline and tab char into the
# third element, which we wanted to be "theThirdWord"
theWords <- c("theFirstWord","theSecondWord","theThird
              Word","theFourthWord",
              "theFifthWord","theSixthWord","theSeventhWord")

theWords[3]


# it is often useful to organize code into *BLOCKS*, which you can think of
# as "paragraphs" -- groups of sentences/commands that mean/do a single thing

# this block builds a df of words with their freq's and freq ranks
wordList <- c("w1","w2","w3","w4","w5")
wordFreq <- c(10,4,3,12,12)
wordRank <- rank(-wordFreq, ties.method="min") 
wordInfo <- data.frame(
  word=wordList,
  freq=wordFreq,
  rank=wordRank
)

wordInfo

# aaaand now it's time to clean up 
# this is not necessary, but can be comforting if you are neurotic :p 
rm(x); rm(theWords); rm(wordList); rm(wordFreq); rm(wordRank); rm(wordInfo)


# that's all for now, folks! 
# shoot me an email if you want to talk/learn/hear more!

# one more thing: it's good practice to end a script with a blank line
