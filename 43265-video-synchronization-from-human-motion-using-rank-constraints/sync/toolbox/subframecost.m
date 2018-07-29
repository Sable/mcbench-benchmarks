function C = subframecost(params,ref,tgt,cons,varargin)
% function C = subframecost(params,ref,tgt,cons,{projprojmodell})
%
% Compute sub-frame cost of synchronization parameters

% read in variable arguments
projmodel	= 'affine';
	if (length(varargin) > 0), projmodel	= varargin{1}; end

% extract beta and dt from params/cons
dt = params(1);
if isempty(cons),	a = params(2);
else,							a = cons(1);
end

% initialize some variables
npoints = size(ref,2) / 2;
nref		= size(ref,1);
ntgt		= size(tgt,1);

% compute corresponding target frames and mask out those out of range
fref	= 1:nref;
ftgt	= (a*fref) + dt;
mask	= (ftgt >= 1) & (ftgt <= size(tgt,1));

% if all frames are out of range then return infinite cost
if ~any(mask)
	C = inf; return
end

fref	= fref(mask);
ftgt	= ftgt(mask);

% compute sub-frame match cost over reference sequence
Cvec		= zeros(length(fref),1);

onevec	= ones(1,npoints);
zerovec	= zeros(1,3);
A				= [];

for f = 1:length(fref)
	refvec 	= reshape(ref(fref(f),:)',2,npoints);

	% interpolate frames of target sequence
	beta	 	= rem(ftgt(f),1);
	tgtvec 	= (1-beta)*reshape(tgt(floor(ftgt(f)),:),2,npoints) + ...
							(beta)*reshape(tgt(ceil(ftgt(f)),:),2,npoints);

	switch (projmodel)
		case{'affine'}
			A 	= [	refvec;
							tgtvec ];
			s 	= svd(A,0);	Cvec(f)	= s(4)*s(4);

		case{'fund','perspective'}
			x1	= [refvec; onevec];
			x2	= [tgtvec; onevec];
			A		= [	x1(1,:).*x2(1,:); x1(1,:).*x2(2,:); x1(1,:).*x2(3,:);
							x1(2,:).*x2(1,:); x1(2,:).*x2(2,:); x1(2,:).*x2(3,:);
							x1(3,:).*x2(1,:); x1(3,:).*x2(2,:); x1(3,:).*x2(3,:) ]';
			s		= svd(A,0);	Cvec(f)	= s(9)*s(9);

		case{'homog','homography'}
			x1	= [refvec; onevec];
			x2	= [tgtvec; onevec];
			row = 1;
			for p = 1:npoints
				a = x1(:,p)*x2(:,p)';
				A(row:row+1,:)	= [	zerovec		-a(3,:)		a(2,:);
														a(3,:)		zerovec		-a(1,:)];
				row = row + 2;
			end
			s		= svd(A,0);	Cvec(f)	= s(9)*s(9);
	end
end

% use mean to allow number of frames considered to vary
C = mean(Cvec);
