function x = lpr_old(y, pfilt)
% LPR_OLD   Multi-level Laplacian pyramid reconstruction using the old method
%
%	x = lpr_old(y, pfilt)
%
% Input:
%   y:      output of a Laplacian pyramid in a cell vector
%   pfilt:  pyramid filter name (see PFILTERS)
%
% Output:
%   x:      reconstructed signal
%
% See also: LPD

% Get the pyramidal filters from the filter name
[h, g] = pfilters(pfilt);

% Decide extension mode
switch pfilt
    case {'9-7', '9/7', '5-3', '5/3', 'Burt'}
        extmod = 'sym';
        
    otherwise
        extmod = 'per';
        
end

x = y{1};

for n = 2:length(y)
    x = lprec1_old(x, y{n}, h, g, extmod);
end