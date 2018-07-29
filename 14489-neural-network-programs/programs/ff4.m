%QUESTION NO:3  

% d)Design and Train a feedforward network for the following problem:
%   Addition: Consider a 4-input and 3-output problem, where the output
%   should be the result of the sum of two 2-bit input numbers.

clear
inp=[0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1;0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1;...
    0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1;0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];
out=[0 0 0 0 0 0 0 1 0 0 1 1 0 1 1 1; 0 0 1 1 0 1 1 0 1 1 0 0 1 0 0 1; ...
     0 1 0 1 1 0 1 0 0 1 0 1 1 0 1 0];
network=newff([0 1;0 1; 0 1; 0 1],[6 3],{'logsig','logsig'});
network=init(network);
y=sim(network,inp);
network.trainParam.epochs = 500;
network=train(network,inp,out);
y=sim(network,inp);
Layer1_Weights=network.iw{1};
Layer1_Bias=network.b{1};
Layer2_Weights=network.lw{2};
Layer2_Bias=network.b{2};
Layer1_Weights
Layer1_Bias
Layer2_Weights
Layer2_Bias
Actual_Desired=[y' out'];
Actual_Desired