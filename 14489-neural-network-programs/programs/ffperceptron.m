%QUESTION NO:2

%Using the Perceptron Learning Law design a classifier for the following
%problem:
% Class C1 : [-2 2]', [-2 1.5]', [-2 0]', [1 0]' and [3 0]'
% Class C2 : [ 1 3]', [3 3]', [1 2]', [3 2]', and [10 0]'

inp=[-2 -2 -2 1 3 1 3 1 3 10;2 1.5 0 0 0 3 3 2 2 0];
out=[1 1 1 1 1 0 0 0 0 0];
network=newp([-2 10;0 3],1);
network.iw{1}=[0.5 0.5];
network.b{1}=0.5;
y=sim(network,inp);
figure,plot(inp,out,inp,y,'o'),title('Before Training');
axis([-10 20 -2.0 2.0]);
network.trainParam.epochs = 20;
network=train(network,inp,out);
y=sim(network,inp);
figure,plot(inp,out,inp,y,'o'),title('After Training');
axis([-10 20 -2.0 2.0]);
display('Final weight vector and bias values : \n');
Weights=network.iw{1};
Bias=network.b{1};
Weights
Bias
Actual_Desired=[y' out'];
Actual_Desired
