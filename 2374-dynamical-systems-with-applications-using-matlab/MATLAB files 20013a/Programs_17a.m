% Chapter 17 - Neural Networks.
% Programs_17a - The Generalized Delta Learning Rule (Figure 17.7).
% Copyright Birkhauser 2013. Stephen Lynch.

function Programs_17a
% Load Boston housing data.
load housing.txt
X = housing(:,[6 9 13]);
t = housing(:,14);

% Scale to zero mean, unit variance and introduce bias on input.
xmean = mean(X);
xstd = std(X);
X = (X-ones(size(X,1),1)*xmean)./(ones(size(X,1),1)*xstd);
X = [ones(size(X,1),1) X];
tmean = (max(t)+min(t))/2;
tstd = (max(t)-min(t))/2;
t = (t-tmean)/tstd;

% Initialise random weight vector.
randn('seed', 123456);
w(:,1) = 0.1*randn(size(X,2),1);
y1 = tanh(X*w(:,1));
e1 = t-y1;
mse(1) = var(e1);


% Do numEpochs iterations.
numEpochs = 10;
numPatterns = size(X,1);
eta = 0.001;
k = 1;
for m=1:numEpochs
  for n=1:numPatterns
	% Calculate feedforward output, error, and gradient.
	yk = tanh(X(n,:)*w(:,k));
	err = yk-t(n);
	g = X(n,:)'*((1-yk^2)*err);
	% Update the weight.
	w(:,k+1) = w(:,k) - eta*g;
	k = k+1;
  end
end

for m=1:size(w,1)
plot(1:k, w(m,:))
hold on
end

fsize=15;
set(gca,'XTick',0:2000:6000,'FontSize',fsize)
set(gca,'YTick',-0.3:0.1:0.3,'FontSize',fsize)
xlabel('Number of Iterations','FontSize',fsize)
ylabel('Weights','FontSize',fsize)
hold off

% End of Programs_17a.
