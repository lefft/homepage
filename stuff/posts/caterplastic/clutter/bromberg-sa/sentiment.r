library("plyr"); library("stringr"); library("e1071")

# word polarity list
afinn_list <- read.delim(
  file='data/AFINN-111.txt', header=FALSE, stringsAsFactors=FALSE
)
names(afinn_list) <- c('word', 'score')
afinn_list$word <- tolower(afinn_list$word)


# categorize words by affinity scores + subjective intuitions
# categories are vNegTerms, negTerms, posTerms, vPosTerms
vNegTerms <- afinn_list$word[afinn_list$score==-5 | afinn_list$score==-4]
negTerms <- c(
  afinn_list$word[afinn_list$score==-3 | 
                    afinn_list$score==-2 | 
                    afinn_list$score==-1], 
  "second-rate", "moronic", "third-rate", "flawed", "juvenile", "boring", 
  "distasteful", "ordinary", "disgusting", "senseless", "static", "brutal",
  "confused", "disappointing", "bloody", "silly", "tired", "predictable", 
  "stupid", "uninteresting", "trite", "uneven", "outdated", "dreadful", "bland"
)

posTerms <- c(
  afinn_list$word[afinn_list$score==3 | 
                    afinn_list$score==2 | 
                    afinn_list$score==1], 
  "first-rate", "insightful", "clever", "charming", "comical", "charismatic",
  "enjoyable", "absorbing", "sensitive", "intriguing", "powerful", "pleasant",
  "surprising", "thought-provoking", "imaginative", "unpretentious"
)

vPosTerms <- c(
  afinn_list$word[afinn_list$score==5 | afinn_list$score==4], 
  "uproarious", "riveting", "fascinating", "dazzling", "legendary"
)


# positive/negative sentences dataset
posText <- read.delim(
  file='data/rt-polarity-pos.txt', 
  header=FALSE, stringsAsFactors=FALSE
)
posText <- posText$V1
posText <- unlist(lapply(posText, function(x) { str_split(x, "\n") }))

negText <- read.delim(
  file='data/rt-polarity-neg.txt', 
  header=FALSE, stringsAsFactors=FALSE
)
negText <- negText$V1
negText <- unlist(lapply(negText, function(x) { str_split(x, "\n") }))

#function to calculate number of words in each category within a sentence

# compute a sentiment score
sentimentScore <- 
  function(sentences, vNegTerms, negTerms, posTerms, vPosTerms){
    
    # container to catch results of laply function
    final_scores <- matrix('', 0, 5)
    
    # will return 'scores' after computing
    scores <- laply(
      sentences, function(sentence, vNegTerms, negTerms, posTerms, vPosTerms){
        
        initial_sentence <- sentence
        
        #remove unnecessary characters and split up by word 
        sentence <- gsub('[[:punct:]]', '', sentence)
        sentence <- gsub('[[:cntrl:]]', '', sentence)
        sentence <- gsub('\\d+', '', sentence)
        sentence <- tolower(sentence)
        wordList <- str_split(sentence, '\\s+')
        words <- unlist(wordList)
        
        #build vector with matches between sentence and each category
        vPosMatches <- match(words, vPosTerms)
        posMatches <- match(words, posTerms)
        vNegMatches <- match(words, vNegTerms)
        negMatches <- match(words, negTerms)
        
        #sum up number of words in each category
        vPosMatches <- sum(!is.na(vPosMatches))
        posMatches <- sum(!is.na(posMatches))
        vNegMatches <- sum(!is.na(vNegMatches))
        negMatches <- sum(!is.na(negMatches))
        score <- c(vNegMatches, negMatches, posMatches, vPosMatches)
        
        #add row to scores table
        newrow <- c(initial_sentence, score)
        final_scores <- rbind(final_scores, newrow)
        
        return(final_scores)
    }, vNegTerms, negTerms, posTerms, vPosTerms)
    
    return(scores)
}

#build tables of positive and negative sentences with scores
posResult <- as.data.frame(
  sentimentScore(posText, vNegTerms, negTerms, posTerms, vPosTerms)
)
negResult <- as.data.frame(
  sentimentScore(negText, vNegTerms, negTerms, posTerms, vPosTerms)
)

posResult <- cbind(posResult, 'positive')
colnames(posResult) <- c('sentence', 'vNeg', 'neg', 'pos', 'vPos', 'sentiment')

negResult <- cbind(negResult, 'negative')
colnames(negResult) <- c('sentence', 'vNeg', 'neg', 'pos', 'vPos', 'sentiment')

#combine the positive and negative tables
results <- rbind(posResult, negResult)

#run the naive bayes algorithm using all four categories
classifier <- naiveBayes(results[,2:5], results[,6])

#display the confusion table for the classification ran on the same data
confTable <- table(
  predict(classifier, results), results[,6], dnn=list('predicted','actual')
)
confTable

#run a binomial test for confidence interval of results
binom.test(confTable[1,1] + confTable[2,2], nrow(results), p=0.5)


