function msim = oneframe(ref,tgt,varargin)

msim = [];

nargchk(2,3,nargin);
mode = 'affine';
	if length(varargin)>0, mode = lower(varargin{1}); end

npoints = size(ref,2) / 2;
nref		= size(ref,1);
ntgt		= size(tgt,1);

switch lower(mode)
	case{'fund','perspective','homog','homography'},
		scale	= sqrt(mean(ref.^2,2).^-1);
		ref		= scale(:,ones(1,size(ref,2))) .* ref;
		scale	= sqrt(mean(tgt.^2,2).^-1);
		tgt		= scale(:,ones(1,size(tgt,2))) .* tgt;
end

msim	= zeros(ntgt,nref);

for fref = 1:nref
	refvec 	= reshape(ref(fref,:),2,npoints);

	for ftgt = 1:ntgt
		tgtvec 	= reshape(tgt(ftgt,:),2,npoints);

		switch (mode)
			case{'affine'}
				s 	= svd([refvec; tgtvec],0);
				msim(ftgt,fref)	= s(4);
				
			case{'fund','perspective'}
				x1	= [refvec; ones(1,npoints)];
				x2	= [tgtvec; ones(1,npoints)];
				A		= [	x1(1,:).*x2(1,:); x1(1,:).*x2(2,:); x1(1,:).*x2(3,:);
								x1(2,:).*x2(1,:); x1(2,:).*x2(2,:); x1(2,:).*x2(3,:);
								x1(3,:).*x2(1,:); x1(3,:).*x2(2,:); x1(3,:).*x2(3,:)]';
				s		= svd(A,0);
				msim(ftgt,fref)	= s(9);
				
			case{'homog','homography'}
				x1	= [refvec; ones(1,npoints)];
				x2	= [tgtvec; ones(1,npoints)];
				row	= 1;
				A		= zeros(2*npoints,9);
				for p = 1:npoints
					a	= [0 -x1(3,p) x1(2,p); x1(3,p) 0 -x1(1,p)];
					A(row:row+1,:)	= kron(a,x2(:,p)');
					row = row + 2;
				end
				s		= svd(A,0);
				msim(ftgt,fref)	= s(9);
		end
	end
end

msim	= msim.^2;

