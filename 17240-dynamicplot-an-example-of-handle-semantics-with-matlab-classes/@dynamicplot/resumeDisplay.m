% resumeDisplay(obj)
%  Resumes the dynamic update of the plot (if the plot has been paused
%  using pauseDisplay()). If the plot is already being dynamically updated,
%  resumeDisplay() does not do anything.
%
%  Also see: pauseDisplay

function resumeDisplay(s)
s.checkValidity();

tobj = s.getTimerObject();
if ~strcmp(get(tobj, 'Running'), 'on')
    start(tobj);
end

