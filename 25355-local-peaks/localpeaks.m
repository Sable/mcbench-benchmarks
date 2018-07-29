function peaks = localpeaks(x,mode)

% LOCALPEAKS Find local peaks and troughs in a vector
% 
% SYNTAX
% 
%     peaks = localpeaks(X)
%     peaks = localpeaks(X,MODE)
% 
% 
% DESCRIPTION
% 
% peaks = localpeaks(X) locates the local peaks in vector X.
% 
% peaks = localpeaks(X,MODE) locates local features specified by MODE. MODE
% can be set to 'peaks' (default), 'troughs' in order to identify local
% troughs or 'both' in order to identify both local peaks and troughs.
% 
% Copyright Chris Hummersone 2010

if ~isvector(x)
    error('Input must be a vector')
end

if nargin < 2
    mode = 'peaks';
end

switch lower(mode)
    case 'peaks'
        % do nothing
        peaks = find_peaks(x);
    case 'troughs'
        peaks = find_peaks(-x);
    case 'both'
        peaks = find_peaks(x) | find_peaks(-x);
    otherwise
        error('Unknown localpeak mode. Please specify ''peaks'', ''troughs'' or ''both''');
end


function peaks = find_peaks(x)

peaks = false(size(x));
peaks(2:end-1) = sign(x(2:end-1)-x(1:end-2)) + sign(x(2:end-1)-x(3:end)) > 1;