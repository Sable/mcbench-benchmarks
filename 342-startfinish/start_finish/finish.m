function finish
% finish 
% Matlab OnExit Routine 
% Save current path in order to return
% to the same workdir automatically (startup).
% 4/7/99 Ishai Hoch 
% mailto:ishaihoch@yahoo.com 
% see also startup
sepath=pwd;
save ([matlabroot,'\bin\sepath'],'sepath');
