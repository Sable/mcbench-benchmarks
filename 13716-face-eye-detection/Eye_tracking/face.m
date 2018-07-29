% function [face,skin_region]=face(I);
% 
% skin_region=skin(I);
% 
% se = strel('disk',3);
% dil = imdilate(skin_region,se);        % morphologic dilation
% d2 = imfill(dil, 'holes');   % morphologic fill
% face = bwdist(~d2);            % computing minimal euclidean distance to non-white pixel 
% figure;imshow(face,[]);

function [face_a,skin_region]=face(I);

skin_region=skin(I);

se = strel('disk',5);
se2 = strel('disk',3);
er = imerode(skin_region,se2);
cl = imclose(er,se);
dil = imdilate(cl,se);        % morphologic dilation
dil = imdilate(dil,se); 
cl2 = imclose(dil,se);
d2 = imfill(cl2, 'holes');   % morphologic fill
facearea = bwdist(~d2);            % computing minimal euclidean distance to non-white pixel 
% figure;imshow(facearea,[]);

% imshow(d2);
face(:,:,1)=double(I(:,:,1)).*d2;   
face(:,:,2)=double(I(:,:,2)).*d2; 
face(:,:,3)=double(I(:,:,3)).*d2; 
face_a=uint8(face);
% figure;imshow(face_a);
