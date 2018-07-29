function et = elapsed(t)
% TIMETIC/ELAPSED Return the elapsed time.
%
% This function is identical to toc, except that it doesn't print a 
% message if called without arguments.
%
% Example:
%   t = timetic;
%   start(t);
%   [L,U] = lu(rand(100));
%   elapsed(t);
%
% See also TIMETIC/TOC

%
% David Gleich
% Stanford University
% 27 September 2006
%

et = t.elapsed();