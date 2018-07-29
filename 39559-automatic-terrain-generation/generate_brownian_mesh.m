function [zm, xm, ym] = generate_brownian_mesh(n, zm)

% [zm, xm, ym] = generate_brownian_mesh(n, zm)
% 
% Generate a mesh of points exhibiting "fractal Brownian motion",  a random
% mesh that more-or-less looks like terrain. The output "height" mesh maps
% over [0, 0] to [1, 1] with 2^n+1 points along each axis for (2^n+1)^2 
% total data points. This method is also known as the midpoint displacement
% method.
%
% Inputs:
% n  - Number of iterations
% zm - Initial heights
%
% Outputs:
% zm - "z" data corresponding to mesh
% xm - "x" data corresponding to mesh
% ym - "y" data corresponding to mesh
%
% Example
% [hm, xm, ym] = generate_brownian_mesh(8);
% hm(hm < 0) = 0;
% surf(xm, ym, 0.1*hm);
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
% For an example, see terrain_generation_introduction.m or 
% html/terrain_generation_introduction.html.
% 
% Tucker McClure
% Copyright 2012, The MathWorks, Inc.

    % If no initial mesh is specified, create one randomly.
    if nargin < 2
        zm = randn(2, 2);
        s = 1;
    else
        s = 1/(size(zm, 1) - 1);
    end
    
    % Make the initial x and y meshes.
    [xm, ym] = meshgrid(0:s:1, 0:s:1);
    
    % Refine for n iterations.
    for k = 1:n
        
        % Distance between neighboring components.
        d = 0.5^k * s;
        
        % Make new meshes.
        [xm_new, ym_new] = meshgrid(0:d:1, 0:d:1);
        
        % Interpolate and add random variation to the new mesh.
        zm = interp2(xm, ym, zm, xm_new, ym_new) + d * randn(2^k/s + 1);
        
        % What was old becomes new.
        xm = xm_new;
        ym = ym_new;
        
    end

end
