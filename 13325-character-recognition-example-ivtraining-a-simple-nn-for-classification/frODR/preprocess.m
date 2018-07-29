function img = preprocess(I,selected_col,selected_ln)

Igray = rgb2gray(I);
Ibw = im2bw(Igray,graythresh(Igray));
Iedge = edge(uint8(Ibw));
se = strel('square',3);
Iedge2 = imdilate(Iedge, se); 
Ifill= imfill(Iedge2,'holes');
[Ilabel num] = bwlabel(Ifill);
Iprops = regionprops(Ilabel);
Ibox = [Iprops.BoundingBox];
[y,x]=size(Ibox);
x=x/4;
Ibox = reshape(Ibox,[4 x]);%
Ic = [Iprops.Centroid];
[z,w]=size(Ic);%
w=w/2;%
Ic = reshape(Ic,[2 w]);%
Ic = Ic';
Ic(:,3) = (mean(Ic.^2,2)).^(1/2);
Ic(:,4) = 1:w;%
Ic2 = sortrows(Ic,2);
for cnt = 1:selected_ln
   Ic2((cnt-1)*selected_col+1:cnt*selected_col,:) = sortrows(Ic2((cnt-1)*selected_col+1:cnt*selected_col,:),4);
end
Ic3 = Ic2(:,1:2);
ind = Ic2(:,4);
for cnt = 1:selected_ln*selected_col
    img{cnt} = imcrop(Ibw,Ibox(:,ind(cnt)));
end