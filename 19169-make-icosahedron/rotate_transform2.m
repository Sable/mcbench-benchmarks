function [X1, Y1, Z1]=rotate_transform2(X, Y, Z, nv, theta)
% % rotate matrices, rectangular coordinates
% % 
% % Syntax;
% % 
% % [X1, Y1, Z1]=rotate_transform2(X, Y, Z, nv, theta); 
% % 
% % ***********************************************************
% % 
% % Description
% % 
% % Rotates coordinates X, Y, and Z, about nv axis 
% % by an angle theta degrees
% % 
% % ***********************************************************
% % 
% % Input Variables
% % 
% % X, Y, Z, are matrices of rectangular coordinates.
% % 
% % nv is the vector to rotate the matrices about.  
% % 
% % theta is the angle in degrees to rotate the matrices.  
% % 
% % ***********************************************************
% % 
% % Output Variables
% % 
% % X1, Y1, Z1, are the rotated matrices in rectangular coordinates.
% % 
% % ***********************************************************
% %
% 
% Example
% 
% theta1=0:(pi/50):(2*pi);
% X=cos(theta1);
% Y=sin(theta1);
% Z=ones(size(theta1));
% nv=[1 1 1];
% theta=90;
% 
% [X1, Y1, Z1]=rotate_transform2(X, Y, Z, nv, theta);
% 
% figure(1);
% 
% plot3(X, Y, Z, 'k');
% hold on;
% plot3([0 1], [0 1], [0 1],'g');
% plot3(X1, Y1, Z1, 'r');
%
% % 
% % ***********************************************************
% % 
% % This program was written by Edward L. Zechmann 
% % 
% %     date     January 2007  
% % 
% % modified 11   March   2008  added examples
% % 
% % ***********************************************************
% % 
% % Feel free to modify this code.
% % 

%enter theta in degrees
theta=theta*pi/180;

%normalize a,b,c
nv=1/norm(nv)*nv;
a=nv(1);
b=nv(2);
c=nv(3);

ct=cos(theta);
st=sin(theta);

T=[[a^2*(1-ct)+ct a*b*(1-ct)-c*st a*c*(1-ct)+b*st];
   [a*b*(1-ct)+c*st b^2*(1-ct)+ct b*c*(1-ct)-a*st];
   [a*c*(1-ct)-b*st b*c*(1-ct)+a*st c^2*(1-ct)+ct]];    

AA=size(X);

for e1=1:AA(1);
    for e2=1:AA(2);
        
        p=[X(e1, e2); Y(e1, e2); Z(e1, e2)];
        p1=T*p;
        
        X1(e1, e2)=p1(1);
        Y1(e1, e2)=p1(2);
        Z1(e1, e2)=p1(3);
        
    end
end

