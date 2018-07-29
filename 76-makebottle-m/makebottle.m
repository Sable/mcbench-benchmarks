function net=makebottle(X,v,s)
%FUNCTION NET=MAKEBOTTLE(X,V,S)
%Returns a bottleneck network ready for initialization
%and training. This constructs it in the standard approach, where
%the network has 5 layers, 
%
%input-encoding-bottleneck-decoding-output
%
%
%The input:
%  X=data set.  Input as number of points x dimension
%  v=vector of 2 numbers for the sizes of the encoding and bottleneck layers.
%    (It is possible to define each layer's nodes.  See bottle1.m)
%  s=Cell consisting of 2 strings, corresp to transfer function at each hidden layer.
%
%EXAMPLE: Data set X is three dimensions, reduce it to two using
%  5 nodes in the hidden layers, with nonlinear transfer functions at
%  the hiddlen layers, so the ending network is 3-5-2-5-3
%
%  c{1}='tansig'; c{2}='tansig';
%  net=makebottle(X,[5,2],c);
%
%AFTER construction, the following commands initialize
%  and train the network: (Default training:  Leven.-Marq.)
%
%net=init(net);
%net=train(net,X',X');
%
%To simulate the network using data in P (numpts x dim)
% Y=sim(net,P');
% THE FIRST K ROWS OF Y correspond to output at
%  the bottleneck!  The remaining rows are output
%  at the end of the bottleneck.
%
%
%The bottleneck neural net is used to perform nonlinear
%principle components analysis.  For the primary literature
%reference, see:  Kramer, "Nonlinear Principal Component 
%Analysis Using Autoassociative Neural Networks", AIChE Journal,
%1991, 37(2), 233-243
%
%Written April 2001
%Doug Hundley
%Whitman College, Mathematics Department
%hundledr@whitman.edu


net=network;
net.numInputs=1;
net.numLayers=4;
net.biasConnect=[1;0;1;1];  %Need a bias at the output?
net.inputConnect(1)=1;
net.layerConnect(2,1)=1;
net.layerConnect(3,2)=1;
net.layerConnect(4,3)=1
net.outputConnect(4)=1;
net.outputConnect(2)=1;
net.targetConnect(4)=1;

[numpts,dim]=size(X);
M=minmax(X');
net.inputs{1}.size=dim;
net.inputs{1}.range=M;

net.layers{1}.size=v(1);  %Matlab has 4 layers
net.layers{3}.size=v(1);
net.layers{1}.transferFcn=s{1};
net.layers{3}.transferFcn=s{2};
net.layers{2}.size=v(2);
net.layers{2}.transferFcn='purelin';
net.layers{4}.size=dim;
net.layers{4}.transferFcn='purelin';
net.layers{1}.initFcn='initnw';
net.layers{2}.initFcn='initnw';
net.layers{3}.initFcn='initnw';
net.layers{4}.initFcn='initnw';
%Now initialize the functions for the network
net.initFcn='initlay';
net.performFcn='mse';
net.trainFcn='trainlm';

