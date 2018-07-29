function [ A, tr ] = to_affine(AAM, q)
% [ A tr ] = to_affine(AAM, q)
%
% Compute the affine transform which corresponds to the parameters q.
% Based on the 'Active Appearance Models Revisited' paper by Iain Matthews and Simon Baker.
% 
%                         PARAMETERS
%
% AAM Active Appearance Models structure returned by build_model_2d
%
% q Row vector containing the global transform parameters of the warp 
%   N(s;q) to be converted into a standard affine transformation s*A + tr
%
%
%                        RETURN VALUES
%
% [ A tr ] A is a 2x2 matrix and tr is a 1x2 vector, and they represent
%          the affine transformation to be applied to row vectors: 
%          v_new = v*A + t
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)
% Acknowledgements: Simon Baker, for providing implementation details I 
% couldn't find in the paper. 

	np = size(AAM.s0, 1) / 2;

	% Pick a triangle in the mesh
	t = AAM.shape_mesh(1,:);
	
	% Warp each vertex using the global shape transform
	for i=1:3
		% Save also the initial vertices for later use
		base(1,i) = AAM.s0(t(i));
		base(2,i) = AAM.s0(np+t(i));
	
		warped(1,i) = base(1,i) + AAM.s_star(t(i), :) * q';
		warped(2,i) = base(2,i) + AAM.s_star(np+t(i), :) * q';
	end
	
	% The following is not explained in detail in the paper. Basically, starting from the definition
	% of the barycentric coordinates and of the warp, we find the linear relationships between
	% the warped coordinates and the original ones:
	% w(i,j) = [ a1 + a2 * i + a3 * j; a4 + a5 * i + a6 * j ];
	% To obtain that it's just a matter of expanding the value of alpha and beta in the warp
	% definition and reorganize the result
		
	% This is the denominator used in computing the barycentric coordinates,
	% it is the same as in the paper
	den = (base(1,2) - base(1,1)) * (base(2,3) - base(2,1)) - (base(2,2) - base(2,1)) * (base(1,3) - base(1,1));
	
	% These are not barycentric coordinates, but are used similarly
	alpha = (-base(1,1) * (base(2,3) - base(2,1)) + base(2,1) * (base(1,3) - base(1,1))) / den;
	beta  = (-base(2,1) * (base(1,2) - base(1,1)) + base(1,1) * (base(2,2) - base(2,1))) / den;
	
	% We start with the translation component
	a1 = warped(1,1) + (warped(1,2) - warped(1,1)) * alpha + (warped(1,3) - warped(1,1)) * beta;
	a4 = warped(2,1) + (warped(2,2) - warped(2,1)) * alpha + (warped(2,3) - warped(2,1)) * beta;
	
	alpha = (base(2,3) - base(2,1)) / den;
	beta  = (base(2,1) - base(2,2)) / den;
	
	% Relationships between original x coordinate and warped x and y coordinates
	a2 = (warped(1,2) - warped(1,1)) * alpha + (warped(1,3) - warped(1,1)) * beta;
	a5 = (warped(2,2) - warped(2,1)) * alpha + (warped(2,3) - warped(2,1)) * beta;
	
	alpha = (base(1,2) - base(1,1)) / den;
	beta  = (base(1,1) - base(1,3)) / den;
	
	% Relationships between original y coordinate and warped x and y coordinates
	a3 = (warped(1,3) - warped(1,1)) * alpha + (warped(1,2) - warped(1,1)) * beta;
	a6 = (warped(2,3) - warped(2,1)) * alpha + (warped(2,2) - warped(2,1)) * beta;
	
	% Store in matrix form
	% To be used in this way: 
	% shape * A + tr ==> N(shape, q)
	tr = [a1 a4];
	A = [a2 a5; a3 a6];