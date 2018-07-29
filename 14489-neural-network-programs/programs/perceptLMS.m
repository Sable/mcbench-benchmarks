%QUESTION NO:4

%For the following 2-class problem determine the decision boundaries
%obtained by LMS and perceptron learning laws.
% Class C1 : [-2 2]', [-2 3]', [-1 1]', [-1 4]', [0 0]', [0 1]', [0 2]', 
%            [0 3]' and [1 1]'
% Class C2 : [ 1 0]', [2 1]', [3 -1]', [3 1]', [3 2]', [4 -2]', [4 1]',
%            [5 -1]' and [5 0]'

clear;
inp=[-2 -2 -1 -1 0 0 0 0 1 1 2 3 3 3 4 4 5 5;2 3 1 4 0 1 2 3 1 0 1 -1 1 2 -2 1 -1 0];
out=[1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0];
choice=input('1: Perceptron Learning Law\n2: LMS Learning Law\n Enter your choice :');
switch choice
    case 1
            network=newp([-2 5;-2 4],1);
            network=init(network);
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
    case 2
            network=newlin([-2 5;-2 4],1);
            network=init(network);
            y=sim(network,inp);
            network=adapt(network,inp,out);
            y=sim(network,inp);
            display('Final weight vector and bias values : \n');
            Weights=network.iw{1};
            Bias=network.b{1};
            Weights
            Bias
            Actual_Desired=[y' out'];
            Actual_Desired
    otherwise 
            error('Wrong Choice');
end


