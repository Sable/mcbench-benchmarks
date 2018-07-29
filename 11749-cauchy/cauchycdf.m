function p= cauchycdf(x, varargin)
	
% USAGE:       p= cauchycdf(x, a, b)
% 
% Cauchy cumulative distribution function (cdf), p= 0.5 + atan((x-a)/b)/pi.
% 
% ARGUMENTS:
% x might be of any dimension.
% a (default value: 0.0) must be scalars or size(x).
% b (b>0, default value: 1.0) must be scalars or size(x).
% 
% EXAMPLE:
% x= -3:0.01:3;
% plot(x, cauchycdf(x));
% 
% SEE ALSO:    cauchyfit, cauchyinv, cauchypdf, cauchyrnd.
% 
% Copyright (C) Peder Axensten <peder at axensten dot se>
% 
% HISTORY:
% Version 1.0, 2006-07-10.
% Version 1.1, 2006-07-26.
% - Added cauchyfit to the cauchy package. 
% Version 1.2, 2006-07-31:
% - cauchyinv(0, ...) returned a large negative number but should be -Inf. 
% - Size comparison in argument check didn't work. 
% - Various other improvements to check list. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	% Default values
	a=	0.0;
	b=	1.0;
	
	
	% Check the arguments
	if(nargin >= 2)
		a=	varargin{1};
		if(nargin == 3)
			b=			varargin{2};
			b(b <= 0)=	NaN;	% Make NaN of out of range values.
		end
	end
	if((nargin < 1) || (nargin > 3))
		error('At least one argument, at most three!');
	end
	
	
	% Calculate
	p=	0.5 + atan((x-a)./b)/pi;
end
