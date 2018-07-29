function display(t)
% TIMETIC/DISPLAY Display a timetic object
%
% Example:
%   t = timetic

disp([inputname(1), ' = ']);

dispstr = sprintf('   timetic object: %g seconds ', elapsed(t));
if (t.state() == 1)
    dispstr = [dispstr '[Running]'];
end

disp(dispstr);