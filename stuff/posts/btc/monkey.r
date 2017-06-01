# https://github.com/ropensci/monkeylearn
library("monkeylearn")
keys <- read.csv("../../../../keyz.csv", stringsAsFactors=FALSE)
ml_key  <- keys$value[keys$auth_type=="monkey_pkey"]

text <- readLines("input/texxxte.txt")

extract <- monkeylearn_extract(
  request=text, extractor_id="ex_isnnZRbS", 
  verbose=TRUE, params=list(max_keywords=3), key=ml_key
)
extract
attr(extract, "headers")


monkeylearn_extract(
  text, extractor_id="ex_y7BPYzNG", params=list(max_keywords=3), key=ml_key
)



text1 <- "I hate everyone :("
text2 <- "I love everyone :)"
request <- c(text1, text2)
monkeylearn_classify(
  request=request, classifier_id="cl_oFKL5wft", verbose=TRUE, key=ml_key
)


cl <- "cl_5icAVzKR" # <-- one from the docs  # one that i found: "cl_b7qAkDMz"
bio <- ""
norc <- ""

monkeylearn_classify(request=c(bio, norc), 
                     key=ml_key, classifier_id=cl, verbose=TRUE)


manif <- readLines("input/unabomber-manifesto.txt")

monkeylearn_classify(
  request=manif, 
  key=ml_key, 
  classifier_id="cl_5icAVzKR",
  verbose=TRUE
)

boosh <- function(text){
  monkeylearn_classify(
    request=text, 
    key=ml_key, 
    classifier_id="cl_5icAVzKR",
    verbose=TRUE
  )
}



