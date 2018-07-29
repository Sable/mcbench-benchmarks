% out = getNumUpdates(obj)
%  Returns the number of times the dynamic plot has been updated.
%
function out = getNumUpdates(s)
s.checkValidity();

out = s.getNumAcquisitions();
end

