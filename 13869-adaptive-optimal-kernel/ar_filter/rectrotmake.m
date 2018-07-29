function [rectrotr,rectroti] = rectrotmake(nraf, nlag, outdelay)
% rectrotmake: make array of rect AF phase shifts
% G.A. Reina 16 Jan 2007
% Modified from the C code provided by D. L. Jones and R. G. Baraniuk
% "An Adaptive Optimal-Kernel Time-Frequency Representation"
%   by D. L. Jones and R. G. Baraniuk, IEEE Transactions on Signal 
%   Processing, Vol. 43, No. 10, pp. 2361--2371, October 1995.
twopin = 2*pi/nraf;

half_nraf = floor(nraf /2);

rectrotr = zeros(nraf, nlag);
rectroti = zeros(nraf, nlag);

for i = 0:(nlag-1)

    rectrotr(1:half_nraf, i+1) = cos( (twopin*(0:(half_nraf-1)))*(outdelay - i/2.0) );
    rectroti(1:half_nraf, i+1) = sin( (twopin*(0:(half_nraf-1)))*(outdelay - i/2.0) );

    rectrotr((half_nraf + 1):nraf, i+1) = ...
        cos( (twopin*(((half_nraf):(nraf - 1))-nraf))*(outdelay - i/2.0 ) );

    rectroti((half_nraf + 1):nraf, i+1) = ...
        sin( (twopin*(((half_nraf):(nraf - 1))-nraf))*(outdelay - i/2.0 ) );

end

