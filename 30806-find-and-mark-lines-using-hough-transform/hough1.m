function [ map,theta,rho ] = hough1( bw,mapSz )
%HOUGH1 Do the Hough transform
%   [MAP,THETA,RHO] = HOUGH1(BW,MAPSZ)	BW is the input binary image, MAPSZ
%   is the size of the output MAP, means that the number of bins of rho and
%   theta is MAPSZ(1) and MAPSZ(2). Output MAP(I,J) is the number of points
%   which satisfy RHO(I) = x*sin(THETA(J))+y*cos(THETA(J)), the origin is the
%   bottom-left corner, THETA is in [-90,90).
%		If MAPSZ = [], it will be calculated automatically.

if ~islogical(bw), error('Image should be logical.'); end
imgSz = size(bw);
maxRho = ceil(norm(imgSz-1));
if isempty(mapSz), mapSz = [maxRho,180]; end
rho = (mapSz(1)-.5:-1:.5)*(maxRho*2+1)/mapSz(1) - maxRho;
theta = -90+180/mapSz(2)*(0:mapSz(2)-1);
the = theta/180*pi;
map = zeros(mapSz);

[Y X] = find(bw);
X = X-1;
Y = imgSz(1)-Y;
rho1 = kron(rho',ones(1,mapSz(2)));

for p = 1:size(X)
	r = X(p)*sin(the)+Y(p)*cos(the);
% 	r1 = repmat(r,mapSz(1),1);
	r1 = kron(r,ones(mapSz(1),1));
	[~,nearestRhoIdx] = min(abs(r1-rho1));
	voteIdx = sub2ind(mapSz,nearestRhoIdx,1:mapSz(2));
	map(voteIdx) = map(voteIdx)+1;
end

end