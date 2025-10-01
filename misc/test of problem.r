# set seed
set.seed(123)

# generate initial grid of nodes and assign rgb values
red_matrix   <- matrix(runif(100, 0, 255), nrow = 10)
green_matrix <- matrix(runif(100, 0, 255), nrow = 10)
blue_matrix  <- matrix(runif(100, 0, 255), nrow = 10)

# generate color names for initial grid
initial_color_matrix <- matrix(
  rgb(red_matrix, green_matrix, blue_matrix, maxColorValue = 255),
  nrow = 10
)

plot(x = 0:11, y = 0:11, type = "n", asp = 1,
     xlab = "", ylab = "", main = "this is a test")
for (x in 1:10) {
  for (y in 1:10) {
    points(x, y, pch = 15, cex = 4, col = initial_color_matrix[x, y])
  }
}
