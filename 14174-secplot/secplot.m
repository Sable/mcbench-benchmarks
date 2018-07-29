function varargout = secplot(th, r, varargin)
% ax = secplot(th, rho) Plot th and r as a series of triangular wedges
% 360/size(th) degrees wide, with a radius corresponding to r.
%
% Return a handle to the polar plot.
%
% Additional arguments will be passed to polar, which handles the plotting.
%
% Example:
%       th = 0:pi/4:2*pi;
%       secplot(th, sin(th/10));
%
% Matt Foster <ee1mpf@bath.ac.uk>
%
% $Id$

    % Sanity checking:
    if ~isvector(th) || ~isvector(r)
        warning('Secplot:ArgWarning', 'Inputs th and r should be vectors');
    end

    % These _must_ be rows -- make sure they are.
    th = rowcheck(th);
    r = rowcheck(r);

    % Find triangle spacing
    space = diff(th)./2;

    if any(diff(space) > 1e-6)
        space = mean(space);
        warning('SecPlot:ArgError', ...
        'input angles not evenly spaced, using mean value: %2.4g', ...
        space);
    else
        space = space(1);
    end

    % Calculate lower and upper bounds of triangles
    lw = th - space;
    up = th + space;

    % Repeat angles (each radial side has two of the same angle)
    angs = [lw; lw; up; up];
    angs = angs(:);

    % handle the radii (the non-radial sides consist of two points at each
    % radius)
    rads = [zeros(size(r)); r; r; zeros(size(r))];
    rads = rads(:);

    % Plot:
    ax = polar(angs, rads);
    set(ax, varargin{:});

    if nargout ~= 0
        varargout{:} = ax;
    end

end % function

function vec = rowcheck(vec)
    if size(vec, 1) ~= 1
        vec = vec';
    end
end

