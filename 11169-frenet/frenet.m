function [T,N,B,k,t] = frenet(x,y,z),
% FRENET - Frenet-Serret Space Curve Invarients
%   
%   [T,N,B,k,t] = frenet(x,y);
%   [T,N,B,k,t] = frenet(x,y,z);
% 
%   Returns the 3 vector and 2 scaler invarients of a space curve defined
%   by vectors x,y and z.  If z is omitted then the curve is only a 2D,
%   but the equations are still valid.
% 
%    _    r'
%    T = ----  (Tangent)
%        |r'|
% 
%    _    T'
%    N = ----  (Normal)
%        |T'|
%    _   _   _
%    B = T x N (Binormal)
% 
%    k = |T'|  (Curvature)
% 
%    t = dot(-B',N) (Torsion)
% 
% 
%    Example:
%    theta = 2*pi*linspace(0,2,100);
%    x = cos(theta);
%    y = sin(theta);
%    z = theta/(2*pi);
%    [T,N,B,k,t] = frenet(x,y,z);
%    line(x,y,z), hold on
%    quiver3(x,y,z,T(:,1),T(:,2),T(:,3),'color','r')
%    quiver3(x,y,z,N(:,1),N(:,2),N(:,3),'color','g')
%    quiver3(x,y,z,B(:,1),B(:,2),B(:,3),'color','b')
%    legend('Curve','Tangent','Normal','Binormal')
% 
% 
% See also: GRADIENT

if nargin == 2,
    z = zeros(size(x));
end

% CONVERT TO COLUMN VECTOR
x = x(:);
y = y(:);
z = z(:);

% SPEED OF CURVE
dx = gradient(x);
dy = gradient(y);
dz = gradient(z);
dr = [dx dy dz];

ddx = gradient(dx);
ddy = gradient(dy);
ddz = gradient(dz);
ddr = [ddx ddy ddz];



% TANGENT
T = dr./mag(dr,3);


% DERIVIATIVE OF TANGENT
dTx =  gradient(T(:,1));
dTy =  gradient(T(:,2));
dTz =  gradient(T(:,3));

dT = [dTx dTy dTz];


% NORMAL
N = dT./mag(dT,3);
% BINORMAL
B = cross(T,N);
% CURVATURE
% k = mag(dT,1);
k = mag(cross(dr,ddr),1)./((mag(dr,1)).^3);
% TORSION
t = dot(-B,N,2);




function N = mag(T,n),
% MAGNATUDE OF A VECTOR (Nx3)
%  M = mag(U)
N = sum(abs(T).^2,2).^(1/2);
d = find(N==0); 
N(d) = eps*ones(size(d));
N = N(:,ones(n,1));