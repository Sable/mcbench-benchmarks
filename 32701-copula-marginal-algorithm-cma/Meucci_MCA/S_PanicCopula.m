% =========================
%  Copula-Marginal Algorithm (CMA) to generate and manipulate flexible copulas, as described in
%  Meucci A., "New Breed of Copulas for Risk and Portfolio Management", Risk, September 2011
%
%  Most recent version of article and code available at http://www.symmys.com/node/335
%  =========================

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate panic distribution
N=20;
J=50000;

p=ones(J,1)/J;

r_c=.3;  
c2_c=(1-r_c)*eye(N)+r_c*ones(N,N);

b=0.02; 
r=.99;  
c2_p=(1-r)*eye(N)+r*ones(N,N);

s2=blkdiag(c2_c,c2_p);
Z = MvnRnd(zeros(2*N,1),s2,J);

X_c = Z(:,1:N);
X_p = Z(:,N+1:end);
D = (normcdf(X_p)<b);

X=(1-D).*X_c+D.*X_p;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% perturb probabilities via Fully Flexible Views
Aeq = ones(1,J);  % constrain probabilities to sum to one...
beq=1;
Aeq = [Aeq   % ...constrain the first moments...
    X'];
beq=[beq
    zeros(N,1)];
p_ = EntropyProg(p,[],[],Aeq ,beq); % ...compute posterior probabilities

[xdd,udd,U]=CMAseparation(X,p_);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% merge panic copula with normal marginals
y=[];
u=[];
for n=1:N
    sig=.20;
    yn = linspace(-4*sig,4*sig,100)';
    un=normcdf(yn,0,sig);
    
    y=[y yn];
    u=[u un];
end
Y=CMAcombination(y,u,U);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute portfolio risk
w=ones(N,1)/N; % portfolio weights
R_w=Y*w;

figure
[n,D]=pHist(R_w,p_,round(10*log(J))  );
h=bar(D,n,1);
[x_lim]=get(gca,'xlim');
set(gca,'ytick',[])
set(h,'FaceColor',.5*[1 1 1],'EdgeColor',.5*[1 1 1]);
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rotate panic copula (only 2Dim)
if N==2
    th=pi/2;
    R=[cos(th) sin(th)
        -sin(th) cos(th)];
    X_=X*R';
    [xdd,udd,U_]=CMAseparation(X_,p_);
end