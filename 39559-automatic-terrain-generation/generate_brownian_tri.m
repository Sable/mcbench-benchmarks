function [hm, xm, ym, rm] = generate_brownian_tri(n, nm, r0, el, rr)

% [hm, xm, ym, rm] = generate_brownian_tri(ni, nm, r0, el, rr))
% 
% Generates a random mesh that more-or-less looks like terrain using a
% Brownian fractal method.
%
% Inputs:
% n  - Number of iterations
% nm - Resolution of final map
% r0 - Initial roughness of terrain (this will vary across the map too)
% el - Initial elevation of terrain
% rr - Roughness of roughness over terrain (how much roughness changes)
%
% Outputs:
% hm - Height mesh
% xm - "x" data corresponding to mesh
% ym - "y" data corresponding to mesh
%
% Example
% [hm, xm, ym] = generate_brownian_tri(14, 128, 0.1, 0.1, 0.25);
% hm(hm < 0) = 0;
% surf(xm, ym, hm);
% shading interp;
% caxis([0 0.25]);
% axis equal vis3d;
% colormap(getfield(load('cape', 'map'), 'map'));
% camlight headlight;
% lighting phong;
%
% This technique was first proposed by Benoit Mandelbrot for generating 
% realistic looking landscapes ("Fractal landscape", Wikipedia).
% 
% Tucker McClure
% Copyright 2012, The MathWorks, Inc.

    % If some arguments aren't provided, use a default.
    if nargin < 5, rr = 1;   end; % Roughness of roughness itself
    if nargin < 4, el = 0;   end; % Initial elevation
    if nargin < 3, r0 = 0.1; end; % Initial roughness

    % Preallocate all the space for the data.
    x = zeros(2^(n+1), 1);
    y = zeros(2^(n+1), 1);
    h = zeros(2^(n+1), 1);
    r = zeros(2^(n+1), 1);
    
    % Make initial boundaries.
    x(1:4) = [0 0 1 1]';
    y(1:4) = [0 1 0 1]';
    h(1:4) = 0.5 * r0 * randn(4, 1) + el;
    r(1:4) = rr * randn(4, 1) + r0;

    % Keep adding detail, doubling at each step.
    for k = 1:n

        % We'll need to refer to the old and new ranges frequently, so
        % store them.
        range     = 1:(2^(k+1));
        new_range = 2^(k+1)+1:2^(k+2);
        
        % Create a fit for the current stuff.
        h_interpolator = TriScatteredInterp(x(range), y(range), h(range));
        r_interpolator = TriScatteredInterp(x(range), y(range), r(range));
        
        % Make new (x,y) points uniformly in the space.
        x(new_range) = rand(2^(k+1), 1);
        y(new_range) = rand(2^(k+1), 1);
        
        % Make a new roughness for each new point based on the
        % interpolation over the old roughness.
        r(new_range) =   r_interpolator(x(new_range), y(new_range)) ...
                       + (rr * 0.5^k) * randn(2^(k+1), 1);
                   
        % Make a new height for each based on the interpolation over the
        % old data and the new roughness values.
        h(new_range) =   h_interpolator(x(new_range), y(new_range)) ...
                       + 0.6^k * (   max(r(new_range), 0)...
                                  .* randn(2^(k+1), 1));
        

    end

    % The final mesh will sample the interior (the edges are always a
    % linear interpolation between the corners, so this is uninteresting).
    [xm, ym] = meshgrid(linspace(0.1, 0.9, nm), linspace(0.1, 0.9, nm));
    
    % Interpolate the output.
    hm = h_interpolator(xm, ym);
    
    % Also output roughness, if requested.
    if nargout >= 4
        rm = h_interpolator(xm, ym);
    end

    % Respace to [0,1].
    [xm, ym] = meshgrid(linspace(0, 1, nm), linspace(0, 1, nm));
    
end
