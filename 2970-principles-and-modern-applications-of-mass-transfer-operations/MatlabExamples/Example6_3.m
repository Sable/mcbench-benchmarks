function Example6_3
% Example 6.3, p.299 Text
% Uses the function fsolve from the Optimization Toolbox
% and the M-function example6_3 supplied by the user. It also uses
% the function mmppint (included) to evaluate an integral of a function 
% expressed in terms of a cubic spline (mmppint is from Hanselman and
% Littlefield, Mastering Matlab 6, Prentice-Hall, 2001). 
 

xW=fsolve(@example6_3,0.4,optimset('fsolve'))
FF=100; D=60; W=FF-D; xF=0.5;
yDav=(FF*xF-W*xW)/D

function F = example6_3(x)
FF=100; D=60; W=FF-D;
F=log(FF/W)-int(x);


function y = int(x)

xx=[.317 .361 .409 .460 .500 .516 .577];
ff=[5.464 5.291 5.236 5.263 5.376 5.435 5.780];
pp=spline(xx,ff);
c=0;
ppi=mmppint(pp,c);
y=ppval(ppi,0.5)-ppval(ppi,x);

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