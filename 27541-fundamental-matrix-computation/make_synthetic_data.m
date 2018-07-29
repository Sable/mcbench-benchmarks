% function [x1,x2,P1,P2] = make_synthetic_data(N,range_model,range_image,verbose)
% makes a synthetic 3D model and makes two projective images of the model
% using arbitrary projective cameras Pi=[M|t]. The second cameras are normalized
% to Pi = Pi / Pi_{34}.
% inputs:      
%               N               1x1     (optional) the maximum number of correspondences to generate. 
%               range_model     2x1     (optional) defines a bounding box (starting from origin) containing the model
%               range_image     2x1     (optional) the size of the output image(scaling on correspondences)
%               verbose         1x1     (optional) plots the generated model and images
% outputs:
%               x1              3x1     homogeneous coordinates of the correspondences in image 1
%               x2              3x1     homogeneous coordinates of the correspondences in image 2
%               P1              3x4     the camera that generates x1(up to an affine transformation)
%               P2              3x4     the camera that generates x2(up to an affine transformation)
% 
% Author: Omid Aghazadeh, KTH(Royal Institute of Technology), 2010/05/09
function [x1,x2,P1,P2] = make_synthetic_data(N,range_model,range_image,verbose)
if nargin < 1, N = 100; end
if nargin < 2, range_model = [10;10;10]; end
if nargin < 3, range_image = [640;480]; end
if nargin < 4, verbose = 1; end
X = rand(3,N); X = (X - repmat(min(X,[],2),1,N)) .* repmat(range_model ./ (max(X,[],2) - min(X,[],2)),1,N);
X = [X; ones(1,N)];
P1 = rand(3,4); P1(end) = 1;
P2 = rand(3,4); P2(end) = 1; %avoid cameras at infinity
x1 = P1*X; x1 = x1./repmat(x1(3,:),3,1); x2 = P2*X; x2 = x2./repmat(x2(3,:),3,1); 
ixinv = sum(isinf(x1) | isnan(x1) | isinf(x2) | isnan(x2) | abs(x1) > 1e3 | abs(x2) > 1e3,1 )>0 ;
x1 = x1(:,~ixinv); x2 = x2(:,~ixinv); N = size(x1,2);
x1 = (x1-repmat([min(x1(1:2,:),[],2);0],1,N)).* repmat([range_image./(max(x1(1:2,:),[],2) - min(x1(1:2,:),[],2));1],1,N); 

x2 = (x2-repmat([min(x2(1:2,:),[],2);0],1,N)).* repmat([range_image./(max(x2(1:2,:),[],2) - min(x2(1:2,:),[],2));1],1,N); 
if verbose
    figure(1); subplot(1,3,1); plot3(X(1,:),X(2,:),X(3,:),'b.'); title('generated 3D model');
    subplot(1,3,2); plot(x1(1,:),x1(2,:),'rx'); title('generated first image');
    subplot(1,3,3); plot(x2(1,:),x2(2,:),'gx'); title('generated second image');
end
end