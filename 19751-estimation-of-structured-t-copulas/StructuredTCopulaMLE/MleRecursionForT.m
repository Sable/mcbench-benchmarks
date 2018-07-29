function C = MleRecursionForT(x,Nu,K,Tolerance)
% this function computes recursively the ML estimators of the correlation
% matrix of a t copula with isotropic structure
% see A. Meucci (2008) "Estimation of Structured T-Copulas"
% available at www.symmys.com > Research > Working Papers

[T,N]=size(x);
Ones_N=ones(1,N); % fixed for fast matrix operation
Ones_T=ones(T,1); % fixed for fast matrix operation 

% initialize variables
w=ones(T,1);
C=0*Ones_N'*Ones_N;

Error=10^6;
% start main loop
while Error>Tolerance
    
    % update
    C_Old=C;
    
    % Step 1
    W=w*Ones_N;
    S_=(W.*x)'*x/T;

    [E,L_]=pcacov(S_);
    L=mean(L_(K+1:N))*Ones_N;
    L(1:K)=L_(1:K);
    S=E*diag(L)*E';

    [s,C]=cov2corr(S);

    % Step 2
    Ma2=sum((x*inv(C)).*x,2);
    w=(Nu+N)./(Nu+Ma2);

    % convergence
    Error = trace((C-C_Old)^2)/N;
    
end