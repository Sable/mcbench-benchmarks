function [y,t] = signum(A,T,t0,c);
%SIGNUM signum function
% function [y,t] = signum(A,T,t0,c)
% This function generates the signum function of 
%amplitude A
%width 2T. 
%shift of t0.
%scaling factor of c
%If no output is mentioned the function plots the signal.
%
%Example:
%signum(1,2,3,4) plots the signum function of amplitude 1, time width of 4,
%shift of 3 and scaing factor of 4.
%
%Algorithm:
%
%signum(t)=2u(t)-1
%
% Author: B.H.Sri Hari, IITMadras
% Copyright B.H.Sri Hari. 
%$Date:04/04/2006 15:30:15$
if nargin < 3,
    t0 = 0;
    c = 1;
elseif nargin ==3
    c =1;
end
t = -2*T:.01:2*T;
y = 2*A*(c*t>=t0)-A;
y1 = zeros(1,length(t));
if nargout == 0,
    plot(t,y,'k','LineWidth',2);
    hold on;
    plot(t,y1,':k');
    hold on;
    plot(y1,t,':k')
    hold off
    title('Signum signal');
    if A<0
        axis([-2*T 2*T 2*A -2*A]);
    else
        axis([-2*T 2*T -2*A 2*A]);
    end
end
