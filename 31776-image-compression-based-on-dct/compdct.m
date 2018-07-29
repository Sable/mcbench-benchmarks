clear all,clc
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%%************************************************************************** 
%************************************************************************** 
% Principal Program  of gray scale image  compression  "This code specific using in medicale image.
% Autors : Said BOUREZG - Abd Elhak DERBEL  
% Engineers on Electronics  option: Communication .
% Date : 05.26.2009
% Filename compdwt.m (Mathlab)
% Please contribute if you find this software useful.
% Report bugs to: said.bourezg@yahoo.fr
% This program is part of my undergraduate project in M'sila university,
% Algeria.
% Adress:                          Said BOUREZG
%                               Elbassatine street
%                                 28038 Tarmount
%                               M'sila --- Algeria 
% Email:  said.bourezg@yahoo.fr
% Mobile: +213 796 018049 
% http://
% If you can improve this code furtherly or add arithmatic coding stage,
% please let me know. Thanks
%************************************************************************** 
%--------------------------------------------------------------------------
    %%%% identification of variables used %%%%
%--------------------------------------------------------------------------   
%TH      le seuille
%R       divisé l'image originale en des bloock de taille 8x8,16x16 ou 32x32
%MX,NX   les dimensions de l'image originale :la hauteur& la lengeur.
%Q       le nombre de bits de sortie aprés la quantification.
%X       l'image originale
%XR      l'image reconstruié
%Xdct    matrice transformée avec la DCT
%XdctQ   matrice DCT est quantifié
%NBz     c'est le nombre de zéros aprés seuillage de la matrice DCT
%pcdz    c'est le nombre des éléments nulls paraport à tous les éléments du matrice Xdct, est présenté en pourcentage
%DCTmin  c'est : la valeur maximal du matrice image aprés tansformée DCT
%DCTmax  c'est: la valeur minimal du matrice image aprés tansformée DCT
%XZzag   c'est: la matrice aprés la lecture zigzag
%XZv     c'est: la matrice convertie le 'XZzag ' de 2-dimention à 1-dimention
%Xrlee   c'est le vecteur qui contien les informations qui codées celon RLE
%comp    c'est le vecteur qui contient les valeurs répétées
%compteur  c'est le compteur des nombre de répétitions aprés RLE
%Xrle1   le vecteur qui contient les valeurs différent de 1 de compteur.
%Tcod8   c'est un tableau qui code le code obtenu aprés codage huffman.
%LT,LXf,Lcd...etc ce sont des valeurs qui représentent les longueurs de
%TAB8,Xfreq,...
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
                      %%% charge et lecture de l'image %%%
%--------------------------------------------------------------------------                
[filename, pathname] = uigetfile('*.bmp', 'open image');% only image Bitmap
if isequal(filename, 0) | isequal(pathname, 0)   
    disp('Image input canceled.');  
   X = [];    map = []; 
else
    [X,MAP]=imread(fullfile(pathname, filename));%Lecture d'image.
end;
[MX,NX]=size(X);
lsz=length(size(X));
if lsz==3
X=rgb2gray(X);
end
%--------------------------------------------------------------------------
                    %%% Application de la DCT sur l'image %%%
%--------------------------------------------------------------------------
disp(' input size of bloc RxR: 8x8 or 16x16 or 32x32.')
R=input('R=');%type de bloc (8*8 or 16*16 or 32*32).
Xdct = blkproc(X,[R R],'dct2');%Transformation dct de matrice X.
%--------------------------------------------------------------------------
                              %%% Seuillage %%%
%--------------------------------------------------------------------------
disp('seuil input .')
TH=input('TH=');%seuill
NBz=0; % Nombre de coeifficients dct nuls
[M,N]=size(Xdct);
for i=1:M
    for j=1:N
        if abs(Xdct(i,j))<TH
            Xdct(i,j)=0;
            NBz=NBz+1;
        end;
    end;
end;
pcdz=100*NBz/(N*M); %Pourcentage de coeifficients dct nuls
disp(['Pourcentage des coefficients qui seuillée = ' num2str(pcdz)])
%--------------------------------------------------------------------------
                       %%%%  Quantification  %%%%
%--------------------------------------------------------------------------
disp('nombre de bits pour coder les éléments de matrice')
Q=input('Q=');
%Q=8;
DCTmin=min(min(Xdct));
DCTmax=max(max(Xdct));
XdctQ=round((-1+2^Q)*(Xdct-DCTmin)/(DCTmax-DCTmin));
%IXdctQ=round(((DCTmax-DCTmin)/(-1+2^Q))*XdctQ+DCTmin);
%DifQ=XdctQ-IXdctQ
%--------------------------------------------------------------------------
             %%% Lecture de matrice Quatifiée en zig zag %%%
%--------------------------------------------------------------------------           
if R==8
XZzag=blkproc(XdctQ,[R R],'zigzag(x)');
else
    if R==16
        XZzag=blkproc(XdctQ,[R R],'zigzag16(x)');
    else
        if R==32
            XZzag=blkproc(XdctQ,[R R],'zigzag32(x)');
        end;
    end;
end;       
[M1 M2]=size(XZzag);
NM=M1*M2;
XZv=reshape(XZzag',1,NM);%la fonction reshape rendre la matrice vecteur
%--------------------------------------------------------------------------
                            %%% Codage RLE %%%% 
%-------------------------------------------------------------------------- l
Xrlee=rle(XZv);
%Grle=(length(XZv)-length(Xrlee))*100/length(XZv);%Gain de compression RLE
 comp=Xrlee(1:2:length(Xrlee));
 Lcomp=length(comp);
 compteur=Xrlee(2:2:length(Xrlee));
 %[fff,ccc]=hist(compteur,256);
 %plot(ccc,fff);
   p1=find(compteur>1);
    if max(compteur)>=256
   Xrle11=compteur(p1);
   LXrle11=length(Xrle11);
   k=1;
   for i=1:LXrle11 
   temp=abais(Xrle11(i));
       for j=1:2
   A(k)=temp(j);
   k=k+1;
   end;
  end;
  Xrle1=A;
  R=R+100;
   else
   Xrle1=compteur(p1);
   end;
      LXrle1=length(Xrle1);
   Xrle2=zeros(1,length(compteur));
   for i=1:length(compteur)
       if compteur(i)>1
           Xrle2(i)=1;
       end;
   end;
   L=length(Xrle2);
Lrl=round(L/8);
if mod(L,8)<4
   if mod(L,8)~=0
      Lrl=Lrl+1;
   end
end 
Lrln=(Lrl)*8 ;
DIFLrl=(Lrln)-L ;
rln=zeros(1,Lrln);
k=1;
for i=1:L
    rln(k)=Xrle2(i);
    k=k+1;
end
Trl8=zeros(1,Lrl);
k=1;
for i=1:Lrl 
   for j=0:7
  Trl8(i)=(rln(k+j))*(2^j)+Trl8(i);
    end;
  k=k+8; 
end;
Xrle=[Xrle1 Trl8 comp];
  %--------------------------------------------------------------------------
                          %%%% codage Huffman  %%%%
%--------------------------------------------------------------------------                          
[Xi,Xf]=proba(Xrle);% fonction proba sert à calculer les fréquences des coefficients.
somf=sum(Xf); %la somme des frequences
Xfreq=Xf./somf;
[dict,avglen] = huffmandict([0:2^Q-1],Xfreq);
code = huffmanenco(Xrle,dict);
%--------------------------------------------------------------------------
%%%% Mettre le code de 0101010...dans un vecteur de 8 bits a l'élement%%%%
%--------------------------------------------------------------------------
L=length(code);
Lcd=round(L/8);
if mod(L,8)<4
   if mod(L,8)~=0
      Lcd=Lcd+1;
   end
end 
Lcdn=(Lcd)*8 ;
DIFLcd=(Lcdn)-L ;
codn=zeros(1,Lcdn);
k=1;
for i=1:L
    codn(k)=code(i);
    k=k+1;
end
Tcod8=zeros(1,Lcd);
k=1;
for i=1:Lcd 
   for j=0:7
  Tcod8(i)=(codn(k+j))*(2^j)+Tcod8(i);
    end;
  k=k+8; 
end;
%--------------------------------------------------------------------------
           %%% sauvegardée des données de compression %%%
%--------------------------------------------------------------------------
LT=length(Tcod8);
LXf=length(Xf);
A=[];P=[];B=[];
k=1;ii=1; jj=1;
for i=1:LXf
   if Xf(i)>255 
   temp=abais(Xf(i));
   P(ii)=i;
     for j=1:2
   A(k)=temp(j);
   k=k+1;
   end;
   ii=ii+1;
   else
      B(jj)=Xf(i);
      jj=jj+1;
   end;
end;
 l=length(A);
 h01=resize(LT);
 h02=resize(LXf);
 h03=resize(DCTmax*10^4);
 if DCTmin<0 
     sign=1;
 else
     sign=0;
 end;
 h04=resize(DCTmin*10^4);
 h05=resize(l);
 h06=resize(M2);
 h07=resize(LXrle1);
  h08=resize(Lcomp);
 fichier=[Tcod8 A B P h01  h02 h03 h04 h05 h06 h07 h08 DIFLrl DIFLcd sign Q R];
 TC=MX*NX/length(fichier)
 GC=100*(1-1/TC)
 f=fopen('fichier.dct','w');
 fwrite(f,fichier,'ubit8');
 fclose(f);
 
