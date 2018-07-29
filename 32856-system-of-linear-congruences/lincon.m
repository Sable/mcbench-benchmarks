function x=lincon(a,b,n)
%System of linear congruences
%   X = LINCON(A,B,N) solves the system of linear congruences
%
%       A(1) * X == B(1)  (mod N(1))
%       A(2) * X == B(2)  (mod N(2))
%       ...
%       A(m) * X == B(m)  (mod N(m))
%
%   The solution, X, will be given as a vector [x1 x2] 
%   representing the general solution 
%
%              X == x1  (mod x2)
%  
%   Any specific answer can be found by letting
%   X = x1 + x2 * k  for any integer value of k.
%
%   If no solution exists [NaN NaN] will be returned.
%
%   A scalar input functions as a constant vector of the
%   same size as the other inputs.
%
%   Program is compatible with Variable Precision Integer
%   Arithmetic Toolbox available on File Exchange (#22725)
%   Use of VPI is recommended for large magnitude inputs 
%   or outputs. If VPI is not used and internal calculations
%   exceed largest consecutive flint a warning will be given
%   that results may be inaccurate, along with [NaN NaN].
%
%   Example #1:
%   Solve the following system of linear congruences
%      2x == 2  (mod 6)
%      3x == 2  (mod 7)
%      2x == 4  (mod 8)
%
%   Solution:
%      a=[2 3 2]; b=[2 2 4]; n=[6 7 8];
%      x=lincon(a,b,n)
%
%   Verify:
%      isequal( mod(a*x(1),n) , b)
%
%
%   Example #2:
%   Use of VPI for large magnitude numbers. Solve the following
%   system of linear congruences
%         (1234567)x == 89       (mod 2^32)
%         (9876543)x == 21       (mod 3^50)
%            (5555)x == 62830211 (mod 7^10)
%
%   Solution:
%     a=[1234567 9876543 5555]; b=[89 21 62830211]; 
%     n=[vpi(2)^32 vpi(3)^50 vpi(7)^10];
%     x=lincon(a,b,n)
%
%   Verify:
%     isequal( mod(a*x(1),n) , b)
%

%   Mike Sheppard
%   Last Modified 11-Sep-2011


%Check Inputs
[a,b,n,isvpi]=LinConCheckInputs(a,b,n);

%Initialize
b=mod(b,n);  % Make all positive for consistency
m=length(a); % Number of congruences
x=[0 1];     % Initialize to x==0  (mod 1)
k=0;         % line number

while k<m
  
  k=k+1;
  
  % Go line by line, using previous solutions of X
  % as starting points for each line
  
  % Original k'th Equation, shown as scalar valued:
  %    a * X == b  (mod n)
  % However, X == x1  (mod x2), substituting in for X
  %    a * (x1 + x2*V) == b  (mod n)
  % Simplifying
  %    a * x2 * V == (b - a*x1)  (mod n)
  % Relabel, and now solve for V for the modified equation
  %    ak * V == bk  (mod n)
  
  ak=a(k)*x(2);
  bk=mod(b(k)-a(k)*x(1),n(k)); %Positive for consistency
  nk=n(k);
  
  % Use Linear congruence theorem
  % Solving ak * V = bk  (mod n) for V

  if isvpi
      [gk,ck,dk]=vpigcd2(ak,nk); %Subfunction below
  else
      [gk,ck,dk]=gcd(ak,nk); 
  end
  
  % GK = CK*[AK] + DK*[NK]
  % (Extended Euclidean algorithm)

  
  if mod(bk,gk)==0 % Solution exists
      % V == v1  (mod v2)
      v2=nk/gk; 
      v1=mod(ck*bk/gk,v2); %Positive for consistency
      v=[v1 v2];
  else % No valid solution
      v=[NaN NaN]; 
      k=Inf; %Terminate loop
  end

  % Solution to modified equation is
  %    V == v1  (mod v2)
  % From before, X is given by
  %    X = x1 + x2*V
  % Substituting in for V yields
  %    X == (x1+x2*v1) (mod x2*v2)
  % Redefine new solution for X for use in next iteration
  
  if isfinite(k)
      x=[x(1)+x(2)*v(1) x(2)*v(2)];
  else
      x=[NaN NaN]; %No valid solution
  end

  
end

% Solution is found
%    X == x1  (mod x2)

end



%SUBFUNCTIONS
%------------
function [a,b,n,isvpi]=LinConCheckInputs(a,b,n)

%Make column vectors
a=a(:); b=b(:); n=n(:);

%Check to see if all are integer valued
if any(a~=round(a)) || any(b~=round(b)) || any(n~=round(n))
   error('LINCON : Input vectors must be same size')
end

%Check sizes, they can either be scalar or same-sized vectors
na=length(a); nb=length(b); nn=length(n); m=max([na nb nn]);
if ~all([na nb nn]==m | [na nb nn]==1)
   error('LINCON : Non-scalar arguments must match in size.')  
end

%If scalar, redefine as vectors of same size as other inputs
if na==1, a=a*ones(m,1); end
if nb==1, b=b*ones(m,1); end
if nn==1, n=n*ones(m,1); end

%Check to see if using VPI (Variable Precision Integers)
%Toolbox is available here:
%http://www.mathworks.com/matlabcentral/fileexchange/22725
isvpi=any(strcmp({class(a) class(b) class(n)},'vpi'));

end


function [g,c,d] = vpigcd2(a,b)
% Built-in GCD code given in VPI Toolbox solves
% for just the GCD; however, the coefficients for
% G = C*[A] + D*[B]
% are needed. This subfunction replaces the
% built-in GCD algorithm in VPI with one that
% uses the Extended Euclidean Algorithm
% (Simplified version of Matlab's built-in GCD)

c = 0; d = 0; g = 0;
u = [1 0 abs(a)];
v = [0 1 abs(b)];

while v(3)~=0
    q = quotient(u(3),v(3));
    t = u - v*q;
    u = v;
    v = t;
end
 
c = u(1) * sign(a);
d = u(2) * sign(b);
g = u(3);

end