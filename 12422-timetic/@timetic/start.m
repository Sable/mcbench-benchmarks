function et = start(t)
% TIMETIC/START Start a timer.
%
% et = start(t) starts timer t and returns the current elapsed time.  This
% function does not reset the current elapsed time like tic.  The start
% function is designed to be used with pause to continue accumulating time.
%
% Example:
%   t = timertic;
%   start(t);
%   sphere;
%   axis square;
%   et = pause(t)
%
% See also TIMETIC/PAUSE

%
% David Gleich
% Stanford University
% 27 September 2006
%

t.start();
et = t.elapsed();