# number of iterations
numruns <- 5

# container to catch the filtered results
pricechange_tweets        <- vector(mode="list", length=numruns)
names(pricechange_tweets) <- paste0("run", seq_len(numruns))


dates <- as.character(c(dec_days, inc_days))
# we'll just do five iterations and take whatever we get.
# some fiddling around suggests that ought to give us close to 100 of each date

# in a perfect world we'd write a while-loop and just wait till our
# criteria are satisfied...

# number of iterations
numruns <- 5

# container to catch the filtered results
pricechange_tweets        <- vector(mode="list", length=numruns)
names(pricechange_tweets) <- paste0("run", seq_len(numruns))

# run five iterations of the get-filter procedure
for (i in 1:numruns){
  
  # container to catch the query results
  twitlist <- vector(mode="list", length=length(dates))
  
  # collect tweets for each date by calling search api
  for (x in seq_along(dates)){
    twitlist[[x]] <- get_tweets(date=dates[x], term="bitcoin", num=30)
  }
  
  # convert the tweet collections to a single df
  pricechange_tweets[[paste0("run", i)]] <- twListToDF(unlist(twitlist)) %>% 
    mutate(date = as.character(date(created))) %>% 
    filter(date %in% dates) %>% data.frame() 
  
}

# sav <- pricechange_tweets
# boosh <- lapply(pricechange_tweets, function(x) rbind(x, sav))

### GOT BLOCKED NOOOOO!!!
str((pricechange_tweets[[1]]))
View(pricechange_tweets[[2]])

# NEXT UNLIST THE PRICECHANGE TWEETS AND DUMP THEM TOGETHER...

if (TRUE){
  # write file interactively, so doesn't get written with every new rmd compile
  write.csv(pricechange_tweets[[1]], "../../../../btc_tweets1.csv", row.names=FALSE)
}

# 139 out of 317 kept first run


# table(pricechange_tweets$date)


