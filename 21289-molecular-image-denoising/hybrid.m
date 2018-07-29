%% This Matlab file demomstrates a hybrid method that improves quality of
%  Molecular images.
%  The original Paper, "An Improved Hybrid Model for Molecular Image Denoising" 
%  Journal of Mathematical Imaging and Vision(2008)Vol.31 pp. 7379.
% Author: Jeny Rajan, K. Kannan and M.R. Kaimal, all rights reserved.

%% Fourth Order + Relaxed Median Filter Program
% function R=hybrid(I,T)
%% Input arrguments : I - Noisy Image
%                     T - Number of Iterations  (depends on the level of
%                     noise)
%% 
function R=hybrid(I,T)
I=double(I);
epsilon=0.000001;
dt=0.1;
I1=I;
for i = 1:T
    disp(i);
    [Ix,Iy]=gradient(gradient((I1))); 
    c=1./(sqrt(Ix.^2+Iy.^2)+epsilon);
    [div1,div2]=gradient(gradient(c.*Ix));
    [div3,div4]=gradient(gradient(c.*Iy));
    div=div1+div4;
    I2=I1-(dt.*div);
    I2 = rmedian(I2);
    I1=I2;
end;
figure, subplot(1,2,1);imshow(uint8(I),[]);title('Before Process');
subplot(1,2,2);imshow(uint8(I1),[]);title('After Process');
R=uint8(I1);
%% relaxed memdian
function rm=rmedian(im2)
im2=double(im2);
n3=im2;
[x y]=size(im2);
nt=medfilt2(im2,[3 3]);
n1=medfilt2(im2,[3 3]);
n2=medfilt2(im2,[5 5]);
for i=1:x
    for j=1:y
        if (n3(i,j)~=n1(i,j) && (n3(i,j)~=n2(i,j)))
           n3(i,j)=nt(i,j);
        end
    end
end
rm=n3;
%%