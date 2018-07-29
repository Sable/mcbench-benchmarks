%************************************************************************
%                       Bezier_circle                                   *
%                                                                       *
%           This program for practising CAO - EMMC11                    *
%           Professor :     Pierre BECKERS                              *
%           (Aerospace Laboratory, University of Liege, Belgium)        *
%           Student   :     NGUYEN QUOC DUAN                            *
%                          ( ngqduan@yahoo.com )                        *   
%                                                                       *
%************************************************************************

%*** Problem ************************************************************
% Given 6 points (pi = 3.1416) :                                        *
%   Pi = [rcos(-pi/3+i*pi/3)    rsin(-pi/3+i*pi/3)] for  i = 0,1,...5   *
% Defined the Bezier curve starting in P0, ending in P5 and passing     *
% through points P1, P2, P3,P4. Explain the method and show all         *
% hypotheses.                                                           *
% ***********************************************************************

clear all; close all; clc;

% INPUT DATA 

r=1;            % the length of the radius 
pi=4*atan(1);   % the value of pi
P=[];           % coordinates matrix of 6 initial points 
for i=1:6
    P(i,:)=[r*cos(-pi/3+(i-1)*pi/3) r*sin(-pi/3+(i-1)*pi/3)];
end
    
% COMPUTE THE COEFFICIENTS MATRICES 

n=5;                % the polynomial degree of the Bezier curve
coefx=zeros(3,3);  
coefy=zeros(3,3);
t=[0:0.2:1];        % matrix of the values of parameter at 6 given points
for k=1:3
    for j=1:3
        i=j-1;
        coefx(k,j)=C(i,n)*(B_para(i,n,t(k))-B_para(n-i,n,t(k)));
        coefy(k,j)=C(i,n)*(B_para(i,n,t(k))+B_para(n-i,n,t(k)));
    end
end

% COMPUTE THE COORDINATES OF BEZIER POINTS

% Initial values
xB=zeros(6,1);          % x-coordinates of 6 Bezier points
yB=zeros(6,1);          % y-coordinates of 6 Bezier points
% Solve the two equations systems
    xB(1:3)=coefx\P(1:3,1);  % x-coordinates of the first 3 Bezier points
    yB(1:3)=coefy\P(1:3,2);  % y-coordinates of the first 3 Bezier points
% Apply the symmetry of 6 given points
for i=4:6
    xB(i)=-xB(6-i+1);
    yB(i)=yB(6-i+1);
end

% OUTPUT THE SOLUTIONS
number=[0:5]';
disp('6 Bezier points coordinates : ' )
[number xB yB]

% PLOT FIGURE
figure(1);  
h=gcf;
set(h,'name','Bezier control points & Bezier curve');
set(h,'NumberTitle','off');
axis equal;
title('Bezier control points & Bezier curve');

% Conecting 6 Bezier points by straight segments
plot(xB,yB,'r-')
hold on;

% Locate 4 Bezier control points
text(xB(2),yB(2),'Q1');
text(xB(3),yB(3),'Q2');  
text(xB(4),yB(4),'Q3');
text(xB(5),yB(5),'Q4'); 
hold on;
% plot Bezier curve
precision=0.01;
for k=0:1/precision
    tp=k*precision;
    xp(k+1)=0;
    yp(k+1)=0;
    for j=1:6
        i=j-1;
        xpj=xB(j)*C(i,n)*B_para(i,n,tp);    
        ypj=yB(j)*C(i,n)*B_para(i,n,tp);
        xp(k+1)=xpj+xp(k+1);
        yp(k+1)=ypj+yp(k+1);
    end
end
plot(xp,yp,'g-')
hold on;

% Locate 6 given points
text(P(1,1),P(1,2),'Po');
text(P(2,1),P(2,2),'P1');
text(P(3,1),P(3,2),'P2');
text(P(4,1),P(4,2),'P3');
text(P(5,1),P(5,2),'P4');
text(P(6,1),P(6,2),'P5');



