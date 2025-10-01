# --- Self-Organizing Map Demo with New Sample BMU ---

set.seed(123)

# --- Parameters ---
grid_size <- 10
iterations <- 100
initial_radius <- 5
initial_lr <- 0.5
n_samples <- 200  # size of training set per iteration

# --- Generate Initial Grid (weights) ---
red_matrix   <- matrix(runif(grid_size^2, 0, 255), nrow = grid_size)
green_matrix <- matrix(runif(grid_size^2, 0, 255), nrow = grid_size)
blue_matrix  <- matrix(runif(grid_size^2, 0, 255), nrow = grid_size)

initial_color_matrix <- matrix(
  rgb(red_matrix, green_matrix, blue_matrix, maxColorValue = 255),
  nrow = grid_size
)

# --- Generate Training Set (inputs from full RGB space) ---
training_set <- data.frame(
  red   = sample(0:255, n_samples, replace = TRUE),
  green = sample(0:255, n_samples, replace = TRUE),
  blue  = sample(0:255, n_samples, replace = TRUE)
)

# --- Function to Plot Grid ---
plot_grid <- function(color_matrix, main_title = "Color Grid") {
  plot(x = 0:(grid_size+1), y = 0:(grid_size+1), type = "n", asp = 1,
       xlab = "", ylab = "", main = main_title)
  for (x in 1:grid_size) {
    for (y in 1:grid_size) {
      points(x, y, pch = 15, cex = 4, col = color_matrix[y, x])
    }
  }
}

# --- Training Loop ---
for (iter in 1:iterations) {
  
  # Decay parameters
  radius <- initial_radius * exp(-iter / iterations)
  lr <- initial_lr * exp(-iter / iterations)
  
  # Shuffle training set each iteration
  shuffled_set <- training_set[sample(nrow(training_set)), ]
  
  for (i in 1:nrow(shuffled_set)) {
    red_input   <- shuffled_set$red[i]
    green_input <- shuffled_set$green[i]
    blue_input  <- shuffled_set$blue[i]
    
    # Find BMU (closest cell in color space)
    distance_matrix <- sqrt((red_matrix - red_input)^2 +
                              (green_matrix - green_input)^2 +
                              (blue_matrix - blue_input)^2)
    bmu <- which(distance_matrix == min(distance_matrix), arr.ind = TRUE)
    bmu_x <- bmu[1]; bmu_y <- bmu[2]
    
    # Update neighbors
    for (x in 1:grid_size) {
      for (y in 1:grid_size) {
        grid_distance <- sqrt((x - bmu_x)^2 + (y - bmu_y)^2)
        if (grid_distance <= radius) {
          influence <- exp(-(grid_distance^2) / (2 * radius^2))
          red_matrix[x, y]   <- red_matrix[x, y] + lr * influence * (red_input - red_matrix[x, y])
          green_matrix[x, y] <- green_matrix[x, y] + lr * influence * (green_input - green_matrix[x, y])
          blue_matrix[x, y]  <- blue_matrix[x, y] + lr * influence * (blue_input - blue_matrix[x, y])
        }
      }
    }
  }
}

# --- Build Final Color Matrix ---
final_color_matrix <- matrix(
  rgb(red_matrix, green_matrix, blue_matrix, maxColorValue = 255),
  nrow = grid_size
)

# --- Plot Original vs Final ---
par(mfrow = c(1, 2))
plot_grid(initial_color_matrix, "Original Random Grid")
plot_grid(final_color_matrix, "Final SOM Grid")
par(mfrow = c(1, 1))

# --- New Sample Demonstration ---
# Pick a brand-new random color NOT used in training
new_sample <- data.frame(
  red   = sample(0:255, 1),
  green = sample(0:255, 1),
  blue  = sample(0:255, 1)
)

# Find BMU for new color
distance_matrix <- sqrt((red_matrix - new_sample$red)^2 +
                          (green_matrix - new_sample$green)^2 +
                          (blue_matrix - new_sample$blue)^2)
bmu <- which(distance_matrix == min(distance_matrix), arr.ind = TRUE)
bmu_x <- bmu[1]; bmu_y <- bmu[2]

# Plot final grid and highlight BMU
plot_grid(final_color_matrix, "Final Grid + New Sample BMU")
points(bmu_x, bmu_y, pch = 1, cex = 2, lwd = 2, col = "black")

# Show new sample color in legend
legend("topright", legend = "New Sample", pch = 15, pt.cex = 2, bty = "n",
       col = rgb(new_sample$red, new_sample$green, new_sample$blue, maxColorValue = 255))
