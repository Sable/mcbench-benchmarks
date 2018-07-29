% Chapter 17 - Neural Networks.
% Programs_17b - Generalized Delta Learing Rule and Backpropagation of errors
% for a multilayer network (Figure 17.8).
% Copyright Birkhauser 2013. Stephen Lynch.

function Programs_17b
% Load full Boston housing data.
load housing.txt
X = housing(:,1:13);
t = housing(:,14);

% Scale to zero mean, unit variance and introduce bias on input.
xmean = mean(X);
xstd = std(X);
X = (X-ones(size(X,1),1)*xmean)./(ones(size(X,1),1)*xstd);
X = [ones(size(X,1),1) X];
tmean = mean(t);
tstd = std(t);
t = (t-tmean)/tstd;

% Iterate over a number of hidden nodes
maxHidden = 2;
for numHidden=1:maxHidden

% Initialise random weight vector.
% Wh are hidden weights, wo are output weights.
randn('seed', 123456);
Wh = 0.1*randn(size(X,2),numHidden);
wo = 0.1*randn(numHidden+1,1);

% Do numEpochs iterations of batch error back propagation.
numEpochs = 2000;
numPatterns = size(X,1);
% Set eta.
eta = 0.05/numPatterns;
for i=1:numEpochs
	% Calculate outputs, errors, and gradients.
	phi = [ones(size(X,1),1) tanh(X*Wh)];
	y = phi*wo;
	err = y-t;
	go = phi'*err;
	Gh = X'*((1-phi(:,2:numHidden+1).^2).*(err*wo(2:numHidden+1)'));
	% Perform gradient descent.
	wo = wo - eta*go;
	Wh = Wh - eta*Gh;
	% Update performance statistics.	
	mse(i) = var(err);
end

plot(1:numEpochs, mse, '-')
hold on
end

fsize=15;
set(gca,'XTick',0:500:2000,'FontSize',fsize)
set(gca,'YTick',0:0.5:1,'FontSize',fsize)
xlabel('Number of Epochs','FontSize',fsize)
ylabel('Mean Squared Error','FontSize',fsize)
hold off

% End of Programs_17b.

 

