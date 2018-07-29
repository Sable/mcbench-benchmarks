function Cp = getCP(P)
% compute a matrix that encapsulates all constraints on all projection matrices
%
% © Copyright Phil Tresadern, University of Oxford, 2006

nframes = size(P,3);

% two constraints (equality and orthogonality) for each of two views
ncons		= 4; 

% there are six degrees of freedom in the symmetric 3x3 matrix \Omega
Cp		= sparse(zeros(ncons*nframes,6*nframes));

rows	= 1:ncons;
cols	= 1:6;

for f = 1:nframes
	% compute bilinear products
	p 	= [	kron(P(1,:,f),P(2,:,f));
					kron(P(3,:,f),P(4,:,f));
					kron(P(1,:,f),P(1,:,f))-kron(P(2,:,f),P(2,:,f));
					kron(P(3,:,f),P(3,:,f))-kron(P(4,:,f),P(4,:,f))];

	% consolidate entries that are not independent
	c	= [p(:,1) p(:,2)+p(:,4) p(:,5) p(:,3)+p(:,7) p(:,6)+p(:,8) p(:,9)];

	% update appropriate rows,cols of constraint matrix
	Cp(rows,cols) = c;

	% got to next block
	rows	= rows + ncons;
	cols	= cols + 6;	
end
