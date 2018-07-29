function out = datenan(x)
% an error handler function that allows blank dates to be represented as
% NaNs when they are cast into MATLAB serial date numbers.
if isempty(x)
    out = NaN;
else
    out = datenum(x);
end