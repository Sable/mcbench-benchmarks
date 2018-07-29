clc;
clear all;
close all;

file = 'data.csv'; % Dataset

% Reading training file
data = dlmread(file);
label = data(:,end);

% Extracting positive data points
idx = (label==1);
pos_data = data(idx,:); 
row_pos = size(pos_data,1);

% Extracting negative data points
neg_data = data(~idx,:);
row_neg = size(neg_data,1);
  
% Random permuation of positive and negative data points
p = randperm(row_pos);
n = randperm(row_neg);

% 80-20 split for training and test
tstpf = p(1:round(row_pos/5));
tstnf = n(1:round(row_neg/5));
trpf = setdiff(p, tstpf);
trnf = setdiff(n, tstnf);

train_data = [pos_data(trpf,:);neg_data(trnf,:)];
test_data = [pos_data(tstpf,:);neg_data(tstnf,:)];

% Decision Tree
prediction = SMOTEBoost(train_data,test_data,'tree',false);
disp ('    Label   Probability');
disp ('-----------------------------');
disp (prediction);