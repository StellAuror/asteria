# Function to generate synthetic training data with progression, regression, and stagnation
generate_training_data <- function(n_sessions, initial_weights, muscle_growth_factors, max_weights, noise=0.05) {
  
  # Define a list of exercises and their corresponding types and target muscle group
  exercises <- data.frame(
    Name = c("Squats", "Deadlifts", "Bench Press", "Overhead Press", "Barbell Rows", 
             "Bicep Curl", "Tricep Extension", "Leg Press", "Pull-Ups", "Chin-Ups", 
             "Dips", "Push-Ups", "Lunges", "Plank", "Leg Raises", "Sit-Ups", 
             "Russian Twists", "Burpees", "Kettlebell Swings", "Farmers Walk"),
    Type = c("Barbell", "Barbell", "Barbell", "Barbell", "Barbell", 
             "Dumbbell", "Dumbbell", "Machine", "Bodyweight", "Bodyweight", 
             "Bodyweight", "Bodyweight", "Bodyweight", "Bodyweight", "Bodyweight", "Bodyweight", 
             "Bodyweight", "Bodyweight", "Kettlebell", "Dumbbell"),
    MuscleGroup = c("Legs", "Legs", "Chest", "Shoulders", "Back", 
                    "Arms", "Arms", "Legs", "Back", "Back", 
                    "Chest", "Chest", "Legs", "Core", "Core", "Core", 
                    "Core", "Full Body", "Full Body", "Full Body"),
    stringsAsFactors = FALSE
  )
  
  # Initialize empty data frame
  data <- data.frame(
    ID = numeric(0),
    Name = character(0),
    Weight = numeric(0),
    Rep = numeric(0),
    Date = character(0),
    Year = numeric(0),
    Load = numeric(0),
    Type = character(0),
    MuscleGroup = character(0),
    stringsAsFactors = FALSE
  )
  
  # Set a random seed for reproducibility
  set.seed(123)
  
  # Generate data for each session
  for (i in 1:n_sessions) {
    for (exercise in 1:nrow(exercises)) {
      # Get the exercise details
      exercise_name <- exercises$Name[exercise]
      muscle_group <- exercises$MuscleGroup[exercise]
      
      # Determine initial weight, growth factor, and max weight
      initial_weight <- initial_weights[[muscle_group]]
      growth_factor <- muscle_growth_factors[[muscle_group]]
      max_weight <- max_weights[[exercise_name]]
      
      # Simulate progression, regression, or stagnation
      if (i == 1) {
        weight <- initial_weight
      } else {
        # Retrieve the previous weight for this exercise
        previous_weight <- data$Weight[nrow(data) - nrow(exercises) + exercise]
        
        if (previous_weight < max_weight) {
          # Apply progression
          trend <- rnorm(1, mean = growth_factor, sd = noise)
          weight <- previous_weight * (1 + trend)
          
          # Ensure weight stays within [5, max_weight]
          weight <- max(weight, 5)
          weight <- min(weight, max_weight)
        } else {
          # Stagnate at max_weight
          weight <- max_weight - (max_weight * (sample(-20:20, 1)/100))
        }
      }
      
      # Randomize repetitions based on progression/regression
      reps <- round(rnorm(1, mean = 10, sd = 2))
      reps <- max(reps, 1)
      
      # Generate date
      date <- as.Date("2021-01-01") + (i*2) * sample(1:7, 1)
      
      # Calculate load
      load <- weight * reps
      
      # Append a new row to the data frame
      data <- rbind(data, data.frame(
        ID = nrow(data) + 1,
        Name = exercise_name,
        Weight = round(weight, 1),  # Round to one decimal for consistency
        Rep = reps,
        Date = as.Date(date, format = "%Y-%m-%d"),
        Year = as.numeric(format(date, "%Y")),
        Load = round(load, 1),
        Type = exercises$Type[exercise],
        MuscleGroup = muscle_group,
        stringsAsFactors = FALSE
      ))
    }
  }
  
  return(data)
}

# Define initial weights for each muscle group
initial_weights <- list(
  "Legs" = 60,
  "Chest" = 40,
  "Shoulders" = 30,
  "Back" = 50,
  "Arms" = 20,
  "Core" = 15,
  "Full Body" = 25
)

# Define growth factors for each muscle group (positive for progression, negative for regression)
muscle_growth_factors <- list(
  "Legs" = 0.02,
  "Chest" = 0.015,
  "Shoulders" = 0.01,
  "Back" = 0.018,
  "Arms" = 0.012,
  "Core" = 0.008,
  "Full Body" = 0.01
)

# Define maximum weights for each exercise
max_weights <- list(
  "Squats" = 100,
  "Deadlifts" = 120,
  "Bench Press" = 80,
  "Overhead Press" = 60,
  "Barbell Rows" = 100,
  "Bicep Curl" = 40,
  "Tricep Extension" = 40,
  "Leg Press" = 100,
  "Pull-Ups" = 100,
  "Chin-Ups" = 100,
  "Dips" = 100,
  "Push-Ups" = 50,
  "Lunges" = 80,
  "Plank" = 50,
  "Leg Raises" = 30,
  "Sit-Ups" = 30,
  "Russian Twists" = 30,
  "Burpees" = 40,
  "Kettlebell Swings" = 60,
  "Farmers Walk" = 50
)

# Generate data for 20 sessions
training_data <- generate_training_data(50, initial_weights, muscle_growth_factors, max_weights)

# View the generated data
training_data |>
  mutate(Date = as.Date(Date, format = "%Y-%m-%d"))