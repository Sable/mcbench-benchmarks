% setUpdatePeriod(s, newPeriod)
%   Specifies how often the dynamic plot should be updated (i.e., how
%   often the generator function should be called). newPeriod is 
%   a value in seconds.
%
% Example:
%  d = dynamicplot(@() randn(1,100), 0.5);
%  setUpdatePeriod(s, 0.1);

function setUpdatePeriod(s, newPeriod)

s.checkValidity();

if (s.getUpdatePeriod() ~= newPeriod)
    tobj = s.getTimerObject();
    stop(tobj);
    set(tobj, 'period', newPeriod);
    start(tobj);
end

