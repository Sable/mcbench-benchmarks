function FSint = fresnelS(X,fresnelType)
% fresnelS - Fresnel sine integrals, S(X), S1(X), or S2(X)
% usage: FSint = fresnelS(X,fresnelType)
%
% Fresnel sine integrals fall into three classes, simple
% transformations of each other. All three types described
% by Abramowitz & Stegun are supported.
%
% The maximum error of this code has been shown to be less
% than (approximately) 1.5e-14 for any value of X.
%
% arguments: (input)
%  X - Any real, numeric value, vector, or array thereof.
%      X is the upper limit of the Fresnel sine integral.
%
%  fresnelType - scalar numeric flag, from the set {0,1,2}.
%      
%      The type 0 Fresnel sine integral (A&S 7.3.1)
%        S(x) = \int_0^x sin(pi*t^2/2) dt, 
%
%      Type 1 (A&S  7.3.3a)
%        S_1(x) = \sqrt(2/pi) \int_0^x sin(t^2) dt
%
%      Type 2 (A&S  7.3.3b)
%        S_2(x) = \sqrt(1/2/pi) \int_0^x sin(t) / \sqrt(t) dt
%
% arguments: (output)
%  FSint - array of the same size and shape as X, containing
%      the indicated Fresnel sine integral values.
% 
%
% Example:
% % Evaluate the Fresnel sine integral S(x) at x = pi
% fresnelS(pi,0)
%
% % ans =
% %       0.598249078090266
%
% % Verify the correctness of this value using quadgk
% fresnelSObj = @(t) sin(pi*t.^2/2);
% quadgk(fresnelSObj,0,pi,'abstol',1e-15')
%
% % ans =
% %       0.598249078090268
%
% % Now, how fast is fresnelS? Using Steve Eddins timeit code
% % to yield an accurate estimate of the time required, we see
% % that it is reasonably fast for scalar input.
% timeit(@() fresnelS(pi))
% % ans =
% %       0.0002935014515
%
% % More importantly, fresnelS is vectorized.  So 1 million
% % evaluations are easy to do, and are much faster than
% % 1 million times the time taken for one evaluation.
% T = rand(1000000,1);
% tic
% FSpred = fresnelS(T);
% toc 
% % Elapsed time is 0.220848 seconds.
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

persistent FSspl

if (nargin < 1) || (nargin > 2)
  error('FRESNELS:improperarguments','1 or 2 arguemtns are required.')
end

% default for fresnelType
if (nargin < 2) || isempty(fresnelType)
  fresnelType = 0;
else
  if ~isnumeric(fresnelType) || ~ismember(fresnelType,[0 1 2]) || (numel(fresnelType) ~= 1)
    error('FRESNELS:fresnelType', ...
      'fresnelType must be scalar, one of {0,1,2} if supplied.')
  end
end

% X must be real, but of any shape.
if any(imag(X) ~= 0)
  warning('FRESNELS:complexarguments','X should be real. Imaginary part will ignored.')
  X = real(X);
end

% preallocate FSint to the proper size
FSint = zeros(size(X));

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
klim = (X > Xlim);
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
  
  FSint(klim) = 0.5 - (1 - 3/pi^2 ./xk.^4 + 105/pi^4 ./xk.^8 - ...
    10395/pi^6 ./xk.^12 + 2027025/pi^8 ./xk.^16).*cos(pi/2*xk.^2)./(pi*xk) - ...
    (1 - 15/pi^2 ./xk.^4 + 945/pi^4 ./xk.^8 - 135135/pi^6 ./xk.^12 + ...
    34459425/pi^8 ./xk.^16).*sin(pi/2*xk.^2)./(pi^2*xk.^3);
  
end
klim = ~klim;

% for abs(Xlim) <= Xlim, we will use a spline interpolant of the
% sine integral itself.
if any(klim(:))
  % have we loaded the appropriate spline?
  if isempty(FSspl)
    load _Fresnel_data_ FSspl
  end
  
  % do the interpolation itself using ppval. This will be
  % better than calling interp1 with the 'spline' option,
  % since it avoids overhead of calling an already created
  % and stored spline. It will be better than pchip or the
  % 'cubic' option for interp1 since the spline will be
  % considerably more accurate.
  FSint(klim) = ppval(FSspl,X(klim));
end

% The Fresnel sine and cosine integrals are odd functions of X,
% so swap signs for any negative X.
FSint(S) = - FSint(S);

end % mainline end


