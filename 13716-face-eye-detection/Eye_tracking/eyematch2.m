function nframe=eyematch2(frame,thresh,template,template2);

% ----------- Template Matching --------------- %
% frame  :           Face including image
% thresh :           Threshold for eye region seperation
% template:          Right eye template
% template2:         Left eye template
%
% eyematch2(I,.8,temp_Rgh,temp_Lft);
%
% Mustafa UÇAK
% Yeditepe University Electronics Faculty MSc.
% mucak@netbulmail.com

[face_a,skin_region]=face(frame);

im1 = double(rgb2gray(face_a));
img=im1-mean(mean(im1));
template=template-mean(mean(template));
template2=template2-mean(mean(template2));

C=normxcorr2(template,img);
C2=normxcorr2(template2,img);

Csub = C((size(template,1)-1)/2+1:size(img,1)-1,(size(template,2)-1)/2+1:size(img,2)-1);
% figure;
Csub2 = C2((size(template,1)-1)/2+1:size(img,1)-1,(size(template,2)-1)/2+1:size(img,2)-1);
% figure;
% imshow(Csub, []), pixval;

BW1 = Csub;
BW1(find(BW1<thresh))=0;
BW1(find(BW1>thresh))=1;
% figure, imshow(BW);
BW2 = Csub2;
BW2(find(BW2<thresh))=0;
BW2(find(BW2>thresh))=1;

BW=BW1+BW2;

[L,n] = bwlabel(BW);
stats = regionprops(L, 'centroid');
% Draw an asterisk 

figure(1);imshow(frame);
centroids = cat(1, stats.Centroid);

hold on
plot(centroids(:,1), centroids(:,2), 'r*');
hold off