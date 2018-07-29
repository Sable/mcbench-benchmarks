function [ Xt,Yt,Zt ] = multiplyEuMat( EuMat, X,Y,Z )
%MULTIPLYEUMAT takes the X, Y, Z coordinates of an object and returns the
%coordinates Xt, Yt, Zt of same object rotated using a rotation matrix

Xt=X;
Yt=Y;
Zt=Z;

resvec=[1;1;1];
for i=1:numel(X)
   temp=[X(i);Y(i);Z(i)];
   resvec=EuMat*temp;
   Xt(i)=resvec(1);
   Yt(i)=resvec(2);
   Zt(i)=resvec(3);
end