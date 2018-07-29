function intrec(Z)
%INTREC Performs morphological character recognition
%INTREC(X) recognizes the characters (in integer form) present in the
%image X and displays it as output. INTREC uses morphological operations(like
%Dilation and Hit-or-Miss transform) to recognize characters.The charecter
%size of the integers present in the image should be exactly 26, otherwise 
%it may not recognize it.
%
%Example:
%X=imread('testimage1.bmp');
%imshow(X)
%intrec(X)
%The digits found in the image are:
%0
%3
%5  
%--------------------------------------------------------------------------
%Authors: Jahanzeb Rajput and Mohammad Fahad
%Department of Electrical Engineering
%University of Engineering and Technology, Lahore, Pakistan.
%--------------------------------------------------------------------------

A= imread ('zero.bmp');
B= imread ('one.bmp');
C= imread ('two.bmp');
D= imread ('three.bmp');
E= imread ('four.bmp');
F= imread ('five.bmp');
G= imread ('six.bmp');
H= imread ('seven.bmp');
I= imread ('eight.bmp');
J= imread ('nine.bmp');
%SE 2
SE = strel('square',3);

K=imdilate(A,SE);A2=K-A;

L=imdilate(B,SE);B2=L-B;

M=imdilate(C,SE);C2=M-C;

N=imdilate(D,SE);D2=N-D;

O=imdilate(E,SE);E2=O-E;

P=imdilate(F,SE);F2=P-F;

Q=imdilate(G,SE);G2=Q-G;

R=imdilate(H,SE);H2=R-H;

S=imdilate(I,SE);I2=S-I;

T=imdilate(J,SE);J2=T-J;
%-------------------------
%Hit or Miss
%-------------------------
disp('The digits found in the image are:');
if ~isempty(nonzeros(bwhitmiss(Z,A,A2)))
  disp('0');
end
%imshow('num1.bmp') 
%U=bwhitmiss(Z,F,F2);
%figure
%imshow(U)
if ~isempty(nonzeros(bwhitmiss(Z,B,B2)))
    disp('1');
end

if ~isempty(nonzeros(bwhitmiss(Z,C,C2)))
   disp('2');
end

if ~isempty(nonzeros(bwhitmiss(Z,D,D2)))
    disp('3');
end

if ~isempty(nonzeros(bwhitmiss(Z,E,E2)))
   disp('4');
end

if ~isempty(nonzeros(bwhitmiss(Z,F,F2)))
   disp('5');
end

if ~isempty(nonzeros(bwhitmiss(Z,G,G2)))
   disp('6');
end

if ~isempty(nonzeros(bwhitmiss(Z,H,H2)))
   disp('7');
end

if ~isempty(nonzeros(bwhitmiss(Z,I,I2)))
   disp('8');
end

if ~isempty(nonzeros(bwhitmiss(Z,J,J2)))
   disp('9');
end


