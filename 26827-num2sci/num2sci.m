function str = num2sci(A,precision,units)
%% FUNCTION num2sci
% Converts a number to a string in scientific format (e.g. .00325 ==> 3.25m).
% Can optionally provide precision (number of significant digits) and/or unit
% string to append.  The default precision is 4 significant digits.
%
%
% Examples:
%
% str = num2sci(165.48e-3) returns str = '165.5 m'
% str = num2sci(165.48e-3,'V') returns str = '165.5 mV'
% str = num2sci(165.48e-3,'mV') returns str = '165.5 uV'
% str = num2sci(165.48e-3,3,'V') returns str = '165 mV'
% str = num2sci([1.5 2.5],{'V','mA'}) returns str = {'1.5 V' '2.5 mA'}
%
% See also: num2str
%
%
% Written By: Jason Kaeding
%       Date: 07/10/09

%% REVISION INFORMATION:
% 11/23/09 - JAK - Added code to check units for cases when a prefix exists
%                  inside the unit string.  Examples are "kg" or "mV".  In these
%                  cases, the prefix is removed, A is recomputed based on this
%                  prefix, and then a new prefix is determined and used.
% 03/03/10 - JAK - Fixed bug in 11/23 revision which did not convert "kg"
%                  properly.

%% Check inputs
error(nargchk(1,3,nargin,'struct'));

if iscell(A)
    error('num2sci:cellInput','Input cannot be a cell array.');
end

if ischar(A)
    str = A;
    return;
end

if isempty(A)
    str = '';
    return;
end

switch nargin
    case 1
        precision = 4;
        units = '';
    case 2
        if ischar(precision) || iscellstr(precision)
            units = precision;
            precision = 4;
        else
            units = '';
        end
    case 3
        if ~ischar(units) && ~iscellstr(units)
            error('Units must be a string');
        end
end

if iscellstr(units)
    if ~all(size(units) == size(A))
        error('num2cell:badUnitsDim',...
            'Units must be the same size as input matrix.');
    end
end

%% Set up SI prefixes
prefix_vector = {'y','z','a','f','p','n','u','m','',...
    'k','M','G','T','P','E','Z','Y'};
prefix_offset = 9;

%% De-exponentiate
exponents = floor(log10(abs(A))./3);
exponents(~isfinite(A)) = 0; % +/- Inf and NaN assign to zero (no prefix)
exponents(A==0) = 0; % log10(0) = -Inf, correct this to 0 = 0*10^0
exponents = max(exponents,-8); % cap finite at 10^-24
exponents = min(exponents,8); % cap finite at 10^24

% Check for prefix in units
% Cases to check:
% 1. [prefix][A-Z][\w]* for typical units
% 2. [prefix][mgs] for SI units such as m,kg,s
% 3. [prefix][b][iyp/]?[\w/]* for bit/byte types of units (include / for bits/s)
unit_exp = 0;
if ~isempty(units)
    unit_check_results = regexp(units,...
        ['^([',[prefix_vector{:}],'])([A-Z]\w*|[mgs]|b[iyp/]?[\w/]*)$'],...
        'tokens','once');
    if ischar(units)
        unit_exp = 0;
        if ~isempty(unit_check_results)
            unit_exp = find(strcmp(unit_check_results{1},prefix_vector),1) - 9; % offset is 9       
            units = unit_check_results{2}; % un-prefixed units
        end
    else
        % Check one by one
        unit_exp = zeros(size(exponents));
        for ind = 1:numel(unit_check_results)
            if ~isempty(unit_check_results{ind})
                unit_exp(ind) = find(strcmp(unit_check_results{ind}{1},...
                    prefix_vector),1) - 9; % offset is 9
                units{ind} = unit_check_results{ind}{2}; % un-prefixed units
            end
        end
    end
end

% Compute new base numbers
A = A./(10.^(3.*exponents)); 
exponents = exponents + unit_exp;

%% Find prefix for each element
prefix = cellfun(@(x)prefix_vector{x},num2cell(exponents+prefix_offset),...
    'UniformOutput',false);

%% Execute num2str
str = cellfun(@(x)[num2str(x,precision),' '],num2cell(A),'UniformOutput',false);

%% Build final string
% 1. Combine number with prefix & units
% 2. Check for num2str anomalies resulting from %g use (e.g. 32.4e+005), fix
% 3. Remove space if last character
str = regexprep(strcat(str,prefix,units),{'(\d+)\.?(\d+)?e[+](\d+)','\s+$'},...
    {'$1$2${repmat(''0'',1,str2double($3)-length($2))}',''});

%% De-cellify if single element
if numel(str) == 1
    str = str{1};
end