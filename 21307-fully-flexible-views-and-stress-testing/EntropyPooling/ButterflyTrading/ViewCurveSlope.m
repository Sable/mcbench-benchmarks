function p_ = ViewCurveSlope(X,p)

[J,K]=size(X);

% constrain probabilities to sum to one...
Aeq = ones(1,J);
beq=1;

% ...constrain the expectation...
V= X(:,14)-X(:,13);
v=.0005;

Aeq=[Aeq
    V'];
beq=[beq
    v];

A=[];
b=[];

% ...compute posterior probabilities
p_ = EntropyProg(p,A,b,Aeq ,beq);
