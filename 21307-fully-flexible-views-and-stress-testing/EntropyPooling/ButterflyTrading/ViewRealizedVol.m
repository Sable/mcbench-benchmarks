function p_ = ViewRealizedVol(X,p)

[J,K]=size(X);

% constrain probabilities to sum to one...
Aeq = ones(1,J);
beq=1;

% ...constrain the median...
V = abs(X(:,1));

[V_Sort I_Sort]=sort(V);
F=cumsum(p(I_Sort));

I_Reference=max(find(F<=3/5));
V_Reference=V_Sort(I_Reference);


I_Select=find(V<=V_Reference);

a=zeros(1,J);
a(I_Select)=1;

A = a;
b = .5;

% ...compute posterior probabilities
p_ = EntropyProg(p,A,b,Aeq ,beq);
