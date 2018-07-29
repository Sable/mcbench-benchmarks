function Example5_3
%Example 5.3 Packed-Tower Absorber for Recovery of Benzene Vapors, p.255, Text.
% Uses the function fsolve from the Optimization Toolbox
% and the M-function example5_3 supplied by the user. It also uses
% the function mmppint (included) to evaluate an integral of a function 
% expressed in terms of a cubic spline (mmppint is from Hanselman and
% Littlefield, Mastering Matlab 6, Prentice-Hall, 2001). 

N=20;
x=linspace(0.0476,0.324,N);
options=optimset('Display','none');
for n=1:N;
    y(n)=(0.004+0.154*x(n))/(1.004-0.846*x(n));
    yi(n)=fsolve(@example5_3,0.03,options,x(n),y(n));
    f(n)=1/(y(n)-yi(n));
end;

clf reset
plot(y,f)
axis([0.01 0.08 0 500])
title('Plot to determine NtG') 
xlabel('Bulk gas-phase concentration, y')
ylabel('1/(y-yi)')
shg

pp=spline(y,f);
c=0.5*log((1-y(1))/(1-y(N)));
ppi=mmppint(pp,c);
NtG=ppval(ppi,y(N));
fprintf('\n');
fprintf('NtG = %7.4f.\n',NtG);

function F = example5_3(yi,x,y)
FL=0.330;
FG=3.172;
F=(1-yi)/(1-y)-((1-x)/(1-7.353*yi))^(FL/FG);

function ppi=mmppint(pp,c)
% MMPPINT Cubic Spline Integral Interpolation.
%PPI=MMPPINT(PP,C) returns the piecewise polynomial vector PPI
%describing the integral of the cubic spline described by
%the piecewise polynomial in PP and having integration constant C.

if prod(size(c))~=1
    error('C must be a scalar')
end
[br,co,npy,nco]=unmkpp(pp);
sf=nco:-1:1;
ico=[co./sf(ones(npy,1),:) zeros(npy,1)];
nco=nco+1;
ico(1,nco)=c;
for k=2:npy
    ico(k,nco)=polyval(ico(k-1,:),br(k)-br(k-1));
end
ppi=mkpp(br,ico);