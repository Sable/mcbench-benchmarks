function [ss,ssfun]=moesp(y,u,d)
% MOESP Multivariable Output Error State Space Approach of Subspace Identification
%   [SS,SSMAT] = MOESP(Y,U,D) identifies the observable subspace based on
%   the measured (N by ny) output matrix, Y with N  sampling points and ny
%   variables, and the corresponding N by nu input matrix, U. The third
%   parameter d is the embeded dimension, which should be larger than the
%   order of the system to be identified. 
%   
%   The function returns the scores of the subspace, SS and a function
%   handle SSMAT, for further identification of state space matrices. 
%
%   The system order can determined from the returned score vector, SS so
%   that sum(SS(1:n)) ~ sum(SS).
%
%   Once the system order is determined, the underline dynamic system is
%   identified by calling the retruned function handle:
%
%   [A,B,C,D] = SSMAT(n)
%   
%   to represent a state space model:
%
%       x(k+1) = Ax(k) + Bu(k)
%       y(k)   = Cx(k) + Du(k)
%
% See also: n4sid, subid

% Version 1.0 by Yi Cao at Cranfield University on 27th April 2008

% Reference
% Tohru Katayama, "Subspace Methods for System Identification", Springer
% 2005.

% Example
%{
%   Consider a multivariable fourth order system a,b,c,d
%   with two inputs and two outputs:
    a = [0.603 0.603 0 0;-0.603 0.603 0 0;0 0 -0.603 -0.603;0 0 0.603 -0.603];
    b = [1.1650,-0.6965;0.6268 1.6961;0.0751,0.0591;0.3516 1.7971];
    c = [0.2641,-1.4462,1.2460,0.5774;0.8717,-0.7012,-0.6390,-0.3600];
    d = [-0.1356,-1.2704;-1.3493,0.9846];
%
%   We take a white noise sequence of 1000 points as input u.
    N = 1000;
    u = randn(N,2);
%
%   With noise added, the state space system equations become:
%                  x_{k+1) = A x_k + B u_k + K e_k        
%                    y_k   = C x_k + D u_k + e_k
%                 cov(e_k) = R
%                 
    k = [0.1242,-0.0895;-0.0828,-0.0128;0.0390,-0.0968;-0.0225,0.1459]*4;
    r = [0.0176,-0.0267;-0.0267,0.0497];
% 
%   The noise input thus is equal to (the extra chol(r) makes cov(e) = r):
    e = randn(N,2)*chol(r);
% 
%   And the simulated noisy output:
    y = dlsim(a,b,c,d,u) + dlsim(a,k,c,eye(2),e);
%
%   Using this output in subid returns a more realistic image of
%   the singular value plot:
    k = 10;
    [ss,ssfun] = moesp(y,u,k);
%
%   To determine the order, check the score vector
%
bar(ss)
%
%   Clearly, the order should be 4. Therefore, the state space model is
%   obtained by calling ssfun:
%
    [A,B,C,D]=ssfun(4);
%
% To compare with the actual system, we use the bode diagram:
    w = [0:0.005:0.5]*(2*pi); 		% Frequency vector
    m1 = dbode(a,b,c,d,1,1,w);
    m2 = dbode(a,b,c,d,1,2,w);
    M1 = dbode(A,B,C,D,1,1,w);
    M2 = dbode(A,B,C,D,1,2,w);
% 
% Plot comparison
    figure(1)
    hold off;subplot;clg;
    subplot(221);plot(w/(2*pi),[m1(:,1),M1(:,1)]);title('Input 1 -> Output 1');
    subplot(222);plot(w/(2*pi),[m2(:,1),M2(:,1)]);title('Input 2 -> Output 1');
    subplot(223);plot(w/(2*pi),[m1(:,2),M1(:,2)]);title('Input 1 -> Output 2');
    subplot(224);plot(w/(2*pi),[m2(:,2),M2(:,2)]);title('Input 2 -> Output 2');
%}

% Input and output check
error(nargchk(1,3,nargin));
error(nargoutchk(0,4,nargout));

[ndat,ny]=size(y);
[mdat,nu]=size(u);
if ndat~=mdat
    error('Y and U have different length.')
end

% block Hankel matrix
N=ndat-d+1;
Y = zeros(d*ny,N);
U = zeros(d*nu,N);
sN=sqrt(N);
sy=y'/sN;
su=u'/sN;
for s=1:d
    Y((s-1)*ny+1:s*ny,:)=sy(:,s:s+N-1);
    U((s-1)*nu+1:s*nu,:)=su(:,s:s+N-1);
end

% LQ decomposition
R=triu(qr([U;Y]'))';
R=R(1:d*(ny+nu),:);

% SVD
R22 = R(d*nu+1:end,d*nu+1:end);
[U1,S1]=svd(R22);

% sigular value
ss = diag(S1);
% n=find(cumsum(ss)>0.85*sum(ss),1);

ssfun = @ssmat;

    function [A,B,C,D]=ssmat(n)
        % C and A
        Ok = U1(:,1:n)*diag(sqrt(ss(1:n)));
        C=Ok(1:ny,:);
        A=Ok(1:ny*(d-1),:)\Ok(ny+1:d*ny,:);

        % B and D
        L1 = U1(:,n+1:end)';
        R11 = R(1:d*nu,1:d*nu);
        R21 = R(d*nu+1:end,1:d*nu);
        M1 = L1*R21/R11;
        m = ny*d-n;
        M = zeros(m*d,nu);
        L = zeros(m*d,ny+n);
        for k=1:d
            M((k-1)*m+1:k*m,:)=M1(:,(k-1)*nu+1:k*nu);
            L((k-1)*m+1:k*m,:)=[L1(:,(k-1)*ny+1:k*ny) L1(:,k*ny+1:end)*Ok(1:end-k*ny,:)];
        end
        DB=L\M;
        D=DB(1:ny,:);
        B=DB(ny+1:end,:);
    end
end


