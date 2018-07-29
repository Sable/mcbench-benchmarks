function [y,t] = unitstep(A,T,t0,c)
%
%UNITSTEP unit step function
% function [y,t] = unitstep(A,T,t0,c)
% This function generates the unit step function of 
%amplitude A.
%width 2T.
%t0 is the shift if required.
%c is the scaling factor.
%If no output is mentioned the function plots the signal.
%
%Example:
%unitstep(1,2,3,4) plots the unitstep function with amplitude 1, time width
%4=2*2, shift of 3, scaling factor of 4 
%[y,t]=unitstep(1,2,3,4) same as above but no plot.
%
% Author: B.H.Sri Hari, IITMadras
% Copyright B.H.Sri Hari. 
%$Date:04/04/2006 15:48:15$
if nargin < 3,
    t0 = 0;
    c=1;
elseif nargin == 3,
    c=1;
end
ra = abs(t0/c);
if ra < 1 | ra==0
    t = -2*T:.01:2*T;
elseif ra>=1
    t = -2*T*(ra):.01:2*T*(ra);
end

y = A*(t>=t0/c);
y1 = zeros(1,length(t));
if nargout == 0,
    plot(t,y,'k','LineWidth',2);
    hold on;
    plot(t,y1,':k');
    hold on;
    plot(y1,t,':k')
    hold off
    title('Unit Step signal')
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
