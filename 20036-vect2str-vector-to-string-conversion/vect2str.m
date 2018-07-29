function s = vect2str(v,varargin)
%VECT2STR Vector to string conversion.
%   VECT2STR(v) yields a string containing the elements of v in a
%   vector-like notation. The elements are separated by
%   commas and enclosed in parentheses.
%   v must be a vector, either row (1xN) or column (Nx1)
% 
%   VECT2STR(v,options) yields a string containing the elements of v in a
%   customised vector-like notation. Element separator, formatting and
%   enclosing delimiters can be independently specified.
% 
%   Options
%   Name              Type    Default         Meaning
%   formatString      char    '%f'            Format string applied to each element
%   openingDelimiter  char    '('             The string starting the output,
%                                             before the first element
%   closingDelimiter  char    ')'             The string ending the output,
%                                             after the last element
%   separator         char    ','             The string put between elements
%
%   Examples
%   x = [pi exp(1)];
%
%   vect2str(x)
%   (3.141593, 2.718282)
%
%   vect2str(x,'formatstring', '%5.2f')
%   ( 3.14,  2.72)
%
%   vect2str(x, 'formatstring', '%5.2f', ...
%               'openingDelimiter', 'Elements are', ...
%               'closingDelimiter', '.'           , ...
%               'separator',' and ')  
%   Elements are 3.14 and  2.72.
%
%   See also sprintf

%% Input parser configuration for parameter handling
ip = inputParser;
ip.FunctionName = mfilename;
ip.CaseSensitive = false;
ip.addRequired('v', @isvector);
ip.addParamValue('formatString', '%f', @ischar);
ip.addParamValue('openingDelimiter', '(', @ischar);
ip.addParamValue('closingDelimiter', ')', @ischar);
ip.addParamValue('separator', ', ', @ischar);
ip.parse(v, varargin{:});

%% String generation
% Start with the opening delimiter...
s = ip.Results.openingDelimiter;

% ... and for each element of v ...
for k = 1 : numel(v)
    % ... print out the value using the specified format string.
    s = [s sprintf([ip.Results.formatString],v(k))]; %#ok<AGROW>
    % If it's not the last element ...
    if k<numel(v)
        % ... then insert the separator.
        s = [s ip.Results.separator]; %#ok<AGROW>
    end
end

% At the end, terminate the string using the closing delimiter
s = [s ip.Results.closingDelimiter];

end
