function [accarray,tr,yr] = hough(x,y,varargin)
% function [accarray,theta,yr] = hough(x,y,{rbins,thetabins,sim})

	accarray	= [];
	
	nargchk(2,5,nargin);
	switch (length(varargin))
		case{0}
			rbins			= 200;
			thetabins	= 180;
			sim				= ones(max(y),max(x));
		case{1}
			rbins			= varargin{1};
			thetabins	= 180;
			sim				= ones(max(y),max(x));
		case{2}
			rbins			= varargin{1};
			thetabins	= varargin{2};
			sim				= ones(max(y),max(x));
		case{3}
			rbins			= varargin{1};
			thetabins	= varargin{2};
			sim				= varargin{3};
	end
		
	ord				= 0:thetabins-1;
	
%	theta			= (ord / thetabins) * 180 * pi/180;
	theta			= (ord * pi) / thetabins;
	sintheta	= sin(theta);

	dmax			= norm([max(x) max(y)]);
	accarray	= zeros(rbins,thetabins);
	
	for p = 1:length(x)
		d 	= norm([x(p) y(p)]) / dmax;
		phi	= atan2(y(p),x(p));
		
%		phi_ind	= round((phi * 180/pi) / 180 * thetabins);
		phi_ind	= round((phi * thetabins) / pi);
		
		r			= d * [sintheta(phi_ind:-1:1) sintheta(end:-1:phi_ind+1)];
		
		coord	= round((rbins-1)*r)+1;
		inds	= sub2ind(size(accarray),coord,ord+1);
		
		accarray(inds) = accarray(inds) + sim(y(p),x(p));
	end

	tr	= [1:thetabins] * pi/180;
	yr	= linspace(0,dmax,rbins);
