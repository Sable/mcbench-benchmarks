function h=demirel(im,thr,T)
%h=demirel(im,thr);
%im is an input image, thr is a threshold between 0-1, T is the thickness 
%of the line to indicate the edge.
%h is an uint8 balck and white image with values of 0 and 255.
%This programme has been written by me, G. Anbarjafari (Shahab) months ago
%but finalized today 17-11-2008.
%(c) Demirel and Anbarjafari - 2008

[sx,sy,sz]=size(im);

if sz~=1
    im1=not(im2bw(rgb2gray(im),thr));
else
    im1=not(im2bw(im,thr));
end

SZ=2*T+1;
X=zeros(SZ,SZ);
X((SZ+1)/2,:)=ones(1,SZ);
X(:,(SZ+1)/2)=ones(SZ,1);
X((SZ+1)/2,(SZ+1)/2)=2;
Q = filter2(X,im1);
Q([find(Q<1)])=0;
Q([find(Q>0)])=1;

h=uint8(abs(double(Q)-double(im1))*255);
