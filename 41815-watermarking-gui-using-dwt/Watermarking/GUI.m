clc;
clear all;
warning off;
chos=0;
possibility=11;

while chos~=possibility,
    chos=menu('Digital 3-level image watermarking','select the cover image','select the watermark image','show 3-level coverimage','show 3-level watermarkimage','show watermarked image','show extracted image','Calculate MSE for embedding','Calculate PSNR for embedding','Calculate MSE for extraction','Calculate PSNR for extraction','exit');
    if chos==1
        [fname pname]=uigetfile('*.jpg','select the Cover Image');
        %eval('imageinput=imread(fname)');
        imageinput=imread(fname);
        

A=rgb2gray(imageinput);
P1=im2double(A);
P=imresize(P1,[2048 2048]);
%imshow(P);
%figure(1);
%title('original image');

[F1,F2]= wfilters('haar', 'd');
[LL,LH,HL,HH] = dwt2(P,'haar','d');
[LL1,LH1,HL1,HH1] = dwt2(LL,'haar','d');
[LL2,LH2,HL2,HH2] = dwt2(LL1,'haar','d');
%figure(2)
%imshow(LL2,'DisplayRange',[]), title('3 level dwt of cover image');
    end
    if chos==2
    [fname pname]=uigetfile('*.jpg','select the Watermark');
    %eval('imageinput=imread(fname)');
    %imageinput=imread(fname);
    imw2=imread(fname);
    imw=rgb2gray(imw2);
watermark=im2double(imw);
watermark=imresize(watermark,[2048 2048]);
%figure(3)
%imshow(uint8(watermark));title('watermark image')
[WF1,WF2]= wfilters('haar', 'd');
[L_L,L_H,H_L,H_H] = dwt2(watermark,'haar','d');
[L_L1,L_H1,H_L1,H_H1] = dwt2(L_L,'haar','d');
[L_L2,L_H2,H_L2,H_H2] = dwt2(L_L1,'haar','d');
%figure(4)
%imshow(L_L2,'DisplayRange',[]), title('3 level dwt of watermark image');
    end
    if chos==3
        imshow(LL2,'DisplayRange',[]), title('3 level dwt of cover image')
    end
    if chos==4
        imshow(L_L2,'DisplayRange',[]), title('3 level dwt of watermark image')
    end
    if chos==5
        Watermarkedimage=LL2+0.0001*L_L2;



%computing level-1 idwt2
Watermarkedimage_level1= idwt2(Watermarkedimage,LH2,HL2,HH2,'haar');
%figure(5)
%imshow(Watermarkedimage_level1,'DisplayRange',[]), title('Watermarkedimage level1');

%computing level-2 idwt2
Watermarkedimage_level2=idwt2(Watermarkedimage_level1,LH1,HL1,HH1,'haar');
%figure(6)
%imshow(Watermarkedimage_level2,'DisplayRange',[]), title('Watermarkedimage level2');


%computing level-3 idwt2
Watermarkedimage_final=idwt2(Watermarkedimage_level2,LH,HL,HH,'haar');
%figure(7)
imshow(Watermarkedimage_final,'DisplayRange',[]), title('Watermarkedimage final')
    end
    if chos==6
        [F11,F22]= wfilters('haar', 'd');
[a b c d]=dwt2(Watermarkedimage_final,'haar','d');
[aa bb cc dd]=dwt2(a,'haar','d');
[aaa bbb ccc ddd]=dwt2(aa,'haar','d');

recovered_image=aaa-LL2;
%figure(8)
imshow(recovered_image,[]);
%title('extracted watermark')
    end
   if chos==7
       
        pic1= P;
    pic2= Watermarkedimage_final;
       mse=MSE(pic1,pic2)
   end
       if chos==8
            pic1= P;
    pic2= Watermarkedimage_final;
psnr=PSNR(pic1,pic2)
       end
       if chos==9
           clear pic1;
           clear pic2;
           pic1=L_L2;
           pic2=recovered_image;
           mse_extraction=MSE(pic1,pic2)
       end
           if chos==10
           psnr_extraction=PSNR(pic1,pic2)
           end
end


