function [R,Theta,angle] = J4(I,sigma)
% this function filters image I by using Jacob 4th filter, 
% and calculates image I's orientation combined with its Hilbert filter;
% input: 
% I: grayscale image;
% sigma: scale parameter of Jacob 4th filter;
% output:
% R: filtered image of I;
% Theta: calculated theta for all pixels of image I;
% angle: The main angle of image I;
% Refenence:"[1]Jacob M and Unser M 2004 Design of steerable filters for feature
% detection using canny-like criteria IEEE. T. Pattern. Anal. 28 1007-1019"
%% [1] pp.1014 M=4,u=0.25 in table.2;

I = double(I);
[m,n] = size(I);
a20 =  0.113*sigma; 
a22 = -0.392*sigma;
a40 =  0.025*sigma^3;
a42 = -0.184*sigma^3;
a44 =  0.034*sigma^3;
%% gaussian derivative;
[gxx,gxy,gyy,gxxxx,gxxxy,gxxyy,gxyyy,gyyyy,L] = gaussdiv(sigma);

%%
q11 = a20*gxx + a22*gyy + a40*gxxxx + a42*gxxyy + a44*gyyyy;
q22 = 2*a20*gxy - 2*a22*gxy + 4*a40*gxxxy + 2*a42*gxyyy - 2*a42*gxxxy - 4*a44*gxyyy;
q33 = a20*gyy +a20*gxx + a22*gxx + a22*gyy + 6*a40*gxxyy + a42*gyyyy -4*a42*gxxyy + a42*gxxxx + 6*a44*gxxyy;
q44 = 2*a20*gxy - 2*a22*gxy +4*a40*gxyyy - 2*a42*gxyyy + 2*a42*gxxxy -4*a44*gxxxy;
q55 = a20*gyy + a22*gxx + a40*gyyyy + a42*gxxyy + a44*gxxxx;
t = 0;
h4 = (cos((t/180)*pi)^4)*q11 + (cos((t/180)*pi)^3)*sin((t/180)*pi)*q22 + (cos((t/180)*pi)^2)*(sin((t/180)*pi)^2)*q33 +...
         cos((t/180)*pi)*(sin((t/180)*pi)^3)*q44 + (sin((t/180)*pi)^4)*q55;
H4 = imag(hilbert(h4)); % Hilbert transform;
% figure,imshow(h4,[]); % Jacob filter kernel;
% figure,imshow(H4,[]); % Hilbert filter kernel;

%% rotate h4,H4 in 1-180¡ãand convolve with I;
responseh4 = zeros(m,n,180);
for i = 1:180
    
   h4M = imrotate(h4,-i,'bicubic','crop');  
   H4M = imrotate(H4,-i,'bicubic','crop');  
   
   responseh4(:,:,i) = imfilter(I,h4M,'replicate');    
   responseH4 = imfilter(I,H4M,'replicate');
%    
%    responseh4(:,:,i) = circshift(real(ifft2(fft2(I) .* fft2(h4M,m,n))),[-L,-L]);
%    responseH4 = circshift(real(ifft2(fft2(I) .* fft2(H4M,m,n))),[-L,-L]);
   
   Energy = responseh4(:,:,i).^4 + responseH4.^4; 
   Energyh4H4(i) = sum(sum(Energy));   

end

[R,Theta] = max(responseh4,[],3); 

[energy,angle] = max(Energyh4H4); 


function [gxx,gxy,gyy,gxxxx,gxxxy,gxxyy,gxyyy,gyyyy,L] = gaussdiv(sigma)
w = 3*sigma;
L = w + 1;
x = -L:L;
co = 1/(sqrt(2*pi)*sigma);
g1 = co*exp(-(x.^2)/(2*sigma^2));       % 1D gaussian filter;
gx1 = g1.*(-x./(sigma^2));              % 1D gx;
gx = g1'*gx1;                           % 2D gx;
gy = gx';                               % 2D gy;
gxx1 = ((x.^2-sigma^2)/sigma^4).*g1;    % 1D gxx; 
gxx = g1'*gxx1;                         % 2D gxx;
gyy = gxx';                             % 2D gyy;
gxy = gx1'*gx1;                         % 2D gxy,result is the same as "gx1'*gx1"; 
% gxxy = gx1'*gxx1; 
gxxx1 = ((3*x.*sigma^2 - x.^3)/sigma^6).*g1;    % 1D gxxx filter;
gxxx = g1'*gxxx1;                               % 2D gxxx filter;
gyyy = gxxx';                                   % 2D gyyy filter;
gxxxx1 = ((x.^4 - 6*x.^2*sigma^2 + 3*sigma^4)/sigma^8).*g1; % 1D gxxxx filter;
gxxxx = g1'*gxxxx1;                             % 2D gxxxx filter;
gxxxy = gy*gxxx*(1/co);                         % 2D gxxxy filter; 
gxyyy = gyyy*gx*(1/co);                         % 2D gxyyy filter;
gyyyy = gxxxx';       
gxxyy = gxx1'*gxx1;
