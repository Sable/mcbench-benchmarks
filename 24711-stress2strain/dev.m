function s=dev(t);
%
%s=dev(t)
%
%This function calculates the deviatoric part s(ij) of a tensor t(ij)
%But, for the purpose of computations we use the vector representation
%of a tensor t(ij), so that:
%t - is a vector representation of a tensor t(ij)
%    with the components in the following order:
%
%t=[txx tyy tzz txy txz tzx tyx tyz txz]
%or
%t=[txx tyy tzz txy txz tyz]
%or
%t=[txx tyy tzz]
%
%Dimension of t can be [m n]
%where: m - represents the number of tensors to calculate
%       n = 9, 6 or 3 (see above)
%
%   Copyright (c) 2001 by Aleksander Karolczuk.
%   $Revision: 1.0 $  $Date: 2001/02/01

error(nargchk(1,1,nargin))

[m n]=size(t);

if n==3
   I=[1 1 1];
elseif n==6
   I=[1 1 1 0 0 0];
elseif n==9
   I=[1 1 1 0 0 0 0 0 0];
else
   error('Improper matrix dimension')
end

s=t-((1/3)*(t*I'))*I;
