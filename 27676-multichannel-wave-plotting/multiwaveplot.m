function varargout = multiwaveplot(varargin)
% Plot stacked waves from a multichannel matrix
% 
%   multiwaveplot(wave)
%   multiwaveplot(x,y,wave)
%   multiwaveplot(...,gain)
%   multiwaveplot(...,mode)
%   h = multiwaveplot(...)
% 
%   Multiwaveplot draws a series of stacked waves (one on
%   top of the other) contained in the rows of an input 2-D
%   matrix. Each wave has a designated row on the plot; the
%   first row is plotted at the bottom of the plot.
% 
%   multiwaveplot(wave) draws a series of waves
%   contained in the rows of wave.
% 
%   multiwaveplot(x,y,wave) plot the waves against the data
%   in x and y, such that x specifies the common x data, and
%   y determines the vertical position of each row. Hence,
%   length(x)==size(wave,2) and length(y)==size(wave,1).
% 
%   multiwaveplot(...,gain) scales the height of each wave
%   according to gain. With gain=1 (default), the height of
%   the tallest wave will be limited so as not to encroach
%   on the adjacent wave; all other waves are scaled
%   accordingly. This can be overridden by specifying gain >
%   1.
% 
%   multiwaveplot(...,mode) plots the data with the
%   specified mode. The default mode depends on gain: for
%   gain <= 1, mode defaults to 'plot' and plots lines for
%   each row of wave; for gain > 1, mode defaults to 'fill'
%   and instead plots white patch objects for each row of
%   wave, covering the area under each wave, such that waves
%   with a lower row index mask those with a higher row
%   index. This behaviour can be overridden by specifying
%   MODE as a string (either 'plot' or 'fill').
% 
%   h = multiwaveplot(...) returns a vector of handles to
%   patch (for mode = 'fill') or lineseries (for mode =
%   'plot') graphics objects, one handle per wave.
% 
%   See also FILL, PATCH, PLOT, IMAGESC.

% !---
% ==========================================================
% Last changed:     $Date: 2013-06-24 17:45:41 +0100 (Mon, 24 Jun 2013) $
% Last committed:   $Revision: 249 $
% Last changed by:  $Author: ch0022 $
% ==========================================================
% !---

%% Derive inputs

input_spec = 'X and Y must be vectors, WAVE must be a matrix, GAIN must be a scalar and MODE must be a string';

% MODE
mode = find_inputs(@ischar,varargin,...
    ['Unknown parameter specified. ' input_spec]);

% GAIN
gain = find_inputs(@(x)(isscalar(x) & ~ischar(x)),varargin,...
    ['Unknown parameter specified. ' input_spec]);

if isempty(gain)
    gain = 1;
end

% Condtionally set MODE depending on GAIN
if isempty(mode)
    if gain > 1
        mode = 'fill';
    else
        mode = 'plot';
    end
end

% WAVE
wave = find_inputs(@(x)(isnumeric(x) & all(numel(x)>size(x)) & length(size(x))<3),varargin,...
    ['Both X and Y must be specified. ' input_spec]);

assert(~isempty(wave),'Please specify WAVE (which should be a matrix)')

[r,c] = size(wave);

% X and Y
[x,y] = find_inputs(@(x)(~isscalar(x) & isvector(x) & ~ischar(x)),varargin,...
    ['Both X and Y must be specified. ' input_spec]);

if isempty(x)
    x = 1:c;
    y = 1:r;
end

%% Plot

if min(wave(:))>=0
    adjust = 1; % for positive data (e.g. correlograms)
else
    adjust = 0.5; % for wave data varying on zero
end

for n = 1:r
    % just in case all values are zero
    if ~all(wave(n,:)==0)
        wave(n,:) = (adjust/max(abs(wave(:)))).*wave(n,:);
    end
end

scale = zeros(r,1); % this parameter allows for non-linear y-values, scaling each channel accordingly
h = zeros(r,1);

axis_min = y(1)-(adjust*(y(2)-y(1)));

hold on;

for n = r:-1:1
    try % calculate scaling factor
        scale(n) = y(n+1)-y(n);
    catch
        scale(n) = y(n)-y(n-1);
    end
    wave(n,:) = wave(n,:).*scale(n);
    switch mode % plot
        case 'plot'
            h(n) = plot(x,gain.*wave(n,:)+y(n),'k');
        case 'fill'
            xa=[x(1) x(1:c) x(c) x(1)];
            ya=[axis_min gain.*wave(n,:)+y(n) axis_min axis_min];
            h(n) = fill(xa,ya,'w');
        otherwise
            error('Unknown MODE specified: must be ''fill'' or ''plot''')
    end
end

hold off
axis([x(1) x(c) axis_min max(y(r)+(gain.*wave(r,:)))]); % set axis limits
set(gca,'layer','top') % move axis to top layer
box on

varargout(1:nargout) = {h};

% end of multiwaveplot()

% ----------------------------------------------------------
% Local functions:
% ----------------------------------------------------------

% ----------------------------------------------------------
% find_inputs: validate and provide inputs (if any)
% ----------------------------------------------------------
function varargout = find_inputs(fhandle,input,msg)

indices = cellfun(fhandle,input);

if any(indices) % inputs are specified
    if sum(indices)~=nargout
        error(msg) % return error message
    end
    varargout(1:nargout) = input(indices);
else % unspecified returns empty matrix
    varargout(1:nargout) = {[]};
end

% [EOF]
