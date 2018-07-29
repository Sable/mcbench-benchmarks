function out = dinput(varargin)

% Same as 'input' function, only this allows you to pass a default
% value in, so you can just hit Enter and accept the default.
% The default can be a string, number, or cell array.
%
% Note that 'dinput' preserves the type of numbers and cell arrays.
% E.g. if the default is a number, 'dinput' checks to make certain the user
% typed a number, and the output of the function is a number.
%
% Usage:
%      out = dinput(question_str, default)
%      out = dinput(..., 'empty_check', 'off')
%
%   empty_check: Check for empty ('') response.  ON by default.  
%
% Examples:
%      out = dinput('Run command? (y/n)', 'y')
%      out = dinput('Your name?', 'Ishmael')
%      out = dinput('Which door? ', 3)
%      out = dinput('Colors? ', {'green', 'orange'})
%
% See also:  input


[qstr, default, empty_check] = parse_inputs(varargin{:});

if isnumeric(default)
    default_is_numeric = 1;
    default_str = num2str(default);
else
    default_is_numeric = 0;
    default_str = default;
end

if iscell(default_str)
    default_is_cell = 1;
    default_str = cell2evalstr(default_str);
else
    default_is_cell = 0;
end

% Form question string, and put default in brackets
if isempty(default)
    % Display empty quotes/brackets just so it's more intuitive to the user
    if ischar(default),     q = [qstr, ' [''''] '];
    elseif iscell(default), q = [qstr, ' [{}] '];
    else                    q = [qstr, ' [[]] '];
    end
else
    q = [qstr, ' [', default_str, '] '];
end

% Repeatedly ask question till we get a valid answer
while 1

    out = input(q, 's'); % Get the raw user input as a string (without trying to evaluate it)
    
    if strcmp(out, '') % User hit enter
        fprintf('\b%s\n', default_str) % display the default as confirmation of the choice made
        out = default;
        break

    else % User typed something as an input
        
        % The 'input' function always returns a string, even if the input was a number.
        % If the default value was numeric, assume output should be numeric too.
        if default_is_numeric
            tmp = str2num(out);
            if isempty(tmp)  % Could not convert what the user typed into a number
                
                % Uncomment lines below if you want to force user to input a
                % number when the default was a number.
                %
                fprintf('\n*** Please input a number ***\n\n')
                continue
                %
                % OR
                %
                % Just return the string the user typed if the conversion from 
                % string to number was unsuccessful.
                break
            else
                out = tmp;
                break
            end
            
        elseif default_is_cell
            cmd = ['out = ', out, ';'];
            try eval(cmd)
                if iscell(out)
                    break
                else
                    fprintf('\n *** Please input a cell array, e.g. {''this'', ''that''}\n\n')
                end
            catch
                fprintf('\n *** Please input a cell array, e.g. {''this'', ''that''}\n\n')
            end
            
        else % default is string
            break
            
        end
    end
end

if empty_check
    out = fix_empty_input(out);
end


% =================================================================
function [qstr, default, empty_check] = parse_inputs(varargin)


qstr = varargin{1};

if nargin < 2
    error(sprintf('\nNo default provided.\n'))
    % default = '';
else
    default = varargin{2};
end
if nargin > 2
    opts = varargin(3:end);
else
    opts = {};
end

% Default
empty_check = 'on';

% Go through option(s)
if ~isempty(opts)
    L = length(opts);
    if mod(L,2) == 0
        opts = reshape(opts, 2, [])';
        for i = 1:L/2
            option_name = opts{i,1};
            option_val = opts{i,2};
            if ischar(option_name)
                option_name = lower(option_name);
                switch option_name
                    case 'empty_check'
                        empty_check = option_val;
                    otherwise
                        error(['Unrecognized option: ', option_name])
                end
            else
                error('Bad option name')
            end
        end
    else
        error('Options must come in option/value pairs')
    end
end

% Convert 'on'/'off' to 1/0
if ischar(empty_check)
    switch lower(empty_check)
        case 'on', empty_check = 1;
        case 'off', empty_check = 0;
        otherwise, error('empty_check must be ''on'' or ''off''')
    end
end


% =================================================================
function out = fix_empty_input(in)

% Check if user typed the literal characters for an empty string/cell/array
%
% Example:
%
%    % Explicitly turn 'empty_check' off to see why it is necessary
%    out = dinput('Which color?', 'green', 'empty_check', 'OFF')
%
%    % Output looks like this
%    >> Which color? [green]
%    >> Which color? [green] '' <-- User didn't know which color and typed
%                                   two single quotes to signify 'I dunno'
%    >> out = ''                <-- 'out' now contains two 'single-quote'
%                                   characters, NOT the empty string, which
%                                   may break further processing, e.g. 
%                                   if isempty(out), color = 'black'; end
%
%    % Correct for this by turning 'empty_check' ON (default):
%    out = dinput('Which color?', 'green')

if ischar(in)
    switch in
        case '''''', out = '';
        case '{}',   out = {};
        case '[]',   out = [];
        otherwise,   out = in;
    end
else
    out = in;
end


% =================================================================
function str = cell2str(c)

% Convert a cell array of strings and numbers into a string
% separated by commas or semicolons.
%
% Usage:
%       str = cell2str(c)
%
% Example:
%       c = {'this', 5, 'that', 'the', 'other'}
%       str = cell2str(c)
%
% See also:
%       cell2evalstr


if ischar(c)
    % Input is already a string, so no conversion necessary
    str = c;
else
    L = length(c);
    if min(size(c)) ~= 1
        error('This function currently only works for vector (Nx1 or 1xN) cell arrays')
    end
    if size(c,1) > size(c,2)
        separator = ';';
    else
        separator = ',';
    end
    str = '';
    for i = 1:L
        if ischar(c{i})
            str = [str, '''', c{i}, '''', separator, ' '];
        elseif isnumeric(c{i})
            str = [str, num2str(c{i}), ', '];
        end
    end
    str = str(1:end-2); % get rid of trailing comma/semi-colon and space
end


% =================================================================
function str = cell2evalstr(c)

% Convert a cell array of strings into a Matlab string that can be
% processed by 'eval'.
%
% Usage:
%       str = cell2evalstr(c)
%
% Example:
%       c = {'this', 5, 'that', 'the', 'other'}
%       str = cell2evalstr(c)
%
% See also:
%       cell2str


str = ['{', cell2str(c), '}'];
