function [ fitted_shape, fitted_app ] = fit_2d(AAM, init_shape, image_data, max_it)
% [ fitted_shape fitted_app ] = fit_2d(AAM, init_shape, image_data, max_it)
%
% Fit an Active Appearance Model to an image, starting from the provided initial shape.
% Based on the 'Active Appearance Models Revisited' paper by Iain Matthews and Simon Baker.
% 
%                         PARAMETERS
%
% AAM Active Appearance Models structure as returned by build_model_2d
%
% init_shape Shape to be used to start the fitting process.
%            It is A Nx2 matrix containing N landmarks over image_data,
%            with image coordinates stored on rows: [i j]
%
% image_data The image to be fitted. 
%            It is A HxWxC floating point image, with pixels arranged such
%            that app_data(i,j,c) actually returns the pixel value
%            associated with position (i,j). Must be in floating point
%            format, ranging between 0 and 1.
%
% max_it Maximum number of iterations to be performed.
%        
%
%                        RETURN VALUES
%
% fitted_shape The shape produced by the fitting process. It has the 
%              same format as init_shape. 
%              Due to the local nature of the optimization process, there is no
%              guarantee of a meaningful result. Hopefully, the closer 
%              the initial guess is, the better the fit. 
%              
%
% fitted_app (Optional) The fitted appearance. It is the best approximation of
%            the appearance that the model can do.
%            It is a MHxMWxC image matrix, where MH = size(AAM.warp_map, 1) and
%            MW = size(AAM.warp_map, 2) and C is the number of colors and
%            is the same as image_data.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

	if isa(image_data, 'float') == 0
		warning 'Image data is not in floating point format, assuming unsigned integer data.'
		image_data = double(image_data) / 255;
	end

	% Number of points in the shape
	np = size(init_shape, 1);
	
	% Number of colors
	nc = size(image_data, 3);
	
	% Size of the model
	modelh = size(AAM.warp_map, 1);
	modelw = size(AAM.warp_map, 2);
	
	% Check that the shape has the right size
	if np ~= (size(AAM.s0, 1) / 2) || nc ~= (size(AAM.A0, 1) / (modelw * modelh))
		msg = strcat('Number of landmarks in init_shape and/or number of ', ...
		             ' colors in image_data are not consistent with the model.');
		error(msg)
	end

	% Initialize current shape
	cur_shape = init_shape;
	
	% Used to estimate convergence, it's the root mean
	% square change on the shapes
	%rms_change = inf;
	
	iter = 1;
	
	%while (rms_change > 1 || iter < 7) && iter <= max_it
	while iter <= max_it
		% Warp the appearance to compute the error image, as a column vector
		%warped_app = reshape(pa_warp(AAM, cur_shape, image_data), [], 1);
		
		% Error image, simply the difference between the image and A0
		error_img = reshape(pa_warp(AAM, cur_shape, image_data), [], 1) - AAM.A0;
		
		% In the first 5 iterations, try to align the shape to the image using only 
		% the affine transform. This will maximize convergence by using smaller error
		% images in determining the incremental shape parameters, giving smaller but
		% more meaningful updates.
		if iter > 5 || max_it < 10
			% Incremental parameter updates which should minimize the error.
			% The first four will be the delta_q and the latter ones are the 
			% delta_p
			delta_qp = AAM.R * error_img;

			% Damping factor, used to scale parameters updates, thus avoiding
			% large updates to parameters associated with less important
			% modes. 
			% FIXME: this improves fitting stability, but at the expense of precision.
			% damping = min(AAM.shape_eiv / AAM.shape_eiv(min(round((iter-6)/4+1),numel(AAM.shape_eiv))), ones(size(AAM.shape_eiv)));
			% damping = AAM.shape_eiv / AAM.shape_eiv(1);
			%
			% Compute the incremental warp using the *negated* incremental 
			% shape parameters and reshape to prepare for the affine transform
			% d_s0 = reshape(AAM.s0 - sum(AAM.s * (damping .* delta_qp(5:end)), 2), np, 2);
			
			d_s0 = reshape(AAM.s0 - sum(AAM.s * delta_qp(5:end), 2), np, 2);
			
			% Compute the incremental affine transformation using the *negated*
			% parameters
			[ A trans ] = to_affine(AAM, -delta_qp(1:4)');
			
			d_s0 = d_s0 * A + repmat(trans, np, 1);    
			
			comp_warp = pa_warp_composition(AAM, cur_shape, d_s0);
		else
			delta_q = AAM.R(1:4,:) * error_img;
		
			% Compute the incremental affine transformation using the *negated*
			% parameters
			[ A trans ] = to_affine(AAM, -delta_q');
			d_s0 = reshape(AAM.s0, np, 2);
			d_s0 = (d_s0 * A + repmat(trans, np, 1)) - d_s0;  
			comp_warp = cur_shape + d_s0;
		end
		
%figure(1);
%hold off;
%imshow(image_data);
%hold on;                                                                                       
%triplot(AAM.shape_mesh, cur_shape(:,2), cur_shape(:,1), 'b');
%triplot(AAM.shape_mesh, comp_warp(:,2), comp_warp(:,1), 'r');
%
%pause;
		
		% Convergence estimate is simply given by relative average vertex rms_change
		%rms_change = sqrt(sum(sum((cur_shape - comp_warp).^2)) / np);
		%pause
		
		iter = iter + 1;
		% Update current shape
		cur_shape = comp_warp;
	end
	
	% Set return value
	fitted_shape = cur_shape;
			
	if nargout > 1
		% Error image, simply the difference between the warped image and A0
		error_img = reshape(pa_warp(AAM, cur_shape, image_data), [], 1) - AAM.A0;
		
		% Project the error image onto the appearance modes and use the resulting parameters
		% to build the reconstructed appearance
		fitted_app = reshape(AAM.A0 + AAM.A * (AAM.A' * error_img), [modelh modelw nc]);
	end
		
	