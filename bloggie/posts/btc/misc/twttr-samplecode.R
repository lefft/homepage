# Now you’ve got a bunch of text data for Bernie Sanders, so how do we decide what’s a “good” tweet and a “bad” tweet? This is where I turned to the Hu and Liu Opinion Lexicon, a list of 6800 positive and negative words compiled by Bing Liu and Minqing Hu of the University of Illinois at Chicago.

# Unpack the Opinion Lexicon into your working directory and you should be ready to roll.

# Read in dictionary of positive and negative works
yay = scan('opinion-lexicon-English/positive-words.txt',
           what='character', comment.char=';')
boo = scan('opinion-lexicon-English/negative-words.txt',
           what='character', comment.char=';')
# Add a few twitter-specific negative phrases
bad_text = c(boo, 'wtf', 'epicfail', 'douchebag')
good_text = c(yay, 'upgrade', ':)', '#iVoted', 'voted')
# Now, you’ve got your list of tweets and your list of opinionated words. The next thing to do is score the text of the tweets compared to how many of the “bad” and “good” words show up in each.

# For this we’ll need a giant R function filled with lots of good gsub and match functions. Thanks to Jeff Breen for the function on which this was based.

score.sentiment = function(sentences, good_text, bad_text, .progress='none')
{
  require(plyr)
  require(stringr)
  # we got a vector of sentences. plyr will handle a list
  # or a vector as an "l" for us
  # we want a simple array of scores back, so we use
  # "l" + "a" + "ply" = "laply":
  scores = laply(sentences, function(sentence, good_text, bad_text) {
    
    # clean up sentences with R's regex-driven global substitute, gsub():
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\d+', '', sentence)
    #to remove emojis
    sentence <- iconv(sentence, 'UTF-8', 'ASCII')
    sentence = tolower(sentence)        
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\s+')
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)
    
    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, good_text)
    neg.matches = match(words, bad_text)
    
    # match() returns the position of the matched term or NA
    # we just want a TRUE/FALSE:
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, good_text, bad_text, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}
# The good news about the obnoxiously long function, is it spits out a nice data frame that can be manipulated very easily.

# Call the function and return a data frame
feelthabern <- score.sentiment(feed_sanders, good_text, bad_text, .progress='text')
# Cut the text, just gets in the way
plotdat <- plotdat[c("name", "score")]
# Remove neutral values of 0
plotdat <- plotdat[!plotdat$score == 0, ]

# Nice little quick plot
qplot(factor(score), data=plotdat, geom="bar", 
      fill=factor(name),
      xlab = "Sentiment Score")






