function et = pause(t)
% TIMETIC/PAUSE Pause a timetic object.
%
% et = pause(t) pauses the timer and returns the elapsed time.
%
% Example:
%   t = timertic;
%   start(t);
%   lu(rand(100));
%   et = pause(t);
%   pause(5);      % wait for 5 seconds
%   start(t);
%   lu(rand(100));
%   toc(t)

%
% David Gleich
% Stanford University
% 27 September 2006
%

t.pause();
et = t.elapsed();
