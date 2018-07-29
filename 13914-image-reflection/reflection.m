%Program for one sided image reflection along a Line
function R = reflection(I,L)
%Author : Jeny Rajan
%I - Image to be Reflected
%L - Line position 
%R - Reflected image 
%eg : R = reflection(I,128);
% L should be between 1 and number of columns
[x y z]=size(I);
R=zeros(x,y,z);
R(:,L+1:y,:)=I(:,1:y-L,:);
R(:,1:L,:)=I(:,L:-1:1,:);
R=uint8(R);
end