%% Fit GLG and GFM models to image
% The GLG model and the GFM model are both fitted to the wavelet
% coefficients of the 'lena' image.
% The fitted densities are compared to the observed distribution of
% coefficients


%% Load the image and compute the wavelet transform

X = imread('lena.png');
I = im2double( X );

dwtmode('per', 'nodisp');
[C, S] = wavedec2(I, 3, 'db4');
tree = dwt2_to_cell( C, S );


%% Fit GLG model

M = compute_moments2D( tree );
theta_glg = moment_estimation( M );
FitInfo_glg = GLG_EM_wrapper( theta_glg, tree );


%% Fit GFM model

theta_gfm = GFM_init( tree, 2, 0.01, 0.001 );
FitInfo_gfm = GFM_EM_wrapper( theta_gfm, tree, 'max_itr', 50 );


%% Plot distributions

% Level and direction of transform
l = 2;
d = 2;

y = tree{l+1}{d}(:);
x = min(y):5e-3:max(y);
n = length(y);
[heights, locations] = hist(y, x);

% Normalized histogram
width = locations(2) - locations(1);
heights = heights / (n*width);
bar( locations, heights, 'hist' )

% Density from GLG model
w = linspace(min(y), max(y), 200);
glg = GLG_marginal_density( w, FitInfo_glg.model(l,1,d), FitInfo_glg.model(l,2,d) );
glg_h = line(w, glg, 'color', 'r');

% Density from GFM model
gfm = GFM_marginal_density( w, FitInfo_gfm.model{l,1,d}, FitInfo_gfm.model{l,3,d} );
gfm_h = line(w, gfm, 'color', 'g');

% Format figure
xlim( 0.5*[-1 1] );
legend( [glg_h, gfm_h], 'GLG density', 'GFM density' );
