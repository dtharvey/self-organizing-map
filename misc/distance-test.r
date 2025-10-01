
red_train = sample(0:255,200, replace = TRUE)
green_train = sample(0:255,200, replace = TRUE)
blue_train = sample(0:255,200, replace = TRUE)


train_id = sample(1:200,1, replace = TRUE)

red_matrix   <- matrix(runif(100, 0, 255), nrow = 10)
green_matrix <- matrix(runif(100, 0, 255), nrow = 10)
blue_matrix  <- matrix(runif(100, 0, 255), nrow = 10)

distance_matrix = sqrt((red_matrix - red_train[train_id])^2 + (green_matrix - green_train[train_id])^2 + (blue_matrix - blue_train[train_id])^2)


red_train = 182
green_train = 14
blue_train = 90

distance_matrix = sqrt((red_matrix - red_train)^2 + (green_matrix - green_train)^2 + (blue_matrix - blue_train)^2)
