%% Remove noise from image
% The 'peppers' image is corrupted with Gaussian additive noise with
% different standard deviations and cleaned using the GFM and GLG models.

%% Load image

X = imread('peppers.png');
I = im2double( X );

imshow(I)

dwtmode('per', 'nodisp');
wavelet = 'db4';

%% Generate noisy image

noise_dev = 0.1;
J = I + noise_dev*randn(size(I));

imshow(J)

[C, S] = wavedec2( J, 3, wavelet );
noisy_tree = dwt2_to_cell( C, S );


%% Fit GLG model

M = compute_moments2D( noisy_tree );
theta_glg = noisy_moment_estimation( M, noise_dev );
FitInfo_glg = GLG_EM_wrapper( theta_glg, noisy_tree, 'noise_dev', noise_dev );


%% Fit GFM model

theta_gfm = GFM_init( noisy_tree, 2, 0.01, 0.001 );
FitInfo_gfm = GFM_EM_wrapper( theta_gfm, noisy_tree, 'max_itr', 50 );


%% Remove noise with GLG

[clean_tree_glg, scaling_factor] = GLG_noise_removal( noisy_tree, FitInfo_glg.model, noise_dev, 20 );

C = cell_to_dwt2( clean_tree_glg );
clean_image_glg = waverec2( C, S, wavelet );

imshow(clean_image_glg)

fprintf('PSNR, GLG: %f\n', psnr(I, clean_image_glg));


%% Remove noise with GFM

clean_tree_gfm = GFM_noise_removal( noisy_tree, FitInfo_gfm.model, noise_dev );

C = cell_to_dwt2( clean_tree_gfm );
clean_image_gfm = waverec2( C, S, wavelet );

imshow(clean_image_gfm)

fprintf('PSNR, GFM: %f\n', psnr(I, clean_image_gfm));
