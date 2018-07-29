function msim = matchcost(ref,tgt,varargin)
% function msim = matchcost(ref,tgt,{projmodel})
%
% Compute the cost for each pair of frames from sequences ref and tgt.

% read in variable arguments
projmodel = 'affine';
	if (length(varargin)>0), projmodel = lower(varargin{1}); end

% initialize some variables and cost surface
nref		= size(ref,1);
ntgt		= size(tgt,1);
npoints = size(ref,2) / 2;
msim		= zeros(ntgt,nref);

% preprocess feature trajectories
newref	= zeros(2,npoints,nref);
	for f = 1:nref, newref(:,:,f) = reshape(ref(f,:),[2,npoints]); end
newtgt	= zeros(2,npoints,ntgt);
	for f = 1:ntgt, newtgt(:,:,f) = reshape(tgt(f,:),[2,npoints]); end
	
onevec	= ones(1,npoints);
zerovec	= zeros(1,3);
A				= [];

% compute match cost for every pairing of frames
for fref = 1:nref
	for ftgt = 1:ntgt
		switch (projmodel)
			case{'affine'}
				A 	= [	newref(:,:,fref);
								newtgt(:,:,ftgt) ];
				s 	= svd(A,0);	msim(ftgt,fref)	= s(4)*s(4);
				
			case{'fund','perspective'}
				x1	= [newref(:,:,fref); onevec];
				x2	= [newtgt(:,:,ftgt); onevec];
				A		= [	x1(1,:).*x2(1,:); x1(1,:).*x2(2,:); x1(1,:).*x2(3,:);
								x1(2,:).*x2(1,:); x1(2,:).*x2(2,:); x1(2,:).*x2(3,:);
								x1(3,:).*x2(1,:); x1(3,:).*x2(2,:); x1(3,:).*x2(3,:) ]';
				s		= svd(A,0);	msim(ftgt,fref)	= s(9)*s(9);
				
			case{'homog','homography'}
				x1	= [newref(:,:,fref); onevec];
				x2	= [newtgt(:,:,ftgt); onevec];
				row = 1;
				for p = 1:npoints
					a = x1(:,p)*x2(:,p)';
					A(row:row+1,:)	= [	zerovec		-a(3,:)		a(2,:);
															a(3,:)		zerovec		-a(1,:)];
					row = row + 2;
				end
 				s		= svd(A,0);	msim(ftgt,fref)	= s(9)*s(9);
		end
	end
end

