%Test weka's Naive Bayes implementation on the iris data. 

load fisheriris;    %built in to matlab

%Shuffle the data
rand('twister',0);
perm = randperm(150);
meas = meas(perm,:);
species = species(perm,:);

featureNames = {'sepallength','sepalwidth','petallength','petalwidth','class'};

%Prepare test and training sets. 
data = [num2cell(meas),species];
train = data(1:120  ,:);
test  = data(121:end,:);

classindex = 5;

%Convert to weka format
train = matlab2weka('iris-train',featureNames,train,classindex);
test =  matlab2weka('iris-test',featureNames,test);

%Train the classifier
nb = trainWekaClassifier(train,'bayes.NaiveBayes');

%Test the classifier
predicted = wekaClassify(test,nb);

%The actual class labels (i.e. indices thereof)
actual = test.attributeToDoubleArray(classindex-1); %java indexes from 0

errorRate = sum(actual ~= predicted)/30

