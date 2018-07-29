function X=linsystem(Xf)
% solve linear equation system

% Discrete X into matrice: A,b,f
b=Xf(:,4);
m=length(b);
b(m)=[];
Xf(:,4)=[];
A=Xf;
A(m,:)=[];
f=Xf(m,:);

% Compute Xf
X=linprog(f,A,b);



