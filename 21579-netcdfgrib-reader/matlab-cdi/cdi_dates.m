function x=cdi_dates(dates)

% CDI_DATES : translates the date from CDI format to true date
%
% The result is a structure with year, month, day, hour and minute,
%
% x=cdi_dates(dates)
%
% INPUT;
%    dates: a date from a call to cdi_readmeta, cdi_readfull or cdi_readll
%
% OUTPUT:
%    x: structure with
%       - year
%       - month
%       - day
%       - hour
%       - min

% Author: Klaus Wyser, FoUrc

x.year=floor(dates/1e4);
x.month=floor(mod(dates,1e4)/100);
x.day=floor(mod(dates,100));
x.hour=floor(24*mod(dates,1));
x.min=mod(floor(1440*mod(dates,1)),60);

return
