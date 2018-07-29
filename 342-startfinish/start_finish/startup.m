function startup
% startup 
% Matlab OnLoad Routine 
% Loads the current path from a file saved by finish and return
% to last workdir automatically.
% 4/7/99 Ishai Hoch
% mailto:ishaihoch@yahoo.com 
% see also finish
  % This must be the only (or the first) startup file

load ([matlabroot,'\bin\sepath']);
cd (sepath)
disp (sepath)



