function [a,dt] = fitline(x,f,varargin)
% function [a,dt] = fitline(x,f,{a,method,sim,rbins,tbins})

error(nargchk(2,7,nargin));

dt 	= [];
accarray	= [];

a	= [];
	if (length(varargin) > 0), a = varargin{1}; end
method = 'hough';
	if (length(varargin) > 1), method = varargin{2}; end
sim = ones(max(f),max(x));
	if (length(varargin) > 2), sim = varargin{3}; end
	
switch (lower(method))
	case{'hough'}
		rbins = 200;
			if (length(varargin) > 3), rbins = varargin{4}; end
		tbins = 180;
			if (length(varargin) > 4), tbins = varargin{5}; end

		if isempty(a)
			accarray	= hough(x,f,rbins,tbins,sim);

			% eliminate all entries not in 0 < theta < 90
			accarray	= accarray(:,1:floor(tbins/2));

			dmax			= norm([max(f) max(x)]);
			[row,col] = find(accarray > (0.9*max(accarray(:))));

			rmax	= (row * dmax) / (rbins-1);
			gamma	= (col * pi) / tbins;

			a		= tan(gamma);
			dt	= rmax ./ cos(gamma);
		else
			[dt,accarray] = houghcon(x,f,a,sim);

			a		= a*(ones(size(dt)));
		end
	case{'ransac'}
		pGood = 0.25;
			if (length(varargin) > 3), pGood = varargin{4}; end
		pFail = 0.001;
			if (length(varargin) > 4), pFail = varargin{5}; end

		ransac(x,f,pGood,pFail);
end
