function y = invgpdf(x, alpha, beta)
%INVGPDF Probability density function (pdf) for Inverse-Gauﬂ distribution.
%   Y = INVGPDF(X, ALPHA, BETA) returns the pdf of the Inverse-Gauﬂ 
%   distribution with parameters ALPHA and BETA, evaluated at the 
%   values in X.
%   
%   ALPHA, BETA must be scalar values.
%   ALPHA, BETA must be positive.
%
%   Default values: ALPHA = 1, BETA = 1.
%
%   See also INVGRND.

%   References:
%      [1] Deler, B. and Nelson, B.L.: Modeling And Generating Multivariate
%          Time Series With Arbitrary Marginals And Autocorrelation
%          Structures
%          Departement of Industrial Engineering and Management Sciences
%          Northwestern University Evanston, IL, 60208-3119, USA, Appendix.

% -------------------------------------------------------------------------
% 
% Allianz, Group Risk Controlling
% Risk Methodology
% Koeniginstr. 28
% D-80802 Muenchen
% Germany
% Internet:    www.allianz.de
% email:       ralf.werner@allianz.de
% 
% Implementation Date:  2006 - 01 - 21
% Author:               Dr. Ralf Werner
%
% -------------------------------------------------------------------------


% Default values
if nargin < 2
    alpha = 1;
end
if nargin < 3
    beta = 1;
end

% Constraints for the parameters
if alpha <= 0
    error('ALPHA must be positive.');
end
if beta <= 0
    error('BETA must be positive.');
end

% transform input into column vector
[nx, mx] = size(x);
x = reshape(x, nx * mx, 1);

% invg is only well-defined for positive values
x(x <= 0) = NaN;

% calculate density
y = alpha/sqrt(2*pi*beta) * x.^(-3/2) .* exp(-(alpha - beta * x) .^2 ./ (2 * beta * x));

% transform input vector back to input format
y = reshape(y, nx, mx);
y(isnan(x)) = 0;
