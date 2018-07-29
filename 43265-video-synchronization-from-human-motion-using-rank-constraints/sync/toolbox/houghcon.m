function [dt,accarray] = houghcon(x,f,a,varargin)

	dt 	= [];
	accarray	= [];

	error(nargchk(3,6,nargin));
	switch (length(varargin))
		case{0}
			sim	= ones(max(f),max(x));
		case{1}
			sim	= varargin{1};
    end

	dtmin	= min(round(f-a*x)');
	dtmax	= max(round(f-a*x)');
	
	dts				= dtmin:dtmax;
	accarray	= zeros(size(dts));
	
	for p = 1:length(x)
		temp	= round(f(p) - (a * x(p)));
		ind		= find(dts == temp);
		
		accarray(ind)	= accarray(ind) + sim(f(p),x(p));
	end

	dt 	= dts(accarray > (0.8*max(accarray)));
