clear, clf

% Examples of noise processes that can be simulated and measured using
% filtered_noise.m and calc_digital_nps.m, respectively.
%
% Erik Fredenberg, Royal Institute of Technology (KTH) (2010).
% Please reference this package if you find it useful.
% Feedback is welcome: fberg@kth.se.

%% --------------------------------------------------------  
%
% Example 1:
% Simulate a 2D digital detector without noise, except for quantum noise,
% but with cross talk between detector pixels. This type of noise appears
% for instance in a photon-counting detector with double counting from
% charge sharing.
%
% E. Fredenberg et al, Nucl. Instr. and Meth. A 613, 156-162 (2010).

px = 100e-3; % pixel side length [e.g. mm]
n = 2; % number of dimensions
pixel_counts = 1000;

% generate a 2D noise-power spectrum (NPS)
chi = 0.2; % Chi is the fraction of counts that come from double counting, i.e. the true number of counts is pixel_counts*(1 - Chi)
sigma2 = pixel_counts; % the variance equals the number of counts in a Poisson distribution
nps_fun_in = @(varargin) cross_talk_noise([chi sigma2 px], varargin{:});

% create a number of noise realizations from the NPS
roi_size = 256;
stack_size = 100;
mean_value = pixel_counts;
[I, x] = filtered_noise(roi_size, n, stack_size, mean_value, px, nps_fun_in);

% measure the NPS in the noise realizations
use_window = 0; % no tapering window is needed because the NPS is close to flat
average_rois = 1; % averaging over all realizations
[nps_measured, f] = calc_digital_nps(I, n, px, use_window, average_rois);

nps_expected = nps_fun_in(repmat(f,roi_size,1));
% --------------------------------------------------------
%
% Compare the simulated noise with the original:
disp(' ')
disp('Cross-talk noise:')
disp('-----------------')
disp(' ')

% The variance is the integral of the NPS:
var2 = @(I) var(I(:));
var_measured = var2(mean(I,3));
var_NPS = mean(mean(nps_measured));
disp(['Expected pixel variance: ' num2str(round(sigma2))])
disp(['Pixel variance from var: ' num2str(round(var_measured))])
disp(['Pixel variance from NPS: ' num2str(round(var_NPS))])

% chi can be found by comparing variance and NPS
% E. Fredenberg et al, Nucl. Instr. and Meth. A 613, 156-162 (2010).
NPS_0_measured = mean(mean(nps_measured(round(roi_size/2) + [0 1],:)));
chi_measured = (var_measured - NPS_0_measured)/(NPS_0_measured - 3*var_measured);
disp(' ')
disp(['Expected chi: ' num2str(chi,2)])
disp(['chi from var and NPS: ' num2str(chi_measured,2)])

figure(1)

subplot(2,2,1)
imagesc(x,x,I(:,:,1))
xlabel('X [mm]'); ylabel('Y [mm]')
title('noise image')

subplot(2,2,2)
imagesc(f,f,nps_measured)
xlabel('frequency [mm^{-1}]'); ylabel('frequency [mm^{-1}]');
title('2D NPS')

subplot(2,2,3)
plot(f,nps_expected(round(roi_size/2),:),f,nps_measured(:,round(roi_size/2)),'x')
xlabel('frequency [mm^{-1}]'); ylabel('NPS [mm^2]')
title('correlated axial NPS')
legend('expected','measured')

subplot(2,2,4)
plot(f,nps_expected(:,round(roi_size/2)),f,nps_measured(round(roi_size/2),:),'x')
xlabel('frequency [mm^{-1}]'); ylabel('NPS [mm^2]')
title('uncorrelated axial NPS')
legend('expected','measured')

%% --------------------------------------------------------
%
% Example 2:
% Simulation of a 3D volume with power-law noise. Fractals are examples of
% structures that exhibit power-law NPS. These can be used to describe many
% naturally occuring phenomena such as mountains or structures in the
% human body. The latter includes, for instance, the vascular system and
% breast tissue, and the power-law noise may in that case be used to model
% the performance of a radiologist who interprets images of the body.
%
% E. Fredenberg et al, RSNA 2011
% E. Fredenberg et al, SPIE Medical Imaging 2011.
% E. Fredenberg et al, Med Phys 37, 2017-2029 (2010).
% Power-law NPS in 3D is very well described in:
% Gang et al, Med Phys 37, 1948-1965 (2010).

vx = 100e-3; % voxel side length [e.g. mm]
n = 3; % number of dimensions

% Generate a 3D NPS.
 % Magnitude of the power law.
alpha = 1e-3;
% Exponent of the power law. beta = 0 is white noise, beta = 1 is referred
% to as pink noise, beta = 2 is brown (or red) noise, beta = 3 is 
% sometimes called black noise. A space-filling fractal has a
% characteristic power law with exponent beta = 3, and many natural
% processes, for instance the vascular system or breast tissue, have
% characteristic power laws with beta in the range 2-3. 
beta = 3;

nps_fun_in = @(varargin) power_law_noise([alpha beta], varargin{:});

% Create a noise volume from the NPS.
roi_size = 100; % The volume is 100x100x100 voxels
voxel_value = 0.5*vx; % This implies a volume that is, for instance, half filled with a material.
stack_size = 1; % A single realization.
[I_3D, x] = filtered_noise(roi_size, n, stack_size, voxel_value, vx, nps_fun_in);

% Create a projection image from the volume.
I_2D = sum(I_3D,3);

% Measure the NPS
use_window = 1; % Tapering window to avoid spectral leakage.
% in the 3D volume:
average_rois = 0; % No averaging since there is only one realization.
[nps_3D_measured, f_x] = calc_digital_nps(I_3D, n, vx, use_window, average_rois); % [e.g. mm^3]
% in a slice of the 3D volume:
average_rois = 1; % Use the planes as realizations.
nps_slc_measured = calc_digital_nps(I_3D, n-1, vx, use_window, average_rois);  % [e.g. mm^2]
% in the projection:
average_rois = 0;
nps_2D_measured = calc_digital_nps(I_2D, n-1, vx, use_window, average_rois); % [e.g. mm^2]

% Assume rotational symmetry and convert to radial coordinates.
uniguify = 1;
[nps_3Dr_measured, f_3Dr] = cart2rad(nps_3D_measured, f_x, n, uniguify);
[nps_slcr_measured, f_slcr] = cart2rad(nps_slc_measured, f_x, n-1, uniguify);
[nps_2Dr_measured, f_2Dr] = cart2rad(nps_2D_measured, f_x, n-1, uniguify);

% Fit the measured NPS:
f_Nyq = 1/(2*px); % Nyquist frequency
f_fit = logspace(log10(1/roi_size), log10(f_Nyq), 1000); % log-spaced frequency vector
log_fit = 1; % fit in log domain
nps_fun_fit = @(P, varargin) power_law_noise(P, varargin{:});
% in the 3D volume:
P_start_3D = [alpha beta];
[P_fit_3D, nps_3Dr_fit] = fit_nps(nps_3Dr_measured, f_3Dr, 1, nps_fun_fit, P_start_3D, f_fit, log_fit);
% in the slice:
% slice alpha is found via the hypergeometric function, slice beta is
% volume beta-1. (Gang et al, Med Phys 37, 1948-1965 (2010))
F = quadgk(@(p) (1+p.^2).^(-beta/2),0,Inf);
P_start_slc = [2*alpha*F beta-1];
[P_fit_slc, nps_slcr_fit] = fit_nps(nps_slcr_measured, f_slcr, 1, nps_fun_fit, P_start_slc, f_fit, log_fit);
% in the projection image
P_start_2D = [alpha*roi_size/vx beta];
[P_fit_2D, nps_2D_fit] = fit_nps(nps_2Dr_measured, f_slcr, 1, nps_fun_fit, P_start_2D, f_fit, log_fit);

% --------------------------------------------------------
%
% Compare the simulated noise with the expected:

disp(' ')
disp('Power-law noise:')
disp('----------------')
disp(' ')
disp(['Expected volume alpha / beta: ' num2str(P_start_3D(1),2) ' / ' num2str(P_start_3D(2),2)])
disp(['Measured volume alpha / beta: ' num2str(P_fit_3D(1),2) ' / ' num2str(P_fit_3D(2),2)])
disp(' ')
disp(['Expected slice alpha / beta: ' num2str(P_start_slc(1),2) ' / ' num2str(P_start_slc(2),2)])
disp(['Measured slice alpha / beta: ' num2str(P_fit_slc(1),2) ' / ' num2str(P_fit_slc(2),2)])
disp(' ')
disp(['Expected projection alpha / beta: ' num2str(P_start_2D(1),2) ' / ' num2str(P_start_2D(2),2)])
disp(['Measured projection alpha / beta: ' num2str(P_fit_2D(1),2) ' / ' num2str(P_fit_2D(2),2)])

figure(2)

subplot(2,2,1)
xslice = [0]; yslice = []; zslice = [0];
[X,Y,Z]=meshgrid(x);
h=slice(X,Y,Z,I_3D, xslice, yslice, zslice);
set(h,'EdgeColor','none')
xlabel('X [mm]'); ylabel('Y [mm]'), zlabel('Z [mm]')
title('slices through the 3D volume')

subplot(2,2,2)
imagesc(x, x, I_2D)
xlabel('X [mm]'); ylabel('Y [mm]')
title('projection of the 3D volume')

subplot(2,2,3)
loglog(f_3Dr, nps_3Dr_measured, 'x', f_slcr, nps_slcr_measured, 'x', f_2Dr, nps_2Dr_measured, 'x',...
    f_fit, nps_3Dr_fit, 'k', f_fit, nps_slcr_fit, 'k', f_fit, nps_2D_fit, 'k')
title('NPS: measured and fitted')
xlabel('frequency [mm^{-1}]'); ylabel('NPS [mm^2 or mm^3]')
xlim([1/roi_size/2 f_Nyq*2])
legend('3D', 'slice', 'projection')

%% --------------------------------------------------------
%
% Example 3:
% Integrated white noise occurs for instance when integrating from
% differential phase-contrast to phase contrast in grating-based x-ray
% phase-contrast imaging. The resulting noise texture is referred to as
% brown noise because it exhibits the characteristic power law of Brownian
% motion (beta = 2).
%
% E. Fredenberg et al, "Cascaded-systems analysis of phase-contrast
% imaging," submitted to Med. Phys., (2012).

px = 100e-3; % pixel side length [e.g. mm]
n = 2; % number of dimensions
pixel_counts = 1000;

% generate a 2D noise-power spectrum (NPS)
sigma2 = pixel_counts; % the variance equals the number of counts in a Poisson distribution
nps_fun_in = @(varargin) sigma2;

% create a number of white noise realizations
roi_size = 256;
stack_size = 1;
[I, x] = filtered_noise(roi_size, n, stack_size, pixel_counts, px, nps_fun_in);

% integrate the white noise
% A similar result could be obtained by filtering the white noise, but
% integration is used here for illustration.
I_int = cumtrapz(x, I - pixel_counts) + pixel_counts;
I_int = mean(I_int(:)) + (I_int-repmat(mean(I_int,1),[roi_size 1 1]));

% measure the NPS in the noise realizations
use_window = 1;
average_rois = 1; % use the second dimension of the array as independent realizations
[nps_measured, f] = calc_digital_nps(I_int, n-1, px, use_window, average_rois);

% fit the measured NPS to a power law
f_Nyq = 1/(2*px); % Nyquist frequency
f_fit = logspace(log10(1/roi_size), log10(f_Nyq), 1000); % log-spaced frequency vector
log_fit = 1; % fit in log domain
nps_fun_fit = @(P, varargin) power_law_noise(P, varargin{:});
P_start = [roi_size*pixel_counts*px*px^2 2]; 
[P_fit, nps_fit] = fit_nps(nps_measured(f>=0.1 & f<=1), abs(f(f>=0.1 & f<=1)), 1, nps_fun_fit, P_start, f_fit, log_fit);

% --------------------------------------------------------
%
% Compare the simulated noise with the original:

disp(' ')
disp('Integrated white noise:')
disp('-----------------------')
disp(' ')
disp(['Expected alpha / beta: ' num2str(P_start(1),2) ' / ' num2str(P_start(2),2)])
disp(['Measured alpha / beta: ' num2str(P_fit(1),2) ' / ' num2str(P_fit(2),2)])

figure(3)

subplot(2,2,1)
imagesc(x, x, I_int)
xlabel('X [mm]'); ylabel('Y [mm]')
title('noise image')

subplot(2,2,2)
loglog(abs(f), nps_measured, 'x', f_fit, nps_fit, 'k')
title('correlated axial NPS')
xlabel('frequency [mm^{-1}]'); ylabel('NPS [mm^2]')
xlim([1/roi_size/2 f_Nyq*2])
legend('measured','fitted')