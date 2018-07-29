function spharmPlot(L, resolution)
% This function plots base spherical harmonic functions in their real forms
%
% Syntax: 
% spharmPlot(L, resolution)
% spharmPlot(L)
% spharmPlot()
%
% Inputs:% 
% L: degree of the functions, default value = 2;
% resolution: resolution of sphere surface, default value = 500.
%
% Results:
% green regions represent negative values
% red regions represent positive values
%
% Reference: http://en.wikipedia.org/wiki/Spherical_harmonics
% 
% Written by Mengliu Zhao, School of Computing Science, Simon Fraser University
% Date: 2013/May/02

if nargin < 1
	L = 2;
	resolution = 500;
end
if nargin < 2
	resolution = 500;
end

% discretize sphere surface
delta = pi/resolution;
theta = 0:delta:pi; % altitude
phi = 0:2*delta:2*pi; % azimuth
[phi,theta] = meshgrid(phi,theta);

% set figure background to white
figure('Color',[1 1 1])
for M = -L:L
	% Legendre polynomials
	P_LM = legendre(L,cos(theta(:,1)));
	P_LM = (-1)^(M)*P_LM(abs(M)+1,:)';
	P_LM = repmat(P_LM, [1, size(theta, 1)]);

	% normalization constant
	N_LM = sqrt((2*L+1)/4/pi*factorial(L-abs(M))/factorial(L+abs(M)));
		
	% base spherical harmonic function
	if M>=0
		Y_LM = sqrt(2) * N_LM * P_LM .* cos(M*phi);
	else		
		Y_LM = sqrt(2) * N_LM * P_LM .* sin(abs(M)*phi);
	end
	
	% map to sphere surface
	r = Y_LM;	
	r = Y_LM;	
	x = abs(r).*sin(theta).*cos(phi); 
	y = abs(r).*sin(theta).*sin(phi);
	z = abs(r).*cos(theta);

	% visualization
	subplot(ceil(sqrt(2*L+1)),ceil(sqrt(2*L+1)),M+1+L)
	h = surf(x,y,z,double(r>=0));
	
	% adjust camera view
	view(40,30)
	camzoom(1.5)
	camlight left
	camlight right
	lighting phong

	axis([-1 1 -1 1 -1 1])
	
	% map positive regions to red, negative regions to green
	colormap(redgreencmap([2]))
	
	% hide edges
	set(h, 'LineStyle','none')
	
	grid off
	text(0,-.5,-1,['L = ', num2str(L), ', M = ', num2str(M)])
end