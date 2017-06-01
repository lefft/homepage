# this is vsbot_test.py, the script that tweets out facts about NBA games when i tell it to
import tweepy

class TwitterAPI:
    def __init__(self):
        consumer_key = "lPsl4bxROkmWjK3tP2W8jr3zF"
        consumer_secret = "0EVuA7dJay9vcv0XZRYbUt5O6MRTu9IozppqFz9t38neaNOvgF"
        auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
        access_token = "726117515529588736-wEo1F1EloIMGo5WxY9Hz3xVzLslMkGq"
        access_token_secret = "2qYdugzjvda1kKEhkRWFZfqdxglCIJUrxXjxUJH5CJvgo"
        auth.set_access_token(access_token, access_token_secret)
        self.api = tweepy.API(auth)

    def tweet(self, message):
        self.api.update_status(status=message)

if __name__ == "__main__":
    twitter = TwitterAPI()
    twitter.tweet("~~<(o_0)^")