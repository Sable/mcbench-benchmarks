function warped_app = pa_warp(AAM, src_shape, image_data, dst_shape)
% warped_app = pa_warp(AAM, src_shape, image_data, [dst_shape])                                                             
%                                                                                                                           
% %%% C++ MEX-file. The first time this script is run, it will try to compile the MEX-file. %%%
% 
% Warps the portion of image_data delimited by src_shape to                                                                 
% dst_shape (which by default is is the mean shape) using a piecewise affine warp.                                          
%                                                                                                                           
%                         PARAMETERS                                                                                        
%                                                                                                                           
% AAM Active Appearance Models structure returned by build_model_2d                                                         
%                                                                                                                           
% src_shape A Nx2 matrix containing N landmarks over image_data,                                                            
%            in image coordinates: [i j]. Can be single or double                                                           
%            precision float.                                                                                               
%                                                                                                                           
% image_data A HxWxC image matrix, with pixels arranged such                                                                
%            that app_data(i,j,c) actually returns the pixel value                                                          
%            associated with position (i,j). Must be in the same floating point                                             
%            format as src_shape.                                                                                           
%                                                                                                                           
%	dst_shape (Optional) A Nx2 matrix containing N landmarks over image_data,                                                 
%            in image coordinates: [i j]. If omitted, it                                                                    
% 					 is assumed to be the base shape (AAM.s0), and an optimized method                                               
%            will be used. Must be in the same floating point                                                               
%            format as src_shape.                                                                                           
%                                                                                                                           
%                                                                                                                           
%                        RETURN VALUE                                                                                       
%                                                                                                                           
% warped_app The warped appearance, may be nonzero only over the region                                                     
%            delimited by the destination shape. It is stored in the same format                                            
%            as src_shape.                                                                                                  
%                                                                                                                           
%                          THROWS                                                                                           
%                                                                                                                           
% Attempts to throw a MATLAB exception if the warp is not possible because of incorrect data types                          
% or shapes lying outside the image (even if partially).                                                                    
%                                                                                                                           
%                        LIMITATIONS                                                                                        
%                                                                                                                           
% For efficiency purposes, not all possible errors are checked, and failure in using the correct datatypes or using         
% incompatible training data will most likely cause a MATLAB crash.                                                         
%                                                                                                                           
% Author: Luca Vezzaro (elvezzaro@gmail.com)                                                                                
	
	opt1 = '-O';
	opt2 = '-DHAVE_MWSIZE';
	opt3 = '-DHAVE_MEXCEPTION';
	
  [major minor] = matlab_version();
    
	% mwSize datatype was introduced in version 7.3
	if ~matlab_version_at_least(7, 3)
		opt2 = '-DDONT_HAVE_MWSIZE';
	end
	
	% Exceptions were introduced in version 7.5
	if ~matlab_version_at_least(7, 5)
		opt3 = '-DDONT_HAVE_MEXCEPTION';
	end

	fprintf('Launching:\n\nmex pa_warp.cpp %s %s %s\n', opt1, opt2, opt3);
	mex('pa_warp.cpp', opt1, opt2, opt3);
	