# global.R file for self-optimizing map learning module

# packages to load
library(shiny)
library(shinythemes)

# set color scheme
palette("Okabe-Ito")

# set seed to fix random values below
set.seed(123)

# generate initial grid of nodes and assign rgb values
# red_matrix   <- matrix(runif(100, 0, 255), nrow = 10)
# green_matrix <- matrix(runif(100, 0, 255), nrow = 10)
# blue_matrix  <- matrix(runif(100, 0, 255), nrow = 10)
red_matrix   <- round(matrix(runif(100, 0, 255), nrow = 10),0)
green_matrix <- round(matrix(runif(100, 0, 255), nrow = 10),0)
blue_matrix  <- round(matrix(runif(100, 0, 255), nrow = 10),0)


grid_size = 10

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

# --- Generate Training Set (inputs from full RGB space) ---
n_samples = 200
training_set <- data.frame(
  red   = sample(0:255, n_samples, replace = TRUE),
  green = sample(0:255, n_samples, replace = TRUE),
  blue  = sample(0:255, n_samples, replace = TRUE)
)

# --- Function to Plot Grid ---
plot_grid <- function(color_matrix, main_title = "Color Grid") {
  plot(x = 0:(grid_size+1), y = 0:(grid_size+1), type = "n", asp = 1,
       xlab = "", ylab = "", main = main_title, bty = "n",
       xaxt = "n", yaxt = "n")
  for (x in 1:grid_size) {
    for (y in 1:grid_size) {
      points(x, y, pch = 15, cex = 8, col = color_matrix[y, x])
    }
  }
}
