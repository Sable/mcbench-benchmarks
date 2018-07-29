function output = roundx(X, decimalplaces, options)
%ROUNDX rounds the elements of X with the desired precision 
%
%  output = roundx(X)
%  output = roundx(X, decimalplaces)
%  output = roundx(X, decimalplaces, options)
%
%  X is the value to be rounded. X can be an array, if desired.
%  DECIMALPLACES is the number of decimal places to round to. Also accepts
%     0 and negative values, used to round to desired sig. figs.
%  OPTIONS can be 'ceil', 'floor', or 'round' and indicates to the function
%     whether to round up, down, or to the closest value, respectively.
%     Default is 'round' if excluded.
%
%  Author: David Berman (dberm22@gmail.com)

if nargin == 1
    output = round(X);
elseif nargin == 2
    if (length(decimalplaces)>1)
        error('Decimal places must be a scalar value') 
    end
    output = round(X*10^decimalplaces)./(10^decimalplaces);
elseif nargin == 3
    if (length(decimalplaces)>1)
        error('Decimal places must be a scalar value') 
    end
    if (strcmpi(options,'ceil') || strcmpi(options,'up'))
        output = ceil(X*10^decimalplaces)./(10^decimalplaces);
    elseif (strcmpi(options,'floor') || strcmpi(options,'down'))
        output = floor(X*10^decimalplaces)./(10^decimalplaces);
    elseif (strcmpi(options,'round') || strcmp(options,'default'))
        output = round(X*10^decimalplaces)./(10^decimalplaces);
    else
        warning('Improper third argument, using ''round''')
        output = round(X*10^decimalplaces)./(10^decimalplaces);
    end
else
    error('Incorrect number of input arguments')
end