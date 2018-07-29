function [x, y] = hands(hour, minute, hlen, mlen)
% HANDS generates coordinates for the hands of a clock.
%   [X,Y] = HANDS(HH, MM, HLEN, MLEN) creates X and Y vectors for the hands
%   of a clock at time HH:MM. The hour and minute hands will be length HLEN
%   and MLEN.
%
%   Example: To generate and plot the coordinates for 5:08
%       [x,y] = hands(5, 8, 0.60, 0.85); plot(x,y)
 
% Copyright 2009 The MathWorks, Inc.

    x = zeros(1, 3); % create a 3 element vector for both x and y
    y = zeros(1, 3); % centered on (0,0)
    
    % position of hour hand
    degrees = (360 / (12 * 60)) * ((mod(hour, 12) * 60) + minute);
    x(1) = hlen * sind(degrees);
    y(1) = hlen * cosd(degrees);
    
    % position of minute hand
    degrees = (360 / 60) * minute;
    x(3) = mlen * sind(degrees);
    y(3) = mlen * cosd(degrees);
    
    %x = x + xcenter;
    %y = y + ycenter;
    
end


