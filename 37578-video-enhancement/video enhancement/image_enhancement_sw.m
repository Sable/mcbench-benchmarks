function MS= image_enhancement_sw(current_image);
% clear;clc;
% [fn,pn]=uigetfile('*.bmp','Select a file');
% current_image=imread(fullfile(pn,fn));
current_image=double(current_image);
r = current_image(:,:,1) + 1                            ;  % Seperate Color Channels
g = current_image(:,:,2) + 1                            ;
b = current_image(:,:,3) + 1                            ;
[n m]=size(r);
[nrows mcolumns] = size(r)                                 ;
transform=@fft2;
inverse_transform=@ifft2;
r_fft1 = transform(r)                                ;  % Fast Fourier Transform (2D) for Red Channel
a1=r_fft1(1,1);
a2=r_fft1(1,m);
a3=r_fft1(n,1);
a4=r_fft1(n,m);
r_fft1=zeros(n,m);
r_fft1(1,1)=a1;
r_fft1(1,m)=a2;
r_fft1(n,1)=a3;
r_fft1(n,m)=a4;
r_fft = (r_fft1)                        ;  % Shift zero frequency component to center of spectrum

%% for G color
g_fft1 = transform(g)                                ;
b1=g_fft1(1,1);
b2=g_fft1(1,m);
b3=g_fft1(n,1);
b4=g_fft1(n,m);
g_fft1=zeros(n,m);
g_fft1(1,1)=b1;
g_fft1(1,m)=b2;
g_fft1(n,1)=b3;
g_fft1(n,m)=b4;
g_fft = (g_fft1)                        ;  % Shift zero frequency component to center of spectrum

%% for B color
b_fft1 = transform(b)                                ;
c1=b_fft1(1,1);
c2=b_fft1(1,m);
c3=b_fft1(n,1);
c4=b_fft1(n,m);
b_fft1=zeros(n,m);
b_fft1(1,1)=c1;
b_fft1(1,m)=c2;
b_fft1(n,1)=c3;
b_fft1(n,m)=c4;
b_fft = (b_fft1)                        ;  % Shift zero frequency component to center of spectrum


Redfin=(mat2gray((log(r)-log(abs(inverse_transform(r_fft))))));  % Normalize to 2
Greenfin=(mat2gray((log(g)-log(abs(inverse_transform(g_fft))))));
Bluefin=(mat2gray((log(b)-log(abs(inverse_transform(b_fft))))));
R(:,:,1)=Redfin;
R(:,:,2)=Greenfin;
R(:,:,3)=Bluefin;

for i=1:1:nrows
       for j=1:1:mcolumns

    ired(i,j)=r(i,j)./(r(i,j)+g(i,j)+b(i,j));
    igreen(i,j)=g(i,j)./(r(i,j)+g(i,j)+b(i,j));
    iblue(i,j)=b(i,j)./(r(i,j)+g(i,j)+b(i,j));
    icolor(i,j)=ired(i,j)+igreen(i,j)+iblue(i,j);  
       end
end
     beta=46;                                                          % Initializing beta value to be 46
    alpha=125;                                                        % Initializing alpha value to be 125  
%icolor=1;
    cired=mat2gray(beta.*((log((alpha.*r)+0.01)-log(icolor+0.01))));    %0.01 added to remove log(0)
    cigreen=mat2gray(beta.*((log((alpha.*g)+0.01)-log(icolor+0.01))));   %cired, ciblue and cigreen are color restoration factors
    ciblue=mat2gray(beta.*((log((alpha.*b)+0.01)-log(icolor+0.01))));

     bvalue=-30;                                                       % bvalue=b in formula  
    G=192;
    MSRCR1(:,:,1)=mat2gray(G.*(cired.*(R(:,:,1)))+bvalue);           %Getting the value of MSRCR1 by multiplying with corresponding C
    MSRCR1(:,:,2)=mat2gray(G.*(cigreen.*(R(:,:,2)))+bvalue);
    MSRCR1(:,:,3)=mat2gray(G.*(ciblue.*(R(:,:,3)))+bvalue);

%             %% change for dr. ag_modifications
    MS(:,:,1)=mat2gray(MSRCR1(:,:,1)+mat2gray(r));
    MS(:,:,2)=mat2gray(MSRCR1(:,:,2)+mat2gray(g));
    MS(:,:,3)=mat2gray(MSRCR1(:,:,3)+mat2gray(b));

%     figure(2);imshow(MSRCR1);title('Image Enhancement');
%     imwrite(MSRCR1,'image_enhancement.bmp');
%     figure(3);imshow(MS);title('Image Enhancement combined with Original Image');
%     imwrite(MS,'image_enhancement_with_original_image.bmp');

    %% 
input_imager=current_image(:,:,1);
input_imageg=current_image(:,:,2);
input_imageb=current_image(:,:,3);
[mrows ncolumns]=size(input_imager);

%% trying dc coefficients
input_imagerdc=fft2(MSRCR1(:,:,1));
input_imagegdc=fft2(MSRCR1(:,:,2));
input_imagebdc=fft2(MSRCR1(:,:,3));
rdc=zeros(mrows,ncolumns);
gdc=zeros(mrows,ncolumns);
bdc=zeros(mrows,ncolumns);

rdc=input_imagerdc(1,1);
gdc=input_imagegdc(1,1);
bdc=input_imagebdc(1,1);

dc_image_enhancement(:,:,1)=mat2gray(exp(log(abs(ifft2(input_imagerdc)))+log(abs(ifft2(input_imagerdc)))-log(abs(ifft2(rdc)))));
dc_image_enhancement(:,:,2)=mat2gray(exp(log(abs(ifft2(input_imagegdc)))+log(abs(ifft2(input_imagegdc)))-log(abs(ifft2(gdc)))));
dc_image_enhancement(:,:,3)=mat2gray(exp(log(abs(ifft2(input_imagebdc)))+log(abs(ifft2(input_imagebdc)))-log(abs(ifft2(bdc)))));

% figure(4) 
% imshow(dc_image_enhancement),title('DC image Enhancement');
% imwrite(dc_image_enhancement,'dc_image_enhancement.bmp');

H = fspecial('disk',10);
input_imager=dc_image_enhancement(:,:,1);
input_imageg=dc_image_enhancement(:,:,2);
input_imageb=dc_image_enhancement(:,:,3);

blurredr = imfilter(input_imager,H,'replicate');
blurredg = imfilter(input_imageg,H,'replicate');
blurredb = imfilter(input_imageb,H,'replicate');
[nrows mcolumns]=size(input_imager);
k=0.5;
for i=1:1:nrows
for j=1:1:mcolumns
low_brightness_contrast_enhr(i,j)=(exp(log(input_imager(i,j)+0.01)+(k.*(log(input_imager(i,j)+0.01)-log(blurredr(i,j)+0.01)))+(k.*(log(input_imager(i,j)+0.01)-log(blurredr(i,j)+0.01)))));
low_brightness_contrast_enhg(i,j)=(exp(log(input_imageg(i,j)+0.01)+(k.*(log(input_imageg(i,j)+0.01)-log(blurredg(i,j)+0.01)))+(k.*(log(input_imageg(i,j)+0.01)-log(blurredg(i,j)+0.01)))));
low_brightness_contrast_enhb(i,j)=(exp(log(input_imageb(i,j)+0.01)+(k.*(log(input_imageb(i,j)+0.01)-log(blurredb(i,j)+0.01)))+(k.*(log(input_imageb(i,j)+0.01)-log(blurredb(i,j)+0.01)))));
end
end
low_bright_enh_cont(:,:,1)=low_brightness_contrast_enhr;
low_bright_enh_cont(:,:,2)=low_brightness_contrast_enhg;
low_bright_enh_cont(:,:,3)=low_brightness_contrast_enhb;
% figure(5);
% imshow(low_bright_enh_cont);title('DC image enhancement with contrast enhancement');
% imwrite(low_bright_enh_cont,'dc_image_n_contrast_enhancement.bmp');
