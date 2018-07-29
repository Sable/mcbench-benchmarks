function p=dmc(p)
% DMC   Dynamic Matrix Control
% P=DMC(P) determines the dynamic matrix control (input change) based on
% the plant model (step response) and current measurement stored in the
% structure P. 
% Input:
%   P.sr - unit step response data
%   P.u  - current input, initially 0
%   P.v  - past input, initially empty
%   P.G  - dynamic matrix, set by the initial call
%   P.F  - matrix to calculate free response, set by the initial call
%   P.k  - DMC gain, set by the initial call
%   P.r  - reference (set point)
%   P.a  - reference smooth factor
%   P.p  - prediction horizon
%   P.m  - moving horizon
%   P.y  - current mrasurement
%   P.la - performance criterion weight, i.e. J = ||r-y|| + p.la*||du||
%          where du is the input change
% Output:
%   P.u  - new input for next step
%   P.f  - updated free response
%   P.G  - dynamic matrix, if it is the first step.
%   P.k  - DMC gain, if it is the first step
%
% See Also: mpc

% Version 1.0 created by Yi Cao at Cranfield University on 6th April 2008.

% Example: 
%{
p.sr=filter([0 0 0.2713],[1 -0.8351],ones(50,1));
p.p=10;
p.m=5;
p.y=0;
p.v=[];
u=zeros(1,3);
N=120;
Y=zeros(N,1);
U=zeros(N,1);
R=zeros(N,1);
R([1:30 61:90])=1;
p.la=1;
for k=1:120
    p.a=0;
    p.r=R(k:min(N,k+p.p));
    if k>60
        p.a=0.7;
    end
    p=dmc(p);
    Y(k)=p.y;
    U(k)=p.u;
    u=[u(2:3) p.u];
    p.y=0.8351*p.y+0.2713*u(1);
end
subplot(211)
plot(1:N,Y,'b-',1:N,R,'r--',[60 60],[-0.5 1.5],':','linewidth',2)
title('solid: output, dashed: reference')
text(35,1,'\alpha=0')
text(95,1,'\alpha=0.7')
axis([0 120 -0.5 1.5])
subplot(212)
[xx,yy]=stairs(1:N,U);
plot(xx,yy,'-',[60 60],[-0.5 1.5],':','linewidth',2)
axis([0 120 -0.5 1.5])
title('input')
xlabel('time, min')
%}
% Input and output check
error(nargchk(1,1,nargin));
error(nargoutchk(0,1,nargout));

% length of step response
N=numel(p.sr);
P=p.p;

% initial setup
if isempty(p.v)
    % number of past inputs to keep
    n=N-P;
    % storage for past input
    p.v=zeros(n,1);
    % matrix to calculate free response from past input
    x=p.sr(1:n);
    p.F=hankel(p.sr(2:P+1),p.sr(P+1:N))-repmat(x(:)',P,1);
    % dynamic matrix
    p.G=toeplitz(p.sr(1:P),p.sr(1)*eye(1,p.m));
    % calculate DMC gain
    R=chol(p.G'*p.G+p.la*eye(p.m));
    K=R\(R'\p.G');
    % only the first input will be used
    p.k=K(1,:);
    p.u=0;
end
% free response
f=p.F*p.v+p.y;
% smooth reference
nr=numel(p.r);
if nr>=P
    ref=p.r(1:P);
else
    ref=[p.r(:);p.r(end)+zeros(P-nr,1)];
end
w=filter([0 (1-p.a)],[1 -p.a],ref,p.y);
% DMC input change
u=p.k*(w-f);
% past input change for next step
p.v=[u;p.v(1:end-1)];
% next input
p.u=p.u+u(1);
