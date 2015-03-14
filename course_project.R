library(caret)
library(kernlab)
library(randomForest)

#Load in the data
data <- read.csv("data/pml-training.csv", header=TRUE)

#See all data types
sapply(data, class)

#
#Data pre-processing
# 
#
#Remove all columns with NA less than 80%.
#They are not very informative
data <- data[,colSums(is.na(data))<(nrow(data)*0.8)]

#keep classe column and it's name, will append 
# it to the pro-processed data
classe<- data$classe;
names(classe)<- "classe"

#Remove all non-numeric columns
#Keep all numeric columns only
data <- data[, sapply(data, is.numeric)]

#Add classe back to the data set
data <-cbind(data, classe)

#Remove unwanted columns
data <-subset(data, select = -c(X, raw_timestamp_part_1,
              raw_timestamp_part_2, num_window)) 

#Inpute null values first, using knnImpute
#NOTE: column 53 is classe in the new data frame
preObj <- preProcess(data[, -c(53)], method ="knnImpute")

#Find near zero variables
nearZeroVar(data, saveMetrics=TRUE)
#No near Zero Variables 

#create data partition for training and testing
inTrain <- createDataPartition(y=data$classe, p=0.75, list=FALSE)
training <-data[inTrain, ]
testing <-data[-inTrain, ]

## Find corrlated predictors
#Find corrlated variables
M <- abs(cor(data[, -c(53)]))
diag(M) <- 0
which(M > 0.95, arr.ind=T)

#There are 5  pairs of variable have cor more than 0.95
#So, use threshold 0.95 for PCA pre-processing
preProc <- preProcess(data[, -53], thresh=0.95, method='pca')

#The PCA generates 25 principal components

#New data sets after PCA 
trainPC <- predict(preProc, training[, -53])
testPC <- predict(preProc, testing[, -53])

##First Random forest try
#THis is too slow.
#modFit =train(training$classe, method='rf', data=data)

#Use a simple randomForest
modFit <- randomForest(training$classe ~. , data=trainPC)
testPredict <- predict(modFit, testPC);
confusionMatrix(testing$classe, testPredict)

###The prediction on the final 20 data points for submission
finalTest <- read.csv("data/pml-testing.csv", header=TRUE)
#use the same way to pre-process the data
#Remove non-numeric columns
testData <- finalTest[, sapply(finalTest, is.numeric)]

#Extract the columns that are selected by the training
testData1 <- testData[, names(data)[-53]]

# use the same PCA 
testPC <- predict(preProc, testData1)

#predict on the final test set
finalPredict <- predict(modFit, testPC)
#print out prid3
finalPredict

##I got 3 and 11 wrong the first time runing the 
#Random forest

#In the second run, I got 11 right. In total, I got 19 predicts right
# out of the 20 test data points

#Need to access using this link
http://dianhuizhu.github.io/PracticalML/gh-pages/

#########The above command didn't succeed. Re-try
http://harpjs.com/docs/deployment/github-pages#project-pages
