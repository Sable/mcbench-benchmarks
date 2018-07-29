function [y,t] = imp(A,T,t0,c)
%
%function [y,t] = imp(A,T,t0,c)
%IMP dirac delta fucntion.
%This function generates dirac delta function at t0 with area A. 
%T is the time duration,c is the scaling factor.
%If scaling factor is not 1 the area of the impulse is not A but (A/c)
%
%Example:
%
% imp(1,2,3,4) plots the impulse function
%[y,t]=imp(1,2,3,4) same as above but no plots
%
% Author: B.H.Sri Hari, IITMadras
% Copyright B.H.Sri Hari. 
%$Date:04/04/2006 15:45:15$
if nargin < 3,
    t0 = 0;
    c=1;
elseif nargin ==3
    c=1;
end
t = -2*T:.01:2*T;
y =(A/c)*(t==t0/c);
y1 = zeros(1,length(t));
if nargout == 0,
    plot(t,y,'k','LineWidth',2);
    hold on;
    plot(t,y1,':k');
    hold on;
    plot(y1,t,':k')
    hold off
    title('impulse')
    if A<0
        axis([-2*T 2*T 4*(A/c) -4*(A/c)]);
    else
        axis([-2*T 2*T -4*(A/c) 4*(A/c)]);
    end
end