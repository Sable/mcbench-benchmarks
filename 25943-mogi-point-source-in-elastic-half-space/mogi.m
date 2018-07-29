function [ur,uz,dt,er,et] = mogi(varargin)
%MOGI	Mogi's model (point source in elastic half-space).
%	[Ur,Uz,Dt,Er,Et] = MOGI(R,F,V,nu) or MOGI(R,F,A,P,E,nu) computes radial 
%	and vertical displacements Ur and Uz, ground tilt Dt, radial and 
%	tangential strain Er and Et on surface, at a radial distance R 
%	from the top of the source due to a hydrostatic pressure inside a 
%	sphere of radius A at depth F, in a homogeneous, semi-infinite elastic
%	body and approximation for A << F (center of dilatation). Formula by
%	Anderson [1936] and Mogi [1958].
%
%	MOGI(R,F,V) and MOGI(R,F,A,µ,P) are also allowed for compatibility 
%	(Mogi's original equation considers an isotropic material with Lamé's 
%	constants equal, i.e., lambda = µ, Poisson's ratio = 0.25).
%
%	Input variables are:
%	   F: depth of the center of the sphere from the surface,
%	   V: volumetric change of the sphere,
%	   A: radius of the sphere,
%	   P: hydrostatic pressure change in the sphere,
%	   E: elasticity (Young's modulus),
%	  nu: Poisson's ratio,
%	   µ: rigidity (Lamé's constant in case of isotropic material).
%
%	Notes:
%		- Equations are all vectorized, so variables R,F,V,A,µ and P are 
%		  scalar but any of them can be vector or matrix, then outputs 
%		  will be vector or matrix of the same size.
%		- Convention: Uz > 0 = UP, F is depth so in -Z direction.
%		- Units should be constistent, e.g.: R, F, A, Ur and Uz in m imply
%		  V in m3; E, µ and P in Pa; Dt in rad, Er, Et and nu dimensionless.
%
%	Example for a 3-D plot of exagerated deformed surface due to a 1-bar
%	overpressure in a 10-cm radius sphere at 1-m depth in rock:
%	  [x,y] = meshgrid(-3:.1:3);
%	  [th,rho] = cart2pol(x,y);
%	  [ur,uz] = mogi(rho,1,0.1,1e5,10e9,0.25);
%	  [ux,uy] = pol2cart(th,ur);
%	  ps = 1e8;
%	  surf(x+ux*ps,y+uy*ps,uz*ps), axis equal, light
%
%	Author: François Beauducel <beauducel@ipgp.fr>
%	  Institut de Physique du Globe de Paris
%	Created: 1997
%	Updated: 2011-11-08
%
%	References:
%	  Anderson, E.M., Dynamics of the formation of cone-sheets, ring-dikes,
%		and cauldron-subsidences, Proc. R. Soc. Edinburgh, 56, 128-157,	1936.
%	  Mogi, K., Relations between the eruptions of various volcanoes and the
%		deformations of the ground surfaces around them, Bull. Earthquake Res.
%		Inst. Univ. Tokyo, 36, 99-134, 1958.

%	Copyright (c) 1997-2011, François Beauducel, covered by BSD License.
%	All rights reserved.
%
%	Redistribution and use in source and binary forms, with or without 
%	modification, are permitted provided that the following conditions are 
%	met:
%
%	   * Redistributions of source code must retain the above copyright 
%	     notice, this list of conditions and the following disclaimer.
%	   * Redistributions in binary form must reproduce the above copyright 
%	     notice, this list of conditions and the following disclaimer in 
%	     the documentation and/or other materials provided with the distribution
%	                           
%	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%	POSSIBILITY OF SUCH DAMAGE.

error(nargchk(3,6,nargin))

for i = 1:nargin
	if ~isnumeric(varargin{i})
		error('All input arguments must be numeric.')
	end
end

% to check if input arguments have compatible sizes, constructs a complex
% vector of sizes, then uses UNIQUE on variables that are not scalar
sz = complex(cellfun('size',varargin,1),cellfun('size',varargin,2));
if length(unique(sz(find(sz~=complex(1,1))))) > 1
	error('All inputs must be scalar or matrix of the same size.')
end

r = varargin{1};
f = varargin{2};

switch nargin
	case 3	% MOGI(R,F,V)
		v = varargin{3};
		nu = 0.25;
	case 4	% MOGI(R,F,V,nu)
		v = varargin{3};
		nu = varargin{4};
	case 5	% MOGI(R,F,A,µ,P)
		a = varargin{3};
		mu = varargin{4};
		p = varargin{5};
		nu = 0.25;
	case 6	% MOGI(R,F,A,P,E,nu)
		a = varargin{3};
		p = varargin{4};		
		nu = varargin{6};
		mu = varargin{5}./(2*(1+nu));
end

if any(nargin==[3,4])
	y = v./pi;
else
	if max(max(a))/min(min(f)) > .1
		warning('Mogi: inaccurate results if F is not much greater than A.')
	end
	y = (a.^3).*p./mu;
end

R = sqrt(f.^2 + r.^2);	% radial distance from source
C = (1-nu).*y;		% intermediate constant

et = C./R.^3;		% tangential horizontal strain
ur = r.*et;		% radial horizontal displacement
uz = f.*et;		% vertical displacement

if nargout > 2
	dt = 3*C.*f.*r./R.^5;	% tilt
end
if nargout > 3
	er = C.*(f.^2 - 2*r.^2)./R.^5;	% radial horizontal strain
end

