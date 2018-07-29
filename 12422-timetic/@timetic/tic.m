function tic(t)
% TIMETIC/TIC Implement the TIC operation on a timetic object
%
% The tic function duplicates the behavior of the global tic command in
% matlab on a timetic object.  It sets the current time to 0 and starts the
% timer.  (Notice the different from the start function which does not set
% the time to 0.)
%
% Using tic and toc on t allow for nested timers analogous to tic and toc.
%
% Example:
%   t = timetic();
%   tic(t);
%   toc(t);
%
% See also TIC, TIMETIC/TOC, TIMETIC/START

%
% David Gleich
% Stanford University
% 27 September 2006
%

t.set(0);
t.start();