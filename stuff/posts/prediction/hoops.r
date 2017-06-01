# this one is nice + simple
#   https://github.com/rtelmore/ballr
#   devtools::install_github("rtelmore/ballr")

library("ballr")

# just five functions:
#   NBAPerGameStatistics()
#   NBAPerGameStatisticsPer36Min()
#   NBAPlayerPerGameStats()
#   NBASeasonTeamByYear()
#   NBAStandingsByDate()

teams <- read.table("teams.txt", header=TRUE, stringsAsFactors=FALSE)

teams$abbrev_guessed <- c(
  "ATL","BOS","BKN","CHA","CHI","CLE","DAL","DEN","DET","GSW",
  "HOU","IND","LAC","LAL","MEM","MIA","MIL","MIN","NOP","NYK",
  "OKC","ORL","PHI","PHX","POR","SAC","SAS","TOR","UTA","WSH"
)



tmyr <- NBASeasonTeamByYear(team="CLE", season=2015)

boosh <- stats$games


team <- "CLE"
season <- 2015
# from the source: 
# NBASeasonTeamByYear <- function (team, season) {
  url <- paste(getOption("NBA_api_base"), "/teams/", team, 
               "/", season, "_games.html", sep = "")
  stats <- readHTMLTable(url) # [["teams_games"]] # [c(1, 2, 6:8, 10:14)]
  # stats <- stats[-c(21, 42, 63, 84), ]
  # stats[, c(1, 6:9)] <- apply(stats[, c(1, 6:9)], 2, as.numeric)
  colnames(stats)[3] <- "Away_Indicator"
  stats <- tbl_df(stats)
  stats <- mutate(stats, Diff = Tm - Opp, AvgDiff = cumsum(Diff)/G, 
                  Away = cumsum(Away_Indicator == "@"), DaysBetweenGames = c(NA, 
                                                                             as.vector(diff(mdy(Date)))))
  return(stats)
# }
