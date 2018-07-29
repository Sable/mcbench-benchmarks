function y = lpd(x, pfilt, nlev)
% LPD   Multi-level Laplacian pyramid decomposition
%
%	y = lpdecn(x, pfilt, nlev)
%
% Input:
%   x:      input signal (of any dimension)
%   pfilt:  pyramid filter name (see PFILTERS)
%   nlev:   number of decomposition level
%
% Output:
%   y:      output in a cell vector from coarse to fine layers
%
% See also: LPR

% Get the pyramidal filters from the filter name
[h, g] = pfilters(pfilt);

% Decide extension mode
switch pfilt
    case {'9-7', '9/7', '5-3', '5/3', 'Burt'}
        extmod = 'sym';
        
    otherwise
        extmod = 'per';
        
end

y = cell(1, nlev+1);

for n = 1:nlev
    [x, y{nlev-n+2}] = lpdec1(x, h, g, extmod);
end

y{1} = x;
