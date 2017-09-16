# url: https://fivethirtyeight.com/features/is-this-bathroom-occupied/

players <- -15:15

# a circle is a set of pairs (x, y) such that: 
#   - x is to the left of y
#   - y is to the right of x


transition <- function(players, position, flip_result){
  if (flip_result=="heads"){
    if (position != min(players)){
      new_position <- position - 1
    } else {
      new_position <- max(players)
    }
  } 
  if (flip_result=="tails"){
    if (position != max(players)){
      new_position <- position + 1
    } else {
      new_position <- min(players)
    }
  }
  return(new_position)
}

flip_coin <- function(coin=c("heads","tails")){
  flip_result <- sample(coin, size=1)
  return(flip_result)
}

play_game1 <- function(players, remove_losers=FALSE){
  
  start_position <- min(abs(players))
  
  current_position <- start_position
  
  potato_holders <- current_position
  
  counter <- 1
  
  while (length(potato_holders) != length(players)-1){
    
    flip <- flip_coin()
    
    current_position <- transition(
      players=players,
      position=current_position, 
      flip_result=flip
    )
    if (!current_position %in% potato_holders){
      potato_holders <- c(potato_holders, current_position)
    }
    
    if (remove_losers){
      players <- players[players != current_position]
    }
    
    message(paste0("there are ", length(potato_holders), 
                   " potato holders, after round ", counter))
    
    counter <- counter + 1
  }
  
  winner <- setdiff(players, potato_holders)
  return(winner)
}

# case 1: the teacher participates in the whole game, but always loses

sim_game <- function(players, num_sims, remove_losers=FALSE){
  sim_results <- replicate(
    num_sims,
    play_game1(players=players, remove_losers=remove_losers)
  )
  print(barplot(table(sim_results)))
  return(sim_results)
}

run_5k_11players <- sim_game(players=-5:5, num_sims=5e3)

barplot(table(run_5k_11players))

run_5k_11players_RL <- sim_game(
  players=-5:5, num_sims=5e3, remove_losers=TRUE
)
barplot(table(run_5k_11players_RL))

# case 2: the teacher is just the start point, then disappears


