%discret system identification N(z)/D(z) by least square method
% [N,D]=mcar(u,y,n,k1,k2)
% u :  input signal of the system
% y :  Output signal of the system
% n :  système order
%k1,k2 indices of the first value  and the last of vector y. 
% [N,D]=mcar(u,y,n) the program allows to choose k1 and k2
function teta=least_square(u,y,n,k1,k2)
if nargin==3
plot(y);
title('select initial point k1 and final point k2 then click <return>','color','r')
[k12,y12]=ginput
k1=k12(1)
k2=k12(2)
end
[n1,m1]=size(u);if n1==1;u=u';y=y';end
z=zeros(2*n,1);
u=[z;u];y=[z;y];
k1=k1+2*n;k2+2*n;
fiy=[];fiu=[];
for i=1:n
    fi1=-y(k1-i:k2-i);fi2=u(k1-i:k2-i);
    fiy=[fiy fi1];fiu=[fiu fi2];
    fi=[fiy fiu];
end
yy=y(k1:k2);
teta=(inv(fi'*fi)*fi')*yy;
tetap=teta';
N=tetap(n+1:2*n);
D=[1 tetap(1:n)];


