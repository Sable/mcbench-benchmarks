function matlab_time = unixtime2mat(unix_time);
% unixtime2mat  Converts unix time stamps (seconds since Jan 1, 1970) to
%               Matlab serial date number (decimal days since Jan 1 0000).
%               
%               USAGE:
%                      unixtime2mat(unix_time)
%
%
%               The function may not handle leap years or leap seconds
%               appropriately.  
%
%               Val Schmidt 
%               Center for Coastal and Ocean Mapping
%               2007

unix_epoch = datenum(1970,1,1,0,0,0);
matlab_time = unix_time./86400 + unix_epoch; 
