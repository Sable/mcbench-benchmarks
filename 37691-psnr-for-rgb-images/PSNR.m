function y=PSNR(noisyImage,restoredImage)
 
% Compute the PSNR of two gray scale image
% Traditional progarmming using loops 
% Class input : [0,1] 
% july, 25 , 2012
% KHMOU Youssef
 
N=size(noisyImage);
if length(N)> 2
    error('Input must be grayscale image');
end
if size(noisyImage)~=size(restoredImage)
    error('The images must have the same size');
end
 
%if ~isa(noisyImage,'double') 
%   noisyImage=double(noisyImage)./255.00;
%end
%if  ~isa(restoredImage,'double')
%    restoredImage=double(restoredImage)./255.00;
%end
 
% begin
 
d1=max(noisyImage(:));
d2=max(restoredImage(:));
d=max(d1,d2);

MSE=0;
for i=1:N(1)
    for j=1:N(2)
        if isnan(noisyImage(i,j)) || isinf(restoredImage(i,j))...
                || isnan(restoredImage(i,j)) || isinf(noisyImage(i,j))
            continue;
        end
        MSE=MSE+((abs(noisyImage(i,j)-restoredImage(i,j))).^2);
    end
end
 
MSE=MSE./(N(1)*N(2));
 
y=10*log10((d.^2) /MSE)
