function runIntersect = mintersect(varargin)
%MINTERSECT Multiple set intersection.
%   MINTERSECT(A,B,C,...) when A,B,C... are vectors returns the values 
%   common to all A,B,C... The result will be sorted.  A,B,C... can be cell
%   arrays of strings.  
%
%   MINTERSECT repeatedly evaluates INTERSECT on successive pairs of sets, 
%   which may not be very efficient.  For a large number of sets, this should
%   probably be reimplemented using some kind of tree algorithm.
%
%   MINTERSECT(A,B,'rows') when A,B,C... are matrices with the same
%   number of columns returns the rows common to all A,B,C...
%
%   See also INTERSECT

flag = 0;
if isempty(varargin),
    error('No inputs specified.')
else
    if isequal(varargin{end},'rows'),
        flag = 'rows';
        setArray = varargin(1:end-1);
    else
        setArray = varargin;
    end
end

runIntersect = setArray{1};
for i = 2:length(setArray),
    
    if isequal(flag,'rows'),
        runIntersect = intersect(runIntersect,setArray{i},'rows');
    elseif flag == 0,
        runIntersect = intersect(runIntersect,setArray{i});
    else 
        error('Flag not set.')
    end
    
    if isempty(runIntersect),
        return
    end
    
end
