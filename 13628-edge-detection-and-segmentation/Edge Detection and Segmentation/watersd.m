% Question No: 8
% Consider a binary image composed of small blobs. Segmenting the circular
% blobs using 
%   a) Distance Transform
%   b) Watershed Transform

function watersd(x)
f=imread(x);
bw=im2bw(f,graythresh(f));
bwc=~bw;
dst=bwdist(bwc);
ws=watershed(-dst);
w=ws==0;
rf=bw&~w;
figure,imshow(f),title('Original Image');
figure,imshow(bw),title('Negative Image');
figure,imshow(ws),title('Watershed - Distance Transform');
figure,imshow(rf),title('Superimposed - Watershed and original image');

h=fspecial('sobel');
fd=im2double(f);
sq=sqrt(imfilter(fd,h,'replicate').^2+imfilter(fd,h','replicate').^2);
sqoc=imclose(imopen(sq,ones(3,3)),ones(3,3));
wsd=watershed(sqoc);
wg=wsd==0;
rfg=f;
rfg(wg)=255;
figure,imshow(wsd),title('Watershed - Gradient');
figure,imshow(rf),title('Superimposed - Watershed and original image');

im=imextendedmin(f,20);
Lim=watershed(bwdist(im));
figure,imshow(Lim),title('Watershed - Marker Controlled');
em=Lim==0;
rfmin=imimposemin(sq,im|em);
wsdmin=watershed(rfmin);
figure,imshow(rfmin),title('Watershed - Gradient and Marker Controlled');
rfgm=f;
rfgm(wsdmin==0)=255;
figure,imshow(rfgm),title('Superimposed - Watershed (GM) and original image');
end