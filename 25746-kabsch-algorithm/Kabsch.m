% Find the Least Root Mean Square distance 
% between two sets of N points in D dimensions
% and the rigid transformation (i.e. translation and rotation) 
% to employ in order to bring one set that close to the other,
% Using the Kabsch (1976) algorithm.
% Note that the points are paired, i.e. we know which point in one set 
% should be compared to a given point in the other set.
% 
% References:
% 1) Kabsch W. A solution for the best rotation to relate two sets of vectors. Acta Cryst A 1976;32:9223.
% 2) Kabsch W. A discussion of the solution for the best rotation to relate two sets of vectors. Acta Cryst A 1978;34:8278.
% 3) http://cnx.org/content/m11608/latest/
% 4) http://en.wikipedia.org/wiki/Kabsch_algorithm
%
% We slightly generalize, allowing weights given to the points.
% Those weights are determined a priori and do not depend on the distances.
%
% We work in the convention that points are column vectors; 
% some use the convention where they are row vectors instead. 
%
% Input  variables:
%  P : a D*N matrix where P(a,i) is the a-th coordinate of the i-th point 
%      in the 1st representation
%  Q : a D*N matrix where Q(a,i) is the a-th coordinate of the i-th point 
%      in the 2nd representation
%  m : (Optional) a row vector of length N giving the weights, i.e. m(i) is 
%      the weight to be assigned to the deviation of the i-th point.
%      If not supplied, we take by default the unweighted (or equal weighted)
%      m(i) = 1/N.
%      The weights do not have to be normalized; 
%      we divide by the sum to ensure sum_{i=1}^N m(i) = 1.
%      The weights must be non-negative with at least one positive entry.
% Output variables:
%  U : a proper orthogonal D*D matrix, representing the rotation
%  r : a D-dimensional column vector, representing the translation
%  lrms: the Least Root Mean Square
%
% Details:
% If p_i, q_i are the i-th point (as a D-dimensional column vector) 
% in the two representations, i.e. p_i = P(:,i) etc., and for 
% p_i' = U p_i + r      (' does not stand for transpose!)
% we have p_i' ~ q_i, that is, 
% lrms = sqrt(sum_{i=1}^N m(i) (p_i' - q_i)^2)
% is the minimal rms when going over the possible U and r.
% (assuming the weights are already normalized).
%
function[U, r, lrms] = Kabsch(P, Q, m)
	sz1 = size(P) ;
	sz2 = size(Q) ;
	if (length(sz1) ~= 2 || length(sz2) ~= 2)
		error 'P and Q must be matrices' ;
	end
	if (any(sz1 ~= sz2))
		error 'P and Q must be of same size' ;
	end
	D = sz1(1) ;         % dimension of space
	N = sz1(2) ;         % number of points
	if (nargin >= 3)
		if (~isvector(m) || any(size(m) ~= [1 N]))
			error 'm must be a row vector of length N' ;
		end 
		if (any(m < 0))
			error 'm must have non-negative entries' ;
		end
		msum = sum(m) ;
		if (msum == 0)
			error 'm must contain some positive entry' ;
		end
		m = m / msum ;     % normalize so that weights sum to 1
	else                 % m not supplied - use default
		m = ones(1,N)/N ;
	end

	p0 = P*m' ;          % the centroid of P
	q0 = Q*m' ;          % the centroid of Q
	v1 = ones(1,N) ;     % row vector of N ones
	P = P - p0*v1 ;      % translating P to center the origin
	Q = Q - q0*v1 ;      % translating Q to center the origin

	% C is a covariance matrix of the coordinates
	% C = P*diag(m)*Q' 
	% but this is inefficient, involving an N*N matrix, while typically D << N.
	% so we use another way to compute Pdm = P*diag(m),
	% which is equivalent to, but more efficient than,
	% Pdm = zeros(D,N) ;
	% for i=1:N
	% 	Pdm(:,i) = m(i)*P(:,i) ;
	% end
	Pdm = bsxfun(@times,m,P) ;
	C = Pdm*Q' ; 	
%	C = P*Q' / N ;       % (for the non-weighted case)       
	[V,S,W] = svd(C) ;   % singular value decomposition
	I = eye(D) ;
	if (det(V*W') < 0)   % more numerically stable than using (det(C) < 0)
		I(D,D) = -1 ;
	end
	U = W*I*V' ;

	r = q0 - U*p0 ;

	Diff = U*P - Q ;     % P, Q already centered
%	lrms = sqrt(sum(sum(Diff.*Diff))/N) ; % (for the non-weighted case)
	% to compute the lrms, we employ an efficient method, equivalent to: 
	% lrms = 0 ;
	% for i=1:N
	% 	lrms = lrms + m(i)*Diff(:,i)'*Diff(:,i) ;
	% end
	% lrms = sqrt(lrms) ;
	lrms = sqrt(sum(sum(bsxfun(@times,m,Diff).*Diff))) ; 
end
