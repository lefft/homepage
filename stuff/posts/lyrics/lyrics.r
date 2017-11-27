# https://docs.genius.com/#/authentication-h1
lefftpack::lazy_setup()
library("httr")
r <- GET("http://httpbin.org/get")
status_code(r)
headers(r)
str(content(r))
http_status(r)
r$status_code
content(r, "text")

kk <- read.csv("~/Google Drive/sandboxxxe/keyz.csv", stringsAsFactors=FALSE) %>% 
  filter(site=="genius")

# library("rvest")
# download.file("https://genius.com/Future-codeine-crazy-lyrics", "d/cc.html")
# d <- xml2::read_html("d/cc.html")
# ff <- d$node


# FOR CLIENT-ONLY APPLICATIONS:  
# An alternative authentication flow is available for browser-based, client-only applications. This mechanism is much less secure than the full code exchange process and should only be used by applications without a server or native platform to execute the full code flow.
# 
# Where "code" is used as the response_type value in the instructions above, use token. Instead of being redirected with a code that your application exchanges for an access token, the user is redirected to https://REDIRECT_URI/#access_token=ACCESS_TOKEN&state=STATE. Extract the access token from the URL hash fragment and use it to make requests.
# 
# With the token response type, the user's access token is exposed in the browser, where it could be accessed by malicious JavaScript or otherwise intercepted much more easily than when it's only exchanged between servers. The client secret isn't used, so it's much easier for potential attackers to fake authorization requests. Don't use the token flow if you don't have to.


# redirect_uri = http://lefft.xyz
# client_id = 
kk$value[kk$auth_type=="client_id"]

kk$value[kk$auth_type]
paste0(
  "https://api.genius.com/oauth/authorize?", 
  "client_id=YOUR_CLIENT_ID&", 
  "redirect_uri=YOUR_REDIRECT_URI&", 
  "scope=REQUESTED_SCOPE&", 
  "state=SOME_STATE_VALUE&", 
  "response_type=code"
)


  


# Getting an Access Token
# 
# Start by directing a user of your application to Genius's authentication page at https://api.genius.com/oauth/authorize with the following query parameters:
# 
# client_id: Your application's Client ID, as listed on the API Client management page
# redirect_uri: The URI Genius will redirect the user to after they've authorized your application; it must be the same as the one set for the API client on the management page
# scope: The permissions your application is requesting as a space-separated list (see available scopes below)
# state: A value that will be returned with the code redirect for maintaining arbitrary state through the authorization process
# response_type: Always "code"
# More About State
# One important use for this value is increased security—by including a unique, difficult to guess value (say, a hash of a user session value), potential attackers can be prevented from sending phony redirects to your app.
# On the authentication page the user can choose to allow your application to access Genius on their behalf. They'll be asked to sign in (or, if necessary, create an account) first. Then the user is redirected to https://YOUR_REDIRECT_URI/?code=CODE&state=SOME_STATE_VALUE.
# 
# Your application can exchange the code query parameter from the redirect for an access token by making a POST request to https://api.genius.com/oauth/token with the following request body data:
#   
# {
#   "code": "CODE_FROM_REDIRECT",
#   "client_id": "YOUR_CLIENT_ID",
#   "client_secret": "YOUR_CLIENT_SECRET",
#   "redirect_uri": "YOUR_REDIRECT_URI",
#   "response_type": "code",
#   "grant_type": "authorization_code"
# }
# code: The code query parameter from the redirect to your redirect_uri
# client_secret: Your application's Client Secret, as listed on the API Client management page
# grant_type: Aways "authorization_code"
# client_id: As above
# redirect_uri: As above
# response_type: As above
# Most of these are the same values as used in the initial request.
# 
# {
#   "access_token": "ACCESS_TOKEN"
# }
# The response body will be an object with the token as the value for the access_token key. Save the token and use it to make requests on behalf of the authorizing user.


# AVAILABLE SCOPES 
# Scope	Endpoints
# me	GET /account
# create_annotation	POST /annotations
# manage_annotation	PUT /annotations/:id 
# DELETE /annotations/:id
# vote	PUT /annotations/:id/upvote 
# PUT /annotations/:id/downvote 
# PUT /annotations/:id/unvote
