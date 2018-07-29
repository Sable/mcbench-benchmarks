function [c, s] = fcs(x, terms)

% FCS Compute Fresnel integral.
% 
% Usage: F = FCS(X, TERMS) or [C, S] = FCS(X, TERMS) 
% 
% Returns the Fresnel cosine integral C and sine integral S for each 
% element in X. If only one output is requested, F = C + j*S is output. The
% convention of this function is to use a pi/2 normalization in the
% argument of the trignometric function in the definition. To get the
% Fresnel integral without this normalization, input sqrt(2/pi)*x and
% multiply the the output by sqrt(pi/2).
% 
% For inputs with magnitude less than or equal to 1.6, the Taylor series
% expansion using TERMS (default 12) number of terms is used. Otherwise,
% an auxillary function is used. The algorithm is described in the paper:
%
% Klaus D. Mielenz, Computation of Fresnel Integrals. II
% J. Res. Natl. Inst. Stand. Technol. 105, 589 (2000), pp 589-590
% (accessible online:
% http://nvlpubs.nist.gov/nistpubs/jres/105/4/j54mie2.pdf)
% 
% The paper claims the error should be less than 1e-9.
% 
% Inputs:
%   -X: values to compute Fresnel integral of.
%   -TERMS: number of terms to use in Taylor series expansion (optional,
%   default is 12).
% 
% Outputs:
%   -C: Fresnel cosine integral (with a pi/2 normalization).
%   -S: Fresnel sine integral (with a pi/2 normalization).


% Turn x into a column vector, but get its size to turn the output back
% when we are done.
sizex = size(x);
x = x(:);

% There are two cases depending on whether or not abs(x) is less than 1.6.
xsmall = abs(x) <= 1.6;

% Initialize the output.
c = zeros(length(x), 1);
s = zeros(length(x), 1);

% When x is less than 1.6, use the Taylor series expansion with the number
% of terms as specified by the input terms.
if any(xsmall)
    if nargin == 1 || isempty(terms)
        terms = 12;
    end
    n = 0 : terms - 2;
    cn = [1, cumprod(-pi^2*(4*n+1)./(4*(2*n+1).*(2*n+2).*(4*n+5)))];
    sn = [1, cumprod(-pi^2*(4*n+3)./(4*(2*n+2).*(2*n+3).*(4*n+7)))]*pi/6;
    n = [n terms-1];
    c(xsmall) = sum(bsxfun(@times, cn, bsxfun(@power, x(xsmall), ...
        4*n+1)), 2);
    s(xsmall) = sum(bsxfun(@times, sn, bsxfun(@power, x(xsmall), ...
        4*n+3)), 2);
end

% When x is larger than 1.6, use the auxillary function.
if any(~xsmall)
    n = 0 : 11;
    fn = [0.318309844, 9.34626e-8, -0.09676631, 0.000606222, ...
         0.325539361, 0.325206461, -7.450551455, 32.20380908, ...
        -78.8035274, 118.5343352, -102.4339798, 39.06207702];
    gn = [0, 0.101321519, -4.07292e-5, -0.152068115, -0.046292605, ...
        1.622793598, -5.199186089, 7.477942354, -0.695291507, ...
        -15.10996796, 22.28401942, -10.89968491];
    fx = sum(bsxfun(@times, fn, bsxfun(@power, x(~xsmall), -2*n-1)), 2);
    gx = sum(bsxfun(@times, gn, bsxfun(@power, x(~xsmall), -2*n-1)), 2);
    c(~xsmall) = 1/2 .* sign(x(~xsmall)) + ...
        fx .* sin(pi/2*x(~xsmall).^2) - gx .* cos(pi/2*x(~xsmall).^2);
    s(~xsmall) = 1/2 .* sign(x(~xsmall)) - ...
        fx .* cos(pi/2*x(~xsmall).^2) - gx .* sin(pi/2*x(~xsmall).^2);
end

% Output the integral.
if nargout <= 1
    c = reshape(c, sizex) + 1i*reshape(s, sizex);
else
    c = reshape(c, sizex);
    s = reshape(s, sizex);
end