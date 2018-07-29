function [ G,scaleXY ] = genGaborKernel( mu,nu,sigma,scaleXY )
% [G SCALEXY] = genGaborKernal( MU,NU,sigma,scaleXY )
%             u^2+v^2         -(u^2+v^2)*(x^2+y^2)                               -sigma^2
%   G(x,y) = --------- * exp(----------------------) * [ exp(i*(u*x+v*y)) - exp(----------)]
%             sigma^2               2*sigma^2                                       2
%	              u         kmax         pi*MU         kmax         pi*MU
%	in which, k=(   ), u = ------ * cos(-------), u = ------ * sin(-------).
%                 v         f^NU           8           f^NU           8
%	in which, kmax = pi/2,f = sqrt(2).
%	if MU or NU is vector, G{p,q} = G(nu(p),mu(q))
%	SCALEXY is the window length of G. if it's set to 0, it will be
%	calculated to include most significant value area.
%	sigma¡ü£¬G goes flat£»NU¡ü£¬freq¡ý£»MU¡ü£¬wave vector turns.
%	ref: Gabor Feature Based Classification Using the Enhanced Fisher Linear 
%	Discriminant Model for Face Recognition, Chengjun Liu et al.

kmax = pi/2;
f = sqrt(2);
angStep = pi/8;
if scaleXY == 0
	th = 5e-3;
	scaleXY = ceil(sqrt(-log(th*sigma^2/kmax^2)*2*sigma^2/kmax^2));
end
[X Y] = meshgrid(-scaleXY:scaleXY,-scaleXY:scaleXY);
DC = exp(-sigma^2/2); %#ok

G = cell(length(nu),length(mu));
for scale_idx = 1:length(nu)
	for angle_idx = 1:length(mu)
		phi = angStep*mu(angle_idx);
		k = kmax/f^nu(scale_idx);
		G{scale_idx,angle_idx} = k^2/sigma^2 * exp(-k^2*(X.^2+Y.^2)/2/sigma^2)...
			.*(exp(1i*(k*cos(phi)*X+k*sin(phi)*Y)));
	end
end