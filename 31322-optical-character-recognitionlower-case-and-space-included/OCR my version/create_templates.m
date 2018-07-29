%CREATE TEMPLATES
%Letter
clc;
close all;
A=imread('letters_numbers\A.bmp');B=imread('letters_numbers\B.bmp');
C=imread('letters_numbers\C.bmp');D=imread('letters_numbers\D.bmp');
E=imread('letters_numbers\E.bmp');F=imread('letters_numbers\F.bmp');
G=imread('letters_numbers\G.bmp');H=imread('letters_numbers\H.bmp');
I=imread('letters_numbers\I.bmp');J=imread('letters_numbers\J.bmp');
K=imread('letters_numbers\K.bmp');L=imread('letters_numbers\L.bmp');
M=imread('letters_numbers\M.bmp');N=imread('letters_numbers\N.bmp');
O=imread('letters_numbers\O.bmp');P=imread('letters_numbers\P.bmp');
Q=imread('letters_numbers\Q.bmp');R=imread('letters_numbers\R.bmp');
S=imread('letters_numbers\S.bmp');T=imread('letters_numbers\T.bmp');
U=imread('letters_numbers\U.bmp');V=imread('letters_numbers\V.bmp');
W=imread('letters_numbers\W.bmp');X=imread('letters_numbers\X.bmp');
Y=imread('letters_numbers\Y.bmp');Z=imread('letters_numbers\Z.bmp');
%lower case letters
a=imread('letters_numbers\a.png');b=imread('letters_numbers\b.png');
c=imread('letters_numbers\c.png');d=imread('letters_numbers\d.png');
e=imread('letters_numbers\e.png');f=imread('letters_numbers\f.png');
g=imread('letters_numbers\g.png');h=imread('letters_numbers\h.png');
i=imread('letters_numbers\i.png');j=imread('letters_numbers\j.png');
k=imread('letters_numbers\k.png');l=imread('letters_numbers\l.png');
m=imread('letters_numbers\m.png');n=imread('letters_numbers\n.png');
o=imread('letters_numbers\o.png');p=imread('letters_numbers\p.png');
q=imread('letters_numbers\q.png');r=imread('letters_numbers\r.png');
s=imread('letters_numbers\s.png');t=imread('letters_numbers\t.png');
u=imread('letters_numbers\u.png');v=imread('letters_numbers\v.png');
w=imread('letters_numbers\w.png');x=imread('letters_numbers\x.png');
y=imread('letters_numbers\y.png');z=imread('letters_numbers\z.png');


%Number
one=imread('letters_numbers\1.bmp');  two=imread('letters_numbers\2.bmp');
three=imread('letters_numbers\3.bmp');four=imread('letters_numbers\4.bmp');
five=imread('letters_numbers\5.bmp'); six=imread('letters_numbers\6.bmp');
seven=imread('letters_numbers\7.bmp');eight=imread('letters_numbers\8.bmp');
nine=imread('letters_numbers\9.bmp'); zero=imread('letters_numbers\0.bmp');
%*-*-*-*-*-*-*-*-*-*-*-
letter=[A B C D E F G H I J K L M...
    N O P Q R S T U V W X Y Z];
number=[one two three four five...
    six seven eight nine zero];

 
    
lowercase = [a b c d e f g h i j k ...
     l m n o p q r s t u v w x y z];
character=[letter number lowercase];
templates=mat2cell(character,42,[24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 24 ...
    24 24]);
save ('templates','templates')
clear all
