function et = set(t,et)
% TIMETIC/SET Set the elapsed time of a timetic object.
%
% Setting a timer object always stops the timer.
%
% Example:
%   t = timetic;
%   set(t,5);
%   start(t);
%   toc(t);


%
% David Gleich
% Stanford University
% 27 September 2006
%

t.set(et);