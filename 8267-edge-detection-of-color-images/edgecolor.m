%Finding edges of a color image
%Authors : Jeny Rajan, Chandrashekar P.S 
%Usage edgecolor('abc.jpg');
function R=edgecolor(nm);
img=imread(nm);
[x y z]=size(img);
if z==1
    rslt=edge(img,'canny');
elseif z==3
    img1=rgb2ycbcr(img);
    dx1=edge(img1(:,:,1),'canny');
    dx1=(dx1*255);
    img2(:,:,1)=dx1;
    img2(:,:,2)=img1(:,:,2);
    img2(:,:,3)=img1(:,:,3);
    rslt=ycbcr2rgb(uint8(img2));
end
R=rslt;
