%--------------------------------------------------------
% FIR filter design via local moving window LS fitting  -
% A magic smooth and derivative formula generator.      -
% By Dr Yangquan Chen		08-07-1999                   -
% Email=<yqchen@ieee.org>; URL=http://www.crosswinds.net/~yqchen/
% ------------------------------------------------------- 
% Purpose: general FIR design via local LS fitting. 
% total taps = nL+nR+1
% Format: function [c]=sgfilter(nL,nR,M,id)
%          -nL      -nL+1           -1                nR
% FIR=c(1)z   +c(2)z     +...+c(nL)z  +...+c(nL+nR+1)z
%
%       nR
%     ------
%     \                   j
%      >       c(nL+1+j) z
%     /
%     ------
%      j=-nL
% M: the order of LS fit at the moving window of [-nL, ... , nR]
% id: index for the derivative order
%		0: smooth filter, 
%		1: 1st order differentiator,
% 		2: 2nd order differentiator, ... 
% NOTE: M>=id, set M=(2~4)*(id+1) for reliably results.
%		  to do LS fit, M<nL+nR+1.
%---------------------------------------------------------------
function [c]=sgfilter(nL,nR,M,id)
% Savitzky-Golay smoothing filter.
if (id>M)
   disp('Error in id! (id<M)');return;
end
if (M>(nL+nR))
   disp('Error in M! (M<=nL+nR)');return;
end

A=zeros(nL+nR+1,M+1);
for i=-nL:nR;
   for j=0:M;
      A(i+nL+1,j+1)=i^j;
   end
end
h=zeros(M+1,1);
%h(1)=1;
h(id+1)=1;
b=inv(A'*A)*h;
c=zeros(nL+nR+1,1);
for n=-nL:nR
   nm=n.^[0:M];
   c(n+nL+1)=nm*b;
end
% coefficient for smoothing
return
 
