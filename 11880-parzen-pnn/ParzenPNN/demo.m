%% Parzen Probabilistic Neural Networks
%  The Parzen Probabilistic Neural Networks (PPNN) are a simple type of
% neural network used to classify data vectors. This classifiers are based
% on the Bayesian theory where the a posteriori probability density
% function (apo-pdf) is estimated from data using the Parzen window
% technique.

%% A brief overview on the theory of the Parzen window and PPNN
%  The Bayesian classifiers use the Bayesian equation:
%
%                 P(x|wi)P(wi)
%  P(wi|x) = ----------------------
%             SUM_j P(x|wj)P(wj)
%
% to estimate the apo-pdf P(wi|x). Obviously to be usefull, this method
% needs the probabilities P(x|wi) and P(wi) to be known. A technique is to
% parametrize this pdfs, another is to estimate them from data.
%  The Parzen window technique estimates the probability defining a window
% (given the winow size) and a function on this window (i.e. an hypersphere
% with the gaussian function truncated inside). The computes the estimation
% of the probability function convolving the window function with the
% samples function. This obviously requires that the window function must
% have the integral (the hypervolume under the funciton) equal to 1 to
% mantain the scale in the estimated pdf.
%  The PPNN is a simple tool that is the composition of the pdf estimation
% with the Parzen window and the Bayesian classification selecting for a
% feature vector x the class wi where P(wi|x) is maximum.
%  In this quick explanation the particular derivations aren't reported but
% can be found in [1].
% 
%  A PPNN is a two layer neural network (NN) where the input data are fully
% connected with the first neuron layer and the first layer is sparsely
% connected with the second (and ouput) layer. The output layer is composed
% of c neurons where c is the number of classes of the classifier. 
% The wheights on the first layer are trained as follows: each sample data
% is normalized so that its length becames unitary, each sample data
% becames a neuron with the normalized values as weights w. The input data
% x is so dot-multiplied by the weights obtaining the network activation
% signal net=w^Tx. Then the exponential nonlinearity:
%
%          net - 1
%         ---------
%               2
%           sigm
%  act = e
%
% is computed to obtain the synaptic activation signals. During the
% learning process each first layer neuron is connected to the output layer
% neuron related to its class with wheight 1. During the classification
% process the output neuron of each class sums the activation signals from
% all the neurons of the neurons of the first layer. Simply the highest
% output value selects the class of the input data.
%
%  (w1)  (w2)  ...        OUTPUT
%    \     \ \__
%     |     |    \
%    ( )   ( )   ( )      internal layer
%    /|\   /|\   /|\
%                         INPUT
%
% [1] "Pattern Classification", second edition,
%     by Richard O. Duda, Peter E. Hart. and David G. Stork

%% A first simple example with 2D data
% In this simple example three set of points in the plane are selected in
% the region [1:100;1:100]. A PPNN is trained with this samples and then
% an image of the classification regions is produced.

% A training set for the class 'a' and 'b':
img=ones(100);
f=figure; imshow(img); [X,Y]=getpts; sa=[X,Y]'; close(f);
f=figure; imshow(img); [X,Y]=getpts; sb=[X,Y]'; close(f);
f=figure; imshow(img); [X,Y]=getpts; sc=[X,Y]'; close(f);
% The samples matrix:
S = [sa,sb,sc];
% The classification vector:
C = [repmat('a',[1,size(sa,2)]),repmat('b',[1,size(sb,2)]),repmat('c',[1,size(sc,2)])];
% Generating the network:
net = parzenPNNlearn(S,C);

% Generating the whole grid:
[X,Y] = meshgrid(1:100,1:100);
D = [X(:),Y(:)]';
% Classification of all points:
class = parzenPNNclassify(net,D);
class = reshape(class,[100,100]);
% Plotting:
sep = double(class=='a') + 2*double(class=='c');
figure; imshow(sep/2); hold on;
plot(sa(1,:),sa(2,:),'r.');
plot(sb(1,:),sb(2,:),'g.');
plot(sc(1,:),sc(2,:),'b.');

%% Adding samples to the network to increase the training
%  A PPNN can be simply improved adding new samples to it, the new samples
% generates new neurons in the internal layer that so can grow. Here an
% example of improving of the generated neural network.

% Getting new samples:
f=figure; imshow(img); hold on; plot(sa(1,:),sa(2,:),'r.');
[X,Y]=getpts; nsa=[X,Y]'; close(f);
f=figure; imshow(img); hold on; plot(sb(1,:),sb(2,:),'g.');
[X,Y]=getpts; nsb=[X,Y]'; close(f);
f=figure; imshow(img); hold on; plot(sc(1,:),sc(2,:),'b.');
[X,Y]=getpts; nsc=[X,Y]'; close(f);
Sa = [sa,nsa];
Sb = [sb,nsb];
Sc = [sc,nsc];

% The samples matrix:
nS = [nsa,nsb,nsc];
% The classification vector:
nC = [repmat('a',[1,size(nsa,2)]),repmat('b',[1,size(nsb,2)]),repmat('c',[1,size(nsc,2)])];
% Improving the network:
net = parzenPNNimprove(net,nS,nC);

% Classification of all points:
class = parzenPNNclassify(net,D);
class = reshape(class,[100,100]);
% Plotting:
sep = double(class=='a') + 2*double(class=='c');
figure; imshow(sep/2); hold on;
plot(Sa(1,:),Sa(2,:),'r.');
plot(Sb(1,:),Sb(2,:),'g.');
plot(Sc(1,:),Sc(2,:),'b.');
