%Program for white balancing%
%Author : Jeny Rajan
%usage : W=imbalance(im) 
%im is the color image array to be corrected.
function W=wbalance(im)
im2=im;
im1=rgb2ycbcr(im);
Lu=im1(:,:,1);
Cb=im1(:,:,2);
Cr=im1(:,:,3);
[x y z]=size(im);
tst=zeros(x,y);
Mb=sum(sum(Cb));
Mr=sum(sum(Cr));
Mb=Mb/(x*y);
Mr=Mr/(x*y);
Db=sum(sum(Cb-Mb))/(x*y);
Dr=sum(sum(Cr-Mr))/(x*y);
cnt=1;    
for i=1:x
    for j=1:y
         b1=Cb(i,j)-(Mb+Db*sign(Mb));
         b2=Cr(i,j)-(1.5*Mr+Dr*sign(Mr));
        if (b1<(1.5*Db) & b2<(1.5*Dr))
            Ciny(cnt)=Lu(i,j);
            tst(i,j)=Lu(i,j);
            cnt=cnt+1;
        end
    end
end
 cnt=cnt-1;
 iy=sort(Ciny,'descend');
 nn=round(cnt/10);
 Ciny2(1:nn)=iy(1:nn);
 mn=min(Ciny2);
 c=0;
 for i=1:x
     for j=1:y
         if tst(i,j)<mn
             tst(i,j)=0;
         else
             tst(i,j)=1;
             c=c+1;
         end
     end
 end
 R=im(:,:,1);
 G=im(:,:,2);
 B=im(:,:,3);
 R=double(R).*tst;
 G=double(G).*tst;
 B=double(B).*tst;
 Rav=mean(mean(R));
 Gav=mean(mean(G));
 Bav=mean(mean(B));
 Ymax=double(max(max(Lu)))/15;
 Rgain=Ymax/Rav;
 Ggain=Ymax/Gav;
 Bgain=Ymax/Bav;
 im(:,:,1)=im(:,:,1)*Rgain;
 im(:,:,2)=im(:,:,2)*Ggain;
 im(:,:,3)=im(:,:,3)*Bgain;
 W=im;
 figure,imshow(im2,[]),title('Original Image');
 figure,imshow(im,[]),title('Corrected Image'); 

