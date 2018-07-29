%CREATE TEMPLATES
%Letter
A=imread('A.bmp');B=imread('B.bmp');
C=imread('C.bmp');D=imread('D.bmp');
E=imread('E.bmp');F=imread('F.bmp');
G=imread('G.bmp');H=imread('H.bmp');
I=imread('I.bmp');J=imread('J.bmp');
K=imread('K.bmp');L=imread('L.bmp');
M=imread('M.bmp');N=imread('N.bmp');
O=imread('O.bmp');P=imread('P.bmp');
Q=imread('Q.bmp');R=imread('R.bmp');
S=imread('S.bmp');T=imread('T.bmp');
U=imread('U.bmp');V=imread('V.bmp');
W=imread('W.bmp');X=imread('X.bmp');
Y=imread('Y.bmp');Z=imread('Z.bmp');
Afill=imread('fillA.bmp');
Bfill=imread('fillB.bmp');
Dfill=imread('fillD.bmp');
Ofill=imread('fillO.bmp');
Pfill=imread('fillP.bmp');
Qfill=imread('fillQ.bmp');
Rfill=imread('fillR.bmp');




%Number
one=imread('1.bmp');  two=imread('2.bmp');
three=imread('3.bmp');four=imread('4.bmp');
five=imread('5.bmp'); six=imread('6.bmp');
seven=imread('7.bmp');eight=imread('8.bmp');
nine=imread('9.bmp'); zero=imread('0.bmp');
zerofill=imread('fill0.bmp');
fourfill=imread('fill4.bmp');
sixfill=imread('fill6.bmp');
sixfill2=imread('fill6_2.bmp');
eightfill=imread('fill8.bmp');
ninefill=imread('fill9.bmp');
ninefill2=imread('fill9_2.bmp');




%*-*-*-*-*-*-*-*-*-*-*-
letter=[A Afill B Bfill C D Dfill E F G H I J K L M...
    N O Ofill P Pfill Q Qfill R Rfill S T U V W X Y Z];

number=[one two three four fourfill five...
    six sixfill sixfill2 seven eight eightfill nine ninefill ninefill2 zero zerofill];

character=[letter number];

NewTemplates=mat2cell(character,42,[24 24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24]);






save ('NewTemplates','NewTemplates')
clear all