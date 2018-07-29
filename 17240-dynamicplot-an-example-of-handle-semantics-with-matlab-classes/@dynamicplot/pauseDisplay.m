% pauseDisplay(obj)
%  Temporarily stops the dynamic update of the plot (the generator function 
%  is not called while the dynamic plot is paused).
%
%  Also see: resumeDisplay
%
function pauseDisplay(s)

s.checkValidity();
tobj = s.getTimerObject();
stop(tobj);

