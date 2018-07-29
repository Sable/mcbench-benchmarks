% Rieman problem solver
% %%%%%%%%%%%%%%%%%%%%%%
%                       [I |II (u) : (u) III |IV ]
% This function solve the Rieman problem of a discontinuity in the initial
% data, about the 1D incompressible Euler equations for an ideal polytropic
% gas.
% %%%%%%%%%%%%%%%%%%%%%%
% The essentialy sintax is as follow:
% [u,p,cII,cIII] = RI_solve(cI,pI,uI,cIV,pIV,uIV,g)
% where c is the sound speed, u the velocity of the gas, p the pressure;
% and the suffix I,II,III,IV refer about the zones of the analysed
% geometry. The zones II and III are connected with a contact
% discontinuity, so it is possible to define u = uII = uIII, and p = pII =
% = pIII. The connecting I-II and III-IV can be a shock waves or a
% systems of rarefection waves.
% The function can be used vectorially.
% Other syntax are aviable:
% [u,p,cII,cIII,res] = RI_solve(cI,pI,uI,cIV,pIV,uIV,g)
% [u,p,cII,cIII] = RI_solve(cI,pI,uI,cIV,pIV,uIV,g,eps)
% [u,p,cII,cIII] = RI_solve(cI,pI,uI,cIV,pIV,uIV,g,eps,nmax)
% [u,p,cII,cIII,res] = RI_solve(cI,pI,uI,cIV,pIV,uIV,g,eps)
% [u,p,cII,cIII,res] = RI_solve(cI,pI,uI,cIV,pIV,uIV,g,eps,nmax)
% where eps is the tollerance admitted, nmax the max number of iterations
% admitted, res the matrix of residuals (number of iteraction X number of 
% vectorial unknows) used to check the convergence.
%
% Marco Pannuzzo                        25/11/2006  12:21

function [u,p,cII,cIII,res] = RI_solve(cI,pI,uI,cIV,pIV,uIV,g,eps,nmax)

switch nargin
    case 7
    eps = 10^-5;	nmax = 100;
    case 8
    nmax = 100;
end

N = length(cI);
if N >1 && size(cI,2)>1
    cI = cI';   pI = pI';   uI = uI';
    cIV = cIV'; pIV= pIV';  uIV= uIV';
end
%%%%% Pre-allocating for speed
u = zeros(N,nmax+1);
res = zeros(N,nmax+1);
pII = zeros(N,1); pIII = pII;
dpII = pII; dpIII = pII;
cII = pII; cIII = pII;

%%%%% Initial condition
d = (g-1)*0.5;
z = cIV./cI.*(pI./pIV).^(d/g);
rpI = cI + d;    rmIV = cIV - d;
u(:,1) = z.*rpI - rmIV;  u(:,1) = u(:,1)./(d.*(1+z));

%%%%%% Solution cycle
i = 1;  res(:,i) = eps*2;
while i<nmax && max(res(:,i)) > eps
    for j = 1:N
        uk = u(j,i);
        % Left wave
        if uk < uI(j)   %Shock wave
            M1 = (g+1)*0.25 * (uI(j) - uk)./cI(j) +...
                sqrt( 1+((g+1)*0.25*(uI(j) - uk)./cI(j))^2 );
            pII(j) = pI(j) *( 1 + (2*g/(g+1)*(M1^2-1)) );
            dpII(j) = -2*g*pI(j)/cI(j)*M1^3/(1+M1^2);
            cII(j) = cI(j)*sqrt( (g+1+(g-1)*pII(j)/pI(j))/(g+1+(g-1)*pI(j)/pII(j)) );
        else            %Rarefaction waves
            cII(j) = cI(j) - d*(uk - uI(j));
            pII(j) = pI(j)*( cII(j)/cI(j) )^(g/d);
            dpII(j) = -g*pII(j)/cII(j);
        end
        % Rigth wave
        if uk > uIV(j)   %Shock wave
            M1 = (g+1)*0.25 * (uk - uIV(j))./cIV(j) +...
               sqrt( 1+((g+1)*0.25*(uk - uIV(j))./cIV(j))^2 );
            pIII(j) = pIV(j) *( 1+ (2*g/(g+1)*(M1^2-1)) );
            dpIII(j) = 2*g*pIV(j)/cIV(j)*M1^3/(1+M1^2);
            cIII(j) = cIV(j)*sqrt( (g+1+(g-1)*pIII(j)/pIV(j))/(g+1+(g-1)*pIV(j)/pIII(j)) );
        else            %Rarefaction waves
            cIII(j) = cIV(j) + d*(uk - uIV(j));
            pIII(j) = pIV(j)*( cIII(j)/cIV(j) )^(g/d);
            dpIII(j) = g*pIII(j)/cIII(j);
        end
    end
    i = i+1;
    res(:,i) = abs(1 -pII./pIII);
    u(:,i) = u(:,i-1) - (pII-pIII)./(dpII-dpIII);
end 
%check for vacuum
if min(cII) < 0.1 || min(cIII) < 0.1
    disp('Warning: some value of sound velocity approch zero')
end
p = pII;    u = u(:,i);
res = res(:,1:i);   res = res';
