%
% newstruct(<struct>,<struct>,...<name>,<field>,...)
%
% NSTRUCT concatenates the first n struct inputs along with a struct made
% by any tailing nonstruct inputs.  The results is sorted by field name
%
% See also STRUCT
function field = nstruct(varargin)
k = find(~cellfun('isclass',varargin,'struct'),1);
if nargin == 0 | k == 1, field = struct(varargin{:});
elseif nargin == 1, field = varargin{1};
else
    if ~isempty(k)
        varargin{k} = struct(varargin{k+1:end});
        varargin(k+1:end) = [];
    end
    for k = 1:length(varargin)
        name{k} = fieldnames(varargin{k});
        field{k} = struct2cell(varargin{k});
    end
    [name k] = unique([name{:}]);
    field = [field{k}];
    field = [name;field];
    field = struct(field{:});
end