function [K,H,Pmax,Pmin] = surfature(X,Y,Z),
% SURFATURE -  COMPUTE GAUSSIAN AND MEAN CURVATURES OF A SURFACE
%   [K,H] = SURFATURE(X,Y,Z), WHERE X,Y,Z ARE 2D ARRAYS OF POINTS ON THE
%   SURFACE.  K AND H ARE THE GAUSSIAN AND MEAN CURVATURES, RESPECTIVELY.
%   SURFATURE RETURNS 2 ADDITIONAL ARGUEMENTS,
%   [K,H,Pmax,Pmin] = SURFATURE(...), WHERE Pmax AND Pmin ARE THE MINIMUM
%   AND MAXIMUM CURVATURES AT EACH POINT, RESPECTIVELY.


% First Derivatives
[Xu,Xv] = gradient(X);
[Yu,Yv] = gradient(Y);
[Zu,Zv] = gradient(Z);

% Second Derivatives
[Xuu,Xuv] = gradient(Xu);
[Yuu,Yuv] = gradient(Yu);
[Zuu,Zuv] = gradient(Zu);

[Xuv,Xvv] = gradient(Xv);
[Yuv,Yvv] = gradient(Yv);
[Zuv,Zvv] = gradient(Zv);

% Reshape 2D Arrays into Vectors
Xu = Xu(:);   Yu = Yu(:);   Zu = Zu(:); 
Xv = Xv(:);   Yv = Yv(:);   Zv = Zv(:); 
Xuu = Xuu(:); Yuu = Yuu(:); Zuu = Zuu(:); 
Xuv = Xuv(:); Yuv = Yuv(:); Zuv = Zuv(:); 
Xvv = Xvv(:); Yvv = Yvv(:); Zvv = Zvv(:); 

Xu          =   [Xu Yu Zu];
Xv          =   [Xv Yv Zv];
Xuu         =   [Xuu Yuu Zuu];
Xuv         =   [Xuv Yuv Zuv];
Xvv         =   [Xvv Yvv Zvv];

% First fundamental Coeffecients of the surface (E,F,G)
E           =   dot(Xu,Xu,2);
F           =   dot(Xu,Xv,2);
G           =   dot(Xv,Xv,2);

m           =   cross(Xu,Xv,2);
p           =   sqrt(dot(m,m,2));
n           =   m./[p p p]; 

% Second fundamental Coeffecients of the surface (L,M,N)
L           =   dot(Xuu,n,2);
M           =   dot(Xuv,n,2);
N           =   dot(Xvv,n,2);

[s,t] = size(Z);

% Gaussian Curvature
K = (L.*N - M.^2)./(E.*G - F.^2);
K = reshape(K,s,t);

% Mean Curvature
H = (E.*N + G.*L - 2.*F.*M)./(2*(E.*G - F.^2));
H = reshape(H,s,t);

% Principal Curvatures
Pmax = H + sqrt(H.^2 - K);
Pmin = H - sqrt(H.^2 - K);
