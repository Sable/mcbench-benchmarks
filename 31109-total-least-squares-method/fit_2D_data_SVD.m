function [Err, P] = fit_2D_data_SVD(XData, YData, vizualization)
%
% function [Err, P] = fit_2D_data_SVD(XData, YData, vizualization)
%
% Orthogonal linear regression method in 2D for model: 
%
%                   y = bx + a   
%
% by using the Singular Value Decomposition (SVD) method
%
% Input parameters:
%  - XData: input data block -- x: axis
%  - YData: input data block -- y: axis
%  - vizualization: figure ('yes','no')
% Return parameters:
%  - Err: error - sum of orthogonal distances 
%  - P: vector of model parameters [b-slope, a-offset] 
%
% Authors:
% Ivo Petras (ivo.petras@tuke.sk)
% Dagmar Bednarova (dagmar.bednarova@tuke.sk)
%
% Date: 25/Jan/2007
%
kx=length(XData);
ky=length(YData);
if kx ~= ky
   disp('Incompatible X and Y data.');
   close all;
end
%
xp=mean(XData);
yp=mean(YData);
%
xs=XData-xp;
ys=YData-yp;
%
D=[xs,ys];
[U,S,V]=svd(D);
%
l1=V(1,1);
l2=V(1,2);
l3=-(l1*xp+l2*yp);
%
a=-l3/l2;
b=-l1/l2;
%
P=[b a];
%
Yhat = XData.*b + a;
Xhat = ((YData-a)./b);
alpha = atan(abs((Yhat-YData)./(Xhat-XData)));
d=abs(Xhat-XData).*sin(alpha);
Err=sum(abs(d));
%
switch lower(vizualization)
     case {'yes'}
        plot(XData,YData,'blue*'); 
        hold on;
        plot(XData,Yhat,'black');
        hold off
     case {'no' }
         disp('No vizualization.')
end    