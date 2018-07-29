function [R,Q] = rq(A)
% RQ (rather than QR) decomposition of a matrix
%
% © Copyright Phil Tresadern, University of Oxford, 2006

temp = A;

R	= zeros(3,3);
Q	= zeros(3,3);

for row = 3:-1:1
	q = temp(row,:) / norm(temp(row,:));
	c	= temp*q';

	R(:,row)	= c;
	Q(row,:)	= q;

	temp = temp - c*q;
end

R = triu(R);

% make sure Q is a rotation matrix rather than a reflection
if (det(Q) < 0)
	R(:,1)	= -R(:,1);
	Q(1,:)	= -Q(1,:);
end
		
