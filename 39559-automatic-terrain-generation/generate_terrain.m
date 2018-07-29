function [x, y, h, hm, xm, ym] = generate_terrain(n, mesh_size, h0, r0, rr)

% [x, y, h, hm, xm, ym] = generate_terrain(n, mesh_size, h0, r0, rr)
% 
% This function generates a series of points that approximate terrain
% according to a simple algorithm and very few parameters.
%
% Inputs:
% n         - Number of iterations of algorithm to perform, akin to the
%             order of magnitudes represented by the variation. Anything
%             beyond 7 will produce detail too fine to notice, while the
%             algorithm will require ~3 times longer for every iteration.
% mesh_size - Size of the output mesh (e.g., 512 for 512-by-512)
% h0        - Initial elevation
% r0        - Initial roughness (how much terrain can vary in a step)
% rr        - Roughness roughness (how much roughness can vary in a step)
%
% For an example, see terrain_generation_introduction.m or 
% html/terrain_generation_introduction.html.
%
% Outputs:
% x, y, and h    - Vectors of points comprising terrain
% xm, ym, and hm - Meshes over landscape, useful for surf(...)
%
% Tucker McClure
% Copyright 2012, The MathWorks, Inc.

    % Set some defaults if the user didn't provide inputs.
    if nargin < 1, n         = 7;            end % Iterations
    if nargin < 2, mesh_size = 513;          end % Output mesh size
    if nargin < 3, h0        = 0.1 * rand(); end % Elevation
    if nargin < 4, r0        = 0.1 * rand(); end % Roughness
    if nargin < 5, rr        = 0.1 * rand(); end % Roughness roughness

    n0 = randi(5);     % Number of initial points
    m  = 3;            % How many points grow from each old point
    nf = n0 * (m+1)^n; % Total number of points
    
    % Create initial x, y, and height coordinates and roughness map.
    x = [randn(n0, 1);           zeros(nf-n0, 1)];
    y = [randn(n0, 1);           zeros(nf-n0, 1)];
    h = [r0 * randn(n0, 1) + h0; zeros(nf-n0, 1)];
    r = [rr * randn(n0, 1) + r0; zeros(nf-n0, 1)];
    
    % Create new points from old points n times.
    for k = 1:n

        % Calculate the new variance for the x, y random draws and for the
        % h, r random draws.
        dxy = 0.75^k;
        dh  = 0.5^k;

        % Number of new points to generate
        n_new = m * n0;

        % Parents for new points
        parents = reshape(repmat(1:n0, m, 1), [n_new, 1]);
        
        % Calculate indices for new and existing points.
        new = (n0+1):(n0+n_new);
        old = 1:n0;

        % Generate new x/y values.
        theta  = 2*pi * rand(n_new, 1);
        radius = dxy * (rand(n_new, 1) + 1);
        x(new) = x(parents) + radius .* cos(theta);
        y(new) = y(parents) + radius .* sin(theta);
        
        % Interpolate to find nominal new r and h values and add noise to
        % roughness and height maps.
        r(new) =   interpolate(x(old), y(old), r(old), x(new), y(new)) ...
                 + (dh * rr) .* randn(n_new, 1);
        h(new) =   interpolate(x(old), y(old), h(old), x(new), y(new)) ...
                 + (dh/dxy) * radius .* r(new) .* randn(n_new, 1);
        
        % Add up the new points.
        n0 = n_new + n0;

    end

    % Normalize the distribution of the points about the median.
    x = (x - median(x))/std(x);
    y = (y - median(y))/std(y);

    % If the user wants a mesh output, we can do that too. Create a mesh
    % over the significant part and interpolate over it.
    if nargout > 3 && ~isempty(mesh_size)
        [xm, ym] = meshgrid(linspace(-1, 1, mesh_size));
        hm = interpolate(x, y, h, xm, ym);
    end
    
end

% Perform our particular type of interpolation.
function vn = interpolate(x0, y0, v0, xn, yn)

    % Make an interpolator for height or roughness. We'll add safe far-away
    % points so we'll always be interpolating and not extrapolating.
    int = TriScatteredInterp([100*[-1 -1 1 1]'; x0], ...
                             [100*[-1 1 -1 1]'; y0], ...
                             [zeros(4, 1);      v0], 'linear'); %#ok<R%#ok<MSNU> EMFF1>

	% Perform the actual interpolation.
	vn = int(xn, yn);

end
