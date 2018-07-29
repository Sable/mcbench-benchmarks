function [w] = hann_p(npt)
%
% Type: [w] = hann_p(npt);
%
% Inputs:
%
% npt   := number of points in the window vector
%
% Outputs:
%
% w     := periodic hanning window vector, npt x 1
%
% Compute the periodic hanning window.

% Scot McNeill, University of Houston, Fall 2007.
%
w=0.5*(1-cos(2*pi*[1:npt].'/(npt)));
%
%%