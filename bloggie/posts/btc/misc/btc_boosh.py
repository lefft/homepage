
import tweepy
import sys

print(sys.version)


key = ""
sec = ""
acc_tok = ""
acc_sec = ""


auth = tweepy.OAuthHandler(key, sec)
auth.set_access_token(acc_tok, acc_sec)

api = tweepy.API(auth)

public_tweets = api.home_timeline()

for tweet in public_tweets[0:3]:
    print(tweet.text)

