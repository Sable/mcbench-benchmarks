function [psi_err,omega_err] = compute_cam_error(P)
% Compare camera rotations
%
% © Copyright Phil Tresadern, University of Oxford, 2006

% this is the true rotation matrix between camera 1 and 2
% (I defined it this way when generating synthetic examples)
Ptrue	= getRx(20*pi/180) * getRy(210*pi/180);
	v		= logm(Ptrue);
	v		= v([6,7,2])';
	tht	= norm(v); % axis of rotation
	axt	= v / tht; % rotation angle about axis

% this is its estimated value
Prect	= [P(1:2,:); cross(P(1,:),P(2,:))];
	v		= logm(Prect);
	v		= v([6,7,2])';
	thr	= norm(v); % axis of rotation
	axr	= v / thr; % rotation angle about axis

psi_err		= acos(axt'*axr); % angle between rotation axes
omega_err	= abs(thr-tht);		% difference in rotation angle about axis
