function p_ = ViewImpliedVol(X,p)

[J,K]=size(X);

% constrain probabilities to sum to one...
Aeq = ones(1,J);  
beq=1;

% ...constrain the expectation...
V = [X(:,12) - X(:,11)];
m=mean(V);
s=std(V);

A = V';
b = m-s;

% ...compute posterior probabilities
p_ = EntropyProg(p,A,b,Aeq ,beq); 