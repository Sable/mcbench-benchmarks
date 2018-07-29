%function[]=vpsnseg()
clear all;
close all;
home;
J = 4;
alpha = 2;
beta = 7;
im = double(rgb2gray(imread('lena.png')));
im=imresize(im,[256,256]);
% intensity gradient ch-1
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(im, hy, 'replicate');
Ix = imfilter(im, hx, 'replicate');
Ge = sqrt(Ix.*Ix + Iy.*Iy);

% Dual tree complex wavelet transform ch-2
w = dtcwt(im,J);

    % Complex magnitude ch-2
    preal = w{1}{1}{1}{1};     pimag = w{1}{2}{1}{1};     d1t1 = sqrt(preal.^2+pimag.^2);
    preal = w{1}{1}{1}{2};     pimag = w{1}{2}{1}{2};     d1t2 = sqrt(preal.^2+pimag.^2);
    preal = w{1}{1}{1}{3};     pimag = w{1}{2}{1}{3};     d1t3 = sqrt(preal.^2+pimag.^2);
    preal = w{1}{1}{2}{1};     pimag = w{1}{2}{2}{1};     d1t4 = sqrt(preal.^2+pimag.^2);
    preal = w{1}{1}{2}{2};     pimag = w{1}{2}{2}{2};     d1t5 = sqrt(preal.^2+pimag.^2);
    preal = w{1}{1}{2}{3};     pimag = w{1}{2}{2}{3};     d1t6 = sqrt(preal.^2+pimag.^2);
    
    preal = w{2}{1}{1}{1};     pimag = w{2}{2}{1}{1};     d2t1 = sqrt(preal.^2+pimag.^2);
    preal = w{2}{1}{1}{2};     pimag = w{2}{2}{1}{2};     d2t2 = sqrt(preal.^2+pimag.^2);
    preal = w{2}{1}{1}{3};     pimag = w{2}{2}{1}{3};     d2t3 = sqrt(preal.^2+pimag.^2);
    preal = w{2}{1}{2}{1};     pimag = w{2}{2}{2}{1};     d2t4 = sqrt(preal.^2+pimag.^2);
    preal = w{2}{1}{2}{2};     pimag = w{2}{2}{2}{2};     d2t5 = sqrt(preal.^2+pimag.^2);
    preal = w{2}{1}{2}{3};     pimag = w{2}{2}{2}{3};     d2t6 = sqrt(preal.^2+pimag.^2);

    preal = w{3}{1}{1}{1};     pimag = w{3}{2}{1}{1};     d3t1 = sqrt(preal.^2+pimag.^2);
    preal = w{3}{1}{1}{2};     pimag = w{3}{2}{1}{2};     d3t2 = sqrt(preal.^2+pimag.^2);
    preal = w{3}{1}{1}{3};     pimag = w{3}{2}{1}{3};     d3t3 = sqrt(preal.^2+pimag.^2);
    preal = w{3}{1}{2}{1};     pimag = w{3}{2}{2}{1};     d3t4 = sqrt(preal.^2+pimag.^2);
    preal = w{3}{1}{2}{2};     pimag = w{3}{2}{2}{2};     d3t5 = sqrt(preal.^2+pimag.^2);
    preal = w{3}{1}{2}{3};     pimag = w{3}{2}{2}{3};     d3t6 = sqrt(preal.^2+pimag.^2);

    preal = w{4}{1}{1}{1};     pimag = w{4}{2}{1}{1};     d4t1 = sqrt(preal.^2+pimag.^2);
    preal = w{4}{1}{1}{2};     pimag = w{4}{2}{1}{2};     d4t2 = sqrt(preal.^2+pimag.^2);
    preal = w{4}{1}{1}{3};     pimag = w{4}{2}{1}{3};     d4t3 = sqrt(preal.^2+pimag.^2);
    preal = w{4}{1}{2}{1};     pimag = w{4}{2}{2}{1};     d4t4 = sqrt(preal.^2+pimag.^2);
    preal = w{4}{1}{2}{2};     pimag = w{4}{2}{2}{2};     d4t5 = sqrt(preal.^2+pimag.^2);
    preal = w{4}{1}{2}{3};     pimag = w{4}{2}{2}{3};     d4t6 = sqrt(preal.^2+pimag.^2);

    
   % median filtering ch-2
    ord = 9;
    d1t1 = medfilt1(d1t1,ord,[],1); d1t1 = medfilt1(d1t1,ord,[],2);
    d1t2 = medfilt1(d1t2,ord,[],1); d1t2 = medfilt1(d1t2,ord,[],2);
    d1t3 = medfilt1(d1t3,ord,[],1); d1t3 = medfilt1(d1t3,ord,[],2);
    d1t4 = medfilt1(d1t4,ord,[],1); d1t4 = medfilt1(d1t4,ord,[],2);
    d1t5 = medfilt1(d1t5,ord,[],1); d1t5 = medfilt1(d1t5,ord,[],2);
    d1t6 = medfilt1(d1t6,ord,[],1); d1t6 = medfilt1(d1t6,ord,[],2);
    
    d2t1 = medfilt1(d2t1,ord,[],1); d2t1 = medfilt1(d2t1,ord,[],2);
    d2t2 = medfilt1(d2t2,ord,[],1); d2t2 = medfilt1(d2t2,ord,[],2);
    d2t3 = medfilt1(d2t3,ord,[],1); d2t3 = medfilt1(d2t3,ord,[],2);
    d2t4 = medfilt1(d2t4,ord,[],1); d2t4 = medfilt1(d2t4,ord,[],2);
    d2t5 = medfilt1(d2t5,ord,[],1); d2t5 = medfilt1(d2t5,ord,[],2);
    d2t6 = medfilt1(d2t6,ord,[],1); d2t6 = medfilt1(d2t6,ord,[],2);

    d3t1 = medfilt1(d3t1,ord,[],1); d3t1 = medfilt1(d3t1,ord,[],2);
    d3t2 = medfilt1(d3t2,ord,[],1); d3t2 = medfilt1(d3t2,ord,[],2);
    d3t3 = medfilt1(d3t3,ord,[],1); d3t3 = medfilt1(d3t3,ord,[],2);
    d3t4 = medfilt1(d3t4,ord,[],1); d3t4 = medfilt1(d3t4,ord,[],2);
    d3t5 = medfilt1(d3t5,ord,[],1); d3t5 = medfilt1(d3t5,ord,[],2);
    d3t6 = medfilt1(d3t6,ord,[],1); d3t6 = medfilt1(d3t6,ord,[],2);

    d4t1 = medfilt1(d4t1,ord,[],1); d4t1 = medfilt1(d4t1,ord,[],2);
    d4t2 = medfilt1(d4t2,ord,[],1); d4t2 = medfilt1(d4t2,ord,[],2);
    d4t3 = medfilt1(d4t3,ord,[],1); d4t3 = medfilt1(d4t3,ord,[],2);
    d4t4 = medfilt1(d4t4,ord,[],1); d4t4 = medfilt1(d4t4,ord,[],2);
    d4t5 = medfilt1(d4t5,ord,[],1); d4t5 = medfilt1(d4t5,ord,[],2);
    d4t6 = medfilt1(d4t6,ord,[],1); d4t6 = medfilt1(d4t6,ord,[],2);

    
    % Morphological erosion ch-12
    se = strel('square',9);
    dnom = 2^2;
    s1t1 = imerode(d1t1/dnom,se);
    s1t2 = imerode(d1t2/dnom,se);
    s1t3 = imerode(d1t3/dnom,se);
    s1t4 = imerode(d1t4/dnom,se);
    s1t5 = imerode(d1t5/dnom,se);
    s1t6 = imerode(d1t6/dnom,se);
    
    dnom = 2^3;
    s2t1 = imerode(d2t1/dnom,se);
    s2t2 = imerode(d2t2/dnom,se);
    s2t3 = imerode(d2t3/dnom,se);
    s2t4 = imerode(d2t4/dnom,se);
    s2t5 = imerode(d2t5/dnom,se);
    s2t6 = imerode(d2t6/dnom,se);
    
    dnom = 2^4;
    s3t1 = imerode(d3t1/dnom,se);
    s3t2 = imerode(d3t2/dnom,se);
    s3t3 = imerode(d3t3/dnom,se);
    s3t4 = imerode(d3t4/dnom,se);
    s3t5 = imerode(d3t5/dnom,se);
    s3t6 = imerode(d3t6/dnom,se);
    
    dnom = 2^5;
    s4t1 = imerode(d4t1/dnom,se);
    s4t2 = imerode(d4t2/dnom,se);
    s4t3 = imerode(d4t3/dnom,se);
    s4t4 = imerode(d4t4/dnom,se);
    s4t5 = imerode(d4t5/dnom,se);
    s4t6 = imerode(d4t6/dnom,se);

    % interpolation ch-12
    ME1t1 = vpnsinterp(s1t1);
    ME1t2 = vpnsinterp(s1t2);
    ME1t3 = vpnsinterp(s1t3);
    ME1t4 = vpnsinterp(s1t4);
    ME1t5 = vpnsinterp(s1t5);
    ME1t6 = vpnsinterp(s1t6);

    ME2t1 = vpnsinterp(s2t1); ME2t1 = vpnsinterp(ME2t1);
    ME2t2 = vpnsinterp(s2t2); ME2t2 = vpnsinterp(ME2t2);
    ME2t3 = vpnsinterp(s2t3); ME2t3 = vpnsinterp(ME2t3);
    ME2t4 = vpnsinterp(s2t4); ME2t4 = vpnsinterp(ME2t4);
    ME2t5 = vpnsinterp(s2t5); ME2t5 = vpnsinterp(ME2t5);
    ME2t6 = vpnsinterp(s2t6); ME2t6 = vpnsinterp(ME2t6);
    
    ME3t1 = vpnsinterp(s3t1); ME3t1 = vpnsinterp(ME3t1); ME3t1 = vpnsinterp(ME3t1);
    ME3t2 = vpnsinterp(s3t2); ME3t2 = vpnsinterp(ME3t2); ME3t2 = vpnsinterp(ME3t2);
    ME3t3 = vpnsinterp(s3t3); ME3t3 = vpnsinterp(ME3t3); ME3t3 = vpnsinterp(ME3t3);
    ME3t4 = vpnsinterp(s3t4); ME3t4 = vpnsinterp(ME3t4); ME3t4 = vpnsinterp(ME3t4);
    ME3t5 = vpnsinterp(s3t5); ME3t5 = vpnsinterp(ME3t5); ME3t5 = vpnsinterp(ME3t5);
    ME3t6 = vpnsinterp(s3t6); ME3t6 = vpnsinterp(ME3t6); ME3t6 = vpnsinterp(ME3t6);

    ME4t1 = vpnsinterp(s4t1); ME4t1 = vpnsinterp(ME4t1); ME4t1 = vpnsinterp(ME4t1); ME4t1 = vpnsinterp(ME4t1);
    ME4t2 = vpnsinterp(s4t2); ME4t2 = vpnsinterp(ME4t2); ME4t2 = vpnsinterp(ME4t2); ME4t2 = vpnsinterp(ME4t2);
    ME4t3 = vpnsinterp(s4t3); ME4t3 = vpnsinterp(ME4t3); ME4t3 = vpnsinterp(ME4t3); ME4t3 = vpnsinterp(ME4t3);
    ME4t4 = vpnsinterp(s4t4); ME4t4 = vpnsinterp(ME4t4); ME4t4 = vpnsinterp(ME4t4); ME4t4 = vpnsinterp(ME4t4);
    ME4t5 = vpnsinterp(s4t5); ME4t5 = vpnsinterp(ME4t5); ME4t5 = vpnsinterp(ME4t5); ME4t5 = vpnsinterp(ME4t5);
    ME4t6 = vpnsinterp(s4t6); ME4t6 = vpnsinterp(ME4t6); ME4t6 = vpnsinterp(ME4t6); ME4t6 = vpnsinterp(ME4t6);

    
    % texture activity ch-12
    Etex = ME1t1+ME1t2+ME1t3+ME1t4+ME1t5+ME1t6 + ME2t1+ME2t2+ME2t3+ME2t4+ME2t5+ME2t6 + ME3t1+ME3t2+ME3t3+ME3t4+ME3t5+ME3t6+ ME4t1+ME4t2+ME4t3+ME4t4+ME4t5+ME4t6;
    Etex = (Etex/alpha)-beta;
    Rh = Etex>=0.0;
    Etex = Rh.*Etex;
    fT = exp(Etex);
    
    % Normalise ch-1
    MG = (abs(Ge)./fT)/(4*median(Ge(:)));
% 
    
    % Gaussian gradient estimation ch-2
    G = fspecial('gaussian',[9 9],2); [dx,dy] = gradient(G); % G is a 2D gaussain
	
    Ix = conv2(d1t1,dx,'same'); Iy = conv2(d1t1,dy,'same'); MT1t1 = sqrt(Ix.*Ix + Iy.*Iy);
    Ix = conv2(d1t2,dx,'same'); Iy = conv2(d1t2,dy,'same'); MT1t2 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d1t3,dx,'same'); Iy = conv2(d1t3,dy,'same'); MT1t3 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d1t4,dx,'same'); Iy = conv2(d1t4,dy,'same'); MT1t4 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d1t5,dx,'same'); Iy = conv2(d1t5,dy,'same'); MT1t5 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d1t6,dx,'same'); Iy = conv2(d1t6,dy,'same'); MT1t6 = sqrt(Ix.*Ix + Iy.*Iy);
    
    Ix = conv2(d2t1,dx,'same'); Iy = conv2(d2t1,dy,'same'); MT2t1 = sqrt(Ix.*Ix + Iy.*Iy);
    Ix = conv2(d2t2,dx,'same'); Iy = conv2(d2t2,dy,'same'); MT2t2 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d2t3,dx,'same'); Iy = conv2(d2t3,dy,'same'); MT2t3 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d2t4,dx,'same'); Iy = conv2(d2t4,dy,'same'); MT2t4 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d2t5,dx,'same'); Iy = conv2(d2t5,dy,'same'); MT2t5 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d2t6,dx,'same'); Iy = conv2(d2t6,dy,'same'); MT2t6 = sqrt(Ix.*Ix + Iy.*Iy);

    Ix = conv2(d3t1,dx,'same'); Iy = conv2(d3t1,dy,'same'); MT3t1 = sqrt(Ix.*Ix + Iy.*Iy);
    Ix = conv2(d3t2,dx,'same'); Iy = conv2(d3t2,dy,'same'); MT3t2 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d3t3,dx,'same'); Iy = conv2(d3t3,dy,'same'); MT3t3 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d3t4,dx,'same'); Iy = conv2(d3t4,dy,'same'); MT3t4 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d3t5,dx,'same'); Iy = conv2(d3t5,dy,'same'); MT3t5 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d3t6,dx,'same'); Iy = conv2(d3t6,dy,'same'); MT3t6 = sqrt(Ix.*Ix + Iy.*Iy);

    Ix = conv2(d4t1,dx,'same'); Iy = conv2(d4t1,dy,'same'); MT4t1 = sqrt(Ix.*Ix + Iy.*Iy);
    Ix = conv2(d4t2,dx,'same'); Iy = conv2(d4t2,dy,'same'); MT4t2 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d4t3,dx,'same'); Iy = conv2(d4t3,dy,'same'); MT4t3 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d4t4,dx,'same'); Iy = conv2(d4t4,dy,'same'); MT4t4 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d4t5,dx,'same'); Iy = conv2(d4t5,dy,'same'); MT4t5 = sqrt(Ix.*Ix + Iy.*Iy);
	Ix = conv2(d4t6,dx,'same'); Iy = conv2(d4t6,dy,'same'); MT4t6 = sqrt(Ix.*Ix + Iy.*Iy);

    % ch-2
    n=size(MT1t1);n=n(1)*n(2);
    MT1t1=MT1t1/max(MT1t1(:)); w1 = n/sum(MT1t1(:).^2); MT1t1 = MT1t1*w1;
    MT1t2=MT1t2/max(MT1t2(:)); w2 = n/sum(MT1t2(:).^2); MT1t2 = MT1t2*w2;
    MT1t3=MT1t3/max(MT1t3(:)); w3 = n/sum(MT1t3(:).^2); MT1t3 = MT1t3*w3;
    MT1t4=MT1t4/max(MT1t4(:)); w4 = n/sum(MT1t4(:).^2); MT1t4 = MT1t4*w4;
    MT1t5=MT1t5/max(MT1t5(:)); w5 = n/sum(MT1t5(:).^2); MT1t5 = MT1t5*w5;
    MT1t6=MT1t6/max(MT1t6(:)); w6 = n/sum(MT1t6(:).^2); MT1t6 = MT1t6*w6;
 
    n=size(MT2t1);n=n(1)*n(2);
    MT2t1=MT2t1/max(MT2t1(:)); w1 = n/sum(MT2t1(:).^2); MT2t1 = MT2t1*w1;
    MT2t2=MT2t2/max(MT2t2(:)); w2 = n/sum(MT2t2(:).^2); MT2t2 = MT2t2*w2;
    MT2t3=MT2t3/max(MT2t3(:)); w3 = n/sum(MT2t3(:).^2); MT2t3 = MT2t3*w3;
    MT2t4=MT2t4/max(MT2t4(:)); w4 = n/sum(MT2t4(:).^2); MT2t4 = MT2t4*w4;
    MT2t5=MT2t5/max(MT2t5(:)); w5 = n/sum(MT2t5(:).^2); MT2t5 = MT2t5*w5;
    MT2t6=MT2t6/max(MT2t6(:)); w6 = n/sum(MT2t6(:).^2); MT2t6 = MT2t6*w6;

    n=size(MT3t1);n=n(1)*n(2);
    MT3t1=MT3t1/max(MT3t1(:)); w1 = n/sum(MT3t1(:).^2); MT3t1 = MT3t1*w1;
    MT3t2=MT3t2/max(MT3t2(:)); w2 = n/sum(MT3t2(:).^2); MT3t2 = MT3t2*w2;
    MT3t3=MT3t3/max(MT3t3(:)); w3 = n/sum(MT3t3(:).^2); MT3t3 = MT3t3*w3;
    MT3t4=MT3t4/max(MT3t4(:)); w4 = n/sum(MT3t4(:).^2); MT3t4 = MT3t4*w4;
    MT3t5=MT3t5/max(MT3t5(:)); w5 = n/sum(MT3t5(:).^2); MT3t5 = MT3t5*w5;
    MT3t6=MT3t6/max(MT3t6(:)); w6 = n/sum(MT3t6(:).^2); MT3t6 = MT3t6*w6;

    n=size(MT4t1);n=n(1)*n(2);
    MT4t1=MT4t1/max(MT4t1(:)); w1 = n/sum(MT4t1(:).^2); MT4t1 = MT4t1*w1;
    MT4t2=MT4t2/max(MT4t2(:)); w2 = n/sum(MT4t2(:).^2); MT4t2 = MT4t2*w2;
    MT4t3=MT4t3/max(MT4t3(:)); w3 = n/sum(MT4t3(:).^2); MT4t3 = MT4t3*w3;
    MT4t4=MT4t4/max(MT4t4(:)); w4 = n/sum(MT4t4(:).^2); MT4t4 = MT4t4*w4;
    MT4t5=MT4t5/max(MT4t5(:)); w5 = n/sum(MT4t5(:).^2); MT4t5 = MT4t5*w5;
    MT4t6=MT4t6/max(MT4t6(:)); w6 = n/sum(MT4t6(:).^2); MT4t6 = MT4t6*w6;

    % Interpolation ch-2
    MT1t1 = vpnsinterp(MT1t1);
    MT1t2 = vpnsinterp(MT1t2);
    MT1t3 = vpnsinterp(MT1t3);
    MT1t4 = vpnsinterp(MT1t4);
    MT1t5 = vpnsinterp(MT1t5);
    MT1t6 = vpnsinterp(MT1t6);

    MT2t1 = vpnsinterp(MT2t1); MT2t1 = vpnsinterp(MT2t1);
    MT2t2 = vpnsinterp(MT2t2); MT2t2 = vpnsinterp(MT2t2);
    MT2t3 = vpnsinterp(MT2t3); MT2t3 = vpnsinterp(MT2t3);
    MT2t4 = vpnsinterp(MT2t4); MT2t4 = vpnsinterp(MT2t4);
    MT2t5 = vpnsinterp(MT2t5); MT2t5 = vpnsinterp(MT2t5);
    MT2t6 = vpnsinterp(MT2t6); MT2t6 = vpnsinterp(MT2t6);
    
    MT3t1 = vpnsinterp(MT3t1); MT3t1 = vpnsinterp(MT3t1); MT3t1 = vpnsinterp(MT3t1);
    MT3t2 = vpnsinterp(MT3t2); MT3t2 = vpnsinterp(MT3t2); MT3t2 = vpnsinterp(MT3t2);
    MT3t3 = vpnsinterp(MT3t3); MT3t3 = vpnsinterp(MT3t3); MT3t3 = vpnsinterp(MT3t3);
    MT3t4 = vpnsinterp(MT3t4); MT3t4 = vpnsinterp(MT3t4); MT3t4 = vpnsinterp(MT3t4);
    MT3t5 = vpnsinterp(MT3t5); MT3t5 = vpnsinterp(MT3t5); MT3t5 = vpnsinterp(MT3t5);
    MT3t6 = vpnsinterp(MT3t6); MT3t6 = vpnsinterp(MT3t6); MT3t6 = vpnsinterp(MT3t6);
    
    MT4t1 = vpnsinterp(MT4t1); MT4t1 = vpnsinterp(MT4t1); MT4t1 = vpnsinterp(MT4t1); MT4t1 = vpnsinterp(MT4t1);
    MT4t2 = vpnsinterp(MT4t2); MT4t2 = vpnsinterp(MT4t2); MT4t2 = vpnsinterp(MT4t2); MT4t2 = vpnsinterp(MT4t2);
    MT4t3 = vpnsinterp(MT4t3); MT4t3 = vpnsinterp(MT4t3); MT4t3 = vpnsinterp(MT4t3); MT4t3 = vpnsinterp(MT4t3);
    MT4t4 = vpnsinterp(MT4t4); MT4t4 = vpnsinterp(MT4t4); MT4t4 = vpnsinterp(MT4t4); MT4t4 = vpnsinterp(MT4t4);
    MT4t5 = vpnsinterp(MT4t5); MT4t5 = vpnsinterp(MT4t5); MT4t5 = vpnsinterp(MT4t5); MT4t5 = vpnsinterp(MT4t5);
    MT4t6 = vpnsinterp(MT4t6); MT4t6 = vpnsinterp(MT4t6); MT4t6 = vpnsinterp(MT4t6); MT4t6 = vpnsinterp(MT4t6);

    % combining ch-2
    TG = MT1t1+MT1t2+MT1t3+MT1t4+MT1t5+MT1t6 + MT2t1+MT2t2+MT2t3+MT2t4+MT2t5+MT2t6 + MT3t1+MT3t2+MT3t3+MT3t4+MT3t5+MT3t6 + MT4t1+MT4t2+MT4t3+MT4t4+MT4t5+MT4t6; 
    TG = TG/median(TG(:));
    
    % Weighted sum
    GS = MG+TG;
    imshow(MG,[]); title('Modulated Intensity Gradient');
    figure; imshow(TG,[]); title('Texture Gradient');
    figure; imshow(GS,[]); title('Total Gradient');
   
    % watershed algorithm
%     GS = imhmin(GS,2,4);
    [f_g,ridge] = watershed_seg(GS,im);
    figure, imshow(im,[]), hold on; title('Segmented Image');
    himage = imshow(f_g);
    set(himage, 'AlphaData', 0.3); 
