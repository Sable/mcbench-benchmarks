% WISHRND - Random Matrix from Wishart Distribution
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
%
%   [W] = wishrnd(Sc,nu) 
%
% W = returned random symmetric positive definite matrix
% 
% Sc = p x p symmetric, postitive definite "scale" matrix 
% nu = "degrees of freedom" (when integer)
%    = "number of observation" (when integer)
%    = precision parameter (when non-integer)
%
% uses the Odell and Feiveson (1966) algorithm
% as printed in Kennedy and Gentle (1980) 
%
% Note:
%   Different sources use different parameterizations.
%   See INVWISHRND for details.
%
% See also INVWISHIRND, WISHIRND

function [W] = wishrnd(Sc,nu) 

[p,p2] = size(Sc) ;
z = normrnd(0,1,p,p) ;

% y = chi2rnd(nu-(1:p)) 
% --- note, matlab's chi2 functions do not work for non-integer DF.
% --- thus, we use the gamma equivalent

y = gamrnd( (nu-(1:p))/2, 2 ) ;
b = NaN*Sc ;

% first element
b(1,1) = y(1) ;

if (p>1),
% rest of diagonal
for (j=2:p), 
  zz = z( 1:(j-1) ,j) ;
  b(j,j) = y(j) + zz'*zz ;
end

%first row and column
for (j=2:p),
  b(1,j) = z(1,j) * sqrt(y(1)) ;
  b(j,1) = b(1,j) ;  % mirror
end 
end

if p>2,
for (j=3:p),
for ( i=2:(j-1) ),
  ix = 1:(i-1) ;
  zki = z(ix,i) ;
  zkj = z(ix,j) ;
  b(i,j) = z(i,j)*sqrt(y(i)) + zki'*zkj ;
  b(j,i) = b(i,j) ;   %mirror
end 
end
end

[ A, nonposdef ] = chol(Sc) ;

if nonposdef,
  disp('ERROR: wishrnd: parameter is not positive-definite')
  Argument = A
end

W = A'*b*A ;
