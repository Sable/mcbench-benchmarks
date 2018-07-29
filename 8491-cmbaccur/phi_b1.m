function   pb1 = phi_b1(la, kb, x, kk0)
% phi_beta() calculates the ultra-spherical Besselfunction from the recursion relation of
% Abbott & Schaefer, ApJ, nr 308, 546 (1986) A24
%
% input : la, kb = kk0/beta and x = beta* eta, (<eta> is conformal time)
% kk0 is the space curvature constant: kk0 =-1 for open space and kk0 = +1 for closed space ->
% it should only have the two values +1,-1.!!!
% output : phi_beta

% D Vangheluwe 26 feb 2005
% remark 1 : attention : Zaldar & Seljak use <eta> as the argument of phi_beta, we use
%   <beta* eta>, which is a smaller value in the same range as la.

% calculate the start values for the recursion
if kk0 < 0
   rx = sinh(kb * x)/kb;
   pb(1) =  sin(x)/rx;
   pb(2) =  (-cos(x) + kb * coth(kb *x) * sin(x))/(rx * sqrt(1 - kk0* kb^2));
else
   rx = sin(kb * x)/kb;
   pb(1) =  sin(x)/rx;
   pb(2) =  (-cos(x) + kb * cot(kb *x) * sin(x))/(rx * sqrt(1 - kk0* kb^2));
end

% proceed with recursion up to the required la
for i = 2:la
  l = i - 1;
  if kk0 < 0
     pb(i+1) = ((2*l + 1) * kb * coth(kb *x) * pb(i) - sqrt(1 - kk0* (kb* l)^2) * pb(i-1))/ ...
       sqrt(1  - kk0* (kb * (l + 1))^2);
  else
     pb(i+1) = ((2*l + 1) * kb * cot(kb *x) * pb(i) - sqrt(1 - kk0* (kb* l)^2) * pb(i-1))/ ...
       sqrt(1  - kk0* (kb * (l + 1))^2);
  end
end
pb1 = pb(end);


