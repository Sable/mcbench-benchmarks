function nframe=eyematch(frame,thresh,template);

[face_a,skin_region]=face(frame);

im1 = double(rgb2gray(face_a));
img=im1-mean(mean(im1));
template=template-mean(mean(template));

C=normxcorr2(template,img);
Csub = C((size(template,1)-1)/2+1:size(img,1)-1,(size(template,2)-1)/2+1:size(img,2)-1);
figure;
% imshow(Csub, []), pixval;

BW = Csub;
BW(find(BW<thresh))=0;
BW(find(BW>thresh))=1;
% figure, imshow(BW);

[L,n] = bwlabel(BW);
stats = regionprops(L, 'centroid');
% Draw an asterisk 

figure(1);imshow(frame);
centroids = cat(1, stats.Centroid);
hold on
plot(centroids(:,1), centroids(:,2), 'r*');
hold off
