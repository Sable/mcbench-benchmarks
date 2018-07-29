function c = generate_terrain_colors(hm)

% c = generate_terrain_colors(hm)
% 
% Given a height map, this function produces a color map that includes
% rock, dirt, vegetation, snow, and water for a moderately
% realistic-looking 3D display. Note that the input height map must be 1
% more than a power of two, e.g., 129, 257, or 513 and must be square.
%
% See terrain_generation_introduction.m for an example.
%
% Tucker McClure
% Copyright 2012, The MathWorks, Inc.

% Check for appropriate size.
if size(hm, 1) ~= size(hm, 2) || ~all(factor(size(hm, 1) - 1) == 2)
    error(['Height map must be square with 2^n + 1 elements to a side ' ...
           '(e.g., 129, 257, or 513).']);
end

% Create function to limit things (like colors) to [0, 1].
limit = @(x) min(max(x, 0), 1);

% Create a sigmoid function to make input data closer to 0 or closer to 1.
sigmoid = @(x) 1./(1+exp(-x));

% Create a function to make random meshes similarly to the terrain
% generator (but a little faster and not specifically "terrain" looking).
n_iterations = log2(size(hm, 1) - 1) - 3;
gen_mesh  = @() limit(3*generate_brownian_mesh(n_iterations, 0.2*rand(9)));

% Create a function to turn a 1-by-3 color into an n-by-n-by-3 matrix of
% colors.
matrixify   = @(c) repmat(reshape(c, [1 1 3]), [size(hm) 1]);

% Create a function to vary a color's hue smoothly across the map and vary
% its lightness sharply and frequently.
vary        = @(c, a, b) feval(@(m) cat(3, c(1)*m.*(1-b*gen_mesh()), ...
                                           c(2)*m.*(1-b*gen_mesh()), ...
                                           c(3)*m.*(1-b*gen_mesh())), ...
                               1-a*rand(size(hm)));
                           
% Create a function to blend two colors according to n-by-n-by-3 alpha.
blend       = @(a, b, alpha) (1-alpha) .* a + alpha .* b;

% Create a function to n-by-n mask (0 is all color a and 1 is all color b).
mix_colors  = @(a, b, mask) blend(a, b, repmat(mask, [1 1 3]));

% Calculate geometrical properties of the surface that we'll use to color
% the landscape.
[fx, fy] = gradient(hm);
g = fx.^2 + fy.^2;
d = del2(hm);

% Create rock in high-gradient (steep) places. There will be two layers of
% rock to capture some different colors.
rockiness1  = gen_mesh() .* limit((g - 1e-5)/1e-5 + gen_mesh());
rockiness2  = gen_mesh() .* limit((g - 1e-5)/1e-5 + gen_mesh());

% Riveriness is the degree to which an area is concave upwards (could hold
% water). This will effect where the plant colors go.
riveriness  = limit((d - 1e-8)/5e-3).^0.5;

% Put sand near low altitude areas.
sandiness   = gen_mesh() .* 1./(0.3+exp(-(2e-2 - hm)/2e-2));

% Grass or other vegetation grows in low gradient (flat) area, near rivers,
% and not on sand.
grassiness  = gen_mesh().*limit(10*(1e-5-g)/1e-5 + riveriness - sandiness);

% Trees can grow in steeper places than grass and really like rivers. This
% allows the tree colors to creep along river-like areas of the map.
treeiness   = limit(1.5 * gen_mesh() .* ((1e-4 - g)/1e-4 + riveriness));

% We want snow where it's high, with some smooth randomness, and with most
% where it's flatter. We also want a global snowiness to account for
% seasons.
snowiness   =    sigmoid(5e3*randn()) ...             % Global snowiness
              .* sigmoid(10 * (gen_mesh() + 0.5)) ... % Randomness
              .* sigmoid(1e2 * (hm - 0.1)) ...        % Altitude
              .* limit((1e-5 - g)/1e-5);              % Cliffs
          
% We want water where the height is below 0. We'll first draw a random
% exponent that is essentially a "murkiness" parameter.
ex = (0.5*rand()+0.25);
coraliness  = rand() * limit(gen_mesh() .* (0 - hm)/0.01).^ex;
oceaniness  = 0.95 * limit((0 - hm)/0.01).^ex;

% Define some colors.
dirt        = [0.23 0.22 0.16];
dirt2       = [0.38 0.35 0.28];
sand        = [0.65 0.64 0.45];
rock        = [0.85 0.82 0.80];
rock2       = [0.51 0.52 0.57];
grass       = [0.40 0.43 0.16];
trees       = [0.20 0.25 0.14];
snow        = [1 1 1] - 0.002;
coral       = [0.00 0.87 0.80];
ocean       = [0.00 0.05 0.15];

% Start with dirt and add some colors.
c = vary(dirt, 0.3, 0.2);
c = mix_colors(c, vary(dirt2, 0.3,  0.2),  gen_mesh()); % More dirt
c = mix_colors(c, matrixify(sand),         sandiness);  % Sand
c = mix_colors(c, vary(rock,  0.3,  0.1),  rockiness1); % Rock
c = mix_colors(c, vary(rock2, 0.3,  0.1),  rockiness2); % Darker rock
c = mix_colors(c, vary(grass, 0.2,  0.3),  grassiness); % Grass
c = mix_colors(c, vary(trees, 0.3,  0.3),  treeiness);  % Trees
c = mix_colors(c, matrixify(snow),         snowiness);  % Snow
c = mix_colors(c, vary(coral, 0.2,  1.0),  coraliness); % Coral
c = mix_colors(c, vary(ocean, 0.05, 0.05), oceaniness); % Oceans

end
