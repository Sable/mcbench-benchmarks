function [y,t] = ramp(A,T,t0,c)
%
%RAMP unit ramp function
% function [y,t] = ramp(A,T,t0,c)
% This function generates the unit ramp function of 
%amplitude A 
%width 2T. 
%shift of t0
%Scaling factor of c
%If no output is mentioned the function plots the signal.
%
%Example:
%ramp(1,2,3,4) plots the rampl signal of amplitude 1, stimewidth of 4
%time-shift of 3 and scaling factor of 4.
%[y,t]=ramp(1,2,3,4) is same as above with no plot.
%
% Author: B.H.Sri Hari, IITMadras
% Copyright B.H.Sri Hari. 
%$Date:03/28/2006 13:04:15$
if nargin < 3,
    t0 = 0;
    c=1;
elseif nargin==3,
    c=1;
end
ra = abs(t0/c);
if ra < 1 | ra==0 
    t = -2*T:.01:2*T;
elseif ra>=1 | ra==0 
    t = -2*T*(ra):.01:2*T*(ra);
end
y = A*(c*t-t0).*(c*t>=t0);
y1 = zeros(1,length(t));
if nargout == 0,
    plot(t,y,'k','LineWidth',2);
    hold on;
    plot(t,y1,':k');
    hold on;
    plot(y1,t,':k')
    hold off
    title('Ramp signal')
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
