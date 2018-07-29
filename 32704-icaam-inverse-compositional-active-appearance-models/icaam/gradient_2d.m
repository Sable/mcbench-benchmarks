function [di, dj] = gradient_2d(M, mask)
% [di dj] = gradient_2d(M)
% [di dj] = gradient_2d(M, mask)
%
% Approximate the gradient of a two-dimensional function represented by M(i,j), using
% a 3x3 plane fitting algorithm.
% 
%                         PARAMETERS
%
% M Matrix of function values, M(i,j) = f(i,j), the spacing is assumed to be uniform.
%
% mask (Optional) Matrix of the same size of M, with zero values in positions of M to be ignored by the 
%                 gradient computations.
%
%                        RETURN VALUES
%
% di First component of the gradient: di(i,j) is the approximated [d/di f](i,j)
%
% dj Second component of the gradient: dj(i,j) is the approximated [d/dj f](i,j)
%
%                        LIMITATIONS
%
% To avoid ill-conditioned solutions, the mask is ignored near the "edges" of M,
% so this may result in artifacts in some cases. Leaving a "safety" border
% on the edges should be more than enough to prevent the issue.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

	nr = size(M, 1);
	nc = size(M, 2);
	
	if nargin < 2
		mask = ones(nr, nc);
	end
	
	v = zeros(3,1);
	
	% The used algorithm is simple: the evaluation point is set
	% as the origin, and a plane is fitted to the 8 nearest positions,
	% centered on the origin. On the boundary, there are less values,
	% but the method is the same.
	
	% First the "corners"
	
	p(1,:) = [1 0]; v(1) = M(2,1) - M(1,1);
	p(2,:) = [0 1]; v(2) = M(1,2) - M(1,1);
	p(3,:) = [1 1]; v(3) = M(2,2) - M(1,1);
		
	n = p \ v;
			
	di(1,1) = n(1);
	dj(1,1) = n(2);
	
	p(1,:) = [0 -1]; v(1) =  M(1,nc-1) - M(1,nc);
	p(2,:) = [1 -1]; v(2) =  M(2,nc-1) - M(1,nc);
	p(3,:) = [1 0];  v(3) =  M(2,nc)   - M(1,nc);
		
	n = p \ v;
			
	di(1,nc) = n(1);
	dj(1,nc) = n(2);
	
	p(1,:) = [-1 0]; v(1) = M(nr-1,1) - M(nr,1);
	p(2,:) = [-1 1]; v(2) = M(nr-1,2) - M(nr,1);
	p(3,:) = [0 1];  v(3) = M(nr,2)   - M(nr,1);
		
	n = p \ v;
			
	di(nr,1) = n(1);
	dj(nr,1) = n(2);

	p(1,:) = [-1 -1]; v(1) = M(nr-1,nc-1) - M(nr,nc);
	p(2,:) = [0 -1];  v(2) = M(nr,nc-1)   - M(nr,nc);
	p(3,:) = [-1 0];  v(3) = M(nr-1,nc)   - M(nr,nc); 
		
	n = p \ v;
			
	di(nr,nc) = n(1);
	dj(nr,nc) = n(2);
	
	% Then, the boundaries
	
	for j=2:nc-1
		p(1,:) = [0 -1]; v(1) = M(1,j-1) - M(1,j);
		p(2,:) = [1 -1]; v(2) = M(2,j-1) - M(1,j);
		p(3,:) = [1 0];  v(3) = M(2,j)   - M(1,j);
		p(4,:) = [0 1];  v(4) = M(1,j+1) - M(1,j);
		p(5,:) = [1 1];  v(5) = M(2,j+1) - M(1,j);
			
		n = p \ v;
			
		di(1,j) = n(1);
		dj(1,j) = n(2);
		
		p(1,:) = [-1 -1]; v(1) = M(nr-1,j-1) - M(nr,j);
		p(2,:) = [0 -1];  v(2) = M(nr,j-1)   - M(nr,j);
		p(3,:) = [-1 0];  v(3) = M(nr-1,j)   - M(nr,j);
		p(4,:) = [-1 1];  v(4) = M(nr-1,j+1) - M(nr,j);
		p(5,:) = [0 1];   v(5) = M(nr,j+1)   - M(nr,j);
			
		n = p \ v;
			
		di(nr,j) = n(1);
		dj(nr,j) = n(2);
	end
	
	for i=2:nr-1
		p(1,:) = [-1 0]; v(1) = M(i-1,1) - M(i,1);
		p(2,:) = [1 0];  v(2) = M(i+1,1) - M(i,1);
		p(3,:) = [-1 1]; v(3) = M(i-1,2) - M(i,1);
		p(4,:) = [0 1];  v(4) = M(i,2)   - M(i,1);
		p(5,:) = [1 1];  v(5) = M(i+1,2) - M(i,1); 
		
	
		n = p \ v;
			
		di(i,1) = n(1);
		dj(i,1) = n(2);
		
		p(1,:) = [-1 -1]; v(1) = M(i-1,nc-1) - M(i,nc);
		p(2,:) = [0 -1];  v(2) = M(i,nc-1)   - M(i,nc);
		p(3,:) = [1 -1];  v(3) = M(i+1,nc-1) - M(i,nc);
		p(4,:) = [-1 0];  v(4) = M(i-1,nc)   - M(i,nc);
		p(5,:) = [1 0];   v(5) = M(i+1,nc)   - M(i,nc);
		
	
		n = p \ v;
			
		di(i,nc) = n(1);
		dj(i,nc) = n(2);
	end

	% And finally the remaining function values
	for i=2:nr-1
		for j=2:nc-1
			if mask(i,j) ~= 0
				k = 1;
				
				if mask(i-1,j-1) ~= 0
					p(k,:) = [-1 -1]; v(k) = M(i-1,j-1) - M(i,j);
					k = k + 1;
				end
				
				if mask(i-1,j) ~= 0
					p(k,:) = [-1 0];  v(k) = M(i-1,j)   - M(i,j);
					k = k + 1;
				end
				
				if mask(i-1,j+1) ~= 0
					p(k,:) = [-1 1];  v(k) = M(i-1,j+1) - M(i,j);
					k = k + 1;
				end
				
				if mask(i,j-1) ~= 0
					p(k,:) = [0 -1];  v(k) = M(i,j-1)   - M(i,j);
					k = k + 1;
				end
				
				if mask(i,j+1) ~= 0
					p(k,:) = [0 1];   v(k) = M(i,j+1)   - M(i,j);
					k = k + 1;
				end
				
				if mask(i+1,j-1) ~= 0
					p(k,:) = [1 -1];  v(k) = M(i+1,j-1) - M(i,j);
					k = k + 1;
				end
				
				if mask(i+1,j) ~= 0
					p(k,:) = [1 0];   v(k) = M(i+1,j)   - M(i,j);
					k = k + 1;
				end
				
				if mask(i+1,j+1) ~= 0
					p(k,:) = [1 1];   v(k) = M(i+1,j+1) - M(i,j);
					k = k + 1;
				end
				
				if k > 2
					n = p(1:k-1,:) \ v(1:k-1);
					
					di(i,j) = n(1);
					dj(i,j) = n(2);
				else
					di(i,j) = 0;
					dj(i,j) = 0;
				end
			else
				di(i,j) = 0;
				dj(i,j) = 0;
			end
		end
	end