function [E,L,G]=GenPCBasis(S,A)
% this function computes the conditional principal portfolios
% see A. Meucci - "Managing Diversification", Risk Magazine, June 2009
% available at www.ssrn.com

% Code by A. Meucci. This version March 2009. 
% Last version available at MATLAB central as "Managing Diversification"

% inputs
% S : covariance matrix
% A : conditioning matrix

% outputs
% E : conditional principal portfolios composition
% L : conditional principal portfolios variances
% G : map weights -> conditional diversification distribution (square root of, not normalized)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isempty(A)
    N=size(S,1);
    K=0;
    [E_,L_]=eig(S);
    E=E_;
    for n=1:N
        E(:,n)=E_(:,N-n+1);
        L(n)=L_(N-n+1,N-n+1);
    end

else

    [K,N]=size(A);
    E=[];
    B=A;
    for n=1:N-K
        if ~isempty(E)
            B=[A
                E'*S];
        end
        e=GenFirstEigVect(S,B);
        E=[E e];
    end

    for n=N-K+1:N
        B=E'*S;
        e=GenFirstEigVect(S,B);
        E=[E e];
    end

    % swap order
    E=[E(:,N-K+1:N) E(:,1:N-K)];
end

L=diag(E'*S*E);

G=diag(sqrt(L))*inv(E);
G=G(K+1:N,:);