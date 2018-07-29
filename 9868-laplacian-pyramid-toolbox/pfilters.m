function [h, g] = pfilters(fname)
% PFILTERS    Generate filters for the Laplacian pyramid
%
%	[h, g] = pfilters(fname)
%
% Input:
%   fname:  Name of the filters, including the famous '9-7' filters
%           and all other available from WFILTERS in Wavelet toolbox
%
% Output:
%   h, g:   1D filters (lowpass for analysis and synthesis, respectively)
%           for seperable pyramid

switch fname
    case {'9-7', '9/7'}
        h = [.037828455506995 -.023849465019380 -.11062440441842 ...
             .37740285561265];	
        h = [h, .85269867900940, fliplr(h)];
    
        g = [-.064538882628938 -.040689417609558 .41809227322221];
        g = [g, .78848561640566, fliplr(g)];
        
    case {'5-3', '5/3'}
        h = [-1, 2, 6, 2, -1] / (4 * sqrt(2));
        g = [1, 2, 1] / (2 * sqrt(2));
        
    case {'Burt'}
        h = [0.6, 0.25, -0.05];
        h = sqrt(2) * [h(end:-1:2), h];
	
        g = [17/28, 73/280, -3/56, -3/280];
        g = sqrt(2) * [g(end:-1:2), g];
        
    otherwise
        [h, g] = wfilters(fname, 'l');
end