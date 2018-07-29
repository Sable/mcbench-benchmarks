% MYCAMCALD	Compute camera calibration from data points
%
%	C = CAMCALD(D)
% 
%	Solve the camera calibration using the SVD technique.  Input is 
%	a table of data points, D, with each row of the form [x y z iX iY]
%	where (x,y,z) is the world coordinate, and (iX, iY) is the image 
%	plane coordinate.
%
%	Output is a 3x4 camera calibration matrix.
%
% SEE ALSO: CAMCALP, CAMERA, CAMCALT, INVCAMCAL
%
% note that this is a modified version of the CAMCALD function in the
% vision toolbox for Matlab (written by whom I am not sure). The 
% original version did not apply the normalization suggested by 
% Hartley (TPAMI 1997) and I found it to be unstable.

function C = mycamcald(D)

X		= D(:,1:3)';
W		= D(:,4:5)';

npoints	= size(X,2);

m 	= mean(W,2);
Wt	= W - m*ones(1,size(W,2));
s		= 2 * sqrt(npoints / (norm(Wt,'fro')^2));
T		= [eye(2)*s -m*s; 0 0 1];
W2	= T * [W; ones(1,size(W,2))];

m 	= mean(X,2);
Xt	= X - m*ones(1,size(X,2));
s		= 3 * sqrt(npoints / (norm(Xt,'fro')^2));
U		= [eye(3)*s -m*s; 0 0 0 1];
X2	= U * [X; ones(1,size(X,2))];

z		= zeros(1,4);
C		= zeros(2*npoints,12);

for p = 1:size(X,2)
	x	= [X2(1:3,p); 1]';
	
	C((2*p)-1:(2*p),:)	= [z -x W2(2,p)*x; x z -W2(1,p)*x];
end
	
[u,s,v] = svd(C,0);

Cv		= v(:,end);
Chat	= reshape(Cv,4,3)';
C			= T \ Chat * U;
C			= C / C(3,3);
