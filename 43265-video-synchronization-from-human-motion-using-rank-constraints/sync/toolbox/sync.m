function [a,dt,sim,newtgt] = sync(ref,tgt,varargin)
% function [a,dt,sim,newtgt] = sync(ref,tgt,{alpha,mode,wnd,noise})

	a 	= [];
	dt 	= [];
	sim	= [];
	
	error(nargchk(2,6,nargin));
	switch (length(varargin))
		case{0}
			alpha	= [];
			mode	= 'affine';
			[nref,ntgt] = preprocess(ref,tgt);			
		case{1}
			alpha = varargin{1};
			mode	= 'affine';
			[nref,ntgt] = preprocess(ref,tgt);			
		case{2}
			alpha = varargin{1};
			mode	= varargin{2};
			[nref,ntgt] = preprocess(ref,tgt);			
		case{3}
			alpha = varargin{1};
			mode	= varargin{2};
			[nref,ntgt] = preprocess(ref,tgt,varargin{3});
		case{4}
			alpha = varargin{1};
			mode	= varargin{2};
			[nref,ntgt] = preprocess(ref,tgt,varargin{3},varargin{4});
	end
	
	sim			= oneframe(nref,ntgt,mode);
	[x,f]		= findmins(sim);
	[a,dt]	= fitline(x,f,alpha);

	if (length(alpha) == 0)
		[a,dt] 	= refine([dt(:),a(:)],nref,ntgt,[],mode);
	else
		[a,dt] 	= refine([dt(:)],nref,ntgt,[a(:)],mode);
	end
	
	if (nargout > 3)
		newtgt	= zeros(size(tgt));
		
		npoints = size(ref,2) / 2;
		refmax	= size(ref,1);
		tgtmax	= size(tgt,1);
		newtgt	= zeros(size(ref));

		for fref = 1:refmax
			ftgt		= (a*fref) + dt;
			ftgt		= min(max(ftgt,1),size(tgt,1));
			f1 			= tgt(floor(ftgt),:);
			f2 			= tgt(ceil(ftgt),:);
			alpha 	= rem(ftgt,1);
		
			newtgt(fref,:) 	= (1-alpha)*f1 + (alpha)*f2;
		end
	end
