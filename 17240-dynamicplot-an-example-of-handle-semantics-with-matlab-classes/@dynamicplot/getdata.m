% out = getdata(obj)
%  Returns the most recent data that has been retrieved 
%  from the generator function. 
%
function out = getdata(s)

s.checkValidity();
out = s.getMostRecentData();


