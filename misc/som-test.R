# set seed so that the same conditions will apply when running code; remove when finished with coding
set.seed(123)

# create separate 10x10 matrices for red, green, and blue values; each is sampled from values between 0 and 255, inclusive, with replacement
red_matrix = matrix(sample(0:255, 100, replace = TRUE), 
                    nrow = 10, ncol = 10)
green_matrix = matrix(sample(0:255, 100, replace = TRUE), 
                      nrow = 10, ncol = 10)
blue_matrix = matrix(sample(0:255, 100, replace = TRUE), 
                     nrow = 10, ncol = 10)

# create matrix of rgb color values as hex codes
color_matrix = matrix(rgb(red_matrix, green_matrix, blue_matrix, 
                          maxColorValue = 255), nrow = 10, ncol = 10)

# plot 10x10 grid that shows colors given by hex codes in color_matrix; create empty plot to establish x and y limits, set aspect ratio, suppress axis labels; add points as rectangles filled with colors taken from color_matrix
plot(x = 0:11, y = 0:11, type = "n", asp = 1, xlab = "", ylab = "")
for (x in 1:10){
  for (y in 1:10){
    points(x , y , type = "p", pch = 15, 
           xlim = c(0,11), ylim = c(0,11),
           cex = 4, col = color_matrix[x,y])
  }
}

# select a random cell as input that will be used to train the grid and determine the values for red, green, and blue
input_x = sample(1:10, 1)
input_y = sample(1:10, 1)
red_input = red_matrix[input_x,input_y]
green_input = green_matrix[input_x,input_y]
blue_input = blue_matrix[input_x,input_y]

# add circle to grid to show location of the random input; this is temporary code to aid in following the training process
points(input_x , input_y , type = "p", pch = 1, 
       xlim = c(0,11), ylim = c(0,11), cex = 2, col = "black")

# calculate distance matrix for all 100 points to the random random input using Euclidean distance
distance_matrix = matrix(0, nrow = 10, ncol = 10)
for (x in 1:10){
  for (y in 1:10){
    distance_matrix[x,y] = sqrt(((red_input - red_matrix[x,y])^2 + 
                                 (green_input - green_matrix[x,y])^2 + 
                                 (blue_input - blue_matrix[x,y])^2))
  }
}

# locate the best matching unit (bmu), which is the second smallest value in the distance_matrix---the smallest value is zero and it is the random input being used for training; and add circle to identify location; the points line is temporary code to aid in following the training process
bmu = which(distance_matrix == min(distance_matrix[-input_x,-input_y]), 
            arr.ind = TRUE)
points(x = bmu[1,1], y = bmu[1,2], type = "p", pch = 1, 
       xlim = c(0,11), ylim = c(0,11),
       cex = 2, col = "white")

radius_initial = 10/2
current_iteration = 1
max_iteration = 10
time_constant = max_iteration/log(radius_initial)
radius_iteration = radius_initial * exp(-current_iteration/time_constant)
alpha_initial = 0.3
alpha_iteration = alpha_initial * exp(current_iteration/max_iteration)

