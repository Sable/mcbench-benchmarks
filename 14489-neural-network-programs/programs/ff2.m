%QUESTION NO:3  

% b)Design and Train a feedforward network for the following problem:
%  Encoding: Consider an 8-input and 8-output problem, where the output
%  should be equal to the input for any of the 8 combinations of seven
%  0s and one 1.

clear
for i=0:255
    x=dec2bin(i,8);
    for j=1:8
        y(j)=str2num(x(j));
    end
    inp(i+1,:)=y;
    if(sum(y)==7)
        out(i+1,:)=y;
    else
        out(i+1,:)=zeros(1,8);
    end
        
end
inp=inp';
out=out';
network=newff([0 1;0 1;0 1;0 1;0 1;0 1;0 1; 0 1],[6 8],{'logsig','logsig'});
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
Actual_output=y;
Actual_output

    



