function A = sortfields(varargin)
%SORTFIELDS sort values in all fields within a structure.
%   SORTFIELDS(A) sorts the rows of each field of structure A in asending
%   order and returns a structure of the same dimension and field names.
%   SORTFIELDS(A,'SORTBYFIELD','FIELDNAME',...) sorts each field by the
%   specified field. All fields must be the same size.
%   SORTFIELDS(A,'PARAMETER1','VALUE1','PARAMETER2','VALUE2',....) uses the
%   properties:
%   DIM selects a dimension along which to sort.
%   MODE selects the direction of the sort
%      'ascend' results in ascending order
%      'descend' results in descending order
%
%   EXAMPLES:
%   >> A.field1 = [9,1,8,2,7,3,6,4,5]; A.field2 = fliplr(A.field1)
%   A = 
%     field1: [9 1 8 2 7 3 6 4 5]
%     field2: [5 4 6 3 7 2 8 1 9]
%   >> B = sortfields(A)
%   B = 
%   field1: [1 2 3 4 5 6 7 8 9]
%   field2: [1 2 3 4 5 6 7 8 9]
%   >> B = sortfields(A,'sortbyfield','field1')
%   B = 
%     field1: [1 2 3 4 5 6 7 8 9]
%     field2: [4 3 2 1 9 8 7 6 5]
%   >> B = sortfields(A,'sortbyfield','field1','mode','descend','dim',2)
%   B = 
%     field1: [9 8 7 6 5 4 3 2 1]
%     field2: [5 6 7 8 9 1 2 3 4]

%   Copyright 2008 Ian M. Howat, ihowat@gmail.com
%   $Version: 1.0 $  $Date: 24-Aug-2008 17:44:28 $

%%
% Get Input Structure
A = varargin{1};

%defaults
mode = 'ASCEND';
sfield = [];
dim = [];

%error checking and parse inputs
if ~isstruct(A)
    error('Input must be a structure.')
end

if nargin > 1

    if rem(nargin,2)
        for i=2:2:nargin
            switch upper(varargin{i})
                case 'MODE'
                    mode = upper(varargin{i+1});
                    if ~strcmp('ASCEND',mode) && ~strcmp('DESCEND',mode)
                        disp(['Value: ',mode,...
                            ' is unknown for parameter ORDER (choices are ascend and descend)']);
                    end
                case 'DIM'
                    dim = varargin{i+1};
                    if dim ~= 1 && dim ~= 2
                        disp(['Value: ',num2str(dim),...
                            ' is unknown for parameter DIM (choices are 1 or 2)']);
                    end
                case 'SORTBYFIELD'
                    sfield = varargin{i+1};
                otherwise
                    error(['Unknown parameter ',upper(varargin{i})]);
            end
        end
    else
        error('unequal number of parameter/value arguments')
    end

end

%field names
fields = fieldnames(A);

if isempty(sfield) && isempty(dim)
    for i=1:length(fields)
        eval(['A.',char(fields(i)),' = sort(A.',char(fields(i)),...
            ',''', mode,''');']);
    end
elseif isempty(sfield) && ~isempty(dim)
    for i=1:length(fields)
        eval(['A.',char(fields(i)),' = sort(A.',char(fields(i)),...
            ',', num2str(dim),',''', mode,''');']);
    end
else
    if isempty(dim)
        eval(['[A.',sfield,',I] = sort(A.',sfield,...
            ',''', mode,''');']);
    else
        eval(['[A.',sfield,',I] = sort(A.',sfield,...
            ',', num2str(dim),',''', mode,''');']);
    end

    fields(strmatch(sfield,fields)) = [];

    for i=1:length(fields)
        eval(['A.',char(fields(i)),' = A.',char(fields(i)),'(I);']);
    end
end