### load dependencies #########################################################
# === === === === === === === === === === === === === === === === === === 
library("reshape2")
library("dplyr")
library("ggplot2")

# **note**: use shortcut ctrl+shift+k to make a document with output from this
#           (cmd+shift+k on mac)


# **note**: 
#   when making plots, if you get the following error:
#   
#                 Error in plot.new() : figure margins too large
#                 
#   then zoom out in R Studio and give the plot window some more room
#   (it's not an *actual* error -- just an error for displaying a plot)


#'

### read data and check missings ##############################################
# === === === === === === === === === === === === === === === === === === 

# read in the data and do some initial inspection
dat <- read.csv("datasets/gss_2016_test.csv") 

# check for na's (none, yay!...but are there *really* none?!)
colSums(is.na(dat))

str(dat)
head(dat, n=5)


#'


### basic cleanup and recoding ################################################
# === === === === === === === === === === === === === === === === === === 

# now check + clean up + transform columns as necessary

# `id` is an identifier, not a number
dat$id <- paste0("resp", dat$id)

# `form` has just two levels
table(dat$form)

# so we can recode it with `ifelse()`
dat$form <- ifelse(dat$form==1, "standard", "alternate_y")

# `sex` has just two levels
table(dat$sex)

# so we can recode it with `ifelse()`
dat$sex <- ifelse(dat$sex==1, "male", "female")

# income has lots of different values
# ALSO BTW YAY FIRST PLOT! 
barplot(table(dat$INCOME16))

# so we'll have to recode it in a more mechanical fashion...


# one option:
# recode income to `hi` or `mid` or `lo`, according to external values
# from the codebook files
lo  <- 1:12; mid <- 13:21; hi  <- 22:26
dat$income_cat <- ifelse(
  dat$INCOME16 %in% lo, "lo", ifelse(
    dat$INCOME16 %in% mid, "mid", ifelse(
      dat$INCOME16 %in% hi, "hi", NA
    )
  )
); rm(lo); rm(mid); rm(hi)


# another option:
# read in external vals as a table, and just sub in values for numeric codes
income <- read.csv(
  "datasets/lookup_income.csv", header=FALSE, col.names=c("num","val"), 
  stringsAsFactors=FALSE
)
# make a vector with values equal to income$val, and names income$num
income_lkup        <- as.vector(income$val)
names(income_lkup) <- income$num

# recode the income column by matching vals w the lookup table names
dat$income_range <- income_lkup[match(dat$INCOME16, names(income_lkup))]

# remove the original income col
dat$INCOME16 <- NULL


#'


### a slightly more complicated case ##########################################
# === === === === === === === === === === === === === === === === === === 

# let's check out the race cols
table(dat$racecen1, useNA="always")
table(dat$racecen2, useNA="always")

# kinda messy...let's just extract the census's notion of "ethnicity"
# (i.e. hispanic or non-hispanic)

# first read in our associative array of keys and values
race <- read.csv(
  "datasets/lookup_race.csv", header=FALSE, col.names=c("num","val"),
  stringsAsFactors=FALSE
)
# same type of procedure as for income above
race_lkup        <- as.vector(race$val)
names(race_lkup) <- race$num

# set 0, 98, and 99 to NA
dat$racecen1 <- ifelse(dat$racecen1 %in% c(0,98,99), NA, dat$racecen1)
dat$racecen2 <- ifelse(dat$racecen2 %in% c(0,98,99), NA, dat$racecen2)

# then recode the other values
dat$racecen1 <- race_lkup[match(dat$racecen1, names(race_lkup))]
dat$racecen2 <- race_lkup[match(dat$racecen2, names(race_lkup))]

# now define `hisp` to be "hispanic" if racecen1=="Hispanic" and non otherwise
dat$hisp <- ifelse(
  dat$racecen1=="Hispanic", "hispanic", "nonhispanic"
)
# make sure that the ppl who said "Hispanic" in racecen2 are coded as such
dat$hisp[dat$racecen2=="Hispanic"] <- "hispanic"

# now we can safely eliminate the `racecen1/2` columns
# (note semicolons end a line -- just compact notation)
dat$racecen1 <- NULL; dat$racecen2 <- NULL


#'


### reorganize columns as desired, toss unused ones ###########################
# === === === === === === === === === === === === === === === === === === 

# now we have everything except the outcome vars
# reorganize the df the way we want it
dem_cols  <- c("id", "year", "form", "sex", "age", "income_cat", "hisp")
item_cols <- names(dat)[startsWith(names(dat), "nat")]
# then cut the data to just those columns, in the order we specified them
dat <- dat[, c(dem_cols, item_cols)]


#'


### deriving the outcome variable with `reshape2::melt()` #####################
# === === === === === === === === === === === === === === === === === === 

# NATFARE/NATFAREY/NATCITY/NATCITYY/NATRACE/NATRACEY
#    9        "No answer"
#    8        "Don't know"
#    3        "Too much"
#    2        "About right"
#    1        "Too little"
#    0        "Not applicable"

# see the week3 notes for info on "melting" data frames
dat <- melt(dat, id.vars=dem_cols)

dat$variable <- as.character(dat$variable)

# rename the new columns
names(dat)[names(dat)=="variable"] <- "item"
names(dat)[names(dat)=="value"]    <- "response"

# let's check out what we have now:
head(dat, n=10)

# toss all the rows w/o real answers
dat <- dat[!dat$response %in% c(9, 8, 0), ]

# make a lookup table for the responses
val_lkup <- c(`1`="too little", `2`="about right", `3`="too much")

# recode responses as character
dat$response <- as.character(val_lkup[match(dat$response, names(val_lkup))])

# look at a table
table(dat$response, useNA="ifany")
table(dat$item, useNA="ifany")

# for now we'll just toss all y's to make life easier
dat$item <- gsub("y", "", dat$item)

# confirm that we have just three vals now
table(dat$item, useNA="ifany")


#'


### summarizing the data ######################################################
# === === === === === === === === === === === === === === === === === === 

# many ways to summarize data by groups!

# frequency tables
table(dat$sex, dat$response)
table(dat$income_cat, dat$response)

# tables can have arbitrary dimensions, but even three is tough to parse...
# table(dat$sex, dat$income_cat, dat$response)

# cross-tabulate 
xtabs( ~ sex + income_cat, data=dat)
xtabs( ~ response + sex + income_cat, data=dat)

# marginal proportions
# **exercise** try setting margin=2
prop.table(xtabs( ~ response + income_cat, data=dat), margin=1)
prop.table(table(dat$response, dat$income_cat), margin=1)

# dplyr::summarize()/group_by() is my drug of choice:
# (see week2 notes appendix for background on the %>% pipe operator)
dat %>% group_by(sex, income_cat) %>% summarize(
  num_obs         = length(response),
  num_toolittle   = sum(response=="too little", na.rm=TRUE),
  prop_toolittle  = num_toolittle / num_obs,
  num_aboutright  = sum(response=="about right", na.rm=TRUE),
  prop_aboutright = num_aboutright / num_obs,
  num_toomuch     = sum(response=="too much", na.rm=TRUE),
  prop_toomuch    = num_toomuch / num_obs
  # the `mutate_if()` is just to make it display nicer
) %>% mutate_if(is.numeric, round, digits=3) %>% data.frame()

dat %>% group_by(item, form) %>% summarize(
  num_obs         = length(response),
  num_toolittle   = sum(response=="too little", na.rm=TRUE),
  prop_toolittle  = num_toolittle / num_obs,
  num_aboutright  = sum(response=="about right", na.rm=TRUE),
  prop_aboutright = num_aboutright / num_obs,
  num_toomuch     = sum(response=="too much", na.rm=TRUE),
  prop_toomuch    = num_toomuch / num_obs
) %>% mutate_if(is.numeric, round, digits=3) %>% data.frame()


# can use formula interface with `aggregate()`
aggregate(age ~ sex + income_cat, FUN="mean", data=dat)
aggregate(age ~ sex + income_cat, FUN="sd", data=dat)
# can specify a custom function in the FUN argument too
aggregate(age ~ sex + income_cat, FUN=function(x) round(mean(x)), data=dat)

# write a custom function for aggregating
custom_summary <- function(x){
  c(mean=round(mean(x)), sd=round(sd(x)), min=min(x), max=max(x))
}
# then supply the function as an argument to `aggregate()`
aggregate(age ~ sex + income_cat, FUN=custom_summary, data=dat)


#'


### plotting with base functions ##############################################
# === === === === === === === === === === === === === === === === === === 

# barplots made from a table
barplot(table(dat$sex))
barplot(table(dat$income_cat))

# basic scatterplot
plot(iris$Sepal.Width, iris$Sepal.Length)
# scatterplot with color coding
plot(iris$Sepal.Width, iris$Sepal.Length, col=iris$Species)

# line plot (nice for time-series data)
xvar <- 1:10
yvar <- rnorm(xvar)
plot(xvar, yvar, type="l")

# can specify plot type with type=
# scatter
plot(xvar, yvar, type="p")
# both line and points
plot(xvar, yvar, type="b")
# other options are "c", "o", "S"/"s", "h", "n"

# histograms for numeric univariate distributions
# this is probably the base plotting function i use the most
hist(dat$age)

#'


### plotting with `ggplot2::` #################################################
# === === === === === === === === === === === === === === === === === === 

# make a couple of summaries to plot directly
# this performs several steps very compactly -- try doing the same with base
# (here we're saving the summary object to `pdat` as a data frame)
pdat <- dat %>% group_by(sex, income_cat, item, form) %>% 
  summarize(
    num_obs         = length(response),
    mean_age        = mean(age, na.rm=TRUE),
    prop_toolittle  = sum(response=="too little", na.rm=TRUE) / num_obs,
    prop_aboutright = sum(response=="about right", na.rm=TRUE) / num_obs,
    prop_toomuch    = sum(response=="too much", na.rm=TRUE) / num_obs
  ) %>% 
  mutate_if(is.numeric, round, digits=3) %>% 
  melt(measure.vars=c("prop_toolittle","prop_aboutright","prop_toomuch")) %>% 
  data.frame()

# make sure income is ordered how we want it (the others dont matter)
pdat$income_cat <- factor(pdat$income_cat, levels=c("lo","mid","hi"))


# the best way to learn ggplot is by example, so here we go.
# some of the plots below are more useful than others, but they're all 
# valid examples of stuff you might have/want to do eventually.

## scatterplots

# regular
ggplot(pdat, aes(x=mean_age, y=value)) +
  geom_point()

# color-coded
ggplot(pdat, aes(x=mean_age, y=value, color=variable)) +
  geom_point()

ggplot(pdat, aes(x=mean_age, y=value, color=income_cat)) +
  geom_point()

# size-coded
ggplot(pdat, aes(x=mean_age, y=value, size=num_obs)) + 
  geom_point()

# size- and color-coded
ggplot(pdat, aes(x=mean_age, y=value, size=num_obs, color=income_cat)) + 
  geom_point()


# now let's look at how the responses are distributed for individual items:


# first group the data by item and get proportions for each response
boosh <- dat %>% group_by(item) %>% summarize(
  prop_toolittle  = sum(response=="too little", na.rm=TRUE) / n(),
  prop_aboutright = sum(response=="about right", na.rm=TRUE) / n(),
  prop_toomuch = sum(response=="too much", na.rm=TRUE) / n()
) %>% melt(id.vars="item")

## barplots

# now make some more useful plots
ggplot(boosh, aes(x=item, y=value, fill=variable)) + 
  geom_bar(stat="identity")

ggplot(boosh, aes(x=item, y=value, fill=variable)) +
  geom_bar(stat="identity", position="dodge") 

ggplot(boosh, aes(x="", y=value, fill=variable)) +
  geom_bar(stat="identity", position="dodge") +
  facet_wrap(~item)


# now let's see if `form` looks like it has an effect on responses!

# first group the data by item and get proportions for each response
(boosh <- dat %>% group_by(item, form) %>% summarize(
  # note that inside of summarize(), n() gives the number of rows in the group
  prop_toolittle  = sum(response=="too little", na.rm=TRUE)  / n(),
  prop_aboutright = sum(response=="about right", na.rm=TRUE) / n(),
  prop_toomuch    = sum(response=="too much", na.rm=TRUE)    / n()
) %>% melt(id.vars=c("item","form")) %>% data.frame())


# we can plot in different ways to get different perspectives on the data
# (*warning*: not all perspectives are equally useful!)
ggplot(boosh, aes(x=variable, y=value, fill=form)) + 
  geom_bar(stat="identity", position="dodge") +
  facet_wrap(~item) 

ggplot(boosh, aes(x=item, y=value, fill=form)) + 
  geom_bar(stat="identity", position="dodge") +
  facet_wrap(~variable) 

ggplot(boosh, aes(x=variable, y=value)) +
  geom_bar(stat="identity", position="dodge") +
  facet_grid(item ~ form) 

ggplot(boosh, aes(x=variable, y=value, fill=variable)) +
  geom_bar(stat="identity", position="dodge") +
  facet_grid(item~form) 


#'


### styling and saving plot objects ###########################################
# === === === === === === === === === === === === === === === === === === 

# let's start with a barplot, and then customize it step-by-step
plob <- ggplot(boosh, aes(x=form, y=value, fill=variable)) +
  geom_bar(stat="identity") +
  facet_wrap( ~ item)

# display the starting point
plob

# set a global "theme" (also try "minimal", "classic", "538", etc.)
theme_set(theme_bw())

# control the color coding, and show new theme
plob + 
  scale_fill_manual(values=c("lightgray","darkgray","black"))


# move the legend position
plob + 
  scale_fill_manual(values=c("lightgray","darkgray","black")) +
  theme(legend.position="top")

# label the axes and plot + make a title
plob + 
  scale_fill_manual(values=c("lightgray","darkgray","black")) +
  theme(legend.position="top") +
  labs(x="wording type", y="proportion of responses", 
       title="responses by wording type, for three GSS items",
       subtitle="survey data from 2016",
       caption="source: NORC at the University of Chicago (thx Ben!)")

# axis limits and axis ticks
plob + 
  scale_fill_manual(values=c("lightgray","darkgray","black")) +
  theme(legend.position="top") +
  labs(x="wording type", y="percentage of responses", 
       title="responses by wording type, for three GSS items",
       subtitle="survey data from 2016",
       caption="source: NORC at the University of Chicago (thx Ben!)") +
  scale_y_continuous(
    limits=c(0, 1), breaks=seq(0, 1, .2), labels=paste0(seq(0, 100, 20), "%")
  ) 

# do a buncha other stuff and save the result to `plob` before saving
# (note same content but different indentation conventions -- a matter of taste)
(saveplob <- plob +
    # specify scale details with `scale_*_*()` layers
    scale_fill_manual(values=c("lightgray","darkgray","black")) +
    scale_y_continuous(limits=c(0, 1), 
                       breaks=seq(0, 1, .2), 
                       labels=paste0(seq(0, 100, 20), "%")) +
    # say how various things should be displayed with `theme()`
    theme(legend.position="top", 
          plot.caption=element_text(hjust=0, color="orange", face="italic")) +
    # specify the content of various "labels" (stuff that gets displayed)
    labs(x="wording type", 
         y="percentage of responses", 
         title="responses by wording type, for three GSS items",
         subtitle="survey data from 2016",
         caption="source: NORC at the University of Chicago (thx Ben!)"))

# save as 9x6 landscape pdf
ggsave(filename="output/plob.pdf", plot=saveplob, width=9, height=6, units="in")


