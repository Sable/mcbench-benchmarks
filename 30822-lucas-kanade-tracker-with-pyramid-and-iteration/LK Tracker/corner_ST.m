function [ r c ] = corner_ST( img,ptNum )
%[ r c ] = corner_ST( img )
%	Find corner points in image using Shi-Tomasi method
%   IMG should be gray.R and C are the coordinates of corners(col vec)

img = im2double(img);
h1 = fspecial('gauss',[6 6],1.5);
hd = imfilter(h1,[-1 1],'rep');
hd = hd(1:5,1:5); % use the HOG gradient
% hd = [-1 0 1];
imgdx = imfilter(img,hd,'rep');
imgdy = imfilter(img,hd','rep');

ker = fspecial('gauss',[5 5],1.5); % weight of the patch
imgdx2 = imfilter(imgdx.^2,ker,'rep');
imgdxdy = imfilter(imgdx.*imgdy,ker,'rep');
imgdy2 = imfilter(imgdy.^2,ker,'rep');

A = zeros(2,2,numel(img));
A(1,1,:) = imgdx2(:);
A(1,2,:) = imgdxdy(:);
A(2,1,:) = imgdxdy(:);
A(2,2,:) = imgdy2(:);
ev = real(eig2(A));

evTh = .1;
minEv = min(ev,[],2);
minEv = reshape(minEv,size(img));
R = (minEv > evTh*max(max(minEv)));
% fis(R)

Rmax = ordfilt2(minEv,9,ones(3));
Rcorner = (minEv == Rmax) & R; % non-maximal suppression
% fis(Rcorner)
I = find(Rcorner);

if exist('ptNum','var') && nnz(Rcorner) > ptNum
	selEvs = minEv(I); % find the ptNum corners with the largest ev
	[~,I1] = sort(selEvs,'descend');
	I = I(I1(1:ptNum));
end
[r c] = ind2sub(size(img),I); % points' positions

end

function ev = eig2(a) % eigenvalue of a 2*2 matrix
b = -(a(1,1,:)+a(2,2,:));
detA = a(1,1,:).*a(2,2,:)-a(1,2,:).*a(2,1,:);
delta = b.^2-4*detA;
ev = [-b+sqrt(delta),-b-sqrt(delta)]/2; 
ev = reshape(ev,2,[])'; % N-by-2
end