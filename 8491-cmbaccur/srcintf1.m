function  [cct, ta1, tetael] = srcintf1(la, nn1, ct4, src4, src5, ctc0, ctad, nprimtilt, lmax, K, stfname)
% srcintf1.m integrates the source including polarisation over conformal time using the approach of Seljak :
% integration over the photon past light cone, see M Zaldarriaga et al., ApJ nr 494, 491 (1998) for K > 0
% the function needs an l-range (la), a k-range (nn1) a ctime-range (ct4), the present conformal time (ctc0),
% decoupling time (ctad), the source in conformal time for the temperature and polarisation, resp  
% src4(1..lct4, 1..lnn1), src5(1..lct4, 1..lnn1), the index of the primary power spectrum (nprimtilt), 
% the maximum la of the anistropy spectrum (lmax) and the curvature energy content from the Friedman equation (K),
% the startfile name of the ultra-spherical function (stfname). 
%
% output: ctt is the square of the temperature spectrum (1) resp the E-polarisation spectrum (2)
% resp the cross-correlation of temperature and polarisation (3), tetatl, tetael temperature resp, polarisation
% temperature for all k1 values (for the last la).
%
% D Vangheluwe 13 june 2005
% remark 1a: attention :nn1 is an integer array :wavenumber array k1 is made from it by taking k1 = nn1 * sqrt(K)
% remark 1: we use ultra-spherical bessel values which have two parameters and must be found by integration:
%   for the calculation of the ultra-spherical bessel functions see: cmb/usphint.m
% remark 2: for the ode equation of the u-function, see equation (36) of Zaldarriaga & Seljak.
% remark 3: take attention the value of nn1 should lie within the range of kb1 values : there is no check!!
%   see spline of start  values x10 and pbd0.
% remark 4: how do we get the ultra-spherical bessel function values? see development and test routine usphpar.m
%  and usphpar1.m
% remark 5: this function is a fast version of srcpint.m (the source need not to be in the loop
% if there is enough memory, probably 80Mbytes will be used)
% remark6 on 13 june: this routine has been obtained by modifying srcpintf.m according to usphpar1.m 

if (K < 0), 
   error('the space curvature constant K should be > 0 for this routine');
   return;
end
kk0 = sign(K);
lla = size(la, 2);
k1 = nn1 * sqrt(K);
lk1 = size(k1, 2);
lct4 = size(ct4, 2);
k1step = k1(2) - k1(1);
ct4step = ct4(2) - ct4(1);
k1max = k1(lk1);
k1min = k1(1);
ct4sym = 0.5 * pi/sqrt(K);

% if necessary adapt the source to the period of the ultra-spherical function for K >0
ct0 = ct4(1);
ict1 = 1 : lct4;
if ct4sym < ct4(end)
   ctc4 = ctc0 - ct4;
   ict1 = find(ctc4 < ct4sym);
   lct1 = size(ict1,2);
%   ct0 = ctc0 - ct4sym;
   ct0 = ct4(ict1(1));
% map the region ctc4 >= ct4sym onto ict1 by mirroring it wrt the point: ctc4 = ct4sym
   ict2 = find(ctc4 < ct4sym  &  ctc4 > 2*ct4sym - ctc0 + ct4step);
% values of ct4 to be used to calculate (by interpolation) the mirrored source values:
   ct44 = 2*(ctc0 - ct4sym) - ct4(ict2);
% define a (small) region (index icts) where the source changes rapidely and should be splined for reconstruction:
% ct4(icts(1..end)) is projected onto ct44s(end..1) :notice that the index is inverted, the phaseshift between 
% the two amounts to : 2*rem(ctc0 - ct4sym - ct4(1), ct4step).
% The same phaseshift and index inversion exists also between ct4(ict1(1..end) and ct44(end..1)
% icts and ict3 have the same size and take attention that they can be empty for ctc0 - ctad +100 < ct4sym!!
   ctcsmin = 2*ct4sym - ctc0 + (ctad - 100);
   ctcsmax = 2*ct4sym - ctc0 + (ctad + 100);
   icts = find((ct4 < ctad + 100)  &  (ct4 >= ctad - 100)  &  (ctc0 - ct4 >= ct4sym));
   ict3 = find(ctc4(ict2) < ctcsmax  &  ctc4(ict2) >= ctcsmin);
   if ~isempty(ict3),    ct44s = ct44(ict3); end
end

% load the table and find the start values for the integration of the ode for u-functions
% the startfile can be obtained by running usphst.m
%  stv1 = load('usphst.dat');
stv1 = load(stfname);
lmax0 = stv1.ust.la(end);

nrsteps = 10000;   % default 10000
%lmax = 1500;
xmax = k1(lk1) * ctc0;   % =default 3000
xstep = 2*lmax0/nrsteps;
kx = 1e-12 : xstep : xmax;

% allocate the data in order to speed up the routine
kctc0 = zeros(1, lct4);
kctc = zeros(1, lct4);
jl = zeros(lct4, 1);
htable = zeros(lct4, 1);
cmbtable = zeros(1, lk1);

% calculate the curvature length times wavenumber : a parameter for the ultra_spherical bessel function
kb = sqrt(abs(K)) ./k1;

%#########
%kb(1)
%kb(end)
if all(kb == 0), kbzero = 1; x10 = 1e-12 * ones(1, lk1);
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
   kb2 = stv1.ust.kb;
   x1v1 = stv1.ust.x1;
   pbdv1 = stv1.ust.pbd;

end %all(kb == 0)


%############################# start
for il = 1:lla

    l = la(il)
    laa = sqrt(l * (l + 1)); 

% make a range of wavenumber and kb starting at 1/(l+1)
    clear('k2')
%    ik2 = (l+1) : lk1;
    ik2 = find(nn1 >= l+1);
    k2 = k1(ik2);
    lk2 = size(k2, 2);
    nn2 = nn1(ik2);
    cmbtable = zeros(1,lk2);

% the range of indices in src for k2 will be ik2 : take care, do not neglect!!:
    k2min = k2(1);
    k2max = k2(lk2);
    tetatl = zeros(1, lk2);
    tetael = zeros(1, lk2);
    kb = sqrt(abs(K)) ./k2;
    odd_la = xor(rem(nn2,2), rem(l,2));

% the kb-range is made more progressive towards 1/la
    nrkbsteps = 100;
    kbmax = 1/laa;
    ekbmax = -7;
    ekbmin = log(kbmax - 1e-5)/log(10);
    ekbstep = (ekbmax - ekbmin)/nrkbsteps;
    ekb1 = ekbmin : ekbstep : ekbmax;
    kb1 = kbmax - 10 .^ekb1;
    lkb1 = size(kb1, 2);
    if l == la1(1)
        if any(kb1 ~= kb2)  error('kb vector is unequal to the start vector'); return; end
    end

% find the start values (hs) for the ode integration step as a function of la and kb (is a surface):
% the long sought magic formula : la1 is the la-vector from usphst1.m!!
    hs = 0.5 * x1v1 .* repmat((la1 .^-0.9)', 1, lkb1);
    if ~kbzero
       il1 = find(la1 == l);
       if isempty(il1)
           error('la not in the range of la1')
           break; 
       else
           x10 = spline(kb1, x1v1(il1,:), kb);
           pbd0 = spline(kb1, pbdv1(il1,:), kb);
           hstart = spline(kb1, hs(il1,:), kb);
       end

% calculate the start values for the u-function : u0 = [u, du/dx] with u = r(x) * phi_beta(x) and
%  du/dx = phi_beta(x) * dr(x)/dx + r(x) * dphi_beta(x)/dx :
       r10 = sin(kb .* x10) ./kb;
       rd10 = cos(kb .* x10);
       u0 = [r10 *1e-6; r10 .* pbd0 + 1e-6 * rd10];

% define the step and set 'odeint' to a constant number of steps for all cases (kb)
       toi = 1e-4;
       hmax = 0.3;   %we take hmax = 0.3 as the default value
       maxstp = 150;   % default maxstp = 150
       x1e = ones(1, lk2) * xmax;
% solve the u-function instead of the phi_beta function : xs2 does not have a constant step  
       [xs2, u2, nok, nbad, nfev] = odeintp(u0, x10, x1e, toi, hstart, 0, hmax, maxstp, @uspheq1, l, kb, kk0);

% prepare a spline of the solution for a constant step in xs (the values are found with ppval1):
       y2der = splinep(xs2, u2);
% calculate the number of constant steps, xstep in the solution xs2: ilast is the last one
%       ilast = ceil((xs2(end,:) - x10)/xstep);
% set the number of overlapping steps for the matching to the asymptotic solution (default= 40):
       noverflow = 85;
       ncsteps = 0;

    end  % kbzero

% calculate also the spherical bessel function as we may need it for kb < 1e-5
    table_bv = sphbes(l, kx);
% set some constants needed for the polarisation formula
    gl = sqrt((l + 2) * (l + 1) * l * (l - 1));

% interpolate and integrate (sum with the Simpson rule) over conformal time :
    for i = 1:lk2
%    for i = 47:47

       clear('htable')
       if kb(i) > 1e-5 * (1500/l)

% define a vector of argument values for the ultra-spherical bessel function (x1): reverse ct4
%          clear('xs', 'x1', 'x2', 'yspl2','iover')
          x1 = x10(i) : xstep : xmax;
% define some parameters for the calculation ; x1=x1sym up to the symmetry point, x1* kb = pi/2 needed for K>0 :
          x1sym = min(0.5*pi/kb(i), xmax);
% in the next 10 lines make a table over x1 (ul) of ultra-spherical bessel values:

          if  xs2(end,i) >=  x1sym

% asymptotic expansion is not needed here as we found already the complete solution: include one point xs2 > x1sym+xstep
% adding xs2step + xstep to x1sym in the find logic statement of xs2 makes sure that xs(end) > x1(ilast) > x1sym
             xs2step = max(diff(xs2(:,i)));
             ix2 = find(xs2(:,i) <= (x1sym + xs2step + xstep));
% include one point xs2 > x1sym in the interpolation of the ode solution:
%             ix2 = [ix2', (ix2(end) + 1)];
             [xs, yspl2] = ppval1(xs2(ix2,i), u2(ix2,i), y2der(ix2,i), xstep);
%             ilast = floor((x1sym - x10(i))/xstep) + 1;
             ilast = floor((x1sym - x10(i))/xstep) + 2;

          else  % all steps in odeint are used (full interpolation) : an asymptotic solution is needed

             [xs, yspl2] = ppval1(xs2(:,i), u2(:,i), y2der(:,i), xstep);
             ilast = floor((xs(end) - x10(i))/xstep) + 1 - ncsteps;
% define the overflow index (iover): default 85 (or 40) steps should at least include one zero and one maximum of u2
             iover = (ilast - noverflow) : ilast;

% find the asymptotic values and the phase correction in the overflow region: 
             dphi = phdif(x1(iover), usphas(l, kb(i), x1(iover), 0, 0, kk0), yspl2(iover));

          end


% calculate the ultra-spherical bessel values
          kctc0 = ctc0 * k2(i) * ones(1, lct4);
          kctc = k2(i) * ct4;
          xctc = kctc0 - kctc;
% xctc > x1(1) is necessary as x1(1)=x10 is not the origin of ct, but the point where odeint started
          if   xs2(end,i) >=  x1sym
% debug action 12-6-2005 : interpolation over xs limits our range to xs(end) at most if it happens xs(end) < x1sym
%             ixode = find(xctc > x1(1)  &  xctc <= x1sym);
             ixode = find(xctc > x1(1)  &  xctc <= min(x1sym, xs(end)));
          else
             ixode = find(xctc > x1(1)  &  xctc <= x1(ilast));
          end
          ul = zeros(1, lct4);
          if  ~isempty(ixode)
             r1 = sin(kb(i) * xs)/kb(i);

% interpolate the ultra-spherical bessel function when we are in the k-range of the ode solution
             ul(ixode) = interpl(xs, yspl2 ./ r1, xctc(ixode));
% calculate the necessary values of the asymptotic expansion of the ultra-spherical bessel function
             if  (xs2(end,i) <  x1sym)   % asymptotic expansion needed for K>0
                ixas = find(xctc > x1(ilast)  &  xctc <= x1sym);
                ul(ixas) = usphas1(l, kb(i), xctc(ixas), dphi, 1, kk0); 
             end

% if necessary adapt the source to the period of the ultra-spherical function for K >0 by mirroring:
% we should have: find(k2(i)* (ctc0 - ct4(ict1)) < x1sym) == find(xctc < x1sym) == ict1
             src41 = src4(:,ik2(i));
             src51 = src5(:,ik2(i));
             if  ct4sym < ct4(end)
% reconstruct the source by linear interpolation : not so accurate but sufficient where changes are slow
                src42 = interpl(ct4, src4(:,ik2(i))', ct44)';
                src52 = interpl(ct4, src5(:,ik2(i))', ct44)';
% for efficieny reason reconstruct the source by splines only in the region (ict3) where it changes fast
                if ~isempty(ict3)
                  src42(ict3) = spline(ct4(icts), src4(icts,ik2(i)), ct44s)';
                  src52(ict3) = spline(ct4(icts), src5(icts,ik2(i)), ct44s)';
                end
                if odd_la(i) == 1
                   src41(ict2) = src41(ict2) + src42;
                   src51(ict2) = src51(ict2) + src52;
                else
                   src41(ict2) = src41(ict2) - src42;
                   src51(ict2) = src51(ict2) - src52;
                end
             end

debug = 0;
if debug == 1
ct4step
nn2(i)
ctc0-ct4sym
ul(ict1(1))
src41(ict1(1))
ct0
odd_la(i)
xs2(end,i)
ct4(ict1(1))
ct4(end) - ct4sym
ct4(end) - x10(i)/k2(i)

figure(1)
plot(ct4(ict1), src41(ict1), ct4, ul, 'k--', ct4, src4(:,ik2(i)), 'b--', ct4(ict2(ict3)), src42(ict3),'r')
%plot(ct4(ict1), src41(ict1), ct4, ul, 'k--', ct4, src4(:,ik2(i)), 'b--')
%axis([6500, 7100, -0.05, 0.05])
end

% integrate the source function over ct4, following formula (40) of Zaldarriaga et al.(1998)
             htable = src41(ict1) .* ul(ict1)';
             tetatl(i) = simpsint(ct0, ct4(end), htable) + (ct0 - ctc0 + ct4sym) * src41(ict1(1)) * ul(ict1(1));
             htable = src51(ict1) .* ul(ict1)';
             tetael(i) = simpsint(ct0, ct4(end), htable) + (ct0 - ctc0 + ct4sym) * src51(ict1(1)) * ul(ict1(1));
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
          htable = src4(:,ik2(i)) .* jl;
          tetatl(i) = simpsint(ct4(1), ct4(end), htable);
          htable = src5(:,ik2(i)) .* jl;
          tetael(i) = simpsint(ct4(1), ct4(end), htable);

       end  %if kb(i)

   end  % forloop k2

%ta1 = tetatl;
f2 = 1;
%if (K ~= 0),  f2 = coth(pi*k2/sqrt(abs(K))); end
factor = sqrt((k2 .^2 - 4*K) ./ (k2 .^2 - K));
%factor = 1;
% perform the integration over k2min-k2max, following (9) of Seljak resp (19) of Zaldarriaga and Seljak
   cmbtable = f2 .* factor .* (tetatl .^2) .* k2 ./ (k2 .^2 - K) .^ (1.5 - 0.5*nprimtilt);
ta1 = cmbtable;
%    cct.ctt(il) = l*(l + 1) * sqrt(K) * sum(cmbtable');
    cct.ctt(il) = l*(l + 1) * k1step * sum(cmbtable');
%   cct.ctt(il) = l*(l + 1) * simpsint(k2min, k2max, cmbtable')
   cmbtable = factor .* (tetael .^2) .* k2 ./ (k2 .^2 - K) .^ (1.5 - 0.5*nprimtilt);
   cct.cee(il) = gl^2 * l*(l + 1) * k1step * sum(cmbtable');
   cmbtable = factor .* (tetael .* tetatl) .* k2 ./ (k2 .^2 - K) .^ (1.5 - 0.5*nprimtilt);
   cct.cte(il) = l*(l + 1) * gl * k1step * sum(cmbtable');
end  % forloop la
