# som sandbox

# set color scheme
palette("Okabe-Ito")

# set seed to fix random values below
set.seed(123)

# generate initial grid of nodes and assign rgb values
red_matrix   <- matrix(runif(100, 0, 255), nrow = 10)
green_matrix <- matrix(runif(100, 0, 255), nrow = 10)
blue_matrix  <- matrix(runif(100, 0, 255), nrow = 10)

# generate color names for initial grid
color_matrix_1 <- matrix(
  rgb(red_matrix, green_matrix, blue_matrix, maxColorValue = 255),
  nrow = 10
)

# red, green, blue values for training sample in second activity
red_train = 182
green_train = 14
blue_train = 90

# calculate distance matrix; bmu is row three, column 2
distance_matrix = sqrt((red_matrix - red_train)^2 + (green_matrix - green_train)^2 + (blue_matrix - blue_train)^2)
bmu = which(distance_matrix == min(distance_matrix), arr.ind = TRUE)
bmu_x = bmu[1]
bmu_y = bmu[2]

radius = 10
learning_rate = 1

for (x in 1:10){
  for (y in 1:10){
    grid_distance = sqrt((x - bmu_x)^2 + (y - bmu_y)^2)
    if (grid_distance <= radius){
      influence = exp(-(grid_distance)^2/(2 * radius^2))
      red_matrix[x,y] = red_matrix[x,y] + learning_rate * influence * (red_train - red_matrix[x,y])
      green_matrix[x,y] = green_matrix[x,y] + learning_rate * influence * (green_train - green_matrix[x,y])
      blue_matrix[x,y] = blue_matrix[x,y] + learning_rate * influence * (blue_train - blue_matrix[x,y])
    }
  }
}

color_matrix_2 <- matrix(
  rgb(red_matrix, green_matrix, blue_matrix, maxColorValue = 255),
  nrow = 10)

plot(x = 0:11, y = 0:11, type = "n", asp = 1, bty = "n",
     xaxt = "n", yaxt = "n",
     xlab = "", ylab = "", main = "")
for (x in 1:10) {
  for (y in 1:10) {
    points(x, y, pch = 15, cex = 6, 
           col = color_matrix_1[y,x])
  }
}

center_x = 2-0.5
center_y = 3-0.5

angle = seq(0, 2 * pi, length.out = 100)
x_coords <- center_x + radius * cos(angle)
y_coords <- center_y + radius * sin(angle)

lines(x_coords, y_coords, col = "white", lwd = 4)

plot(x = 0:11, y = 0:11, type = "n", asp = 1, bty = "n",
     xaxt = "n", yaxt = "n",
     xlab = "", ylab = "", main = "")
for (x in 1:10) {
  for (y in 1:10) {
    points(x, y, pch = 15, cex = 6, 
           col = color_matrix_2[y,x])
  }
}

center_x = 2-0.5
center_y = 3-0.5

angle = seq(0, 2 * pi, length.out = 100)
x_coords <- center_x + radius * cos(angle)
y_coords <- center_y + radius * sin(angle)

lines(x_coords, y_coords, col = "white", lwd = 4)


