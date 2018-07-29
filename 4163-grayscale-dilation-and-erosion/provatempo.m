clear;
pack;
clear;
xx=1000;
yy=1000;
im=double(round(2^4*rand(xx,yy)));
%im=uint8(round(2^8*rand(xx,yy)));
%im=uint16(round(2^16*rand(xx,yy)));
%im=uint32(round(2^32*rand(xx,yy)));
im=repmat(im,1,1);

sex=3;
sey=3;
se=logical(round(rand(sex,sey)));
se=strel('diamond',15);


%-------------------------------
tic;out2=imdilate(im,se);t2=toc

tic;out3=graydil(im,se);t3=toc
%-------------------------------
nnz(double(out2)-double(out3))

%rapporto=t2/t3

%-------------------------------
tic;out2=imerode(im,se);t2=toc

tic;out3=grayero(im,se);t3=toc
%-------------------------------
nnz(double(out2)-double(out3))
disp('nnz may be different from zero if the element is equal to inf or to -inf');
%rapporto=t2/t3

