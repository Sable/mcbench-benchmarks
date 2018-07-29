function AAM = build_model_2d_from_files(directory, varargin)
% AAM = build_model_2d_from_files(directory)
% AAM = build_model_2d_from_files(directory, 'triangulation', triangulation)
%
% FIXME: Mostly a cut/paste from build_model_2d, but this
% method was needed to avoid out-of-memory issues when dealing with large training
% sets.
%
% Builds an Active Appearance Model using shape and appearance data retrieved from
% the given directory.
% Based on the 'Active Appearance Models Revisited' paper by Iain Matthews and Simon Baker.
%
%                         PARAMETERS
%
% directory Path to a directory containing shape and appearance data in the appropriate format.
%           See the examples to see what this format is, or use one of the provided datasets.
%
%                     OPTIONAL PROPERTIES
%
% 'triangulation' A matrix property providing a triangular mesh over the
%                 shape (in the same format as the one returned by delaunay).
%                 If not provided, a triangulation will be determined using
%                 delaunay on the mean shape.
%
%
%                        RETURN VALUE
%
% AAM is a structure with the following fields:
%
% 	s0 The mean shape as a column vector [i1 i2 i3 ... j1 j2 j3 ...]'.
%
%   s  The matrix of base shapes with each shape stored on a column vector
%      with the same structure as s0
%
%   s_star The basis for the global normalizing transform. They are four column
%          vectors whose linear combination allow for translation, scale and
%          rotation of the base shape
%
%   shape_eiv The eigenvalues associated to each shape principal
%             component
%
%   warp_map A modelh-by-modelw lookup table for determining to which
%            triangle warp_map(i,j) the pixel (i,j) belongs. If 0, the
%            pixel is outside the mean shape
%
%   shape_mesh The triangles indexed by warp_map. It is a Tx3 matrix
%              containing indices to vertices in the shape. Look at
%              the delaunay function for further information
%
%   alpha_coords An image containing the alpha barycentric coordinate
%                for pixel (i,j) wrt of the triangle given by
%                shape_mesh(warp_map(i,j),:). Value is undefined if
%                warp_map(i,j) is 0
%
%   beta_coords An image containing the beta barycentric coordinate
%               for pixel (i,j) wrt of the triangle given by
%               shape_mesh(warp_map(i,j),:). Value is undefined if
%               warp_map(i,j) is 0
%
%   adj_list Array of N cells containing indices to the triangles sharing
%            a given vertex. Such that for the k-th cell, the list will
%            contain the indices to the triangles in shape_mesh sharing
%            the k-th vertex.
%
%   A0 Mean appearance as a column vector, sorted firstly by color
%      component, then j coordinate and finally i coordinate
%      Example:
%       X1 = [ 1 2; 3 4];
%       X2 = [ 5 6; 7 8];
%       X3 = [ 9 10; 11 12];
%       X(:,:,1)=X1;
%       X(:,:,2)=X2;
%       X(:,:,3)=X3;
%       reshape(X,[],1) =>
%          _________
%        1  j==1
%        3 _____   C1
%        2  j==2
%        4 _________
%        5  j==1
%        7 _____   C2
%        6  j==2
%        8 _________
%        9  j==1
%       11 _____   C3
%       10  j==2
%       12 _________
%
%   A  The matrix of base appearances, with each appearance stored on
%      the colomuns in the same manner as A0
%
%   app_eiv The eigenvalues associated to each appearance principal
%           component
%
%   dA0 The gradient of the mean appearance stored such that for pixel (i,j),
%       dA0(i,j,c,1) gives the i direction of the gradient for color c
%       and dA0(i,j,c,2) gives the j direction of the gradient for color c
%
%   dW_dp Jacobian of the warp with respect to the shape parameters p
%
%   dN_dq Jacobian of the global normalizing warp with respect of the
%         global transform parameters q
%
%   SD Steepest descent images. They are stored as row vectors (of the same length
%      as A0). The first 4 images are associated with the q
%      paramenters, the other are associated with the p parameters
%
%   H The hessian, it's a square NxN matrix where N is the number of steepest
%     descent images (or, equivalently, the sum of the number of p and
%     q parameters)
%
%   invH Inverse hessian, it's a square NxN matrix where N is the number of steepest
%     descent images (or, equivalently, the sum of the number of p and
%     q parameters)
%
%   R Simply the product between the inverse hessian and the steepest descent images,
%     invH * SD. Encodes the linear relationship between the error image and the incremental
%     parameters.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

	shape_triangles = zeros(0, 3, 'uint32');

	i = 1;
	while i < numel(varargin)
		if strcmp(varargin{i}, 'triangulation')
			% Be sure the triangle indices are unsigned integers.
			shape_triangles = uint32(varargin{i+1});
		else
			error(sprintf('Unsupported property: %s.', varargin{i}));
		end

		i = i + 2;
	end

	tic;

	landmark_files = dir(sprintf('%s/*.mat', directory));
	disp 'Number of shapes:'
	% size of training set
	ns = numel(landmark_files)

	for j=1:ns
		% Load associated landmarks
		load(sprintf('%s/%s', directory, landmark_files(j).name));
		info = imfinfo(sprintf('%s/%s', directory, landmark_files(j).name(1:end-4)));
		shape_data(:,:,j) = xy2ij(annotations, info.Height);
	end

	% number of points
	np = size(shape_data, 1);

	% use first shape as initial mean
	mean_shape = shape_data(:,:,1);

	reference_shape = mean_shape;

	% Matrix containing the aligned shapes
	aligned_data = shape_data;


	% Less iterations should be enough, but better safe than sorry, efficiency
	% is not an issue here
	for it=1:100
		for i=1:ns
			% Align each shape to the mean
			[ D Y ] = procrustes(mean_shape, aligned_data(:,:,i));
			aligned_data(:,:,i) = Y;
		end

		% New mean shape, store in a different variable so we can compare it to
		% the old one
		new_mean_shape = mean(aligned_data, 3);
		[ D Y ] = procrustes(reference_shape, new_mean_shape);
		new_mean_shape = Y;

		mean_shape = new_mean_shape;
	end

	mean_shape = mean(aligned_data, 3);

	% Determine the region of interest
	mini = min(mean_shape(:,1));
	minj = min(mean_shape(:,2));
	maxi = max(mean_shape(:,1));
	maxj = max(mean_shape(:,2));

	% Place the origin in the upper left corner of the rectangle
	% representing the bounding box of the mean shape. Add a 1
	% pixel offset to avoid artifacts in gradient computations.
	mean_shape = mean_shape - repmat([mini - 2, minj - 2], [np, 1]);

	disp 'Width of model:'
	% Determine width and height of the model, add 1 pixel offset
	% to avoid gradient artifacts
	modelw = ceil(maxj - minj + 3)
	disp 'Height of model:'
	modelh = ceil(maxi - mini + 3)

	disp 'Time required for shape data alignment:'

	toc

	%%
	%% DEBUG STUFF
	%%
%	for i=1:ns
%		plot(aligned_data(:,2,i), aligned_data(:,1,i), 'o');
%		hold on;
%		pause;
%	end
%	plot(mean_shape(:,2), mean_shape(:,1), 'rx');
%	hold off;
%	return;

	%%
	%% END OF DEBUG STUFF
	%%

	tic

	% Definitive mean shape for AAM, stored on a column vector [i1 i2 i3 ... j1 j2 j3 ...]'
	AAM.s0 = reshape(mean_shape, 2*np, 1);

	% Prepare shape data for PCA
	shape_matrix = reshape(aligned_data, [2*np ns]) - repmat(AAM.s0, [1 ns]);
	clear aligned_data;

	% Get modes covering 98% of variation
	[pc eiv] = var_pca(shape_matrix, 0.98);
	clear shape_matrix;

	disp 'Number of Shape Modes:'
	size(pc, 2)

	AAM.shape_eiv = eiv;

	% Build the basis for the global shape transform, we do it here because
	% they are used to orthonormalize the shape principal vectors
	% It is done differently to the paper as we're using a different coordinate
	% frame. Here u -> i, v -> j
	s1_star = AAM.s0;
	s2_star(1:np) = -AAM.s0(np+1:end);
	s2_star(np+1:2*np) = AAM.s0(1:np);
	s3_star(1:np) = ones(np,1);
	s3_star(np+1:2*np) = zeros(np,1);
	s4_star(1:np) = zeros(np,1);
	s4_star(np+1:2*np) = ones(np,1);

	% Stack the basis we found before with the shape basis so
	% we can orthonormalize
	s_star_pc(:,1) = s1_star;
	s_star_pc(:,2) = s2_star;
	s_star_pc(:,3) = s3_star;
	s_star_pc(:,4) = s4_star;

	s_star_pc(:,5:size(pc,2)+4) = pc;


	% Orthogonalize the basis (should already be close to orthogonal)
	s_star_pc = gs_orthonorm(s_star_pc);

	% Basis for the global shape transform
	AAM.s_star = s_star_pc(:,1:4);
	% Basis for the shape model
	AAM.s = s_star_pc(:,5:end);

	disp 'Time required for building shape model:'
	toc

	%%
	%% DEBUG STUFF
	%%

%	disp 'Plotting principal vectors as deformation directions of the mean...'
%
%	plot_s0 = reshape(AAM.s0, [np 2]);
%
%	for i=1:size(AAM.s, 2)
%		hold off;
%		plot(plot_s0(:,2), plot_s0(:,1), 'o');
%		hold on;
%
%		fprintf('Principal vector %d\n.', i);
%
%		delta_s = reshape(AAM.s(:,i), [np 2]);
%		plot_s = plot_s0 + delta_s * 16;
%
%		for j=1:5
%			plot(plot_s(:,2), plot_s(:,1), 'r.');
%			plot_s = plot_s + delta_s * 16;
%		end
%		hold off;
%		disp 'Waiting for keypress...'
%		pause;
%	end
%	return;

	%%
	%% END OF DEBUG STUFF
	%%

	tic

	% Check if a triangulation was already provided
	if size(shape_triangles, 1) == 0
		% Triangle mesh used for warping. We determine it on the base shape.
		% Returned result is double, convert to unsigned integer.
		shape_triangles = delaunay(AAM.s0(np+1:2*np)', AAM.s0(1:np)');
		%triplot(shape_triangles, AAM.s0(1:np)', AAM.s0(np+1:2*np)');
	end

	% Bitmap mapping pixels to the triangle they belong to (the triangle used
	% for warping)
	warp_map = zeros(modelh, modelw, 'uint32');

	% Bitmap containing the first barycentric coordinate of each pixel wrt to the
	% triangle specified by warp_map
	alpha_coords = zeros(modelh, modelw);

	% Bitmap containing the second barycentric coordinate of each pixel wrt to the
	% triangle specified by warp_map
	beta_coords = zeros(modelh, modelw);

	% For each pixel, find the triangle it belongs to
	for j=1:modelw
		for i=1:modelh
			% For each triangle
			for k=1:size(shape_triangles, 1)
				t = shape_triangles(k,:);

				% Vertices of the triangle in the mean shape
				i1 = AAM.s0(t(1));
				j1 = AAM.s0(np + t(1));
				i2 = AAM.s0(t(2));
				j2 = AAM.s0(np + t(2));
				i3 = AAM.s0(t(3));
				j3 = AAM.s0(np + t(3));

				% Compute the two barjcentric coordinates
				den = (i2 - i1) * (j3 - j1) - (j2 - j1) * (i3 - i1);
				alpha = ((i - i1) * (j3 - j1) - (j - j1) * (i3 - i1)) / den;
				beta = ((j - j1) * (i2 - i1) - (i - i1) * (j2 - j1)) / den;

				if alpha >= 0 && beta >= 0 && (alpha + beta) <= 1
					% Found the triangle, save data to the bitmaps and break
					warp_map(i,j) = k;
					alpha_coords(i,j) = alpha;
					beta_coords(i,j) = beta;
					break;
				end
			end
		end
	end

	% Build adjacency list
	AAM.adj_list = cell(np, 1);

	for i=1:size(shape_triangles, 1)
		for j=1:3
			v = shape_triangles(i,j);
			AAM.adj_list{v} = [AAM.adj_list{v} i];
		end
	end

	% IMPORTANT: If the datatype is changed from 'uint32', the mex-file will
	% need to be changed!
	AAM.warp_map = uint32(warp_map);
	AAM.shape_mesh = uint32(shape_triangles);
	AAM.alpha_coords = alpha_coords;
	AAM.beta_coords = beta_coords;

	disp 'Time required for warp pre-computations:'
	toc

	%%
	%% DEBUG STUFF
	%%
%	color_map = rand(max(max(warp_map)), 3);
%	figure(1)
%	imshow(warp_map, color_map);
%
%	figure(2)
%	imshow(alpha_coords);
%
%	figure(3)
%	imshow(beta_coords);
%
%	return;

	%%
	%% END OF DEBUG STUFF
	%%

	tic

	% FIXME: This is somewhat of an hack, but the code is so slow when matrices grow inside loops...
	app = double(imread(sprintf('%s/%s', directory, landmark_files(1).name(1:end-4)))) / 255;
	app_matrix = zeros(modelw*modelh*size(app,3), ns);

	disp 'Color components:'
	nc = size(app, 3)

	for i=1:ns
		% Prepare appearance data
		app = double(imread(sprintf('%s/%s', directory, landmark_files(i).name(1:end-4)))) / 255;
		%app = convn(convn(app, exp(-(-5:5).^2)./sum(exp(-(-5:5).^2)), 'same'), exp(-(-5:5).^2)./sum(exp(-(-5:5).^2))', 'same');

		app_matrix(:,i) = reshape(pa_warp(AAM, shape_data(:,:,i), app), [(modelw*modelh*nc) 1]);
	end

	disp 'Time required for warping all input appearances:'
	toc

	clear app;
	clear landmark_files;

	%%
	%% DEBUG STUFF
	%%

%disp 'Displaying warped images...'
%
%for i=1:ns
%	fprintf('Image %d\n.', i);
%
%	imshow(reshape(app_matrix(:,i), [modelh modelw nc]));
%
%	hold on;
%
%	triplot(shape_triangles, AAM.s0(np+1:2*np)', AAM.s0(1:np)');
%	hold off;
%
%	disp 'Waiting for keypress...'
%	pause;
%end
%hold off;
%return;

	%%
	%% END OF DEBUG STUFF
	%%


	tic

	% FIXME: Should we normalize pixel values like done by Stegmann to
	% improve the generalization of the model?

	% Mean appearance as a column vector, sorted firstly by color
	% component, then j coordinate and finally i coordinate
	%Example:
	%       X1 = [ 1 2; 3 4];
	%       X2 = [ 5 6; 7 8];
	%       X3 = [ 9 10; 11 12];
	%       X(:,:,1)=X1;
	%       X(:,:,2)=X2;
	%       X(:,:,3)=X3;
	%       reshape(X,[],1) =>
	%          _________
	%        1  j==1
	%        3 _____   C1
	%        2  j==2
	%        4 _________
	%        5  j==1
	%        7 _____   C2
	%        6  j==2
	%        8 _________
	%        9  j==1
	%       11 _____   C3
	%       10  j==2
	%       12 _________

	AAM.A0 = mean(app_matrix, 2);
	mean_app = reshape(AAM.A0, [modelh modelw nc]);

	%app_size = modelw * modelh * nc;

	% Prepare apperances for PCA
	app_matrix = app_matrix - repmat(AAM.A0, [1 ns]);

	% FIXME: Goes out of memory without 'econ' flag, look at "An Introduction to Active
	% Shape Models" by Cootes for an optimized PCA
	%[pc eiv] = var_pca(app_matrix, 0.95);
  [pc eiv] = app_pca(app_matrix, 0.95);

	clear app_matrix;

	disp 'Number of Appearance Modes:'
	size(pc, 2)

	AAM.A = pc;
	AAM.app_eiv = eiv;

	disp 'Time required for building apperance model:'
	toc

	%%
	%% DEBUG STUFF
	%%

%  disp 'Displaying results of PCA on appearances...'
%
%	for i=1:size(AAM.A,2)
%   cur_app = reshape(AAM.A(:,i), [modelh modelw nc]);
%
%		fprintf('Showing mean appearance and sums of mean and principal component %d with increasing weight\n.', i);
%
%		subplot(1,3,1), imshow(mean_app)
%		subplot(1,3,2), imshow(mean_app + cur_app*sqrt(eiv(i))*3)
%		subplot(1,3,3), imshow(mean_app - cur_app*sqrt(eiv(i))*3)
%		%subplot(1,4,4), imshow(mean_app + cur_app*sqrt(eiv(i))*3)
%
%		disp 'Waiting for keypress...'
%		pause;
%	end
%	hold off;
%	return;
	%%
	%% END OF DEBUG STUFF
	%%

	tic

	% Now we get into the interesting (and tricky) stuff

	for i=1:nc
		% For each color, estimate the gradient of the mean appearance.
		% dcol is the estimated derivative wrt to columns (which for us is the
		% j coordinate), drow is wrt to rows (which for us is the i coordinate)
		[di dj] = gradient_2d(mean_app(:,:,i), AAM.warp_map);
		mean_app_gradient(:,:,i,1) = di;
		mean_app_gradient(:,:,i,2) = dj;
	end

	AAM.dA0 = mean_app_gradient;

	%%
	%% DEBUG STUFF
	%%
%	figure(1)
%imshow(mean_app);
%	mn = min(min(min(min(AAM.dA0))));
%	mx = max(max(max(max(AAM.dA0))));
%
%	plot_dA0 = (AAM.dA0 - repmat(mn, [modelh modelw nc 2])) / (mx - mn);
%	figure(2)
%	imshow(plot_dA0(:,:,:,1));
%	figure(3);
%	imshow(plot_dA0(:,:,:,2));
%	return;
	%%
	%% END OF DEBUG STUFF
	%%

	disp 'Time required for calculating image gradient:'
	toc

	tic

	dW_dp = zeros(modelh, modelw, 2, size(AAM.s,2));
	dN_dq = zeros(modelh, modelw, 2, 4);

	for j=1:modelw
		for i=1:modelh
			if warp_map(i,j) ~= 0
				% Only the vertices of the triangle containing the pixel are of relevance
				% in determining the Jacobian.
				t = shape_triangles(warp_map(i,j),:);

				% FIXME: this is not how it should be done, there is a way to juggle
				% with the barycentric coordinates we already computed to do the same
				for k=1:3
					% Derivative of vertex 'k' wrt to the shape parameters
					dik_dp = AAM.s(t(k),:);
					djk_dp = AAM.s(t(k)+np,:);

					% Derivative of vertex 'k' wrt to the global transformation parameters
					dik_dq = AAM.s_star(t(k),:);
					djk_dq = AAM.s_star(t(k)+np,:);

					% Now we need the barycentric coordinates of (i,j) computed using
					% point 'k' as the origin. So we rearrange the order of the vertices
					% (it doesn't matter if the result has clockwise or counterclockwise
					% winding)
					t2 = t;
					t2(1) = t(k);
					t2(k) = t(1);

						% Vertices of the triangle in the mean shape
					i1 = AAM.s0(t2(1));
					j1 = AAM.s0(np + t2(1));
					i2 = AAM.s0(t2(2));
					j2 = AAM.s0(np + t2(2));
					i3 = AAM.s0(t2(3));
					j3 = AAM.s0(np + t2(3));

					% Compute the two barycentric coordinates
					den = (i2 - i1) * (j3 - j1) - (j2 - j1) * (i3 - i1);
					alpha = ((i - i1) * (j3 - j1) - (j - j1) * (i3 - i1)) / den;
					beta = ((j - j1) * (i2 - i1) - (i - i1) * (j2 - j1)) / den;


					% Nonzero portion of the Jacobian of the warp wrt to the vertex 'k'.
					% TODO: Isn't this the third barycentric coordinate? It should be
					% easier and faster to compute it directly.
					dW_dij = 1 - alpha - beta;

					% This is how it's formulated on the paper (dW_dq is similar):
					% dW_dp = dW_dp + [dW_dij; 0] * dik_dp + [0; dW_dij] * djk_dp;
					% MATLAB does weird things with dimensions here, so we need squeeze()
					% to make sure the submatrix is actually a 2xn matrix and not a
					% 1x1x2xn
					dW_dp(i,j,:,:) = squeeze(dW_dp(i,j,:,:)) + dW_dij * [dik_dp; djk_dp];
					dN_dq(i,j,:,:) = squeeze(dN_dq(i,j,:,:)) + dW_dij * [dik_dq; djk_dq];
				end
			end
		end
	end

	disp 'Time required for calculating warp Jacobians:'
	toc

	%%
	%% DEBUG STUFF
	%%
%  disp 'Displaying the warp Jacobian...'
%
%	for i=1:size(dW_dp,4)
%	  jacobian_i = dW_dp(:,:,1,i);
%	  jacobian_j = dW_dp(:,:,2,i);
%
%
%		fprintf('Showing warp jacobian i and j components for parameter %d\n.', i);
%
%		subplot(1,2,1), imshow(jacobian_i)
%		subplot(1,2,2), imshow(jacobian_j)
%
%		disp 'Waiting for keypress...'
%		pause;
%	end
%	return;
	%%
	%% END OF DEBUG STUFF
	%%

	tic

	app_modes = reshape(AAM.A, [modelh modelw nc size(AAM.A, 2)]);

	SD = zeros(modelh, modelw, nc, 4 + size(dW_dp, 4));

	% Compute steepest descent images for the 4 global transformation parameters
	% TODO: the loops over c are probably optimizable, but the number of dimensions involved
	% are starting to hurt my head...
	% TODO: test me
	for i=1:4
		prj_diff = zeros(nc, size(AAM.A, 2));
		for j=1:size(AAM.A, 2)
			for c=1:nc
				prj_diff(c,j) = sum(sum(app_modes(:,:,c,j) .* (AAM.dA0(:,:,c,1) .* dN_dq(:,:,1,i) + AAM.dA0(:,:,c,2) .* dN_dq(:,:,2,i))));
			end
		end

		for c=1:nc
			SD(:,:,c,i) = AAM.dA0(:,:,c,1) .* dN_dq(:,:,1,i) + AAM.dA0(:,:,c,2) .* dN_dq(:,:,2,i);
		end

		for j=1:size(AAM.A, 2)
			for c=1:nc
				SD(:,:,c,i) = SD(:,:,c,i) - prj_diff(c,j) * app_modes(:,:,c,j);
			end
		end
	end

	% Compute steepest descent images for the shape parameters
	% TODO: the loops over c are probably optimizable, but the number of dimensions involved
	% are starting to hurt my head...
	% TODO: test me
	for i=1:size(dW_dp, 4)
		prj_diff = zeros(nc, size(AAM.A, 2));
		for j=1:size(AAM.A, 2)
			for c=1:nc
				prj_diff(c,j) = sum(sum(app_modes(:,:,c,j) .* (AAM.dA0(:,:,c,1) .* dW_dp(:,:,1,i) + AAM.dA0(:,:,c,2) .* dW_dp(:,:,2,i))));
			end
		end

		for c=1:nc
			SD(:,:,c,i+4) = AAM.dA0(:,:,c,1) .* dW_dp(:,:,1,i) + AAM.dA0(:,:,c,2) .* dW_dp(:,:,2,i);
		end

		for j=1:size(AAM.A, 2)
			for c=1:nc
				SD(:,:,c,i+4) = SD(:,:,c,i+4) - prj_diff(c,j) * app_modes(:,:,c,j);
			end
		end
	end

	AAM.SD = zeros(size(SD, 4), size(AAM.A,1));

	% FIXME: A posteriori optimization fix, integrate it more nicely with the code.
	for i=1:size(SD, 4)
		AAM.SD(i,:) = reshape(SD(:,:,:,i), 1, []);
	end

	%%
	%% DEBUG STUFF
	%%
%	mn = min(min(min(min(SD))));
%	mx = max(max(max(max(SD))));
%	SD = (SD - repmat(mn, [modelh modelw nc size(SD, 4)])) / (mx - mn);
%	for i=1:size(SD,4)
%		h=figure(i+1);
%		imshow(SD(:,:,:,i));
%	end
	%%
	%% END OF DEBUG STUFF
	%%

	clear SD;

	disp 'Time required for calculating steepest descent images:'
	toc

	tic

	% Compute the Hessian, still not sure if this is the right
	% way to treat the color information (using greyscale images
	% give pretty much the same matching results so it should be ok)
	AAM.H = AAM.SD * AAM.SD';

	AAM.invH = inv(AAM.H);

	AAM.R = AAM.invH * AAM.SD;

	disp 'Time required for determining and inverting Jacobian and calculating invH*SD:'
	toc
