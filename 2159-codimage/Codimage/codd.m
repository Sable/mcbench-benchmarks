function codd(u,x)
%-------------------------------------------------------------------------------------
%  CODD
%  The program disorders an image in format .tif,bmp,png,pcx (no jpg). 
%
%  The original image can be located in any portfolio of the computer.
%
%  It admits a format of map of colors or in true color.
%
%  The syntax is codd.  
%  The key is a word without numbers, (of up to 24 characters). 
%
%  It also admits an image in scale of grises(256 ranges of gray). 
%
%  Author: Francisco Echegorri  
%  E-mail: fdefac@montevideo.com.uy  
%  Created in September of 2002.  
%
%--------------------------------------------------------------------------------------
%  El programa desordena una imagen en formato .tif,bmp,png,pcx(no jpg).
%
%  La imagen original deberá guardarse en la carpeta work de Matlab.
%
%  Admite un formato de mapa de colores o en color verdadero.
%  La sintaxis es codd.
%
%  La clave es una palabra sin números,(de hasta 24 caracteres).
%
%  Admite tambien una imagen en escala de grises(256 gamas de gris).
%
if nargin<1
   [u, pathname] = uigetfile('*.*', 'Select the Image to code');
buffer=pwd;
cd (pathname);
cd (buffer);
end
x=input('To enter a key word \n','s');tic, x=dalfa(x);x=keyexpansion(x);
[X,map]=imread(u);
if length(size(X))==2
   MC=size(X(1,:));MF=size(X(:,1));NC=MC(1,2);NF=MF(1,1);w=x.*997;x=w-fix(w);
   y=randpermut(x,NF);z=randpermut(x,NC);h=waitbar(0,'Coding the Image...');
   for i=1:NF
      Y(i,:)=X(y(i),:);waitbar(i/(NF+NC),h)
   end
   for j=1:NC
      Z(:,j)=Y(:,z(j));waitbar((j+NF)/(NF+NC),h)
   end
   if isempty(map)==1
      map=gray(256);image(Z),colormap(map),axis image;zoom on;p=length(u);u=[u(1:p-4)];
   v=[u,'C.png'];imwrite(Z,map,v);
    else
   image(Z),colormap(map),axis image;zoom on;p=length(u);u=[u(1:p-4)];
   v=[u,'C.png'];imwrite(Z,map,v);
    end
else
MC=size(X(1,:,:));MF=size(X(:,1,:));
NC=MC(1,2);NF=MF(1,1);y=randpermut(x,NF);
w=x.*997;x=w-fix(w);z=randpermut(x,NC);h=waitbar(0,'Coding the Image...');
for i=1:NF
   Y(i,:,:)=X(y(i),:,:);waitbar(i/(NF+NC),h)
end
for j=1:NC
   Z(:,j,:)=Y(:,z(j),:);waitbar((j+NF)/(NF+NC),h)
end
image(Z),axis image;zoom on;
p=length(u);u=[u(1:p-4)];v=[u,'C.png'];
imwrite(Z,v);
end
fprintf('The coded image this in :\n '),disp(v),close(h),toc

