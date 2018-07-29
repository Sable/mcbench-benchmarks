% Simple example of 2D AAM fitting.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

clear all;

addpath('..');

training_files = dir('cootes/*.bmp.mat');

for i=1:numel(training_files)
	load(sprintf('cootes/%s', training_files(i).name));
	
	app = imread(sprintf('cootes/%s', training_files(i).name(1:end-4)));
	
	% Map RGB colors to [0,1]
	appearances(:,:,:,i) = double(app) ./ 255;
	
	shapes(:,:,i) = xy2ij(annotations, size(app,1));
end
	
load('cootes/triangulation.mat');

test_img = 2;
one_out = [1:test_img-1, test_img+1:size(shapes,3)];

AAM = build_model_2d(shapes(:,:,one_out), appearances(:,:,:,one_out), 'triangulation', triangulation);

fprintf('\n******************************************************* 2D FITTING *******************************************************\n\n');
disp 'Figure 1: leave-one-out fitting result (red mesh) using as intialization a random shape from the training set (blue mesh).'
disp 'Figure 2: reconstructed appearance.'
disp 'Usage: Hit a random key to use a different initialization shape. Use CTRL+C to quit.'
fprintf('\n');

while 1
	init_shape = one_out(round(rand()*(numel(one_out) - 1) + 1));
	try
		[ fitted_shape fitted_app ] = fit_2d(AAM, shapes(:,:,init_shape) + repmat([-5 -5], [size(shapes, 1) 1 1]), appearances(:,:,:,test_img), 20);
			
		figure(1)
		imshow(appearances(:,:,:,test_img));
		hold on;
		triplot(AAM.shape_mesh, shapes(:,2,init_shape), shapes(:,1,init_shape), 'b');
		triplot(AAM.shape_mesh, fitted_shape(:,2), fitted_shape(:,1), 'r');
		hold off;
		
		figure(2)
		imshow(fitted_app);
			
		pause;
	catch ME
		fprintf('Fitting diverged: %s\n', ME.message);
	end
end
	
