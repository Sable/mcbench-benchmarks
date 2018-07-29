
%
%      JAWAHARLAL NEHRU TECHNOLOGICAL UNIVERSITY
%
%
%
%

clear;
clc;
clear all; 
close all;
display('           ');
display('           ');

display('           ');
display('               SOME EXPERIMENTS ON IMAGE DENOISING USING WAVELETS ');

display('           ');
display('           ');
display('         RAJA RAO           ');

display('           ');
display('           ');

display('select the image');

display('           1:lena.png');
display('           2:barbara.png');
display('           3:boat.png');
display('           4:house.png');
display('           5:peppers256.png');
display('           6:cameraman.jpg');
display('           ');
display('           7:hyderabad.png');
display('           8:friendgray.jpg');
display('           ');


ss1=input('enter your choice:   ');
switch ss1
    case 1
       f=imread('lena.png');
       %f=imread('babu.jpg');
    case 2
        f=imread('barbara.png');
    case 3
        f=imread('boat.png');
    case 4
        f=imread('house.png');
        case 5
        f=imread('peppers256.png');
    case 6
        f=imread('cameraman.jpg');
    case 7
        f=imread('hyderabad512.png');
    case 8
        f=imread('friendgray.jpg');               
end

subplot(2,2,1), imshow(f);title('original image');

display('enter the type of noise:');
display('    1    for salt & pepper');
display('    2    for gaussian');    
display('    3    for poisson');
display('    4    for speckle');

ud=input('enter the value:');

switch ud
    case 1
        display('enter the % of noise(Ex:0.2)');
        ud1=input('pls enter:     ');
        g=imnoise(f,'salt & pepper',ud1);
    case 2
    
    
%f=imread('peppers256.png');
%subplot(2,2,1),imshow(f);
display('enter the noise varience:  ');
va=input('enter between 0.01 to 0.09:   ');
g=imnoise(f,'gaussian',0,va);
    case 3
       % display('enter the % of noise(Ex:0.2)');
        %ud1=input('pls enter:     ');
        g=imnoise(f,'poisson');
        case 4
        display('enter the varience of noise(Ex:0.02)');
        ud1=input('pls enter:     ');
        g=imnoise(f,'speckle',ud1);
    
    
end
%g=imnoise(f,'salt & pepper',01);
subplot(2,2,2),imshow(g);title('noisy image');


%[ca,ch,cv,cd] = dwt2(g,'db2');
%c=[ca ch;cv cd];
%subplot(2,2,3),imshow(uint8(c));

x=g;
% Use wdencmp for image de-noising. 
% find default values (see ddencmp). 
[thr,sorh,keepapp] = ddencmp('den','wv',x);
display('');
display('select wavelet');
display('enter 1 for haar wavelet');
display('enter 2 for db2 wavelet');
display('enter 3 for db4 wavelet');
display('enter 4 for sym wavelet');
display('enter 5 for sym wavelet');
display('enter 6 for bior wavelet');
display('enter 7 for bior wavelet');
display('enter 8 for mexh wavelet');
display('enter 9 for coif  wavelet');
display('enter 10 for meyr wavelet');
display('enter 11 for morl wavelet');
display('enter 12 for  rbio wavelet');
display('press any key to quit');
display('');

ww=input('enter your choice:    ');
switch ww
    case 1
        wv='haar';
    case 2
        wv='db2';
    case 3
        wv='db4' ; 
    case 4
        wv='sym2'
    case 5
        wv='sym4';
    case 6
        wv='bior1.1';
    case 7
       wv='bior6.8'; 
    case 8
        wv='mexh';
    case 9
        wv='coif5';
    case 10
        wv='dmey';
    case 11
        wv='mor1';
    case 12 
        wv='jpeg9.7';
    otherwise 
        quit;
end
display('');
display('enter 1 for soft thresholding');
display('enter 2 for hard thresholding');
display('enter 3 for bayes soft thresholding');
sorh=input('sorh:   ');

display('enter the level of decomposition');
level=input(' enter 1 or 2 :    ');

switch sorh
    case 1
        sorh='s';
        xd = wdencmp('gbl',x,wv,level,thr,sorh,keepapp);
    case 2
        sorh='h';
        xd = wdencmp('gbl',x,wv,level,thr,sorh,keepapp);
    case 3
        %%%%%%%%%%%%%%%%%%%%%
       % clear all;
%close all;
%clc;

%Denoising using Bayes soft thresholding

%Note: Figure window 1 displays the original image, fig 2 the noisy img
%fig 3 denoised img by bayes soft thresholding


%Reading the image 
%pic=imread('elaine','png');
pic=f;
%figure, imagesc(pic);colormap(gray);

%Define the Noise Variance and adding Gaussian noise
%While using 'imnoise' the pixel values(0 to 255) are converted to double in the range 0 to 1
%So variance also has to be suitably converted
sig=15;
V=(sig/256)^2;
npic=g;
%npic=imnoise(pic,'gaussian',0,V);
%figure, imagesc(npic);colormap(gray);

%Define the type of wavelet(filterbank) used and the number of scales in the wavelet decomp
filtertype=wv;
levels=level;

%Doing the wavelet decomposition
[C,S]=wavedec2(npic,levels,filtertype);

st=(S(1,1)^2)+1;
bayesC=[C(1:st-1),zeros(1,length(st:1:length(C)))];
var=length(C)-S(size(S,1)-1,1)^2+1;

%Calculating sigmahat
sigmahat=median(abs(C(var:length(C))))/0.6745;

for jj=2:size(S,1)-1
    %for the H detail coefficients
    coefh=C(st:st+S(jj,1)^2-1);
    thr=bayes(coefh,sigmahat);
    bayesC(st:st+S(jj,1)^2-1)=sthresh(coefh,thr);
    st=st+S(jj,1)^2;
    
    % for the V detail coefficients
    coefv=C(st:st+S(jj,1)^2-1);
    thr=bayes(coefv,sigmahat);
    bayesC(st:st+S(jj,1)^2-1)=sthresh(coefv,thr);
    st=st+S(jj,1)^2;
     
    %for Diag detail coefficients 
    coefd=C(st:st+S(jj,1)^2-1);
    thr=bayes(coefd,sigmahat);
    bayesC(st:st+S(jj,1)^2-1)=sthresh(coefd,thr);
    st=st+S(jj,1)^2;
end


%Reconstructing the image from the Bayes-thresholded wavelet coefficients
bayespic=waverec2(bayesC,S,filtertype);
xd=bayespic;
%Displaying the Bayes-denoised image
%figure, imagesc(uint8(bayespic));colormap(gray);
display('IEEE TRANSACTIONS ON IMAGE PROCESSING, VOL. 9, NO. 9, SEPTEMBER 2000');

display('IEEE TRANSACTIONS ON IMAGE PROCESSING, VOL. 9, NO. 9, SEPTEMBER 2000');
display('Adaptive Wavelet Thresholding for Image Denoising and Compression');
display('S. Grace Chang, Student Member, IEEE, Bin Yu, Senior Member, IEEE, and Martin Vetterli, Fellow, IEEE');


        
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
end



%sorh=sorh;
% de-noise image using global thresholding option. 


%f=imread('peppers256.png');
[c,s]=wavefast(g,level,wv);
subplot(2,2,3),wave2gray(c,s,8);title('decomposed structure');


subplot(2,2,4),xd=uint8(xd);
imshow(xd);title('denoised image');
%subplot(2,2,4),sub=f-xd;
%sub=abs(1.2*sub);
%imshow(im2uint8(sub));title('difference image');
ff=im2double(f);xdd=im2double(xd);
display('      ');
display('      ');
display('reference: To calcullate signal to noise ratio');
display('Makoto Miyahara');
display('"Objective Picture Quality Scale (PQS) for Image Coding"');
display('IEEE Trans. on Comm., Vol 46, No.9, 1998.');
display('      ');
display('      ');
snr=wpsnr(ff,xdd)

display('      ');
display('      ');
mse=compare11(ff,xdd)