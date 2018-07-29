function [y,t] = rect(A,T,t0,c)
%
%RECT rectangular pulse.
% function [y,t] = rect(A,T,t0,c)
% This function gives the rectangular pulse of 
%width T 
%amplitude A and 
%shift of t0, 
%scaling factor c
% If no output is mentioned the function plots the signal
%   
%Example:
%rect(1,2,3,4) plots the rectangular pulse witha mplitude 1, time width 2,
%shift of 3 and scaling factor 4.
%[y,t]=rect(1,2,3,4) is same as the above no plot.
%
% Author: B.H.Sri Hari IITMadras
% Copyright B.H.Sri Hari
% $Date: 04/04/2006 15:45:45 $ 
%
if nargin < 3
    t0 = 0;
    c =1;
elseif nargin==3,
    c=1;
end
ra = abs(t0/c);
if ra < 1 | ra==0 
    t = -2*T:.01:2*T;
elseif ra>=1 | ra==0 
    t = -2*T*(ra):.01:2*T*(ra);
end
y = zeros(1,length(t));
y1 = (c*t>=-T/2+t0);
y2 = (c*t>=T/2+t0);
y = A*(y1-y2);
y3 = zeros(1,length(t));
if nargout == 0,
    plot(t,y,'k','LineWidth',2);
    hold on;
    plot(t,y3,':k');
    hold on;
    plot(y3,t,':k')
    hold off
    title('Rectangular pulse')
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
