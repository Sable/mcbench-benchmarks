function [gm samc] = mcurvature_vec(x,y,z)
% Description: The function calculates mean curvature and 
% Surface Avg Mean Curvature (SAMC) of a surface formed by x, y & z. 
% The input are the coordinate matrices x, y & z. The 
% matrices can be formed using meshgrid or similar functions.
% This code is a vectorized form of original code (mcurvature) posted 
% on Matlab File Exchange.

% The mean curvature is calculated according to the formula:

% If x:U->R^3 is a regular patch, then the mean curvature is given by
%       
%         H = (eG-2fF+gE)/(2(EG-F^2)),	
% 
% where E, F, and G are coefficients of the first fundamental form and
% e, f, and g are coefficients of the second fundamental form 

% Reference: Gray, A. "The Gaussian and Mean Curvatures." §16.5 in 
% Modern Differential Geometry of Curves and Surfaces with Mathematica, 
% 2nd ed. Boca Raton, FL: CRC Press, pp. 373-380, 1997 (p. 377).

% Inspired by:
% Title:  	Mean Curvature
% Author: 	Ahmed Elnaggar
% Summary: 	Calculate the Mean curvature of a given surface (x,y,z).

gm = zeros(size(z));
[xu,xv]     =   gradient(x);
[xuu,xuv]   =   gradient(xu);
[xvu,xvv]   =   gradient(xv);

[yu,yv]     =   gradient(y);
[yuu,yuv]   =   gradient(yu);
[yvu,yvv]   =   gradient(yv);

[zu,zv]     =   gradient(z);
[zuu,zuv]   =   gradient(zu);
[zvu,zvv]   =   gradient(zv);

Xu(:,:,1) = xu;
Xu(:,:,2) = yu;
Xu(:,:,3) = zu;

Xv(:,:,1) = xv;
Xv(:,:,2) = yv;
Xv(:,:,3) = zv;

Xuu(:,:,1) = xuu;
Xuu(:,:,2) = yuu;
Xuu(:,:,3) = zuu;

Xuv(:,:,1) = xuv;
Xuv(:,:,2) = yuv;
Xuv(:,:,3) = zuv;

Xvv(:,:,1) = xvv;
Xvv(:,:,2) = yvv;
Xvv(:,:,3) = zvv;

E = dot(Xu,Xu,3);
F           =   dot(Xu,Xv,3);
G           =   dot(Xv,Xv,3);
m           =   cross(Xu,Xv,3);
temp(:,:,1) = sqrt(sum(m.*m,3));
temp(:,:,2) = temp(:,:,1);
temp(:,:,3) = temp(:,:,1);
n           =   m./temp;
L           =   dot(Xuu,n,3);
M           =   dot(Xuv,n,3);
N           =   dot(Xvv,n,3);
gm          =   ((E.*N)+(G.*L)-(2.*F.*M))./(2.*(E.*G - F.^2));

dim = size(z);
samc = 1/ (dim(1) * dim(2)) * sum (gm(:).^2);


