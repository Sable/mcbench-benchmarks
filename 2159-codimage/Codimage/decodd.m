function decodd(u,x)
%----------------------------------------------------------------------------------------
%  DECODD
%  The program reorders an image in format .tif,bmp,png,pcx (no jpg).
%
%  The coded image can be in any portfolio of the computer.
%
%  It admits a format of map of colors or in true color. 
%
%  The syntax is decodd.
%
%  The key is a word without numbers, (of up to 24 characters).
%
%  It also admits an image in scale of grises(256 ranges of gray).
%
%  Author: Francisco Echegorri  
%  E-mail: fdefac@montevideo.com.uy  
%  Created in September of 2002.  
%-----------------------------------------------------------------------------------------
%
%  El programa reordena una imagen en formato .tif,bmp,png,pcx(no jpg).
%
%  La imagen original puede estar ubicada en cualquier carpeta de la computadora.
%
%  Admite un formato de mapa de colores o en color verdadero.
%
%  La sintaxis es decodd.
%  La clave es una palabra sin números,(de hasta 24 caracteres).
%
%  Admite tambien una imagen en escala de grises(256 gamas de gris).
%
if nargin<1
[u, pathname] = uigetfile('*.*', 'Select the Image to decode');
buffer=pwd;
cd (pathname);
cd (buffer);
end
x=input('To enter a key word \n','s');tic
x=dalfa(x);x=keyexpansion(x);[Z,map]=imread(u);      
if length(size(Z))==2
   MC=size(Z(1,:));MF=size(Z(:,1));NC=MC(1,2);NF=MF(1,1);w=x.*997;x=w-fix(w);
   y=randpermut(x,NF);z=randpermut(x,NC);
    h = waitbar(0,'Decoding the Image...');
      for j=1:NC
      Y(:,z(j))=Z(:,j);waitbar(j/(NC+NF),h)
   end
   for i=1:NF
      X(y(i),:)=Y(i,:);waitbar((i+NC)/(NF+NC),h)
   end
   if isempty(map)==1
      map=gray(256);image(X),colormap(map),axis image,zoom on,p=length(u);v=[u(1:p-5)];
   v=[v,'D.jpg'];imwrite(X,map,v);
    else
   image(X),colormap(map),axis image,zoom on,p=length(u);v=[u(1:p-5)];
   v=[v,'D.jpg'];imwrite(X,map,v);
    end
else
MC=size(Z(1,:,:));MF=size(Z(:,1,:));NC=MC(1,2);NF=MF(1,1);
y=randpermut(x,NF);w=x.*997;x=w-fix(w);z=randpermut(x,NC); 
h = waitbar(0,'Decoding the Image...');
for j=1:NC
     Y(:,z(j),:)=Z(:,j,:);waitbar(j/(NC+NF),h)
   end
   for i=1:NF
       X(y(i),:,:)=Y(i,:,:);waitbar((i+NC)/(NF+NC),h)
    end
    p=length(u);v=[u(1:p-5)];v=[v,'D.jpg'];
    image(X),axis image;zoom on;imwrite(X,v);
    end
    fprintf('The decoded image this in :\n '),disp(v),toc

 close(h)