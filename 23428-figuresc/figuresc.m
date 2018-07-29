function varargout = figuresc(varargin)
% Create a figure scaled relative to screen size.
%
% figuresc(w,h) creates a normal figure except that figure size is
% adjusted by scaling factors for width and height, w and h. Scaling
% factors have a range of 0.0 <= X < 1.0, and are relative to screen size.
%
% figuresc(s) makes width and height scaling factors both equal to s.
%
% h = figuresc(...) returns a handle to the figure.
%
% Demo code (and fun too!)
%     for x = 0.9:-0.1:0.1, figuresc(x), end

% by Steve Hoelzer
% 2009-03-25

% process inputs
switch nargin
    case 0
        error('Not enough input arguments.')
    case 1
        % width and height scaling are identical
        w = varargin{1};
        h = w;
    case 2
        % width and height scaling are idependent
        w = varargin{1};
        h = varargin{2};
    otherwise
        error('Too many input arguments.')
end

% error checking
if ~isscalar(w) || ~isscalar(h)
    error('Scaling factor must be a scalar.')
end
if w <= 0 || h <= 0
    error('Scaling factor must be > 0.')
end
if w > 1 || h > 1
    error('Scaling factor must be <= 1.0.')
end

% calculate position in normalized units
pos = [(1-w)/2, (1-h)/2, w, h]; % [left, bottom, width, height]

% display figure
h = figure('Units','Normalized','Position',pos);

% output figure handle if needed
if nargout > 0
    varargout{1} = h;
end
