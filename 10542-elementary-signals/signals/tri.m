function [y,t] = tri(A,T,t0,c)
%
%TRI traingular pulse
%function [y,t] = tri(A,T,t0,c)
%This function generates a triangular pulse,
%width 2T.
%amplitude A 
%t0 is the shift.
%c is the scaling factor.
%If no output is mentioned the function plots the signal.
%
%Example:
%tri(1,2,3,4) plots the unit step function with amplitude 1,time width
%4*2*4/3, scaling factor 4, shift of 3.
%
%[y,t]=tri(1,2,3,4) same as above but no plot.
%
% Author: B.H.Sri Hari, IITMadras
% Copyright B.H.Sri Hari. 
%$Date:04/04/2006 15:45:15$
%
if nargin < 3,
    t0 = 0;
    c=1;
elseif nargin==3
    c=1;
end
ra = abs(t0/c);
if ra < 1 | ra==0 
    t = -2*T:.01:2*T;
elseif ra>=1 | ra==0 
    t = -2*T*(ra):.01:2*T*(ra);
end
y1 = (1+(c*t-t0)/T).*(c*t>=-T+t0 & c*t<=t0);
y2 = (1-(c*t-t0)/T).*(c*t>t0 & c*t<=T+t0);
y = A*(y1+y2);
y3 = zeros(1,length(t));
if nargout == 0,
    plot(t,y,'k','LineWidth',2);
    hold on;
    plot(t,y3,':k');
    hold on;
    plot(y3,t,':k')
    hold off
    title('Triangular Pulse')
    if A<0 & ra ~= 0
        axis([-2*T*(ra) 2*T*(ra) 4*A/3 -A/4]);
    elseif A<0  & ra == 0
        axis([-2*T 2*T 4*A/3 -A/4])
    elseif A>0 & ra~=0
        axis([-2*T*(ra) 2*T*(ra) -A/4 4*A/3]);
    else
            axis([-2*T 2*T -A/4 4*A/3]);
    end
end