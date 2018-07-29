clear all;
close all;
clc;

targetFolder = './images/';
candidateImages = {'skewed1.gif', 'trapezoid.jpg', 'QR2.jpg', 'QR3.jpg', 'book.jpg', 'square.jpg', 'skewed1.gif' };
candidateChoice = 5;

targetImageFile = strcat(targetFolder , char(candidateImages(candidateChoice )));
targetImageData = imread(targetImageFile);

% 5.1 Undoing Perspective Distortion of Planar Surface
% a)

%book=imread('trapezoid.jpg');
imshow(targetImageData);

% b)
fprintf('Corner selection must be clockwise or anti-clockwise.\n');
[X Y] = ginput(4);

%if ispolycw(X, Y) % if the coordinates are not clockwise, sort them clockwise    
%    [X, Y] = poly2cw(X, Y)
%end

%X = uint8(X);
%Y = uint8(Y);
[X Y] = sortPolyFromClockwiseStartingFromTopLeft( X, Y );

x=[1;210;210;1];
y=[1;1;297;297];

% c)
A=zeros(8,8);
A(1,:)=[X(1),Y(1),1,0,0,0,-1*X(1)*x(1),-1*Y(1)*x(1)];
A(2,:)=[0,0,0,X(1),Y(1),1,-1*X(1)*y(1),-1*Y(1)*y(1)];

A(3,:)=[X(2),Y(2),1,0,0,0,-1*X(2)*x(2),-1*Y(2)*x(2)];
A(4,:)=[0,0,0,X(2),Y(2),1,-1*X(2)*y(2),-1*Y(2)*y(2)];

A(5,:)=[X(3),Y(3),1,0,0,0,-1*X(3)*x(3),-1*Y(3)*x(3)];
A(6,:)=[0,0,0,X(3),Y(3),1,-1*X(3)*y(3),-1*Y(3)*y(3)];

A(7,:)=[X(4),Y(4),1,0,0,0,-1*X(4)*x(4),-1*Y(4)*x(4)];
A(8,:)=[0,0,0,X(4),Y(4),1,-1*X(4)*y(4),-1*Y(4)*y(4)];

v=[x(1);y(1);x(2);y(2);x(3);y(3);x(4);y(4)];

u=A\v;
%which reshape

U=reshape([u;1],3,3)';

w=U*[X';Y';ones(1,4)];
w=w./(ones(3,1)*w(3,:));

% d)
%which maketform
T=maketform('projective',U');

%which imtransform
P2=imtransform(targetImageData,T,'XData',[1 210],'YData',[1 297]);

% e)
figure,
imshow(P2)