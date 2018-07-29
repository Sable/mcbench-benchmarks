function p_ = ViewRanking(X,p,Lower,Upper)

[J,N]=size(X);
K=length(Lower);

% constrain probabilities to sum to one...
Aeq = ones(1,J);  
beq=1;

% ...constrain the expectations...
V=X(:,Lower) - X(:,Upper);

A = V';
b = 0;

% ...compute posterior probabilities
p_ = EntropyProg(p,A,b,Aeq ,beq); 