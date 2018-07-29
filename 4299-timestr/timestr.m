function S = timestr(D,precision)
%timestr          String representation of time.   HH:MM:SS.SSSS
%
% TIMESTR(D) converts D, a serial date number (as returned by DATENUM)
% into a time string with the format HH:MM:SS.SSSS
%
% TIMESTR(D,precision) uses precision values to the right of the decimal

% Copyright 2003 The MathWorks, Inc

if nargin==1
    precision=4;
end;
totalwidth = precision + 3;         %2 to left of decimal, plus decimal
precision = num2str(precision);
totalwidth = num2str(totalwidth);

D = D(:);

% Obtain components of date number
[y,mo,d,h,min,s] = datevecmx(D,1.1);  mo(mo==0) = 1;

% Generate formatted string
% sw = floor(s);      %Whole
% sf = floor((s-sw)*1000);          %Fraction
% M = [h';min';sw';sf'];       %sprintf works columnwise
% fmt = '%02d:%02d:%02d.%04d';
M = [h';min';s'];       %sprintf works columnwise

% Figure out how long to make seconds format.
% Since we are building a string array, every element must be the same
% length
sw = floor(s);      %Whole
sf = floor((s-sw)*1000);          %Fraction

fmt = ['%02d:%02d:%' totalwidth '.' precision 'f'];
S = sprintf(fmt,M(:,1));
for ii=2:length(D)
    t= sprintf(fmt,M(:,ii));
    S = [S;t];
end;

% My formatting is a bit messed up.  I can't figure out how to add 
% zeros when necessary for seconds - I end up with blanks.
% Replace blanks with 0
blnks = find(double(S)==32);        % 32 - ASCII for 0
S(blnks) = '0';

