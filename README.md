Steps I followed to do modelling and prediction

1. Data cleanup
  - Remove all columns with NA more than 80%
  - Remove all non-numeric variables
  - Remove unwanted columns from the original dataset

2. Data Pre-processing
  - Inpute NAs using knnInpute
  - Check near zero variables, no such variables found
  - Use PCA to remove correlated variables

3. Modelling
  - Use a simple Random Forest model in randomForest package

4. Prediction
  - Use the same data processing procedure to the final test dataset
  - Run the random forest model to prodict on the 20 data points. I got 19/20 
    right after running random forest models for three times 


To compile the html file, I used index.Rmd

I also put the R script in the repository for those
who want to run the script. You either need to change the
path to the files or put the script under the dir that contains
data subdir and you put the two files under data/


