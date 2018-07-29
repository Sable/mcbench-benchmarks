function [ fitted_shape, fitted_shape3, P, O, fitted_app] = fit_3d(AAM, init_shape, image_data, mean3, base3, max_it)
% [ fitted_shape fitted_shape3 P O fitted_app ] = fit_3d(AAM, init_shape, image_data, base3, max_it)   
% 
% Fit an Active Appearance Model to an image combining 2D and 3D information to
% recover both 2D and 3D shapes. Based on the paper:
% "2D vs. 3D Deformable Face Models: Representational Power, Construction, 
% and Real-Time Fitting" by Iain Matthews, Jing Xiao, and Simon Baker.
% 
%                         PARAMETERS
%
% AAM Active Appearance Models structure returned by build_model_2d
%
% init_shape 2D shape to be used to start the fitting process.
%            It is A Nx2 matrix containing N landmarks over image_data,
%            in image coordinates: [i j]
%
% image_data The image to be fitted. 
%            It is A HxWxC floating point image, with pixels arranged such
%            that app_data(i,j,c) actually returns the pixel value
%            associated with position (i,j). Must be in floating point
%            format, ranging between 0 and 1.
%
% base3 Matrix of 3D base shapes as returned by sm_recovery. Its size is Nx3xB where
%       B is the number of basis shapes.
%
% max_it Maximum number of iterations to be performed.
%
%
%                        RETURN VALUES
%
% fitted_shape The 2D shape produced by the fitting process. It has the 
%              same format as init_shape. 
%              Due to the local nature of the optimization process, there is no
%              guarantee of a meaningful result. Hopefully, the closer 
%              the initial guess is, the better the fit. 
%              
%
% fitted_shape3 The 3D shape produced by the fitting process. 
%               Due to the local nature of the optimization process, there is no
%               guarantee of a correct result. 
%
% P (Optional) Projection matrix associated with fitted_shape3, such that
%   fitted_shape3 * P' + repmat(O, [np 1]) is as close as possible to 
%   fitted_shape.
%
% O (Optional) Translation component of the projection, such that
%   fitted_shape3 * P' + repmat(O, [np 1]) is as close as possible to 
%   fitted_shape.
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
	
	% Number of 2D shape basis
	nsm = size(AAM.s, 2);
	
	% Number of 3D shape basis
	nsm3 = size(base3, 3);
	
	%%
	% Some preallocations and precomputations
	%%
	
	dp = zeros(nsm, 1);
	dq = zeros(1, 4);
	
	raw_base3 = reshape(base3, np*3, []);
	mean_shape = reshape(AAM.s0, np, 2);	
		
	% Incremental rotation matrices used to estimate
	% derivatives on the projection matrix
	Rx = [0 0 0; 0 0 1; 0 -1 0];
	Ry = [0 0 -1; 0 0 0; 1 0 0];
	Rz = [0 1 0; -1 0 0; 0 0 0];
	
	% Matrix of partial derivatives
	SD_F = zeros(np, 2, 4+nsm+nsm3+6);
	
	offset = 4+nsm+nsm3+4;
	
	% Parial derivatives wrt to the 2D translation components of the projection,
	% never change
	SD_F(:,:,offset+1) = [ ones(np, 1) zeros(np, 1)];
	SD_F(:,:,offset+2) = [ zeros(np, 1) ones(np, 1)];
	
	% Initial hessian
	H3_init = zeros(size(SD_F, 3));
	H3_init(1:size(AAM.H, 1), 1:size(AAM.H, 2)) = AAM.H;
	
	% Use the mean shape as initialization for the 3D shape,
	% and use procrustes analysys to estimate the initial projection
	% matrix	
	[D Z M] = procrustes([cur_shape zeros(np,1)], mean3);
				
	cur_shape3 = mean3;
	cur_trans = M.c(1,1:2);
	cur_scale = M.b;
	
	cur_P = M.T(:,1:2)';
	cur_P = cur_P * M.b;
	
	%while rms_change > 0.8 && iter <= max_it
	while iter <= max_it

		% Warp the appearance to compute the error image, as a column vector
		warped_app = reshape(pa_warp(AAM, cur_shape, image_data), [], 1);
		
		% Error image, simply the difference between the image and A0
		error_img = warped_app - AAM.A0;
		
		if iter > 10
			% Estimate (dFti * Jp) / dq
			for j=1:4
				% Set increment on the j-th q parameter to 1
				dq(j) = 1;
				
				% Affine transformation corresponding to -dq
				[ A trans ] = to_affine(AAM, -dq);
				
				% Result of applying the affine transformation on the current shape
				%ds = cur_shape * A + repmat(trans, np, 1); 
				ds = mean_shape * A + repmat(trans, np, 1); 
				
				% Incremental difference between current shape and result of warp
				d_shape = cur_shape - pa_warp_composition(AAM, cur_shape, ds);
				
				% Store j-th jacobian	component	
				SD_F(:,:,j) = d_shape;		
					
				dq(j) = 0;
			end
			
			% Estimate (dFti * Jp) / dp
	
			for j=1:nsm
				% Set increment on the j-th p parameter to 1
				dp(j) = 1;
				
				% Warp resulting from dp parameters
				ds = reshape(AAM.s0 - AAM.s * dp, np, 2);
				
				% Incremental difference between current shape and result of warp
				d_shape = cur_shape - pa_warp_composition(AAM, cur_shape, ds);
				
				% Store 4+j-th jacobian	component	
				SD_F(:,:,4+j) = d_shape;
				
				dp(j) = 0;
			end
			
			offset = 4 + nsm;
		
			% Partial derivatives wrt to 3d shape parameters
			for j=1:nsm3
				SD_F(:,:,offset+j) =  base3(:,:,j) * cur_P';
			end
		
			offset = offset + nsm3;
			
			% Derivatives wrt scale
			SD_F(:,:,offset+1) = cur_shape3 * (cur_P' / cur_scale);
			
			% Derivatives wrt cur_P's x rotation
			SD_F(:,:,offset+2) = cur_shape3 * (Rx * cur_P');
			                                
			% Derivatives wrt cur_P's y rotation
			SD_F(:,:,offset+3) = cur_shape3 * (Ry * cur_P');
			
			% Derivatives wrt cur_P's z rotation
			SD_F(:,:,offset+4) = cur_shape3 * (Rz * cur_P');
			
			% Old projected shape, used to estimate convergence                
			old_shape3_prj = cur_shape3 * cur_P' + repmat(cur_trans, np, 1);
			   
			% Difference between the current 2D shape and projected current 3D shape
			prj_diff = old_shape3_prj - cur_shape;
		
			H3 = H3_init;
	
			% TODO: optimize, if possible (keep in mind that the last 2
			% components of SD_F(i,w,:) are constant)
			for i=1:np
				% Partial derivatives for i-th x coordinate
				SD_Fti = squeeze(SD_F(i,1,:));
				H3 = H3 + SD_Fti * SD_Fti';        
							
				% Partial derivatives for i-th y coordinate
				SD_Fti = squeeze(SD_F(i,2,:));
				H3 = H3 + SD_Fti * SD_Fti';
			end
			
			% TODO: optimize, if possible
			% Steepest descent parameter updates for 3D component
			K3 = squeeze(sum(sum(SD_F .* repmat(prj_diff, [1 1 size(SD_F, 3)]), 1), 2));
			
			% Compute the steepest descent parameter updates for the
			% 2D component
			% Since the steepest descent images are stored as 
			% rows in AAM.SD this is fast and clean.
			K3(1:4+nsm) = K3(1:4+nsm) + AAM.SD * error_img;
					
			% Incremental parameter updates which should minimize the error.
			delta_params = -inv(H3) * K3;
			
			offset = 4 + nsm;
		
			% Update of 3D shape is simpy additive
			cur_shape3 = cur_shape3 + reshape(raw_base3 * delta_params(offset+1:offset+nsm3), np, 3);
			
			offset = offset + nsm3;
			
			% Update of scale, additive
			cur_scale = cur_scale + delta_params(offset + 1);
								
			% Incremental angles
			delta_rx = delta_params(offset + 2);
			delta_ry = delta_params(offset + 3);
			delta_rz = delta_params(offset + 4);
			
			% Apply (hopefully) small rotation
			cur_P = cur_P * [1 -delta_rz  delta_ry; delta_rz 1 -delta_rx; -delta_ry delta_rx 1];
			
			% Orthonormalize and rescale
			cur_P = cur_scale * gs_orthonorm(cur_P')';
			
			% Update translation
			cur_trans(1) = cur_trans(1) + delta_params(offset + 5);
			cur_trans(2) = cur_trans(2) + delta_params(offset + 6);
			
			% Do not update 2D shape, as the 3D term will most likely steer it
			% away from the correct solution
			comp_warp = cur_shape;
		elseif iter > 5
			delta_qp = AAM.R * error_img;
			d_s0 = reshape(AAM.s0 - sum(AAM.s * delta_qp(5:end), 2), np, 2);
						
			% Compute the incremental affine transformation using the *negated*
			% parameters
			[ A trans ] = to_affine(AAM, -delta_qp(1:4)');
			
			d_s0 = d_s0 * A + repmat(trans, np, 1);    
			
			comp_warp = pa_warp_composition(AAM, cur_shape, d_s0);
			%old_shape3_prj =    cur_shape3 * cur_P' + repmat(cur_trans, np, 1);
		else
			delta_q = AAM.R(1:4,:) * error_img;
		
			% Compute the incremental affine transformation using the *negated*
			% parameters
			[ A trans ] = to_affine(AAM, -delta_q');
			d_s0 = reshape(AAM.s0, np, 2);
			d_s0 = (d_s0 * A + repmat(trans, np, 1)) - d_s0;  
			
			comp_warp = cur_shape + d_s0;
			%old_shape3_prj = cur_shape3 * cur_P' + repmat(cur_trans, np, 1);
		end
		
		%shape3_prj = cur_shape3 * cur_P' + repmat(cur_trans, np, 1);	

		% TODO: this is crap, use a better error metric
		%rms_change = sqrt(sum(sum((cur_shape - comp_warp).^2)) / np) + sqrt(sum(sum((old_shape3_prj - shape3_prj).^2)) / np)
				
		iter = iter + 1;
		% Update current shape
		cur_shape = comp_warp;
		
	end
		
	
	% Set return value
	fitted_shape = cur_shape;
	fitted_shape3 = cur_shape3;
	
	if nargout > 2
		P = cur_P;
		
		if nargout > 3
			O = cur_trans;
					
			if nargout > 4
				% Error image, simply the difference between the warped image and A0
				error_img = reshape(pa_warp(AAM, cur_shape, image_data), [], 1) - AAM.A0;
				
				% Project the error image onto the appearance modes and use the resulting parameters
				% to build the reconstructed appearance
				fitted_app = reshape(AAM.A0 + AAM.A * (AAM.A' * error_img), [modelw modelh nc]);
			end
		end
	end
	
	
	