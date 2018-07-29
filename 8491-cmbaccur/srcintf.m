function  [cct,  ta1, tetael] = srcintf(la, k2, ct4, src4, src5, ctc0, nprimtilt, lmax, K, stfname, logstep)
% srcint.m integrates the source including polarisation over conformal time using the approach of Seljak :
% integration over the photon past light cone, see M Zaldarriaga et al., ApJ nr 494, 491 (1998)
% the function needs an l-range (la), a k-range (k2) a ctime-range (ct4),
% ctc0 : the present conformal time, a series of splines of the source in conformal time for the 
% temperature (pp1) and for the polarisation (pp2), the index of the primary power spectrum (nprimtilt),  
% the curvature energy content from the Friedman equation (K), startfile name for the ultra-spherical
% function, an option for logaritmic variation k2 vector : default logstep = 0 (constant steps in k2).
% k2 has 10-log steps, if logstep = 1. 
%
% the result (cct) is the square of the temperature spectrum (1) resp the E-polarisation spectrum (2)
% resp the cross-correlation of temperature and polarisation (3).
%
% D Vangheluwe 4 april 2005
% remark 1: we use ultra-spherical bessel values which have two parameters and must be found by integration:
%   for the calculation of the ultra-spherical bessel functions see: cmb/usphint.m
% remark 2: for the ode equation of the u-function, see equation (36) of Zaldarriaga & Seljak.
% remark 3: take attention the value of k2 should lie within the range of kb1 values : there is no check!!
%   see spline of start  values x10 and pbd0.
% remark 4: how do we get the ultra-spherical bessel function values? see development and test routine usphpar.m
% remark 5: this function is a fast version of srcpint.m (the source need not to be in the loop
% if there is enough memory, probably 80Mbytes will be used) 

lla = size(la, 2);
lk2 = size(k2, 2);
k2min = k2(1);
k2max = k2(lk2);
lct4 = size(ct4, 2);
kk0 = sign(K);

% load the table and find the start values for the integration of the ode for u-functions
% the startfile can be obtained by running usphst.m
%  stv1 = load('usphst.dat');
stv1 = load(stfname);
lmax0 = stv1.ust.la(end);

ek2step = 1;
if logstep == 1, ek2step = log(k2(2)/k2(1))/log(10); end
nrsteps = 10000;   % default 10000
%lmax = 1500;
xmax = k2(lk2) * ctc0;   % =default 3000
xstep = 2*lmax0/nrsteps;
kx = 1e-12 : xstep : xmax;

% allocate the data in order to speed up the routine
kctc0 = zeros(1, lct4);
kctc = zeros(1, lct4);
jl = zeros(lct4, 1);
src = zeros(lct4, 1);
htable = zeros(lct4, 1);
tetatl = zeros(1, lk2);
tetael = zeros(1, lk2);
cmbtable = zeros(1, lk2);

% calculate the curvature length times wavenumber : a parameter for the ultra_spherical bessel function
kb = sqrt(-K) ./k2;

%#########
%kb(1)
%kb(end)
if all(kb == 0), kbzero = 1; x10 = 1e-12 * ones(1, lk2);
else  % not all kb are zero

  kbzero = 0;
  ikb = find(kb > 10);
  if ~isempty(ikb), 
      kb(ikb) = 10 * ones(1, size(ikb, 2));
      message('boundary kb > 10 reached')
  end
 
% split the structure stv1 from the startfile : x1: start values where pbi_beta = 1e-6,
% pbd : dphi_beta/dx at the start values, all data exact within 1e-6.
% the la-values resp kb-vector should be the same as in the program usphst.m
  la1 = stv1.ust.la;
  lla1 = size(la1, 2);
  kb1 = stv1.ust.kb;
  lkb1 = size(kb1, 2);
  x1v1 = stv1.ust.x1;
  pbdv1 = stv1.ust.pbd;

% find all start values (hs) for the ode integration step as a function of la and kb (is a surface):
% the long sought magic formula : la1 is the la-vector from usphst.m!!
  hs = sqrt(0.6* x1v1 ./ repmat(((la1+250) .^0.905)', 1, lkb1));
  hs = hs.* repmat((kb1 + 1) ./ (4*kb1 + 1), lla1, 1);

end %all(kb == 0)

%############################# start
for il = 1:lla

    l = la(il)

    if ~kbzero
       il1 = find(la1 == l);
       if isempty(il1) 
           error('la value not found, try another value')
           break;
       else
           x10 = spline(kb1, x1v1(il1,:), kb);
           pbd0 = spline(kb1, pbdv1(il1,:), kb);
       end
%x10(1:400)
% calculate the start values for the u-function : u0 = [u, du/dx] with u = r(x) * phi_beta(x) and
%  du/dx = phi_beta(x) * dr(x)/dx + r(x) * dphi_beta(x)/dx :
       r10 = sinh(kb .* x10) ./kb;
       rd10 = cosh(kb .* x10);
       u0 = [r10 *1e-6; r10 .* pbd0 + 1e-6 * rd10];

% define the step and set 'odeint' to a constant number of steps for all cases (kb)
       hstart = spline(kb1, hs(il1,:), kb);
       toi = 1e-4;
       hmax = 0.3;   %we take hmax = 0.3 as the default value
       maxstp = 150;   % default maxstp = 150
       x1e = ones(1, lk2) * xmax;
% solve the u-function instead of the phi_beta function : xs2 does not have a constant step  
       [xs2, u2, nok, nbad, nfev] = odeintp(u0, x10, x1e, toi, hstart, 0, hmax, maxstp, @uspheq1, l, kb, kk0);

% prepare a spline of the solution for a constant step in xs (the values are found with ppval1):
       y2der = splinep(xs2, u2);
% calculate the number of constant steps, xstep in the solution xs2: ilast is the last one
       ilast = ceil((xs2(end,:) - x10)/xstep);
       ncsteps = 8;
       ilast = ilast - ncsteps;
% set the number of overlapping steps for the matching to the asymptotic solution (default= 40):
       noverflow = 40;
    end  % kbzero

% calculate also the spherical bessel function as we may need it for kb < 1-5
    table_bv = sphbes(l, kx);
% set some constants needed for the polarisation formula
    gl = sqrt((l + 2) * (l + 1) * l * (l - 1));


% interpolate and integrate (sum with the Simpson rule) over conformal time :
    for i = 1:lk2
%    for i = 967:967

       if kb(i) > 1e-5 * (1500/l)

% define a vector of argument values for the ultra-spherical bessel function (x1): reverse ct4
%          clear('xs', 'x1', 'x2', 'yspl2','iover','iasym', 'yas', 'table_pb')
          x1 = x10(i) : xstep : xmax;
          lx1 = size(x1, 2);

% in the next 10 lines make a table over x1 (table_pb) of ultra-spherical bessel values:

% make the interpolation of the ode solution for a constant step xstep:
          [xs, yspl2] = ppval1(xs2(:,i), u2(:,i), y2der(:,i), xstep);

% define the overflow index in x1 (iover): 
%default 40 steps should at least include one zero and one maximum of u2
          iover = (ilast(i) - noverflow) : ilast(i);
% define the index of x1 where the asymptotic appr is applied (iasym)
          iasym = ilast(i) : lx1;

% calculate the ultra-spherical bessel values
          kctc0 = ctc0 * k2(i) * ones(1, lct4);
          kctc = k2(i) * ct4;
          xctc = kctc0 - kctc;
          ixode = find(xctc > x1(1)  &  xctc < x1(ilast(i)));
          ul = zeros(1, lct4);
          if  ~isempty(ixode)
             r1 = sinh(kb(i) * xs)/kb(i);
% interpolate the ultra-spherical bessel function when we are in the k-range of the ode solution
             ul(ixode) = interpl(xs, yspl2 ./ r1, xctc(ixode));
% calculate the necessry values of the asymptotic expansion of the ultra-spherical bessel function
             ixas = find(xctc >= x1(ilast(i)));
% find the asymptotic values and the phase correction in the overflow region: 
             if ~isempty(ixas),
                 dphi = phdif(x1(iover), usphas(l, kb(i), x1(iover), 0, 0, kk0), yspl2(iover)); 
                 ul(ixas) = usphas1(l, kb(i), xctc(ixas), dphi, 1, kk0);
             end
% integrate the source function over ct4, following formula (40) of Zaldarriaga et al.(1998)
             htable = src4(:,i) .* ul';
             tetatl(i) = simpsint(ct4(1), ct4(end), htable);
             htable = src5(:,i) .* ul';
             tetael(i) = simpsint(ct4(1), ct4(end), htable);
          else
             tetatl(i) = 0;
             tetael(i) = 0;
          end

       else  %if kb(i) <= 1e-5 *(1500/l)

% interpolate the spherical bessel function
          kctc0 = ctc0 * k2(i) * ones(1, lct4);
          kctc = k2(i) * ct4;
          xctc = kctc0 - kctc;
          jl = interpl(kx, table_bv, xctc)';
% integrate the source function following (12) and (13) of Seljak resp (18) of Zaldarriaga and Seljak
% the integration interval is limited to ct4 where the source <> 0
          htable = src4(:,i) .* jl;
          tetatl(i) = simpsint(ct4(1), ct4(end), htable);
          htable = src5(:,i) .* jl;
          tetael(i) = simpsint(ct4(1), ct4(end), htable);
       end  %if kb(i)

   end  % forloop k2

%ta1 = tetatl;
f2 = 1;
%if (K ~= 0),  f2 = coth(pi*k2/sqrt(-K)); end
factor = 1;
if  logstep == 1, factor = k2 * log(10) * ek2step * (lk2-1)/(k2max - k2min); end
% perform the integration over k2min-k2max, following (9) of Seljak resp (19) of Zaldarriaga and Seljak
%   cmbtable = (tetatl .^2) ./ (k2 .^ (2-nprimtilt));
   cmbtable = factor .* f2 .* (tetatl .^2) .* k2 ./ (k2 .^2 - K) .^ (1.5 - 0.5*nprimtilt);
%   cmbtable = factor .* (tetatl .^2) .* k2 .^1.5 ./ (k2 .^2 - 4*K) .^2;
ta1 = cmbtable;
   cct.ctt(il) = l*(l + 1) * simpsint(k2min, k2max, cmbtable');
%   cmbtable = (tetael .^2) ./ (k2 .^ (2-nprimtilt));
   cmbtable = factor .* (tetael .^2) .* (k2 ./ (k2 .^2 - K)) .^ (1.5 - 0.5*nprimtilt);
   cct.cee(il) = gl^2 * l*(l + 1) * simpsint(k2min, k2max, cmbtable');
%   cmbtable = (tetael .* tetatl) ./ (k2 .^ (2-nprimtilt));
   cmbtable = factor .* (tetael .* tetatl) .* (k2 ./ (k2 .^2 - K)) .^ (1.5 - 0.5*nprimtilt);
   cct.cte(il) = l*(l + 1) * gl * simpsint(k2min, k2max, cmbtable');

end  % forloop la
