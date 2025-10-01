# Parameters
grid_size <- 11
bmu_x <- 6
bmu_y <- 6
radius <- 4

# Create matrices for distances
euclidean_matrix <- matrix(0, nrow = grid_size, ncol = grid_size)
manhattan_matrix <- matrix(0, nrow = grid_size, ncol = grid_size)

for (x in 1:grid_size) {
  for (y in 1:grid_size) {
    euclidean_matrix[x, y] <- sqrt((x - bmu_x)^2 + (y - bmu_y)^2)
    manhattan_matrix[x, y] <- abs(x - bmu_x) + abs(y - bmu_y)
  }
}

# Logical matrices for neighbors
euclidean_neighbors <- euclidean_matrix <= radius
manhattan_neighbors <- manhattan_matrix <= radius

# Plot side-by-side
par(mfrow = c(1, 2), mar = c(2, 2, 3, 2))

# Euclidean
image(
  t(apply(euclidean_neighbors, 2, rev)),
  col = c("white", "lightblue"),
  axes = FALSE,
  main = "Euclidean Distance (Circle-like)"
)
points((bmu_x - 1) / (grid_size - 1), (bmu_y - 1) / (grid_size - 1),
       pch = 4, col = "red", cex = 2, lwd = 2)

# Manhattan
image(
  t(apply(manhattan_neighbors, 2, rev)),
  col = c("white", "lightblue"),
  axes = FALSE,
  main = "Manhattan Distance (Diamond-shaped)"
)
points((bmu_x - 1) / (grid_size - 1), (bmu_y - 1) / (grid_size - 1),
       pch = 4, col = "red", cex = 2, lwd = 2)
