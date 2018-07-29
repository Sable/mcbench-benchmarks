function [U D] = UDFactor(P,uflag)
% UDFactor performs the U-D factorization of a symmetric matrix.
% 
% [U D] = UDFactor(P) returns matrices U and D such that U.'*D*U = P
% [U D] = UDFactor(P,uflag) returns matrices U and D such that U*D*U.' = P
% when uflag is set to TRUE.  Setting uflag to FALSE is equivalent to
% running UDFactor with only one argument.
% 
% The alogrithm of UDFactor is similar to the Cholesky decomposition except
% that the matrix is factored into a unitary upper triangular matrix (U)
% and diagonal matrix (D) such that P = U*D*U.' (or U.'*D*U).  Note that
% while this is equivalent to P = (U*D^0.5)*(U*D^0.5).' = S*S.' where S is
% the upper triangular square root of P, no square roots are taken in the
% calculations of U and D.  This makes this factorization ideal for a
% square-root implementation of a Kalman filter (a U-D filter). For more
% details, see Bierman, G. J., Factorization methods for discrete 
% sequential estimation, 1977.
%
% Note: This factorization is only guaranteed to work for symmetric
% matrices.
% 
% Examples:  
%     %create symmetric matrix
%     P = rand(5)*10;, P = triu(P)+triu(P).';
%     %factor
%     [U1,D1] = UDFactor(P);
%     [U2,D2] = UDFactor(P,true);
%     %check factorization
%     P - U1.'*D1*U1
%     P - U2*D2*U2.'
%
% Written by Dmitry Savransky 7 July 2008

%if no flag was set, assume it to be false
if ~exist('uflag','var')
    uflag = false;
end

%size of matrix
n = length(P);
%allocate U
U = zeros(n);

%if uflag UDU' otherwise U'DU
if uflag
    D = zeros(1,n);%D is diagonal, so leave it as a vector

    D(end) = P(end);
    U(:,end) = P(:,end)./P(end);

    for j = n-1:-1:1
        D(j) = P(j,j) - sum(D(j+1:n).*U(j,j+1:n).^2);
        U(j,j) = 1;

        for i=j-1:-1:1
            U(i,j) = (P(i,j) - sum(D(j+1:n).*U(i,j+1:n).*U(j,j+1:n)))/D(j);
        end
    end
else
    D = zeros(n,1);%D is diagonal, so leave it as a vector

    D(1) = P(1);
    U(1,:) = P(:,1)./P(1);

    for j = 2:n
        D(j) = P(j,j) - sum(D(1:j-1).*U(1:j-1,j).^2);
        U(j,j) = 1;

        for i=j+1:n
            U(j,i) = (P(j,i) - sum(D(1:j-1).*U(1:j-1,i).*U(1:j-1,j)))/D(j);
        end
    end
end

D = diag(D);