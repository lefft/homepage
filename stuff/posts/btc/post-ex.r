# load dependencies -- for data acquisition and processing
library("twitteR"); library("ROAuth"); library("httr"); library("lubridate")
library("reshape2"); library("dplyr")
# load dependencies -- for plotting results
library("ggplot2"); library("scales")
# set auth cache to false to avoid prompts in `setup_twitter_oauth()`
options(httr_oauth_cache=FALSE)
# read in api keys and access tokens
keyz <- read.csv("../../../../keyz.csv", header=TRUE, stringsAsFactors=FALSE)
# set up twitter auth -- call `setup_twitter_oauth()` w keys from `keyz`
setup_twitter_oauth(
  consumer_key    = keyz$value[keyz$auth_type=="twtr_api_key"], 
  consumer_secret = keyz$value[keyz$auth_type=="twtr_api_sec"], 
  access_token    = keyz$value[keyz$auth_type=="twtr_acc_tok"], 
  access_secret   = keyz$value[keyz$auth_type=="twtr_acc_sec"]
)

# get tweets from user @bitcoinprice for maximum n (3200 as of may2017)

# @bitcoinprice
# The average price of Bitcoin across all exchanges is ... 
btc <- userTimeline(user="bitcoinprice", n=3200, excludeReplies=TRUE)

# now want to tidy them up a bit...

clean_btc_tweets <- function(lst){
  # initialize container to catch the cleaned up tweets
  dat <- data.frame(
    date_time  = rep(NA, length(lst)),
    source     = rep(NA, length(lst)),
    tweet      = rep(NA, length(lst)), 
    date       = as_date(rep(NA, length(lst))),
    hour       = rep(NA, length(lst)),
    is_rt      = as.logical(rep(NA, length(lst)))
  )
  # loop over elements of btc, extract info and put it in `dat`
  # (tweets occur at ever hour, so no need for minutes in `dat$time`)
  for (x in seq_along(lst)){
    dat$date_time[x] <- as.character(lst[[x]]$created)
    dat$source[x]    <- paste0("@", lst[[x]]$screenName)
    dat$tweet[x]     <- lst[[x]]$text
    dat$date[x]      <- date(lst[[x]]$created)
    dat$hour[x]      <- hour(lst[[x]]$created) 
    dat$is_rt[x]     <- lst[[x]]$isRetweet
  }
  
  return(dat)
}


dat <- clean_btc_tweets(btc)

# a tweet consists of "toss[1] + dddd.dd + toss[2]"
toss <- c("The average price of Bitcoin across all exchanges is ", " USD")

# check that all tweets are formulaic + as expected
if (!all(grepl(paste0(toss[1], "\\d*\\.?\\d*", toss[2]), dat$tweet))){
  message("careful -- tweets not as formulaic as they may seem! :/ ")
}

# if tweets are formulaic, just remove `toss` + extract price from `dat$tweet`
dat$price <- gsub(paste0(toss, collapse="|"), "", dat$tweet)

# check that we don't have any words/letters left before converting
if (sum(grepl("[a-z]", dat$price)) > 0){
  warning("careful -- some tweets were not in expected format! :o ")
}

# now convert to numeric
dat$price <- as.numeric(dat$price)

# delete any retweets that could've crept in
dat <- dat[!dat$is_rt, ]

# convert date_time to nicer format [CHECK THAT MOVING FROM lt TO CT IS OKAY]
dat$date_time <- as.POSIXct(dat$date_time, tz="UTC")

# get day of the week so we can look at weekly trends
dat$day <- weekdays(dat$date_time, abbreviate=TRUE)
dat$day <- factor(dat$day, levels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))
# "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"

# notice that on 2017-03-14 15:00:03, the value is listed at $1.25
# inspecting the surrounding data suggests it's probably meant to be $1225.00.
# **exercise**: what does this suggest about how the bot works?
dat$price[dat$price==1.25] <- dat$price[dat$price==1.25] * 1000

# now cut the df to just the cols we want
dat <- dat[, c("source","date_time","date","hour","day","price")]


# what's our date range? (3200 hourly tweets so should be 3200/24 days ~ 4mo)
# from "2017-01-15" to "2017-05-29"
# range(dat$date)

# now make some plots!
ggplot(dat, aes(x=date_time, y=price)) +
  geom_line() + scale_y_continuous(limits=c(0, 3000))

ggplot(dat, aes(x=date_time, y=price, color=day)) +
  geom_line()

ggplot(dat, aes(x=hour, y=price, group=date)) +
  geom_line()

pdat <- dat %>% select(day, hour, price) %>% group_by(day) %>% summarize(
  mean_price = mean(price)
) %>% data.frame()

ggplot(pdat, aes(x=day, y=mean_price)) + geom_bar(stat="identity")

pdat <- dat %>% select(day, hour, price) %>% group_by(day, hour) %>% summarize(
  mean_price = mean(price)
) %>% data.frame()

ggplot(pdat, aes(x=hour, y=mean_price)) + 
  geom_line() + 
  facet_wrap(~day, ncol=7)



### get external data now
bdat <- read.csv(
  "data/bitcoinity_data-price-volume.csv", 
  col.names=c("date","price","volume"),
  colClasses=c("Date","numeric","numeric")
)
bdat$source <- "bitcoinity.org"

# the twitter data:
ggplot(dat, aes(x=date_time, y=price)) +
  geom_line() + scale_y_continuous(limits=c(0, 3000))

# the external data, plotted on the same interval:
ggplot(bdat[bdat$date >= min(dat$date), ], aes(x=date, y=price)) +
  geom_line() + scale_y_continuous(limits=c(0, 3000))

# the external data, plotted on the whole lifetime of btc:
ggplot(bdat[bdat$date >= "2017-01-01", ], aes(x=date, y=price)) +
  geom_line() + scale_y_continuous(limits=c(0, 3000)) +
  geom_line(aes(x=date, y=volume/1e6), color="orange") +
  scale_x_date(date_breaks="2 weeks") +
  geom_hline(yintercept=max(bdat$price), color="#8aa8b5", linetype="dashed") +
  annotate(geom="text", x=as.Date("2017-02-01"), y=max(bdat$price)+100, 
           color="#8aa8b5", label="all-time high")


# want to merge twitter data with bitcoinity data
# first need to aggregate twitter data to the day-level
tdat_simple <- dat %>% 
  mutate(date=as.character(date)) %>% 
  select(source, date, price) %>% 
  group_by(source, date) %>% summarize(
  price = mean(price, na.rm=TRUE)
) %>% data.frame()

bdat_simple <- bdat %>% 
  filter(date >= min(dat$date)) %>% 
  select(source, date, price) %>% 
  mutate(date=as.character(date))

head(tdat_simple, 2); head(bdat_simple, 2)

merged <- rbind(tdat_simple, bdat_simple)
merged$date <- as.Date(merged$date)
# merged <- left_join(tdat_simple, bdat_simple, by="date")

ggplot(merged, aes(x=date, y=price, group=source)) +
  geom_point() + geom_line() + 
  facet_wrap(~source) + scale_y_continuous(limits=c(0, 3000)) +
  scale_x_date(date_breaks="2 weeks") +
  theme(axis.text.x=element_text(angle=45, vjust=1, hjust=1))

ggplot(merged, aes(x=date, y=price, group=source, color=source)) +
  geom_line() + 
  scale_y_continuous(limits=c(0, 3000)) +
  scale_x_date(date_breaks="2 weeks") +
  theme(axis.text.x=element_text(angle=45, vjust=1, hjust=1))



### scratch area ##############################################################
# === === === === === === === === === === === === === === === === === === 

# @coindesk
# The latest Bitcoin Price Index is 2,316.06 USD http://www.coindesk.com/price/  
dsk <- userTimeline(user="coindesk", n=3200, excludeReplies=TRUE)

# @BTCTN
# Bitcoin’s exchange rate is currently 2253.56 USD
# https://price.bitcoin.com  #Bitcoin #Bitcoinprice
ctn <- userTimeline(user="BTCTN", n=3200, excludeReplies=TRUE)

# @Bitcoin10min
# $2275.21 | €2034.87 | ¥14865.36 | £1803.94
# 1h -0.73% | 1d +5.85% | 7d +1.88% | 1m +69.55%
ten <- userTimeline(user="Bitcoin10min", n=3200, excludeReplies=TRUE)

dat_dsk <- clean_btc_tweets(dsk)
dat_ctn <- clean_btc_tweets(ctn)
dat_ten <- clean_btc_tweets(ten)
