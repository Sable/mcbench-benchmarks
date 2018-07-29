% usphst2.m : make a table for the integration start values for the ultra-spherical besselfunctions phi_beta
% this routine is special for open space : K=(omt-1)*(h0*h)^2 > 0, (kk0== 1)
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

% D Vangheluwe 8 june 2005
% remark 1 : we use 2 parameters only for pbi_beta, they are :1. la and 2. kb= kk2/beta
%   kb is the inverse curvature kk2 of the universe related to the wave number beta.
% remark 2: use phi_b1 for the recursion as it is more stable than phi_beta.m fot K>0
% remark 3: 9 june 2005, this program takes about 1 hr
% remark 3: the program fills the file usphst2.dat with ascii start data (x1 and pbd),
%  this data is to be used by functions srcint1.m and usphpar1.m
% remark 4: the user has to activate the <save> of his results himself when the program has finished (a protection)


clear all

% define the spacecurvature constant : kk0== 1 for closed space : it should have the value +1 or -1!!
kk0 = 1;
% start value for phi_beta integration : all phi_beta's must have this value
pbstart = 1e-6

% calculate the start values of the utra-spherical function
% define an la-range+++++++++++
lmax = 1500;
%lstep1 = 25;
%lstep2 = 50;
lstep1 = 10;
lstep2 = 25;
%la1 = 220
la1 = [2,6,10, 20:lstep1:220, 250:lstep2:lmax];
lla = size(la1, 2);
 
nrkbsteps = 100;
x1 = zeros(lla, nrkbsteps+1);
pb = zeros(lla, nrkbsteps+1);
pbd = zeros(lla, nrkbsteps+1);

% start making the table x1 (two loops)
for j = 1 : lla
la = la1(j)
laa = sqrt(la * (la + 1));

% define a k-range : kbmax = 1/laa
kbmax = 1/laa
ekbmax = -7;
ekbmin = log(kbmax - 1e-5)/log(10);
ekbstep = (ekbmax - ekbmin)/nrkbsteps;
ekb1 = ekbmin : ekbstep : ekbmax;
kb1 = kbmax - 10 .^ekb1;
lkb1 = size(kb1, 2);
kb(j) = kb1;

% start the kb range:
for i = 1 : (nrkbsteps+1)

hi(j,i) = 0;
jh1(j, i) = 0;
jh2(j, i) = 0;


% make a range for x : this is approximately phi_b1(la, kb)
% take care that we stay below the first maximum of jl(y) at y=la
xmax = asin(la*kb1(i))/kb1(i);
%stepl = la/2000;
stepl = la/100;
% for large kb1 we need a smaller step
if kb1(i) > 1, stepl = la/2e4; end
xmax = asin(laa * kb1(i))/kb1(i);
x = 1e-6 : stepl : xmax;
lx = size(x, 2);
x2 = x(lx);

% take smaller x2 until pb < 2e-6
pb1 = phi_b1(la, kb1(i), x2, kk0);
pb10 = pb1;
j3 = 1;
if pb1 > 2e-6
%    for j1 = (ie1-1): -1 : 1
    for j1 = lx : -1 : 1
       pbtest = phi_b1(la, kb1(i), x(j1), kk0);
       if  pbtest <= 2e-4
          break;
       else
          pb1 = pbtest;
          x2 = x(j1);
          j3 = j3 + 1;
       end
    end         
end

% use the derivative (pbd3) of phi_beta (Abbott & Schaefer formula A23) to find phi_b1 = 1e-6
% stop when phi_b1 is within 1e-12 from the value pbstart (=1e-6)
bl1 = sqrt(1 - kk0* (kb1(i) *(la + 1))^2);
pb3 = pb1;
pb4 = pb1;

x20 = x2;
% switch to the asymptotic expansion in the damped region for the phi_beta function
%pb3 = pb10;
%pb4 = pb10;
j2max = 20;
x3 = 0;
for j2 = 1:j2max

  pbl3 = phi_b1(la + 1, kb1(i), x2, kk0);
  pbd3 = la * kb1(i) * cot(kb1(i) * x2) * pb3 -  bl1 * pbl3;
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
pbd(j, i) = la * kb1(i) * cot(kb1(i) * x3) * pb4 -  bl1 * pbl4;

end  % k1 loop
end  % la1 loop

%plot(la1, x1)
plot(xn, pbn, 'x-')
% all pb should be 1e-6
%save -ascii usphst2.dat  x1 pbd
stv1 = load('usphst2.dat');
% separate two data blocks : block1. x1 start values where pbi_beta = 1e-6,
% block2. dphi_beta/dx at the start values, all data exact within 1e-6.
lla1 = size(la1, 2);
x1v1 = stv1(1:lla1,:);
pbdv1 = stv1(lla1+1:2*lla1, :);
% save the start info in a structure
ust.la = la1;
ust.kb = kb1;
ust.x1 = x1v1;
ust.pbd = pbdv1;
% save stfile1 ust
figure(1)
mesh(-5-log(kb1)/log(10),la1, x1v1)
figure(2)
mesh(-5-log(kb1)/log(10), 8-log(la1), log(pbdv1)/log(10))
