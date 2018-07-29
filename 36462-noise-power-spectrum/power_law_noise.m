function nps = power_law_noise(P, varargin)

% nps = power_law_noise(P(alpha, beta), f1, f2, ..., fn)
% nps = power_law_noise(P(alpha, beta), fr)
%
% Returns a radially symmetric power-law NPS, nps = alpha * fr^(-beta), for
% Cartesian or radial input coordinates.
%
% f1, f2, ..., fn are equally sized n-dimensional arrays with Cartesian
% coordinates. Optionally, fr is an array of radial coordinates. The output
% nps is in Cartesian coordinates and in units of alpha.
%
% Erik Fredenberg, Royal Institute of Technology (KTH) (2010).
% Please reference this package if you find it useful.
% Feedback is welcome: fberg@kth.se.

% input checking
if length(varargin)>1 && (ndims(varargin{1})~=length(varargin) ||...
        any(diff(cellfun(@(C) ndims(C),varargin))))
    error('f1, f2, ..., fn need to be equally sized n-D arrays.')
end

alpha = P(1);
beta = P(2);

% converting to radial coordinates
r2=0; for p = 1:length(varargin), r2 = r2 + varargin{p}.^2; end

% power law
nps = alpha * r2.^(-beta/2);