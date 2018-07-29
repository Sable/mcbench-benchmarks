function test
%Test function for loadACQ
%  (c) 2003 Mihai Moldovan 
%   M.Moldovan@mfi.ku.dk


chan=loadacq ('EEGdata.acq');
%id -> the original channel id
%color -> matlab converted color
%name -> name of the channel
%units -> label of the units
%ms -> ms per point
%data -> vector with scaled samples
%mdata -> marker samples
%mname -> marker names

%plots channel structure
plotacq (chan)
%return
%----------------------------------------------