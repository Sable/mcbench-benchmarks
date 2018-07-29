function y=PSNR_RGB(X,Y)
 
% Y= PSNR_RGB(X,Y)
% Computes the Peak Signal to Noise Ratio for two RGB images
% Class input : double [0,1] ,
% july ,25, 2012
% KHMOU Youssef
 
 
 
if size(X)~=size(Y)
    error('The images must have the same size');
end
 
%if ~isa(X,'double') 
%   X=double(X)./255.00;
%end
%if  ~isa(Y,'double')
%    Y=double(Y)./255.00;
%end
 
% begin
d1=max(X(:));
d2=max(Y(:));
d=max(d1,d2);
sigma=mean2((X-Y).^2);
 
y=10*log((d.^2)./sigma);