%Question No:10

%Write a MATLAB function which converts an RGB to HSI. Display the Hue
%image, Saturation image and the Intensity image. Histogram equalize the H,
%S and I images and the HSI image. Then convert the HSI image back to RGB.

function rgbtohsi(x)
F=imread(x);
F=im2double(F);
r=F(:,:,1);
g=F(:,:,2);
b=F(:,:,3);
th=acos((0.5*((r-g)+(r-b)))./((sqrt((r-g).^2+(r-b).*(g-b)))+eps));
H=th;
H(b>g)=2*pi-H(b>g);
H=H/(2*pi);
S=1-3.*(min(min(r,g),b))./(r+g+b+eps);
I=(r+g+b)/3;
hsi=cat(3,H,S,I);
HE=H*2*pi;
HE=histeq(HE);
HE=HE/(2*pi);
SE=histeq(S);
IE=histeq(I);
choice=input('1:RGB to HSI\n2:Display Hue, Saturation and Intensity Images\n3:HSI to RGB\n4:Hue-Equalization\n5:Saturation-Equalization\n6:Intensity-Equalization\n7:HSI-Equalization\n Enter your choice :');
switch choice
    case 1
        figure,imshow(F),title('RGB Image');
        figure, imshow(hsi),title('HSI Image');
    case 2
        figure,imshow(F),title('RGB Image');
        figure, imshow(H),title('Hue Image');
        figure, imshow(S),title('Saturation Image');
        figure, imshow(I),title('Intensity Image');   
    case 3
        C=hsitorgb(hsi);
        figure,imshow(hsi),title('HSI Image');
        figure, imshow(C),title('RGB Image');
    case 4
        RV=cat(3,HE,S,I);
        C=hsitorgb(RV);
        figure,imshow(hsi),title('HSI Image');
        figure,imshow(F),title('RGB Image');
        figure, imshow(C),title('RGB Image-Hue Equalized');
    case 5
        RV=cat(3,H,SE,I);
        C=hsitorgb(RV);
        figure,imshow(hsi),title('HSI Image');
        figure,imshow(F),title('RGB Image');
        figure, imshow(C),title('RGB Image-Saturation Equalized');
    case 6
        RV=cat(3,H,S,IE);
        C=hsitorgb(RV);
        figure,imshow(hsi),title('HSI Image');
        figure,imshow(F),title('RGB Image');
        figure, imshow(C),title('RGB Image-Intensity Equalized');
    case 7
        RV=cat(3,HE,SE,IE);
        C=hsitorgb(RV);
        figure,imshow(hsi),title('HSI Image');
        figure,imshow(F),title('RGB Image');
        figure, imshow(C),title('RGB Image-HSI Equalized');
    otherwise
        display('Wrong choice');
end
end
function C=hsitorgb(hsi)
HV=hsi(:,:,1)*2*pi;
SV=hsi(:,:,2);
IV=hsi(:,:,3);
R=zeros(size(HV));
G=zeros(size(HV));
B=zeros(size(HV));
%RG Sector
id=find((0<=HV)& (HV<2*pi/3));
B(id)=IV(id).*(1-SV(id));
R(id)=IV(id).*(1+SV(id).*cos(HV(id))./cos(pi/3-HV(id)));
G(id)=3*IV(id)-(R(id)+B(id));

%BG Sector
id=find((2*pi/3<=HV)& (HV<4*pi/3));
R(id)=IV(id).*(1-SV(id));
G(id)=IV(id).*(1+SV(id).*cos(HV(id)-2*pi/3)./cos(pi-HV(id)));
B(id)=3*IV(id)-(R(id)+G(id));
%BR Sector
id=find((4*pi/3<=HV)& (HV<2*pi));
G(id)=IV(id).*(1-SV(id));
B(id)=IV(id).*(1+SV(id).*cos(HV(id)-4*pi/3)./cos(5*pi/3-HV(id)));
R(id)=3*IV(id)-(G(id)+B(id));
C=cat(3,R,G,B);
C=max(min(C,1),0);
end

