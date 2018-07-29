% Evaluate fitting performance on different datasets.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

clear all;
close all;

addpath('..');

datasets = { 'child', 'Cootes', 'mother', 'movie1', 'movie2'};
convergence_thresholds = {2, 7, 3, 5.5, 5.5};
test = {[1 2 3 4 5 10 13], [8 10 12 22 26 ], [2 3 14], [7 12 5 21], [1 3 22 31 ]};

% Selected dataset
sel = 3;
blur_training_set = 1;

base_path = sprintf('performance/%s', datasets{sel});

% Available landmark files
landmark_files = dir(sprintf('%s/training/*.mat', base_path));
ns = numel(landmark_files);

for j=1:ns
	% Prepare appearance data
	app = double(imread(sprintf('%s/training/%s', base_path, landmark_files(j).name(1:end-4)))) / 255;
	
	if blur_training_set
		app = convn(convn(app, exp(-(-5:5).^2)./sum(exp(-(-5:5).^2)), 'same'), exp(-(-5:5).^2)./sum(exp(-(-5:5).^2))', 'same');
	end
	
	appearances(:,:,:,j) = app;
end

for j=1:ns
	% Load associated landmarks
	load(sprintf('%s/training/%s', base_path, landmark_files(j).name));
	shapes(:,:,j) = xy2ij(annotations, size(app,1)); 
end

load(sprintf('%s/triangulation.mat', base_path));

np = size(shapes, 1);

% Sum of fitting times
tempi = 0;
% Number of fitting times considered
ntempi = 0;

% Number of times the fitting is evaluated
ntries = zeros(10,1);
% Number of times the fitting successfully produced a result (ie. the warp didn't diverge)
nfitted = zeros(10,1);
% Number of times the pt.pt error was below the convergence threshold
nconverged = zeros(10,1);
% Sum of ptpt errors for a given value of 'k'. The number of values considered here is given by 'nfitted'.
ptpt = zeros(10,1);
% Minimum pt.pt. error for a given value of 'k'
ptpt_min = ones(10,1) * inf;
% Maximum pt.pt. error for a given value of 'k'
ptpt_max = zeros(10,1);
	
% Carry out leave-one-out testing
for jj=1:numel(test{sel})
	j = test{sel}(jj);

	fprintf('\n\n\n****************************************************************************\n');
	fprintf('Carrying out %d/%d leave-one-out try on dataset: %s\n', jj, numel(test{sel}), datasets{sel});
	fprintf('****************************************************************************\n');
	
	one_out = [1:j-1,j+1:ns];
	AAM = build_model_2d(shapes(:,:,one_out), appearances(:,:,:,one_out), 'triangulation', triangulation);
			
	for k=1:10
		fprintf('%d/10\n', k);
		
		d1 = [rand() rand()] - [0.5 0.5];
		d1 = 3*d1 / norm(d1);
		
		d2 = [rand() rand()] - [0.5 0.5];
		d2 = 3*d2 / norm(d2);
		
		% dx dy
		%displacements = k*0.6*[0 0; 0 5; 5 0; 0 -5; -5 0; -3.5355 3.5355; 3.5355 3.5355; 3.5355 -3.5355; -3.5355 -3.5355];
		displacements = k*0.6*[0 5; 5 0; 0 -5; -5 0];
		%displacements = k*[d1; d2];
		rotations = k*[0 pi/80 -pi/80 ];
		scales = [1 1 1 ] + k*[0 0.02 -0.02];
		
		cog = repmat(mean(shapes(:,:,j), 1), [np 1]);
		
		for ti=1:size(displacements, 1)
			for rot=1:numel(rotations)
				for sc=1:numel(scales)
					ntries(k) = ntries(k) + 1;
					theta = rotations(rot);
					
					A = [cos(theta) sin(theta); -sin(theta) cos(theta)] * scales(sc);
					d = repmat(displacements(ti,:), [np, 1]);
					
					init_shape = (shapes(:,:,j) - cog) * A + d + cog;
					%init_shape = shapes(:,:,j) + d;
					
					%ptpt_init = mean(sqrt(sum((init_shape - shapes(:,:,j)).^2, 2)));
					%rms_init = sqrt(sum(sum((init_shape - shapes(:,:,j)).^2)) / (2*np));
					
					diverged = 0;
					try
						tic;
						[ fitted_shape ] = fit_2d(AAM, init_shape, appearances(:,:,:,j), 20);
						dt = toc;
						nfitted(k) = nfitted(k) + 1;
					catch		
						dt = toc;
						diverged = 1;
					end
					
					if diverged == 0
						ptpt_err = mean(sqrt(sum((fitted_shape - shapes(:,:,j)).^2, 2)))
						%rms_err = sqrt(sum(sum((fitted_shape - shapes(:,:,j)).^2)) / (2*np));
						
						ptpt(k) =  ptpt(k) + ptpt_err;
					
						if ptpt_err < ptpt_min(k)
							ptpt_min(k) = ptpt_err;
						end
						
						if ptpt_err > ptpt_max(k)
							ptpt_max(k) = ptpt_err;
						end

						tempi = tempi + dt;
						ntempi = ntempi + 1;

						% Check if error is acceptable
						if ptpt_err < convergence_thresholds{sel}
							nconverged(k) = nconverged(k) + 1;
						end	
					end
					
					%hold off;
					%imshow(appearances(:,:,:,j));
					%hold on;
					%triplot(triangulation, init_shape(:,2), init_shape(:,1), 'b', 'LineWidth', 2);
					%if diverged == 0
					%	triplot(triangulation, fitted_shape(:,2), fitted_shape(:,1), 'w', 'LineWidth', 2);
					%end
					%pause;
				end
			end
		end
	end
end

% Convergence rate as a function of 'k'
results.conv_rate = nconverged ./ ntries;
% Mean fitting time
results.time_mean = tempi / ntempi;
% Mean pt.pt error as a function of 'k'
results.ptpt_mean = ptpt ./ nfitted;

results.ptpt_min = ptpt_min;
results.ptpt_max = ptpt_max;

results.nfitted = nfitted;
results.ntries = ntries;
results.nconverged = nconverged;

disp 'Plotting convergence ratio as a function of k...'
figure;
plot(1:numel(nconverged), results.conv_rate);

result_path = sprintf('%s/results.mat', base_path);
save(result_path, 'results');
fprintf('\For the full results of the performance evaluation see: ./%s. See that file for more details.\n', result_path);
	
clear all;

	