function [s, xRound, seRound] = seround(x, se, lim)
% SEROUND:  Round value and standard error
%
% First, se is rounded to 1 significant figure.  Next,
%   x is rounded to the same significant figure as se.
%
% Returns a string suitable for output using fprintf or
%   other tools.  Also returns the rounded values if 
%   desired.
%
% Usage:
%   [s, xRound, seRound] = seround(x, se, [lim])
%       x: value to be rounded
%      se: standard error of x
%     lim: do not use scientific notation below this
%          order of magnitude (optional, default=2)
%
% See also: ROUND, FLOOR, CEIL

% v0.2 (Feb 2012) by Andrew Davis -- addavis@gmail.com

% Check inputs
if ~isscalar(x) || ~isscalar(se), error('Expected two scalars as input'); end;
x = double(x); se = double(se);
if ~exist('lim', 'var') || ~isscalar(lim), lim = 2; end;

% Round SE and x
mag = floor(log10(abs(se)));        % order of magnitude of se
seRound = round(se/10^mag)*10^mag;

xRound = round(x/10^mag)*10^mag;


% generate output string
if mag > lim || mag < -1*lim,       % thousands or more or less than hundredths get scientific notation
   s = sprintf('(%01.0f +/- %01.0f) x 10^%d', xRound/10^(mag), seRound/10^(mag), mag);
else,                               % near order 0
   if mag < 0,
      strFormat = ['%01.', num2str(abs(mag)), 'f'];      % string format depends on sig fig of SE
      s = sprintf([strFormat, ' +/- ', strFormat], xRound, seRound);
   else
      s = sprintf('%01.0f +/- %01.0f', xRound, seRound);
   end;
end;

