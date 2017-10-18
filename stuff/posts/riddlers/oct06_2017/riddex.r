# https://fivethirtyeight.com/features/can-you-beat-the-game-show/
# A farmer has three daughters. He is getting old and decides to split his 1-mile-by-1-mile farm equally among his daughters using fencing. What is the shortest length of fence he needs to divide his square farm into three sections of equal area?


side <- 10
gran <- 1
idx <- seq(from=1, to=side, by=gran)
paste0(idx, idx)
m <- sapply(idx, function(x) paste0(x, "_", idx), simplify=TRUE)


