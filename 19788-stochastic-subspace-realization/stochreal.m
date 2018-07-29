function [ss,ssfun]=stochreal(y,d)
% STOCHREAL     Stochastic Subspace Realization Algorithm
%   [S,SSFUN] = STOCHREAL(Y,D) Returns the singular values, S of the D
% dimension subspace identified from the measured data, Y (N by NY), an
% array of N samples of NY variables. The second output is a function
% handle: 
%   [A,C,K,R,L0] = SSFUN(NX), to obtain an NXth-order state space model:
% 
%   X_k+1 = A X_k + K E_k,  E_k ~ N(0,R)
%   Y_k   = C X_k + E_k    
%
% The system order, NX can be determined from the singular values such that
% sum(S(1:NX)) ~ sum(S).
%
% See also: n4sid, moesp, subid.

% Version 1.0 by Yi Cao at Cranfield University on 28 April 2008

% Reference
% Tohru Katayama, "Subspace Methods for System Identification", Springer
% 2005.

% Example
%{
% Consider a 2nd order ARMA model
%   y(t)-1.5y(t-1)+0.7y(t-2)=e(t)-0.5e(t-1)+0.3e(t-2), e(t)~N(0,1)
% generate the time series:
    N = 2000;
    y = filter([1 -0.5 0.3],[1 -1.5 0.7],randn(N,1));
% call the main program
    [sv,ssfun] = stochreal(y,6);
% determine the order from the singular value
    bar(sv)
% So the order should be 2. All matrices are determined afterwards.
    [A,C,K,R] = ssfun(2);
% The characteristic polynomial
    disp(poly(A))
%}

% Input and output check
error(nargchk(2,2,nargin));
error(nargoutchk(0,2,nargout));

[ndat,ny]=size(y);

% block Toeplitz and block Hankel
N=ndat-2*d+1;
Yp = zeros(ny*d,N);
Yf = Yp;
sy=y'/sqrt(N);
for k=1:d
    Yp((d-k)*ny+1:(d-k+1)*ny,:)=sy(:,k:k+N-1);
    Yf((k-1)*ny+1:k*ny,:)=sy(:,d+k:d+k+N-1);
end

% LQ decomposition
L0=triu(qr([Yp;Yf]'))';
L0=L0(1:2*d*ny,:);

% Square roots
M = L0(1:d*ny,1:d*ny);
L2 = L0(d*ny+1:end,:);
Sff = L2*L2';
L = chol(Sff)';

% SVD
[U1,S1,V1] = svd(L\L2(:,1:d*ny));
ss=diag(S1);
ssfun=@realmat;

    function [A,C,K,R]=realmat(n)
    % Input and output check
        error(nargchk(1,1,nargin));
        error(nargoutchk(0,4,nargout));
    % Observable and Controllable Subspaces    
        U2 = U1(:,1:n);
        S2 = diag(sqrt(ss(1:n)));
        V2 = V1(:,1:n);
        Ok = L*U2*S2;
        Ck = S2*V2'*M;
    % State Space Matrices    
        A = Ok(1:(d-1)*ny,:)\Ok(ny+1:d*ny,:);
        C = Ok(1:ny,:);
        C1 = Ck(:,1:ny)';
    % Kalman filter gain    
        P0 = Sff(1:ny,1:ny);
        S0 = S1(1:n,1:n);
        R = P0-C*S0*C';
        K = (C1'-A*S0*C')/R;
    end
end
