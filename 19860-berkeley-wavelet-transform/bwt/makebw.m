function z = makebw(or,ph)
% function z = makebw(or,ph)
%
% Create BWT wavelets
% Version 1.2
%
% Arguments:
%  or: Orientation { -1 (DC), 0, 45, 90, 135 }
%  ph: Phase { 0 (odd), 90 (even) }
%
% Result:
%  z: The selected wavelet, or NaN if the parameters are not recognized
%
% Citation:
%  Willmore B, Prenger RJ, Wu MC and Gallant JL (2008). The Berkeley 
%  Wavelet Transform: A biologically-inspired orthogonal wavelet transform.
%  Neural Computation 20:6, 1537-1564 
%
% The article is available at:
%  <http://dx.doi.org/10.1162/neco.2007.05-07-513>
%
% Copyright (c) 2008 Ben Willmore
%
% Permission is hereby granted, free of charge, to any person
% obtaining a copy of this software and associated documentation
% files (the "Software"), to deal in the Software without
% restriction, including without limitation the rights to use,
% copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the
% Software is furnished to do so, subject to the following
% conditions:
% 
% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
% HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
% OTHER DEALINGS IN THE SOFTWARE.

z = nan;

if (or==-1)
    z = ones(3,3)/sqrt(9);
    
elseif (or==0)
    if (ph==0)
        z = [-1 0 1; -1 0 1; -1 0 1]/sqrt(6);
    elseif (ph==90)
        z = [-1 2 -1; -1 2 -1; -1 2 -1]/sqrt(18);
    end
    
elseif (or==45)
    if (ph==0)
        z = [-1 1 0; 1 0 -1; 0 -1 1]/sqrt(6);
    elseif (ph==90)
        z = [-1 -1 2; -1 2 -1; 2 -1 -1]/sqrt(18);
    end
    
elseif (or==90)
    if (ph==0)
        z = [-1 -1 -1; 0 0 0; 1 1 1]/sqrt(6);
    elseif (ph==90)
        z = [-1 -1 -1; 2 2 2; -1 -1 -1]/sqrt(18);
    end
    
elseif (or==135)
    if (ph==0)
        z = [0 -1 1; 1 0 -1; -1 1 0]/sqrt(6);
    elseif (ph==90)
        z = [2 -1 -1; -1 2 -1; -1 -1 2]/sqrt(18);
    end 
    
end

if (isnan(z))
    disp('Wavelet parameters not recognized');
end
