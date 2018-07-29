function FCint = fresnelC(X,fresnelType)
% fresnelC - Fresnel cosine integrals, C(X), C1(X), or C2(X)
% usage: FCint = fresnelC(X,fresnelType)
%
% Fresnel cosine integrals fall into three classes, simple
% transformations of each other. All three types described
% by Abramowitz & Stegun are supported.
%
% The maximum error of this code has been shown to be less
% than 1.5e-14 for any value of X.
%
% arguments: (input)
%  X - Any real, numeric value, vector, or array thereof.
%      X is the upper limit of the Fresnel cosine integral.
%
%  fresnelType - scalar numeric flag, from the set {0,1,2}.
%      
%      The type 0 Fresnel cosine integral (A&S 7.3.1)
%        C(x) = \int_0^x cos(pi*t^2/2) dt, 
%
%      Type 1 (A&S  7.3.3a)
%        C_1(x) = \sqrt(2/pi) \int_0^x cos(t^2) dt
%
%      Type 2 (A&S  7.3.3b)
%        C_2(x) = \sqrt(1/2/pi) \int_0^x cos(t) / \sqrt(t) dt
%
% arguments: (output)
%  FCint - array of the same size and shape as X, containing
%      the indicated Fresnel cosine integral values.
% 
%
% Example:
% % Evaluate the Fresnel cosine integral C(x) at x = 1.38
%
% fresnelC(1.38,0)
%
% % ans =
% %       0.562975925772444
%
% % Verify the correctness of this value using quadgk
% FresnelCObj = @(t) cos(pi*t.^2/2);
% quadgk(FresnelCObj,0,1.38,'abstol',1e-15')
%
% % ans =
% %       0.562975925772444
%
% % Now, how fast is fresnelC? Using Steve Eddins timeit code
% % to yield an accurate estimate of the time required, we see
% % that it is reasonably fast for scalar input.
% timeit(@() fresnelC(1.38))
% % ans =
% %       0.000193604455833333
%
% % More importantly, fresnelC is vectorized. So 1 million
% % evaluations are easy to do, and are much faster than
% % 1 million times the time taken for one evaluation.
% T = rand(1000000,1);
% tic
% FCpred = fresnelC(T);
% toc 
% % Elapsed time is 0.226884 seconds.
%
%
% REFERENCES
% [1] Abramowitz, M. and Stegun, I. A. (Eds.). "Error Function and Fresnel 
%     Integrals." Ch. 7 in Handbook of Mathematical Functions with
%     Formulas, Graphs, and Mathematical Tables, 9th printing. New York:
%     Dover, pp. 295-329, 1970.  
%
% [2] Mielenz, K. D.; "Computation of Fresnel Integrals", Journal of
%     Research of the National Institute of Standards and Technology,
%     Vol 102, Number 3, May-June 1997
%        http://nvl.nist.gov/pub/nistpubs/jres/102/3/j23mie.pdf

persistent FCspl

if (nargin < 1) || (nargin > 2)
  error('FRESNELC:improperarguments','1 or 2 arguemtns are required.')
end

% default for fresnelType
if (nargin < 2) || isempty(fresnelType)
  fresnelType = 0;
else
  if ~isnumeric(fresnelType) || ~ismember(fresnelType,[0 1 2]) || (numel(fresnelType) ~= 1)
    error('FRESNELC:fresnelType', ...
      'fresnelType must be scalar, one of {0,1,2} if supplied.')
  end
end

% X must be real, but of any shape.
if any(imag(X) ~= 0)
  warning('FRESNELC:complexarguments','X should be real. Imaginary part will ignored.')
  X = real(X);
end

% preallocate FCint to the proper size
FCint = zeros(size(X));

% flag any negative X, make it positive.
S = X < 0;
X(S) = -X(S);

% transform the type 1 and 2 problems into type 0
switch fresnelType
  case 1
    X = sqrt(2/pi)*X;
  case 2
    X = sqrt(2*X/pi);
end

% The upper limit of the tables is 7.5.
Xlim = 7.5;
% klim is a boolean variable that indicates values that exceed Xlim.
klim = (X >= Xlim);
if any(klim(:))
  % we found some values that exceed the limit. Use
  % the rational approximations provided in Mielenz [2]
  % for the associated functions f(z) (see (4a)) and
  % g(z) (see (4b)). The approximations are carried to
  % additional terms beyond that displayed in Mielenz.
  %
  % For abs(X) >= 7.5, these yield results with
  % roughly 15 significant digits.
  xk = X(klim);
  
  FCint(klim) = 0.5 + (1 - 3/pi^2 ./xk.^4 + 105/pi^4 ./xk.^8 - ...
    10395/pi^6 ./xk.^12 + 2027025/pi^8 ./xk.^16).*sin(pi/2*xk.^2)./(pi*xk) - ...
    (1 - 15/pi^2 ./xk.^4 + 945/pi^4 ./xk.^8 - 135135/pi^6 ./xk.^12 + ...
    34459425/pi^8 ./xk.^16).*cos(pi/2*xk.^2)./(pi^2*xk.^3);
  
end
klim = ~klim;

% for abs(Xlim) <= Xlim, we will use a spline interpolant of the
% cosine integral itself.
if any(klim(:))
  % have we loaded the appropriate spline?
  if isempty(FCspl)
    load _Fresnel_data_ FCspl
  end
  
  % do the interpolation itself using ppval. This will be
  % better than calling interp1 with the 'spline' option,
  % since it avoids overhead of calling an already created
  % and stored spline. It will be better than pchip or the
  % 'cubic' option for interp1 since the spline will be
  % considerably more accurate.
  FCint(klim) = ppval(FCspl,X(klim));
end

% The Fresnel sine and cosine integrals are odd functions of X,
% so swap signs for any negative X.
FCint(S) = - FCint(S);

end % mainline end

% ===============================================================
%     Code used only to generate and save the integral tables
% ===============================================================
function generateTables

% Generate the integral tables, more accurate than Abramowitz &
% Stegun provide, since they give only 7 digits.
FresnelCObj = @(t) cos(pi*t.^2/2);
FresnelSObj = @(t) sin(pi*t.^2/2);

p = 1.75;
T0 = linspace(1,7.5.^p,501).' .^(1/p);
dt = T0(2) - T0(1);
T0 = [linspace(0,1 - dt,ceil(1./dt))';T0];
plot(diff(T0))

n = length(T0);
FC75 = zeros(n,1);
FS75 = zeros(n,1);

h = waitbar(0,'Computing Fresnel integrals');
for i = 2:n
  waitbar(i/n,h)
  FC75(i) = quadgk(FresnelCObj,0,T0(i),'abstol',1.e-16,'reltol',100*eps('double'));
  FS75(i) = quadgk(FresnelSObj,0,T0(i),'abstol',1.e-16,'reltol',100*eps('double'));
end
delete(h)

% Turn them into splines, then save the splines. These splines are
% first built in a Hermite form, since I can supply the 1st and second
% derivatives of the function. Then I turn them into a pp form, for use
% in fresnelC and fresnelS.
FCspl = hermite2slm([T0,FC75,FresnelCObj(T0), -pi*T0.*sin(pi*T0.^2/2), ...
  -pi*(sin(pi*T0.^2/2) + pi*T0.^2 .*cos(pi*T0.^2/2))]);
FCspl = slm2pp(FCspl);

FSspl = hermite2slm([T0,FS75,FresnelSObj(T0),pi*T0.*cos(pi*T0.^2/2), ...
  pi*(cos(pi*T0.^2/2) - pi*T0.^2 .*sin(pi*T0.^2/2))]);
FSspl = slm2pp(FSspl);

save _Fresnel_data_ FCspl FSspl


% test the result
clear functions

n = 1000;
T = sort(rand(n,1)*10);
FCquad = zeros(n,1);
FSquad = zeros(n,1);
for i = 1:n
  FCquad(i) = quadgk(FresnelCObj,0,T(i),'abstol',1.e-16);
  FSquad(i) = quadgk(FresnelSObj,0,T(i),'abstol',1.e-16);
end
FCpred = fresnelC(T,0);
FSpred = fresnelS(T,0);

subplot(1,2,1)
plot(T,FCquad - FCpred,'.')
grid on
subplot(1,2,2)
plot(T,FSquad - FSpred,'.')
grid on

end


