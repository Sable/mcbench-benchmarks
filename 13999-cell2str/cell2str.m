function string = cell2str(cellstr)
%CELL2STR Convert a 2-D cell array of strings to a string in MATLAB syntax.
%   STR = CELL2STR(CELLSTR) converts the 2-D cell-string CELLSTR to a 
%   MATLAB string so that EVAL(STR) produces the original cell-string.
%   Works as corresponding MAT2STR but for cell array of strings instead of 
%   scalar matrices.
%
%   Example
%       cellstr = {'U-234','Th-230'};
%       cell2str(cellstr) produces the string '{''U-234'',''Th-230'';}'.
%
%   See also MAT2STR, STRREP, CELLFUN, EVAL.

%   Developed by Per-Anders Ekström, 2003-2007 Facilia AB.

if nargin~=1
    error('CELL2STR:Nargin','Takes 1 input argument.');
end
if ischar(cellstr)
   string = ['''' strrep(cellstr,'''','''''') ''''];
   return
end
if ~iscellstr(cellstr)
    error('CELL2STR:Class','Input argument must be cell array of strings.');
end
if ndims(cellstr)>2
    error('CELL2STR:TwoDInput','Input cell array must be 2-D.');
end

ncols = size(cellstr,2);
for i=1:ncols-1
    cellstr(:,i) = cellfun(@(x)['''' strrep(x,'''','''''') ''','],...
        cellstr(:,i),'UniformOutput',false);
end
if ncols>0
    cellstr(:,ncols) = cellfun(@(x)['''' strrep(x,'''','''''') ''';'],...
        cellstr(:,ncols),'UniformOutput',false);
end
cellstr = cellstr';
string = ['{' cellstr{:} '}'];