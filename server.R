# server.R file for self-optimizing maps

shinyServer(function(input, output, session){

# code for first activity exploring rgb color system
  output$activity1a = renderPlot({
    par(mar = c(0,0,1,0) + 0.1)
    plot(x = 1, y = 1, type = "n", xlim = c(0,32), ylim = c(0,5),
         xlab = "", ylab = "", xaxt = "n", yaxt = "n", bty = "n",
         main = "individual colors of red, green, and blue")
    rect(xleft = 1, xright = 7, ybottom = 1, ytop = 4, 
         col = rgb(input$ac1_red, 0, 0, 
                   maxColorValue = 255))
    rect(xleft = 13, xright = 19, ybottom = 1, ytop = 4, 
         col = rgb(0, input$ac1_green, 0, 
                   maxColorValue = 255))
    rect(xleft = 25, xright = 31, ybottom = 1, ytop = 4, 
         col = rgb(0, 0, input$ac1_blue, 
                   maxColorValue = 255))
  })
  
  output$activity1b = renderPlot({
    par(mar = c(0,0,1,0) + 0.1)
    plot(x = 1, y = 1, type = "n", xlim = c(0,32), ylim = c(0,5),
         xlab = "", ylab = "", xaxt = "n", yaxt = "n", bty = "n",
         main = "color from mixing of red, green, and blue")
    rect(xleft = 1, xright = 31, ybottom = 1, ytop = 4, 
         col = rgb(input$ac1_red, input$ac1_green, input$ac1_blue, 
                   maxColorValue = 255))
  })
  
# code for second activity to find bmu  
  output$activity2a = renderPlot({
    old.par = par(mar = c(0,0,0,0))
    plot(x = 0:11, y = 0:11, type = "n", asp = 1, bty = "n",
         xaxt = "n", yaxt = "n",
         xlab = "", ylab = "", main = "")
    for (x in 1:10) {
      for (y in 1:10) {
        points(x, y, pch = 15, cex = 6, 
               col = color_matrix_1[y,x])
      }
    }
    points(x = input$column_number, y = input$row_number, pch = 19, col = "white")
    par(old.par)
  })

 output$rgb = renderText({
   colnum = input$column_number
   rownum = input$row_number
   color_r = round(red_matrix[rownum,colnum],0)
   color_g = round(green_matrix[rownum,colnum],0)
   color_b = round(blue_matrix[rownum,colnum],0)
   paste0("(R,G,B) = (", color_r,",", color_g, ",", color_b,")")
 }) 
 
 output$distance = renderText({
   colnum = input$column_number
   rownum = input$row_number
   paste0("distance = ", round(distance_matrix[rownum,colnum],0))
 })
 
#code for third activity to update rgb values of nodes
  output$activity3a = renderPlot({
    old.par = par(mar = c(0,0,0,0))
    plot(x = 0:11, y = 0:11, type = "n", asp = 1, bty = "n",
         xaxt = "n", yaxt = "n",
         xlab = "", ylab = "", main = "")
    for (x in 1:10) {
      for (y in 1:10) {
        points(x, y, pch = 15, cex = 4, 
               col = color_matrix_1[y,x])
      }
    }
    points(x = 2, y = 3, pch = 19, col = "white")
    par(old.par)
 })
  
  output$activity3b = renderPlot({
    old.par = par(mar = c(0,0,0,0))
    
    radius = input$radius
    learning_rate = input$stepsize
    
    red_matrix_act3b = red_matrix
    green_matrix_act3b = green_matrix
    blue_matrix_act3b = blue_matrix
    
    for (x in 1:10){
      for (y in 1:10){
        grid_distance = sqrt((x - bmu_x)^2 + (y - bmu_y)^2)
        if (grid_distance <= radius){
          influence = exp(-(grid_distance)^2/(2 * radius^2))
          red_matrix_act3b[x,y] = red_matrix_act3b[x,y] + learning_rate * influence * (red_train - red_matrix_act3b[x,y])
          green_matrix_act3b[x,y] = green_matrix_act3b[x,y] + learning_rate * influence * (green_train - green_matrix_act3b[x,y])
          blue_matrix_act3b[x,y] = blue_matrix_act3b[x,y] + learning_rate * influence * (blue_train - blue_matrix_act3b[x,y])
        }
      }
    }
    color_matrix_2 <- matrix(
      rgb(red_matrix_act3b, green_matrix_act3b, blue_matrix_act3b, maxColorValue = 255),
      nrow = 10)
    
    plot(x = 0:11, y = 0:11, type = "n", asp = 1, bty = "n",
         xaxt = "n", yaxt = "n",
         xlab = "", ylab = "", main = "")
    for (x in 1:10) {
      for (y in 1:10) {
        points(x, y, pch = 15, cex = 4, 
               col = color_matrix_2[y,x])
      }
    }
    
    center_x = 2
    center_y = 3
    
    angle = seq(0, 2 * pi, length.out = 100)
    x_coords <- center_x + radius * cos(angle)
    y_coords <- center_y + radius * sin(angle)
    
    lines(x_coords, y_coords, col = "white", lwd = 4)
    points(x = 2, y = 3, pch = 19, col = "white")
    par(old.par)
  })
  
  output$activity4a = renderPlot({
    grid_size <- 10
    iterations <- input$iterations
    initial_radius <- input$radius_0
    initial_lr <- input$eta_0
    n_samples <- 200  # size of training set per iteration
    
    red_matrix_act4a = red_matrix
    green_matrix_act4a = green_matrix
    blue_matrix_act4a = blue_matrix
    
    initial_color_matrix <- matrix(
      rgb(red_matrix_act4a, green_matrix_act4a, blue_matrix_act4a, maxColorValue = 255),
      nrow = grid_size
    )
    
    # --- Generate Training Set (inputs from full RGB space) ---
    # training_set <- data.frame(
    #   red   = sample(0:255, n_samples, replace = TRUE),
    #   green = sample(0:255, n_samples, replace = TRUE),
    #   blue  = sample(0:255, n_samples, replace = TRUE)
    # )
    
    # # --- Function to Plot Grid ---
    # plot_grid <- function(color_matrix, main_title = "Color Grid") {
    #   plot(x = 0:(grid_size+1), y = 0:(grid_size+1), type = "n", asp = 1,
    #        xlab = "", ylab = "", main = main_title, bty = "n",
    #        xaxt = "n", yaxt = "n")
    #   for (x in 1:grid_size) {
    #     for (y in 1:grid_size) {
    #       points(x, y, pch = 15, cex = 5, col = color_matrix[y, x])
    #     }
    #   }
    # }
    
    # --- Training Loop ---
    for (i in 1:iterations) {
      
      # Decay parameters
      radius <- initial_radius * exp(-i / 100)
      lr <- initial_lr * exp(-i / 100)
      
      # Shuffle training set each iteration
      shuffled_set <- training_set[sample(nrow(training_set)), ]
      
      for (i in 1:nrow(shuffled_set)) {
        red_input   <- shuffled_set$red[i]
        green_input <- shuffled_set$green[i]
        blue_input  <- shuffled_set$blue[i]
        
        # Find BMU (closest cell in color space)
        distance_matrix <- sqrt((red_matrix_act4a - red_input)^2 +
                                  (green_matrix_act4a - green_input)^2 +
                                  (blue_matrix_act4a - blue_input)^2)
        bmu <- which(distance_matrix == min(distance_matrix), arr.ind = TRUE)
        bmu_x <- bmu[1]; bmu_y <- bmu[2]
        
        # Update neighbors
        for (x in 1:grid_size) {
          for (y in 1:grid_size) {
            grid_distance <- sqrt((x - bmu_x)^2 + (y - bmu_y)^2)
            if (grid_distance <= radius) {
              influence <- exp(-(grid_distance^2) / (2 * radius^2))
              red_matrix_act4a[x, y]   <- red_matrix_act4a[x, y] + lr * influence * (red_input - red_matrix_act4a[x, y])
              green_matrix_act4a[x, y] <- green_matrix_act4a[x, y] + lr * influence * (green_input - green_matrix_act4a[x, y])
              blue_matrix_act4a[x, y]  <- blue_matrix_act4a[x, y] + lr * influence * (blue_input - blue_matrix_act4a[x, y])
            }
          }
        }
      }
    }
    
    # --- Build Final Color Matrix ---
    final_color_matrix <- matrix(
      rgb(red_matrix_act4a, green_matrix_act4a, blue_matrix_act4a, maxColorValue = 255),
      nrow = grid_size
    )
    
    # --- Plot Final ---
    old.par = par(mar = c(0,0,0,0))
    plot_grid(final_color_matrix, "")
    par(old.par)

    red_new = sample(0:255,1)
    green_new = sample(0:255,1)
    blue_new = sample(0:255,1)
    distance_new = sqrt((red_matrix_act4a - red_new)^2 + (green_matrix_act4a - green_new)^2 + (blue_matrix_act4a - blue_new)^2)
    bmu_new = which(distance_new == min(distance_new), arr.ind = TRUE)
    points(x = bmu_new[2], y = bmu_new[1], pch = 1, lwd = 4, cex = 4, col = "white")
    legend("topright", legend = "  new sample", pch = 15, pt.cex = 5, bty = "n",
           col = rgb(red_new, green_new, blue_new, maxColorValue = 255))
  })

}) # keep this to close the server file
