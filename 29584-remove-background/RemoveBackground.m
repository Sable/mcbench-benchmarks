function [im]=RemoveBackground(I,Ib)
% Ib=background image
% I=input image
% im=background removed image
I1=rgb2gray(I);
Ib1=rgb2gray(Ib);
Id=imsubtract(Ib1,I1);
Id=Id;
Id=bwareaopen(Id,500,8);
Id=imfill(Id,'holes');
BW=Id;
Id=uint8(Id);
[r c]=size(Id);
for i=1:r
    for j=1:c
        if Id(i,j)==255
            Id(i,j)=1;
        end
    end
end
im(:,:,1)=I(:,:,1).*Id;
im(:,:,2)=I(:,:,2).*Id;
im(:,:,3)=I(:,:,3).*Id;

