% HISTWCV  Vectorized weighted histogram count given number of bins
%
% This function generates a vector of cumulative weights for data
% histogram. Equal number of bins will be considered using minimum and 
% maximum values of the data. Weights will be summed in the given bin.
%
% Usage: [histw, vinterval] = histwcv(vv, ww, nbins)
%
% Arguments:
%       vv    - values as a vector
%       ww    - weights as a vector
%       nbins - number of bins
%
% Returns:
%       histw     - weighted histogram
%       vinterval - intervals used
%       
%
%
% See also: HISTC, HISTWC

% Author:
% mehmet.suzen physics org
% BSD License
% July 2013

function [histw, vinterval] = histwcv(vv, ww, nbins)  
  minV  = min(vv);
  maxV  = max(vv);
  delta = (maxV-minV)/nbins;
  vinterval = linspace(minV, maxV, nbins)-delta/2.0;
  histw = zeros(nbins, 1);
  indX  = arrayfun(@(xx) find(vinterval < vv(xx), 1, 'last'), 1:length(vv));
  arrayfun(@(xx) evalin('caller', ['histw(indX(', sprintf('%d', xx),')) = histw(indX(', sprintf('%d', xx),')) + ww(', sprintf('%d', xx),');']), 1:length(vv));
end