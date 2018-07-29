%%% set Default values for structs ONLY WHEN values are not set
%%% (C) Yohai Devir, yohai_devir AT YAH00 D0T C0M
function myStruct = setDefaultValues(myStruct,varargin)
if mod(length(varargin),2) ~= 0
    error('number of fields + values is odd ');
end
if ~isstruct(myStruct)
    error('arg 1 is not a struct');
end %if
if nargin == 1
    return
end %if

if (length(myStruct) == 0)
    myStruct(1).XXXdeldelmeXXX = '1';
end

for ii = 1:(length(varargin)/2)
    if ~ischar(varargin{2*ii-1})
        error('In assertDefaultValues: input %d is not a string',2*ii);
    end %if

    if ~isfield(myStruct,varargin{2*ii-1})
        myStruct = setfield(myStruct,varargin{2*ii-1},varargin{2*ii});
    end
end

if isfield(myStruct,'XXXdeldelmeXXX')
    myStruct = rmfield(myStruct,'XXXdeldelmeXXX');
end %if
