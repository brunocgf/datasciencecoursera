run_analysis <- function(){
  
  header <- read.table("./UCI HAR Dataset/features.txt", sep="")
  test <- read.table("./UCI HAR Dataset/test/X_test.txt", sep="")
  train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="")
  
  complete_data <- rbind(test, train)
  colnames(complete_data) <- header$V2
  
  write.table(complete_data, file="Tidy_Data.txt")
  
}