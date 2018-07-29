function [ P, c, X, M, B ] = sm_recovery(shapes, varargin)
% [ P c X M B ] = sm_recovery(shapes)
% [ P c X M B ] = sm_recovery(shapes, k)
% [ P c X M B ] = sm_recovery(shapes, 'ratio', ratio)
% [ P c X M B ] = sm_recovery(shapes, k, 'ratio', ratio)
%
% Recover 3D information from deforming and moving 2D shapes, as
% described in the paper:
% "A Closed-Form Solution to Non-Rigid Shape and Motion Recovery"
% by Jing Xiao, Jin-xiang Chai, Takeo Kanade.
% The algorithm is randomized, try running it another time if the results
% are not satisfying.
% 
%                         PARAMETERS
%
% shapes A np-by-2-by-N matrix containing N shapes and np landmarks,
%        that is, 2D points stored on rows in image coordinates: [i j]
%
%
% k (Optional) Number of shape modes used to recover the 3D deformable
%   shapes. If not provided, it is a third of the number of singular values 
%   of the registered measurement matrix satisfying s_1 / s_i < ratio. 
%   Note that too high values will lead to an ill-conditioned solution.
%   
%
%
%                     OPTIONAL PROPERTIES
%
% 'ratio'  For noisy data, only keep floor(S / 3) shape modes, where
%          S is the number of singular values of the registered measurement matrix
%          satisfying s_1 / s_i < ratio. Default is 100. Tip: use this if 
%          the condition number of constraints matrices is too high.
%
%
%                        RETURN VALUES
%
% P A 2*N-by-3 matrix containing the stacked 2-by-3 projection matrices
%   associated with each 3D shape.
%
% c A N-by-k matrix containing the weight of each 3D shape mode
%   for a given 3D shape. That is, the i-th 3D shape is given by
%		sum_{j} {c(i,j) * B_j}, where sum_{j}{} denotes the sum over j and
%   B_j denotes the j-th base shape.
%
% X A 3*N-by-np matrix containing the stacked recovered 3D shapes
%
% M A 2*N-by-3*k matrix containing combining projection matrices
%   and weights. See the paper for more info.
% 
% B A A 3*k-by-np matrix containing the stacked 3D base shapes.
%
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)
% Acknowledgments: Most of the credit goes to Jing Xiao which was kind enough
% to show me his implementation of the algorithm. Without that
% it would've been nearly impossible for me to figure out
% how to get the code to work.

	k = 0;
	ratio = 100;
	
	% Parse optional parameters
	if numel(varargin) > 0
		i = 1;
		if ~ischar(varargin{1})
			k = varargin{1}
			i = i + 1;
		end
		
		if numel(varargin) > 1 && strcmp(varargin{i}, 'ratio')
			ratio = varargin{i+1};
		end
	end

	%
	% shapes(:,:,t) = [ i1_t j1_t; i2_t j2_t; ...; in_t jn_t]
	%
	
	% The number of provided 2D shapes
	N = size(shapes, 3);
	% The number of landmarks
	np = size(shapes, 1);
	
	% Measurement matrix, as defined in the paper
	W = reshape(shapes, np, [])';
		
	%
	% W = [ i1_1   i2_1  ...  in_1 
	%       j1_1   j2_1  ...  jn_1 
	%       i1_2   i2_2  ...  in_2
	%       j1_2   j2_2  ...  jn_2
	%       .          .       .
	%       .          .       .
	%       .          .       .
	%       i1_N+1 i2_N+1 ... in_N+1 
	%       j1_N+1 j2_N+1 ... jn_N+1 ]
	%
	
	% Register and decompose
	reg_W = W - repmat(mean(W, 2), 1, np);
	[U S V] = svd(reg_W, 'econ');
	
	% If not provided, determine k
	if k == 0
		i = 2;
		while S(1,1) / S(i,i) < ratio && i < size(S,1)
			i = i + 1;
		end
		
		k = floor((i - 1) / 3)
	end
	
	% Useful shorthand
	dim = 3 * k;
	
	% Do not allow for an underdetermined problem
	if dim > size(U, 2) 
		error('sm_recovery: k is too big. Either provide more useful shape data or reduce its value.');
	end
	
	% M prior to correction, as in the paper
	M_tilde = U(:,1:dim);
			
	% Find k independent 2D shapes, and use them as starting point for the 3D basis 
	if k > 2
		% Start withthe first k shapes
	  permutation = [1:2*k];
	  
	  % Condition number for these. 
	   cur_cond = cond(reg_W(permutation,:));
	 
		% Iterate over all couples of shapes, while leaving space at the end 
		% of the sequence for the remaining shapes
		for i=1:N-k+1
	    for j=i+1:N-k+2
	  		% Iterate k times
	      for it=1:k
	      		% Indices to ith and jth shapes
	          sel = [i*2-1:i*2,j*2-1:j*2];
	          index = j;
	          % Iterate k-2 times
	          for n=3:k
	          		% Random index between j+1 and N+n-k, so in the next iterations
	          		% there will always be a choice
	              index = round(rand * (N + n - k - index - 1) + index + 1);
	              % Indices to shape corresponding to "index"
	              sel(1,n*2-1:n*2) = [index*2-1,index*2];
	          end
	          
	          % Condition number of selected shapes
						cn = cond(reg_W(sel,:));
						
						% If lower than previous value, pick this selection
						if cn < cur_cond
	              cur_cond = cn;
	              permutation = sel;
						end
		    end
	    end
		end
	elseif k == 2
		% This is easier, find the 2 best independent 2D shapes 
	  permutation = [1:2*k];
	  cur_cond = cond(W(permutation,:));
	  
		% Iterate over all couples of shapes and keep the one
		% with the lowest condition number
		for i=1:N-1
			for j=i+1:N
		    sel = [i*2-1:i*2,j*2-1:j*2];
				cn = cond(W(sel,:));
				if cn < cur_cond
	        cur_cond = cn;
	        permutation = sel;
				end
		  end
		end
	else
		% The first shape is as good as any
	  permutation = [1 2];
	end;
	
	disp 'Condition number of first K shapes:'
	cur_cond

	indices = [permutation, 1:permutation(1)-1];
	
	for i=2:2:numel(permutation)-1
		indices = [indices permutation(i)+1:permutation(i+1)-1];
	end
	
	indices = [indices permutation(end)+1:2*N];

	% Reorder M_tilde
	perm_M_tilde = M_tilde(indices,:);
	M_tilde = perm_M_tilde;
	
	% C is the matrix of constraints that do not depend
	% from the tri-colum of G being estimated.
	% d is the column vector of the constant terms associated
	% with each constraint
	C_base = zeros(2*N, dim*dim);
	d_base = zeros(2*N, 1);
	
	% Rotation constraints, see paper for more details
	for i=1:N
		m1 = M_tilde(2*i-1,:);
		m2 = M_tilde(2*i,:);
						
		C_base(2*i-1,:) = reshape(m1' * m1, 1, []) - reshape(m2' * m2, 1, []); 
		
		% Invert order of multiplication to obtain the transposed result, so reshape
		% gives the constraint in row-wise order. For the previous it doesn't matter
		% as the result is symmetric.
		C_base(2*i,:) = reshape(m2' * m1, 1, []);
	end
	
	all_C = cell(k,1);
	all_d = cell(k,1);
	
	% M_tilde as a row vector, one row after another
	M_rows = reshape(M_tilde', 1, []);
	
	% First 2*k rows of M_tilde as a row vector, one row after another
	M_k_rows = reshape(M_tilde(1:k*2,:)', 1, []);
	
	% Matrix containing blocks b(i,j) given by M_tilde(2*i,:)' * M_tilde(2*j,:)
	% where i is in range [1,2*k] and j is in range [1,2*N]
	% Each block is dim x dim
	BC = M_k_rows' * M_rows;
	
	clear M_rows;
	clear M_k_rows;
	
	C = zeros(size(C_base,1)+2+4*N*(k-1), (dim+1)*dim/2);
	
	% Basis constraints for each k
	for l=1:k	
		% others contains all integers in range [1,k] except "l"
    if l == 1
    	others = 2:k;
    else
    	others = [1:l-1,l+1:k];
    end;
    
    % Initialize cell with the constraints we have so far
    % and preallocate for further constraints
    all_C{l} = [C_base; zeros(2+4*N*(k-1), dim*dim)];
    all_d{l} = [d_base; 1; 1; zeros(4*N*(k-1), 1)];
      
    m1 = M_tilde(2*l-1,:);
		m2 = M_tilde(2*l,:);
		
		% Starting index for new constraints
    offset = size(C_base, 1);
    
    % The 2 nonzero constraints for i=j=k
    all_C{l}(offset+1,:) = reshape(m1' * m1, 1, []);
    all_C{l}(offset+2,:) = reshape(m2' * m2, 1, []);
    
    offset = offset + 2;
        
    % All the other basis constraints
    for j=1:size(others, 2)
	    for c=1:dim
	  		% Take c-th row of all products of the form M_tilde((others(j)-1)*2,:)' * m
	  		% Then each piece of the row belonging to a different product is placed in a different
	  		% row and finally this block can be copied in the constraints matrix
	  		% This is possible because each constraint row is of the form [r1 r2 r3 ... r_dim] where r* is
	  		% the row of a product of the form m' * n and its length is dim. It is then easy to see
	  		% how stacking constraint rows allows for the following syntax
	  		 all_C{l}(offset+1:offset+2*N,(c-1)*dim+1:c*dim) = reshape(BC((others(j)-1)*2*dim+c,:), dim, [])';
	      
	      % Take c-th row of all products of the form M_tilde(others(j)*2-1,:)' * m
	  		% Then each piece of the row belonging to a different product is placed in a different
	  		% row and finally this block can be copied in the constraints matrix
	  		% This is possible because each constraint row is of the form [r1 r2 r3 ... r_dim] where r* is
	  		% the row of a product of the form m' * n and its length is dim. It is then easy to see
	  		% how stacking constraint rows allows for the following syntax
	  		all_C{l}(offset+2*N+1:offset+4*N,(c-1)*dim+1:c*dim) = reshape(BC((others(j)*2-1)*dim+c,:), dim, [])';
	    end;
	    
	   	offset = offset + 4 * N;
    end;

    % Sum constraint elements corresponding to equal values in
    % the unknown. This will force the result to be symmetric as
    % we compute equal unknowns once and not twice.
    col = 1;
    for i=1:dim
      for j=i:dim
        if i == j
            C(:,col) = all_C{l}(:,(i-1)*dim+j);
        else
            C(:,col) = all_C{l}(:,(i-1)*dim+j) + all_C{l}(:,(j-1)*dim+i);
        end;
        col = col + 1;
      end;
    end;
   
    all_C{l} = C;
	end;
	
	clear BC;
	clear m1;
	clear m2;
	clear C_base;
	clear d_base;
	
	R = cell(k,1);
	
	disp 'Condition number of constraint matrices:'
	for l=1:k
		cond(all_C{l})
	end
		
	for l=1:k
    C = all_C{l};
    d = all_d{l};
    
    clear all_C{l};
    clear all_d{l};
   
    % Least-square solution of problem
    sol = pinv(C) * d;
    
    Q = zeros(dim, dim);
    
    % Solution in matrix form, note that sol only comprises a
    % triangular portion of this matrix, as it is symmetric
    pos = 1;
    for i=1:dim
    	% Store the lower portion of column including
    	% the diagonal element
    	Q(i:end,i) = sol(pos:pos+dim-i);
    	pos = pos + dim - i + 1;
    end
    
    % Add the upper triangular portion
    Q = Q + tril(Q, -1)';
    
    % Since Q is Q_k = g_k * g_k', DP is equal to M(:,1:3) * M(:,1:3)'
    % where M is Q * G
    % The result is a matrix containing all the dot products between the
    % projection axes of M, and on the diagonals are the squared norms 
    % of all the axes 
    DP = M_tilde * Q * M_tilde';
    
    % Rescale Q, ensuring that the coefficient
    % for the shape l is 1
    Q = Q / DP(l*2-1,l*2-1);
    
    % Finally, the factorization
    [U S V] = svd(Q);
    
    U = U * sqrt(S);
    
    % This is g_k
    g = U(:,1:3);

		% l-th tri-column of M
    tric = M_tilde * g;
	  
    for i=1:N
			% SVD on the i-th projection matrix
      [U S V] = svd(tric(2*i-1:i*2,:));
      % Extract coefficient
      p(i,l) = (S(1,1) + S(2,2)) / 2;
      S(1:2,1:2) = eye(2);
      % Normalize axes
      R{l}(2*i-1:i*2,:) = U * S * V';
    end
	end
	
	
	clear all_C;
	clear all_d;
	clear DP;
	clear tric;
	clear full_sol;
	clear C;
	clear d;
	
	% Store in seqp the product of sequences of p over k for each shape
	seqp = p(:,1);
	for i=2:k
	    seqp = seqp .* p(:,i);
	end;
	
	% seqp_max: maximum absolute value of seqp
	% seqp_max_id: index of seqp_max in seqp
	[seqp_max, seqp_max_id] = max(abs(seqp));
	if k > 1
			% p_max: maximum absolute value of p for a given shape
			% p_max_id: k such that p is maximum for a given shape
	    [p_max, p_max_id] = max(abs(p), [], 2);
	else
	    %[p_max, p_max_id] = max(abs(p), [], 2);
	    p_max_id = ones(N, 1);
	end;
	
	% Find k such that p(s,k) is maximum for the shape s with the highest value in seqp
	% and set ref_R to be R{k}
	ref_R = R{p_max_id(seqp_max_id)};
	
	for i=1:k
		% Do not do this if R{i} is the same as ref_R
  	if i ~= p_max_id(seqp_max_id)
  		% Average dot products between the respective projection axes, and convert to an
  		% angle, in degrees
  		to_ref = acos(trace(ref_R(seqp_max_id*2-1:seqp_max_id*2,:) * R{i}(seqp_max_id*2-1:seqp_max_id*2,:)') / 2) * 180 / pi;
      % The first k shapes have not been considered since their coefficients are supposed to
      % be 0 except for a single one
      for j=k+1:N
      		% Average dot products between the respective projection axes, and convert to an
  				% angle, in degrees
          pos = acos(trace(ref_R(j*2-1:j*2,:) * R{i}(j*2-1:j*2,:)') / 2) * 180 / pi;
          % Average dot products between the respective projection axes, and convert to an
  				% angle, in degrees. Note the minus sign this time.
          neg = acos(trace(-ref_R(j*2-1:j*2,:) * R{i}(j*2-1:j*2,:)') / 2) * 180 / pi;
          % Use the sign that minimizes the difference between the angles
          if abs(pos - to_ref) > abs(neg - to_ref)
              R{i}(j*2-1:j*2,:) = -R{i}(j*2-1:j*2,:);
              p(j,i) = -p(j,i);
          end
      end
      
      % Orthogonal procrustes transform aligning R{i}((k+1)*2-1:N*2,:) to ref_R((k+1)*2-1:N*2,:)
      OP = R{i}((k+1)*2-1:N*2,:)' * ref_R((k+1)*2-1:N*2,:);
      [U S V] = svd(OP);
      R{i} = R{i} * U * V';
		end
	end
	
	clear OP;
	
	% Set the first k projection matrices in ref_R to be the ones on the "diagonal" of M
	for i=1:k
	    ref_R(i*2-1:i*2,:) = R{i}(i*2-1:i*2,:);
	end
	
	% Set the other projection matrices in ref_R to be the ones with the greatest associated
	% coefficient
	for i=k+1:N
	    ref_R(i*2-1:i*2,:) = R{p_max_id(i)}(i*2-1:i*2,:);
	end
	
	for i=1:k
	   for j=1:N
	   			% Reconstruct M
	       M(2*j-1:2*j,3*i-2:3*i) = p(j,i) * ref_R(2*j-1:2*j,:);
	   end;
	end;
	
	[ind indices] = sort(indices);
	P = ref_R(indices,:);

	perm_M = M(indices,:);
	M = perm_M;                      

	c = p(indices(2:2:end)/2,:);
	
	% This should be the shape basis matrix
	B = pinv(M) * reg_W;
	disp 'Reconstruction error in percentage'
	% Given w is the measurement matrix and NLR1 is 
	% what the paper call M, B has to be what the paper calls B
	norm(reg_W-M*B,'fro') / norm(reg_W,'fro')
	
	% Reconstructed shapes
	X = zeros(3*N, np);
	for j=1:N    
	    for i=1:k        
	        X(j*3-2:j*3,:) = X(j*3-2:j*3,:) + c(j,i) * B(3*i-2:3*i,:);
	    end;
	end;