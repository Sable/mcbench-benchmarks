function [ X2 Y2 ] = LKTrack1( img1, img2, X1, Y1 )

winR = 5;
th = .01;
maxIter = 20;

if ~all(size(img2) == size(img1))
	error('image sizes are not the same!');
end
[M N] = size(img1);

h = fspecial('sobel');
img1x = imfilter(img1,h','replicate');
img1y = imfilter(img1,h,'replicate');

ptNum = size(X1,1);
X2 = X1;
Y2 = Y1;

for p = 1:ptNum
	xt = X2(p);
	yt = Y2(p);
	l = xt-winR;
	t = yt-winR;
	r = xt+winR;
	b = yt+winR;
	[iX,iY] = meshgrid(l:r,t:b);
	fl = max(1,floor(l));
	ft = max(1,floor(t));
	cr = min(N,ceil(r));
	cb = min(M,ceil(b));
	Ix = interp2(fl:cr,ft:cb,img1x(ft:cb,fl:cr),iX,iY);
	Iy = interp2(fl:cr,ft:cb,img1y(ft:cb,fl:cr),iX,iY);
	I1 = interp2(fl:cr,ft:cb,img1(ft:cb,fl:cr),iX,iY);
	for q = 1:maxIter
		l = xt-winR;
		t = yt-winR;
		r = xt+winR;
		b = yt+winR;
		[iX,iY] = meshgrid(l:r,t:b);
		fl = max(1,floor(l));
		ft = max(1,floor(t));
		cr = min(N,ceil(r));
		cb = min(M,ceil(b));

		It = interp2(fl:cr,ft:cb,img2(ft:cb,fl:cr),iX,iY)-I1;
		
		vel = [Ix(:),Iy(:)]\It(:);
		xt = xt+vel(1);
		yt = yt+vel(2);
		if max(abs(vel))<th, break; end
	end
	X2(p) = xt;
	Y2(p) = yt;
end

