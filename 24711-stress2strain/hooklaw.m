function Y=hooklaw(X, td, E, ni);

%Y=hooklaw(X, td, E, ni)
%
%This function calculates the strain or stress according to Hook's Law.
%Transform direction determine the input variable td.
%The proper values of td variable:
%td='stress_strain' - if input variable X is a stress tensor
%td='strain_stress' - if input variable X is a strain tensor
%
%But, for the purpose of computations we use the vector representation
%of a tensor X(ij), so that:
%X - is a vector representation of a tensor X(ij)
%    with the components in the following order:
%
%X=[Xxx Xyy Xzz Xxy Xxz Xzx Xyx Xyz Xxz]
%or
%X=[Xxx Xyy Xzz Xxy Xxz Xyz]
%or
%X=[Xxx Xyy Xzz]
%
%Dimension of X can be [m n]
%where: m - represents the number of tensors to calculate
%       n = 9, 6 or 3 (see above)
%
%E  - Young's modulus
%ni - Poisson's coefficient
%
%   Copyright (c) 2001 by Aleksander Karolczuk.
%   $Revision: 1.2 $  $Date: 2004/02/13



error(nargchk(4,4,nargin))

[m n]=size(X);

if n==3
   I=[1 1 1];
elseif n==6
   I=[1 1 1 0 0 0];
elseif n==9
   I=[1 1 1 0 0 0 0 0 0];
else
   error('Improper matrix dimension')
end

if lower(td)=='stress_strain'
   Y=((1+ni)/E)*(X-(ni/(1+ni))*(X*I')*I);
   elseif lower(td)=='strain_stress'
      Y=(E/(1+ni))*(X+(ni/(1-2*ni))*(X*I')*I);
   else
      error('Improper name of transform direction')
end