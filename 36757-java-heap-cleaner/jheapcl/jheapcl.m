function [] = jheapcl(verbose)

if nargin < 1
    verbose = 0;
end

org.dt.matlab.utilities.JavaMemoryCleaner.clear(verbose)

% Use this for silent cleanup
% org.dt.matlab.utilities.JavaMemoryCleaner.clear(1)

% Decomment this for verbose cleanup
% org.dt.matlab.utilities.JavaMemoryCleaner.clear(1)