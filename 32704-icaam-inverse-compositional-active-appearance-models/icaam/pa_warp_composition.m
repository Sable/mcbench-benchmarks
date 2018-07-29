function comp_warp = pa_warp_composition(AAM, shape, increment)
% comp_warp = pa_warp_composition(AAM, shape, increment)
%
% Composition of two piecewiese affine warps, as described in 
% 'Active Appearance Models Revisited' paper by Iain Matthews and 
% Simon Baker.
% 
%                         PARAMETERS
%
% AAM Active Appearance Models structure returned by build_model_2d
%
% shape Used as the starting point for the composition: N(W(s0,p),q)
%       It is A Nx2 matrix containing 2D points stored on 
%       rows, in image coordinates: [i j]
%
% increment It has the same format as shape, and is the result of applying
%           incremental shape and global transformation parameters to the
%           base shape: N(W(s0,-dp),-dq). See the paper for details.
%        
%
%                        RETURN VALUE
%
% comp_warp Result of the composition, in the same format as shape and increment.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

	% The method used is apparently different from the one proposed in the paper,
	% but the results are very similar. 
	% While the paper describes the composition procedure as a per-vertex procedure,
	% averaging results for each triangle sharing a given vertex, this implementation
	% works on a per-triangle basis, accumulating the composition results and averaging
	% at the end.

	% Number of points in shapes
	np = size(shape, 1);
	
	% nt(i) counts the number of triangles that share vertex i
	% It's used to average the results		
	nt = zeros(np,1);
	comp_warp = zeros(np, 2);
	
	mesh_size = size(AAM.shape_mesh, 1);
		
	% Compose the warp given by current p and q with the incremental warp
	% For each triangle, we evaluate the warp for each vertex
	for i=1:mesh_size
	  % Current triangle
		%t(1) = AAM.shape_mesh(i,1);
		%t(2) = AAM.shape_mesh(i,2);
		%t(3) = AAM.shape_mesh(i,3);
		t = AAM.shape_mesh(i,:);
		
		% Update counters
		nt(t(1)) = nt(t(1)) + 1;
		nt(t(2)) = nt(t(2)) + 1;
		nt(t(3)) = nt(t(3)) + 1;
		
		for k=1:3
			% Now we need the barycentric coordinates of (i,k) + (di,dj) computed using 
			% point 'x_k' as the origin. So we rearrange the order of the vertices.
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
			
	    %Point to be warped
			i_coord = increment(t2(1),1);
			j_coord = increment(t2(1),2);
			
			% Compute the two barycentric coordinates
			den = (i2 - i1) * (j3 - j1) - (j2 - j1) * (i3 - i1);
			alpha = ((i_coord - i1) * (j3 - j1) - (j_coord - j1) * (i3 - i1)) / den;
			beta = ((j_coord - j1) * (i2 - i1) - (i_coord - i1) * (j2 - j1)) / den;
			
			%  % Warp the i and j coordinates and accumulate the results
			%comp_warp(t2(1),1) = comp_warp(t2(1),1) + ...
			%                      alpha * (shape(t2(2),1) - shape(t2(1),1)) + ...
			%                      beta * (shape(t2(3),1) - shape(t2(1),1));
			%                      
			%comp_warp(t2(1),2) = comp_warp(t2(1),2) + ...
			%                      alpha * (shape(t2(2),2) - shape(t2(1),2)) + ...
			%                      beta * (shape(t2(3),2) - shape(t2(1),2));
			%                      
			comp_warp(t2(1),:) = comp_warp(t2(1),:) + ...
			                     alpha * (shape(t2(2),:) - shape(t2(1),:)) + ...
			                     beta * (shape(t2(3),:) - shape(t2(1),:));
		end
	end
	
	%Average the results we accumulated
	comp_warp = shape + comp_warp ./ repmat(nt, 1, 2);
	
	
% ALTERNATIVE METHOD, slower but apparently less prone to diverge
% This is more similar to the method proposed by the paper.
% It works on a per-vertex basis, updating a different vertex at each iteration,
% thus the composition is affected by the order with which the vertex are considered.
%  np = size(shape, 1);         
%	comp_warp = shape;
%	t2 = zeros(1, 3);
%	
%	for k=1:np
%		%figure(1);
%		%hold off;
%		%triplot(AAM.shape_mesh, comp_warp(:,1), comp_warp(:,2), 'b');
%		%hold on;
%		%plot(comp_warp(k,1), comp_warp(k,2), 'yo');
%		
%	
%		comp = [0 0];
%				
%		nt = numel(AAM.adj_list{k});
%		
%		for l=1:nt
%			t = AAM.shape_mesh(AAM.adj_list{k}(l),:);
%			
%			t2(1) = k;
%			if t(2) == k
%				t2(2) = t(3);
%				t2(3) = t(1);
%			elseif t(3) == k	
%				t2(2) = t(1);
%				t2(3) = t(2);
%			else
%				t2(2) = t(2);
%				t2(3) = t(3);
%			end
%						
%			% Vertices of the triangle in the mean shape
%			i1 = AAM.s0(k);
%			j1 = AAM.s0(np + k);
%			i2 = AAM.s0(t2(2));
%			j2 = AAM.s0(np + t2(2));
%			i3 = AAM.s0(t2(3));
%			j3 = AAM.s0(np + t2(3));
%			
%	    % Point to be warped
%			i = increment(k, 1);
%			j = increment(k, 2);
%			
%			
%			% Compute the two barycentric coordinates
%			den = (i2 - i1) * (j3 - j1) - (j2 - j1) * (i3 - i1);
%			alpha = ((i - i1) * (j3 - j1) - (j - j1) * (i3 - i1)) / den;
%			beta = ((j - j1) * (i2 - i1) - (i - i1) * (j2 - j1)) / den;
%			
%			% TODO: not nice to see, but I'd rather have this than other 6 new variables to define
%	    % Warp the i and j coordinates and accumulate the results
%			comp = comp + ...
%			                      alpha * (comp_warp(t2(2),:) - comp_warp(k,:)) + ...
%			                      beta * (comp_warp(t2(3),:) - comp_warp(k,:));
%		end
%
%%		old_comp_warp = comp_warp(k, :);
%		
%		comp_warp(k, :) = comp_warp(k, :) + comp / nt;
%	
%	%plot(comp_warp(k,1), comp_warp(k,2), 'ro');
%	%pause;
%	end