%QUESTION NO:3  

% c)Design and Train a feedforward network for the following problem:
%     Symmetry: Consider a 4-input and 1-output problem where the output is
%     required to be 'one' if the input configuration is symmetrical and
%     'zero' otherwise.

clear
inp=[0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1;0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1;...
    0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1;0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];
out=[1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 1];
network=newff([0 1;0 1; 0 1; 0 1],[6 1],{'logsig','logsig'});
network=init(network);
y=sim(network,inp);
figure,plot(inp,out,inp,y,'o'),title('Before Training');
axis([-5 5 -2.0 2.0]);
network.trainParam.epochs = 500;
network=train(network,inp,out);
y=sim(network,inp);
figure,plot(inp,out,inp,y,'o'),title('After Training');
axis([-5 5 -2.0 2.0]);
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
