library("R6")

coffee_pot <- R6Class(
  classname="pot", 
  public = list(
    capacity = NULL, 
    remaining = NULL, 
    initialize = function(capacity=NULL){
      self$capacity <- capacity
      self$remaining <- 0
    }, 
    fill = function(){
      self$remaining <- self$capacity
    }, 
    pour_cup = function(cup_size){
      if(self$remaining < cup_size){
        message("not enough to pour cup :/")
        self$remaining <- self$remaining
      } else {
        self$remaining <- self$remaining - cup_size 
      }
    }
  )
)

# blocks from pouring cup, as desired
pot <- coffee_pot$new(capacity=100)
pot$pour_cup(cup_size=.25)

# so fill it first 
pot <- coffee_pot$new(capacity=100)
pot$fill()
pot$pour_cup(cup_size=25)

# and some attributes
pot$capacity
pot$remaining



# 1. pot has amount 1 (gallon)


# goal: choose a number 0 < x < 1 such that you'll 
#   - maximize the amount of coffee you drink by pouring `x` per cup; 
#   - minimize the probability of pouring when less than `x` remains
cup_sizes <- round(runif(n=100, min=0, max=100), 0)
my_cup_size <- sample(cup_sizes, 1)
pot <- coffee_pot$new(capacity=100)
pot$fill()
pot$pour_cup(cup_size=my_cup_size)


sim_day <- function(num_workers, my_position, my_amount){
  stopifnot(num_workers < 100)
  
  worker_ids <- paste0("worker", sprintf("%02d", 1:num_workers))
  my_id <- worker_ids[my_position]
  message(paste0("i am worker ", my_id, " in this sim"))
  
  worker_amounts <- runif(length(worker_ids), min=0, max=1)
  worker_amounts[my_position] <- my_amount
  
  workers <- setNames(worker_amounts, nm=worker_ids)
  
  office_pot <- coffee_pot$new(capacity=1)
  office_pot$fill()
  
  # keep a value if he's able to take it; set to zero if he has to fill
  result <- setNames(rep(NA, times=length(worker_ids)), nm=worker_ids)
  
  for (w_idx in seq_along(workers)){
    # try to pour; if can't, fill
    # if he can pour, do nothing; if not, set his result to zero
    cup_amount <- workers[w_idx]
    if (cup_amount > office_pot$remaining){
      office_pot$fill()
      result[w_idx] <- 0
    } else {
      office_pot$pour_cup(cup_size=cup_amount)
      result[w_idx] <- workers[w_idx]
    }
  }
  amount_i_drank <- result[my_position]
  amount_others_drank <- result[-my_position]
  return(list(
    amount_i_drank=amount_i_drank, 
    amount_others_drank=amount_others_drank
    # also get my rank of amount drank, mean of amount drank, etc. 
    # what prop of ppl drank, etc.
  ))
}

sim_day(num_workers=10, my_position=1, my_amount=.5)


# Riddler Headquarters is a buzzing hive of activity. Mathematicians, statisticians and programmers roam the halls at all hours, proving theorems and calculating probabilities. They’re fueled, of course, by caffeine. But the headquarters has just one coffee pot, along with one unbreakable rule: You finish the joe, you make some mo’.

# Specifically, the coffee pot holds one gallon of coffee, and workers fill their mugs from it in sequence. Whoever takes the last drop has to make the next pot, no ifs, ands or buts. Every worker in the office is trying to take as much coffee as he or she can while minimizing the probability of having to refill the pot. Also, this pot is both incredibly heavy and completely opaque, so it’s tough to tell how much remains. That means a worker can’t keep pouring until she sees or feels just a drop left. Anyone stuck refilling the pot becomes so frustrated that they throw their cup to the ground in frustration, so they get no coffee that round.

# Congratulations! You’ve just been hired to work at Riddler Headquarters. Submit a number between 0 and 1. (It could be 0.9999, or 0.0001, or 0.5, or 0.12345, and so on.) This is the number of gallons of coffee you will attempt to take from the pot each time you go for a cup. If that amount remains, lucky you, you get to drink it. If less remains, you’re out of luck that round; you must refill the pot, and you get no coffee.

# Once I’ve received your submissions, I’ll randomize the order in which you and your colleagues head for the pot. Then I’ll run a lot of simulations — thousands of hypothetical trips to the coffee pot in the Riddler offices. Whoever drinks the most coffee is the ☕ Caffeine King or Queen ☕ of Riddler Headquarters!


