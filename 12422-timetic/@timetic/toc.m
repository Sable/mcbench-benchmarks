function et=toc(t)
% TIMETIC/TOC Implement the TOC operation on a timetic object
%
% The toc function duplicates the behavior of the global toc command in
% matlab on a timetic object.  By itself, it prints the total elapsed time
% in seconds.  Calling et = toc(t) saves the elapsed time in seconds 
% in the variable et and does not print anything.
%
% Using tic and toc on t allow for nested timers analogous to tic and toc.
%
% Example:
%   t = timetic();
%   tic(t);
%   toc(t);
%
% See also TOC, TIMETIC/TIC, TIMETIC/ELAPSED

%
% David Gleich
% Stanford University
% 27 September 2006
%

if nargout < 1
    disp(sprintf('Elapsed time is %f seconds.', t.elapsed()));
else
    et = t.elapsed();
end
