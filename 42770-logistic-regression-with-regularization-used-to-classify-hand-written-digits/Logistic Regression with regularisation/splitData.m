function [XTrain XTest yTrain yTest] = splitData(X, y)

% Splits the data into training and testing

% Useful Variables
totalEgs = size(X,1);
numTrain = 0.8*totalEgs; % 80% data reserved for training
numTest = 0.2*totalEgs; % 20% reserved for testing
numLabels = unique(y); % how many unique labels present
TrainPerLable = numTrain/length(numLabels); % how many egs per lable in training
TestPerLable = numTest/length(numLabels);  % how many egs per lable in test

for i=1:length(numLabels)
    temp = (y==numLabels(i,1)); % find out where each label is present
    idx = find(temp==1); % get the index of that row where the lable is present
    Xtemp = X(idx(:,1),:); % get values of X stored at that particular index
    idxTemp = (randperm(size(Xtemp,1)))'; % randomly choose rows to put into train
    XTrainTemp = Xtemp(idxTemp(1:TrainPerLable,1),:);
    yTrainTemp = (ones(TrainPerLable,1))*i; 
    XTestTemp = Xtemp(idxTemp(TrainPerLable+1:end),:); % select remaining rows for testing
    yTestTemp = (ones(TestPerLable,1))*i;
    
    if i==1 % set up first input to train and test
        XTrain = XTrainTemp;
        yTrain = yTrainTemp;
        XTest = XTestTemp;
        yTest = yTestTemp;
    else % keep adding new egs to the training and testing sets
        XTrain = [XTrain; XTrainTemp];
        yTrain = [yTrain; yTrainTemp];
        XTest = [XTest; XTestTemp];
        yTest = [yTest; yTestTemp];
    end
end