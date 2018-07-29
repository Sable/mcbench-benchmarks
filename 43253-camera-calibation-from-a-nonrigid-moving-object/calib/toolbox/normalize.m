function [S,Pout,Xout] = normalize(Pm,Xm)
% separate projection*structure into scale*projection*structure with
% everything rotated so that camera 1 is aligned with the world co-ordinate
% frame
%
% © Copyright Phil Tresadern, University of Oxford, 2006

nframes = size(Pm,3);

for f = 1:nframes
	% decompose into calibration * rotation
	Ptemp				= Pm(:,:,f);
	[q1,r1]			= qr(Ptemp(1:2,:)',0);
	[q2,r2]			= qr(Ptemp(3:4,:)',0);
	[q1full,r]	= qr(q1);

	S(:,:,f)		= [r1' zeros(2,2); zeros(2,2) r2'];

	% transform to canonical coordinate frame
	Pout(:,:,f) = [1 0 0; 0 1 0; q2'*q1full];
	Xout(:,:,f) = q1full' * Xm(:,:,f);
end

% get absolute scale
s = S(1,1,1);

for f = 1:nframes
	% ensure scales are positive and relative to global scale
	sgn					= diag(sign(diag(S(:,:,f))));
	S(:,:,f)		= diag(diag(S(:,:,f) * sgn)) / abs(s);
	
	% apply sign correction to P and scale correction to X
	Pout(:,:,f)	= sgn * Pout(:,:,f); 
	Xout(:,:,f)	= Xout(:,:,f) * abs(s);

	% apply another sign correction to P and X
	sgn					= diag(sign(diag(Pout(:,:,f))));
	Pout(:,:,f)	= Pout(:,:,f) * sgn;
	Xout(:,:,f)	= sgn * Xout(:,:,f);
end

