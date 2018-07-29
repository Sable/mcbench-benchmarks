clear all,clc
[filename, pathname] = uigetfile('*.dct', 'open file');% only image Bitmap
if isequal(filename, 0) | isequal(pathname, 0)   
    disp('file input canceled.');  
  else
    f1=fopen(fullfile(pathname, filename),'r');%Lecture du fichier de données.
end;
fichier2=fread(f1,'ubit8');
Lfich=length(fichier2);
Rr=fichier2(end);
d32=0;
if Rr>=100
    d32=1;
    Rr=Rr-100;
end;
Qr=fichier2(end-1);
sgn=fichier2(end-2);
DIFLcdR=fichier2(end-3);
DIFLrlR=fichier2(end-4);
i=1;
k=Lfich-36;
h=zeros(1,8);
while k<=Lfich-5
   for j=0:3
  h(i)=(fichier2(k+j))*(256^j)+h(i);
    end;
  k=k+4;
  i=i+1;
end;
LTR=h(1);
LXfreqR=h(2);
DCTmaxR=h(3)*10^(-4);
DCTminR=h(4)*10^(-4);
if sgn==1
  DCTminR=-DCTminR;  
end;
lR=h(5);
M2R=h(6);
LXrle1R=h(7);
LcompR=h(8);
%--------------------------------------------------------------------------
                %%% Reconstruire d'une code %%%
%--------------------------------------------------------------------------
Tcod8R=fichier2(1:LTR);
LcdR=LTR*8-DIFLcdR;
k=8;
for j=1:LTR
    for i=0:7
        cdR(k-i)=fix(Tcod8R(j)/(2^(7-i)));
        if Tcod8R(j)>=2^(7-i)
            Tcod8R(j)=Tcod8R(j)-2^(7-i);
        end;
    end;
        k=k+8;
end;
for i=1:LcdR
    codeR(i)=cdR(i);
end; 
%--------------------------------------------------------------------------
                          %%% Reconstruire Xfreq %%%
%--------------------------------------------------------------------------
AR=fichier2(LTR+1:LTR+lR);
BR=fichier2(LTR+lR+1:LTR+lR/2+LXfreqR);
PR=fichier2(LTR+lR/2+LXfreqR+1:LTR+lR+LXfreqR);
if length(AR)==0
    XfR=BR;
else
ARR=Iabais(AR);
XfR=zeros(1,LXfreqR);
XfR(PR)=ARR;
k=1;
for i=1:LXfreqR
    if XfR(i)==0
        XfR(i)=BR(k);
        k=k+1;
    end;
end;
end;
somf=sum(XfR);
%--------------------------------------------------------------------------
                          %%%% Décodage Huffman %%%%
%--------------------------------------------------------------------------
XfreqR=XfR./somf;
[dict,avglen] = huffmandict([0:2^Qr-1],XfreqR);
XrleRR = huffmandeco(codeR,dict);
Xrle1R=XrleRR(1:LXrle1R);
if d32==1
    temp=Iabais(Xrle1R);
Xrle1R=temp;
end;
Trl8R=XrleRR(LXrle1R+1:length(XrleRR)-LcompR);
compR=XrleRR(length(XrleRR)-LcompR+1:length(XrleRR));
LTrl8=length(Trl8R);
LrlR=LTrl8*8-DIFLrlR;
k=8;
for j=1:LTrl8
    for i=0:7
        rlR(k-i)=fix(Trl8R(j)/(2^(7-i)));
        if Trl8R(j)>=2^(7-i)
            Trl8R(j)=Trl8R(j)-2^(7-i);
        end;
    end;
        k=k+8;
end;
k=1;
for i=1:LrlR
       if rlR(i)==1
           XrleR(i)=Xrle1R(k);
           k=k+1;
       else
          XrleR(i)=1; 
       end;
   end;
   XrleeR(2:2:2*length(XrleR))=XrleR;
    XrleeR(1:2:2*length(XrleR))=compR;
%--------------------------------------------------------------------------
                            %%% Décodage RLE %%%% 
%--------------------------------------------------------------------------
XZvR=irle(XrleeR);
%--------------------------------------------------------------------------
          %%% Lecture de vecteur Quatifiée en zig zag inverse %%%
%--------------------------------------------------------------------------
XZzagR=vec2mat(XZvR,M2R);
if Rr==8
XdctQR=blkproc(XZzagR,[1 Rr^2],'zigzaginv(x)');
else
    if Rr==16
        XdctQR=blkproc(XZzagR,[1 Rr^2],'zigzinv16(x)');
    else
        if Rr==32
            XdctQR=blkproc(XZzagR,[1 Rr^2],'zigzinv32(x)');
        end;
    end;
end;       
%--------------------------------------------------------------------------
                       %%%%  Déquantification  %%%%
%--------------------------------------------------------------------------
XdctR=round(((DCTmaxR-DCTminR)/(-1+2^Qr))*XdctQR+DCTminR);
%--------------------------------------------------------------------------
           %%% Application de la DCT Inverse sur la matrice %%%
%--------------------------------------------------------------------------
XR = blkproc(XdctR,[Rr Rr],'idct2');%Transformation IDCT de matrice X.
%--------------------------------------------------------------------------
%%%  Sauvgardée l'Image Réconstruite en extention 'BMP'  %%%
%--------------------------------------------------------------------------
XR=uint8(XR);
imwrite(XR,'new_ima.bmp','bmp');
figure,imshow(XR),title('Image Reconstruite');
%--------------------------------------------------------------------------
                            %%% MSE, PSNR %%%
%--------------------------------------------------------------------------
[filename, pathname] = uigetfile('*.bmp', 'open image');% only image Bitmap
if isequal(filename, 0) | isequal(pathname, 0)   
    disp('Image input canceled.');  
   X = [];    map = []; 
else
    [X,MAP]=imread(fullfile(pathname, filename));%Lecture d'image.
end;
[M N]=size(X);
XR=double(XR);
XE=zeros(size(X));
XE=double(XE);
E=0;
for i=1:M
    for j=1:N
      XE(i,j)=X(i,j)-XR(i,j);
      E=E+((XE(i,j))^2);
          end
end
MSE=E/(M*N)%L’erreur quadratique moyenne EQM
PSNR=10*log10((2^Qr-1)^2/MSE)%Rapport signal sur bruit de crête PSNR
%imwrite(XR,'Image Erreur.bmp','bmp');
figure,imshow(XE,[]),title('Image Erreur');





