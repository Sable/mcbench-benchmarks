% Shape from motion recovery and 2D+3D fitting.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

clear all;
close all;

addpath('..');

if ~exist('tesi/AAM.mat', 'file')
	error('Please train an AAM using "tesi_train" before running this script.');
end

load('tesi/triangulation.mat');
groundtruth_files = dir('tesi/test3d/*.mat');

if ~exist('tesi/B.mat', 'file')
	app = imread(sprintf('tesi/test3d/%s', groundtruth_files(1).name(1:end-4)));
	
	motion_files = dir('tesi/motion/*.mat');
		
	for i=1:numel(motion_files)
		load(sprintf('tesi/motion/%s', motion_files(i).name));
		shapes(:,:,i)	= xy2ij(annotations, size(app,1));
	end
	
		np = size(shapes, 1);
		
		K = 3;
		[ P c X M B] = sm_recovery(shapes, K);
	  
		shapes3 = reshape(X', [np, 3 numel(motion_files)]);
		mean3 = mean(shapes3, 3);
	
		%save('tesi/B.mat', 'B');
		%save('tesi/mean3.mat', 'mean3');
	
		%	for i=1:(size(X,1)/3)
				%figure;
		%		trisurf(triangulation, X(3*i-2,:),X(3*i-1,:),X(3*i,:));
		%		pause;
		%	end	
		
		
else
	load('tesi/B.mat');
	load('tesi/mean3.mat');     
	
	K = size(B, 1) / 3;
	np = size(mean3, 1);
end

% Align base shapes to the mean
for i=1:K
	[D Z] = procrustes(mean3, B(3*i-2:3*i,:)');
	B(3*i-2:3*i,:) = Z';
end

% Remove the mean shape component from the base shapes and orthonormalize the result to
% obtain a basis.
% This procedure gives slightly better 3D shapes as it convert from a "weighted sum of 
% basis" representation to a 3DMM shape representation.
B_vec = reshape(B' - repmat(mean3, [1 K]), [np*3 K]);
B_vec = gs_orthonorm(B_vec);

B = reshape(B_vec, [np 3*K])';
%
%while 1
%	S = mean3';
%	for i=1:K
%		S = S + 100*(rand() - 0.5)*B(3*i-2:3*i,:);
%	end
%	
%	
%	figure(1);
%	%hold off;
%	%trimesh(triangulation, mean3(:,1), mean3(:,2), mean3(:,3));
%	%hold on;
%	trisurf(triangulation, S(1,:), S(2,:), S(3,:));
%	pause;
%end      


base3 = reshape(B', [np 3 K]);
load('tesi/AAM.mat');

%for i=1:K
%	figure(100+i)
%	trisurf(triangulation, base3(:,1,i), base3(:,2,i), base3(:,3,i));
%end

fprintf('\n********************************************************** 2D+3D FITTING **********************************************************\n\n');
disp 'Figure 1: 2D+3D (2D: white lines, 3D: black circles) fitting obtained by displacing the ground truth 5 pixels in a random direction.'
disp 'Figure 2: The 3D reconstructed shape.'
disp 'Usage: Hit a random key to test a different image. Use CTRL+C to quit.'
disp 'Notice: As the shape-from motion algorithm is randomized, try running the script multiple times to see the different possible results.'
fprintf('\n');

for i=1:numel(groundtruth_files)
	load(sprintf('tesi/test3d/%s', groundtruth_files(i).name));
	app = double(imread(sprintf('tesi/test3d/%s', groundtruth_files(i).name(1:end-4)))) / 255;
	
	init_shape = xy2ij(annotations, size(app,1));
	
	% Simple displacement of the ground-truth
	d = ([rand() rand()] - [0.5 0.5]) * 10;
	init_shape = init_shape + repmat(d, [np 1]);
	
	try
		[fitted_shape fitted_shape3 P O] = fit_3d(AAM, init_shape, app, mean3, base3, 20);
		
	  figure(1)
	  imshow(app);
	  hold on;
	  
	  triplot(AAM.shape_mesh, fitted_shape(:,2), fitted_shape(:,1), 'w', 'LineWidth', 2);
	    
	  shape3_prj = fitted_shape3 * P' + repmat(O, np, 1);	
	  
	  plot(shape3_prj(:,2), shape3_prj(:,1), 'ko', 'LineWidth', 2, 'MarkerSize', 5);
	  
	  hold off;
	  
	  figure(2)
	  trisurf(AAM.shape_mesh, fitted_shape3(:,1), fitted_shape3(:,2), fitted_shape3(:,3));
		pause
	catch ME
		fprintf('Fitting diverged: %s\n', ME.message);
	end
end
