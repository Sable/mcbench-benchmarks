% usphst1.m : make a table for the integration start values for the ultra-spherical besselfunctions 
% (phi_beta) for open universe : K = (omt - 1) * (h0 * h)^2 < 0 as a function of angle number l and wave number kb.
%
% a table x1 is made as function of la values (rows) and values for kk2/beta (columns)
% at phi_beta= 'pbstart' where the integration of the phi_beta function starts. 'pbstart' is 
% initialised in the program. Default it should be 1e-6.
% The algorithm finds a first value at the footing of jl(y), with jl the spherical
% bessel function and y is a sinh(kk2*x)/kk2 function, which sometimes outdoes x.
% After that we diminish x in small steps untill
% phi_teta(x) < 2e-6, calculating phi_teta with the cumbersome recursion formula
% of Abbott & Schaefer, avoiding the region where the recursion falls down due
% to rounding errors. It is then time to zoom in as close as possible to x1 where 
% phi_teta== pbstart, using the derivative of phi_teta, calculated from the
% formula (A23) of Abbott and Schaefer. 

% D Vangheluwe 18 feb 2005
% remark 1 : we use 2 parameters only for pbi_beta, they are :1. la and 2. kb= kk2/beta
%   kb is the inverse curvature kk2 of the universe related to the wave number beta.
% remark 2 : if we want all have all values we have to initialise a vector la1 and a vector kb1
% remark 3: the program fills the file usphst.dat with ascii start data (x1 and pbd),
%  this data is to be used by functions srcint.m and usphpar.m


clear all

% define the spacecurvature constant : kk0== -1 for open space : it should have the value +1 or -1!!
kk0 = -1;
% start value for phi_beta integration : all phi_beta's must have this value
pbstart = 1e-6

% calculate the start values of the utra-spherical function
% define an la-range+++++++++++
lmax = 1500;
%lstep1 = 25;
%lstep2 = 50;
lstep1 = 10;
lstep2 = 25;
%la1 = 60
la1 = [2,6,10, 20:lstep1:100, 100 + lstep2:lstep2:lmax;];
lla = size(la1, 2); 
% define a k-range###################
ekb1 = -5 : 0.05 : 1;
kb1 = 10 .^ ekb1;
%kb1 = 1
lkb1 = size(kb1, 2);

% start making the table x1 (two loops)
for j = 1 : lla
la = la1(j)

for i = 1 : lkb1


hi(j,i) = 0;
jh1(j, i) = 0;
jh2(j, i) = 0;

% kr1 is the relative wavenumer : k1/kk2
kr1 = sqrt(1/kb1(i)^2 + 1);

bl = sqrt(1 - kk0* kb1(i)^2* la^2);
% make a range for x : this is approximately phi_b1(la, kb)
% take care that we stay below the first maximum of jl(y) at y=la
xmax = kr1 * asinh(la*kb1(i));
%stepl = la/2000;
stepl = la/1000;
% for large kb1 we need a smaller step
if kb1(i) > 1, stepl = la/2e4; end
x = 1e-6:stepl:xmax;
y = sinh(x * kb1(i))/kb1(i);
y1 = y(end);

% find the jk1 value=1e-6-> then phi_b1(x1)=approx(1e-6)
jl1 = sphbes(la, y); 
i1 = find(abs(jl1) < 1e-6);
% eliminate near zeros that are not in the immediate neighborhood of the startvalue of the ultra-sph f
ii1 = find(diff(i1) > 1);
if  ~isempty(ii1),  i1 = i1(1 : ii1(1)); end
ie1 = i1(end);
x2 = x(ie1);

% take smaller x2 until pb < 2e-6
pb1 = phi_b1(la, kb1(i), x2, kk0);
pb10 = pb1;
j3 = 1;
if pb1 > 2e-6
%    for j1 = (ie1-1): -1 : 1
    for j1 = ie1 : -1 : 1
       pbtest = phi_b1(la, kb1(i), x(j1), kk0);
       if  pbtest <= 2e-5
          break;
       else
          pb1 = pbtest;
          x2 = x(j1);
          j3 = j3 + 1;
       end
    end         
end

% use the derivative (Abbott & Schaefer formula A23) to find phi_b1 = 1e-6
% stop when phi_b1 is within 1e-12 from the value pbstart (=1e-6)
bl1 = sqrt(1 - kk0* (kb1(i) *(la + 1))^2);
pb3 = pb1;
pb4 = pb1;

x20 = x2;
j2max = 20;
x3 = 0;
for j2 = 1:j2max

  pbl3 = phi_b1(la + 1, kb1(i), x2, kk0);
  pbd3 = la * kb1(i) * coth(kb1(i) * x2) * pb3 -  bl1 * pbl3;
pbdn(j2) = pbd3;
  if pbd3 > 0
    x3 = x2 + (pbstart - pb3)/pbd3;
  else 
    break;
  end
xn(j2) = x3;
  pb4 = phi_b1(la, kb1(i), x3, kk0);
pbn(j2) = pb4;
  if abs(pb4 - pbstart) < 1e-12
     break;
  else 
     x2 = x3;
     pb3 = pb4;
  end
end
%if j2 == j2max, pb4 = 0;  end

% keep track of the algorithm's
hj1(j, i) = j3;
hj2(j, i) = j2;
pb(j, i) = pb4;
x1(j, i) = x3;

% calculate the final derivative of pbl
pbl4 = phi_b1(la + 1, kb1(i), x3, kk0);
pbd(j, i) = la * kb1(i) * coth(kb1(i) * x3) * pb4 -  bl1 * pbl4;

end  % k1 loop
end  % la1 loop

%plot(la1, x1)
plot(xn, pbn, 'x-')
%save -ascii usphst.dat  x1 pbd
stv1 = load('usphst.dat');
% separate two data blocks : block1. x1 start values where pbi_beta = 1e-6,
% block2. dphi_beta/dx at the start values, all data exact within 1e-6.
% all values of pb should be at 1e-6
% use mesh if lla1>1 and lkb1 > 1 : if hs is a matrix
lla1 = size(la1, 2);
x1v1 = stv1(1:lla1,:);
pbdv1 = stv1(lla1+1:2*lla1, :);
% save all start info as a structure :
ust.la = la1;
ust.kb = kb1;
ust.x1 = x1v1;
ust.pbd = pbdv1;
%save stfile ust
hs = x1v1;
figure(1)
if lla1 > 1
   mesh(-5-log(kb1)/log(10),la1, hs)
else
   semilogx(kb1, x1)
end
hs = pbdv1;
figure(2)
if lla1 > 1
   mesh(-5-log(kb1)/log(10), 8-log(la1), hs)
else
   semilogx(kb1, pb, kb1, pbd, '--')
end
