function x=isleap(Year)
%ISLEAP True for leap year.
%     ISLEAP(Year) returns 1 if Year is a leap year and 0 otherwise.
%     ISLEAP is only set for gregorian calendar, so Year >= 1583
%
% Syntax: 	ISLEAP(YEAR)
%      
%     Inputs:
%           YEAR - Year of interest (default = current year). 
%           You can input a vector of years.
%     Outputs:
%           Logical vector.
%
%      Example: 
%
%           Calling on Matlab the function: isleap
%
%           Answer is: 0
%
%
%           Calling on Matlab the function: x=isleap([2007 2008])
%
%           Answer is:
%           x = 0 1
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%           Modified after Simon Jan suggestions
% To cite this file, this would be an appropriate format:
% Cardillo G. (2007) Isleap: a simple routine to test if a year is a leap
% year.
% http://www.mathworks.com/matlabcentral/fileexchange/14172



%Input Error handling
switch nargin
    case 0
         c=clock; Year=c(1); clear c
    case 1
        if ~isvector(Year) || ~all(isnumeric(Year)) || ~all(isfinite(Year)) || isempty(Year)
            error('Warning: Year values must be numeric and finite')
        end
        if ~isequal(Year,round(Year))
            error('Warning: Year values must be integer')
        end
        L=Year-1583;
        if L(L<0)
            error('Warning: Every value of Year must be >1582')
        end
    otherwise
        error('stats:Isleap:TooMuchInputs','Year must be a scalar or a vector.');
end

% The Gregorian calendar has 97 leap years every 400 years: 
% Every year divisible by 4 is a leap year. 
% However, every year divisible by 100 is not a leap year. 
% However, every year divisible by 400 is a leap year after all. 
% So, 1700, 1800, 1900, 2100, and 2200 are not leap years, 
% but 1600, 2000, and 2400 are leap years.
x = ~mod(Year, 4) & (mod(Year, 100) | ~mod(Year, 400)); 
return