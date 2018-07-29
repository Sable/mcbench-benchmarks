function [S] = cell2nestedstruct(C)
%
%  S = CELL2NESTEDSTRUCT(C) converts an MxN cell array C into a
%     nested 1x1 structure array S
%  
%     Examples:
% 
%       C = {'a','b',1;  'qqq','',cell(6,2);   'aa','',[1 3]};
%       [S] = cell2nestedstruct(C)
% 
%       S = 
%           a: [1x1 struct]
%           qqq: {6x2 cell}
%           aa: [1 3]
%
%
%       C = {'water'    'a'     ''     ''     ''    111;...
%            'water'    'b'     ''     ''     ''    222;...
%            'melon'     ''     ''     ''     ''    [];...
%            'a'        'b'    'c'    'd'    'e'    'aaa';...
%            'q'        'r'     ''     ''     ''    cell(6,2)};
%       [S] = cell2nestedstruct(C);
%       [C2] = nestedstruct2cell(S);
%       isequal(C,C2)
% 
%       ans =
% 
%           1
% 
%
%     Notes:
%       1. The fields in the first N-1 rows of C must be be left-justified.
%       2. The data must be in the right-most column.
%       3. The structure is produced row-by-row using the general syntax:
%                   S.row1.row2. ... rowN-1 = rowN;
%           which means that a sigle row, for example:
%                   {'water'    'a'     ''     ''     ''    111}
%           is equivalent to entering:
%                   S.water.a = 111;
%
%
%
%     See also CELL2STRUCT, STRUCT2CELL
%     
%     See also NESTEDSTRUCT2CELL (available at Matlab
%     Central File Exchange)
%
%Author:
%
% Todd C Pataky (0todd0@gmail.com)  26-May-2006

%Programming notes:
%1. Currently working on implementating of MxN structural array, but
%   blank fields, for example, make the N-D case difficult to deal with.
%   Suggestions appreciated.



%%%%%%%%%%%%%%%%%%%%
%DATA ORGANIZATION CHECKS
%%%%%%%%%%%%%%%%%%%%
if ~iscell(C) | ndims(C)~=2 | size(C,2)<2
    error('Must input an MxN cell array (N>1).')
end
if ~iscellstr(C(:,1:end-1))
    error('First %.0f columns of cell array must contain strings.',size(C,2)-1)
end
%%%%%%%%%%%%%%%%%%%%
%check that empty cells are to the right
%%%%%%%%%%%%%%%%%%%%
c = C(:,1:end-1);
L = ones(size(c));
ind = strmatch({' '},c);
L(ind) = 0;   %logical array indicating non-blank entries
for k=1:size(L,1)
    f = find(L(k,:));
    if ~isequal(f,1:length(f))
        error('All non-blank cells in row %.0f must be left-justified',k)
    end
end
%%%%%%%%%%%%%%%%%%%%
%check that there are no duplicate rows
%%%%%%%%%%%%%%%%%%%%
for k = 1:size(C,1)-1
    c = C(k,1:end-1);
    for kk = (k+1):size(C,1);
        cc = C(kk,1:end-1);
        if isequal(c,cc)
            error('Rows %.0f and %.0f are identical branches',k,kk);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%
%check that branches go to the same depth (i.e. check for branch overwriting)
%%%%%%%%%%%%%%%%%%%%
hereCheckOverWrite(C(:,1:end-1));    %see subfunction below

    
    
%%%%%%%%%%%%%%%%%%%%
%ASSEMBLE STRUCTURE ROW-BY-ROW
%%%%%%%%%%%%%%%%%%%%
for k=1:size(C,1)
    a = C(k,:);
    ind = strmatch('',a(1:end-1),'exact');
    a(ind) = [];
    
    s = a(1:end-1);
    data = a{end};
    
    s = [s; repmat({'.'},size(s))];
    s = s(:)';
    s = cat(2,s{1:end-1});
    
    eval(['S.',s,'= data;']);
end





%%%%%%%%%%%%%%%%%%%%
%SUBFUNCTIONS
%%%%%%%%%%%%%%%%%%%%
function hereCheckOverWrite(C)
%%%%%%%%%%%%%%%%%%%%
if size(C,2)==1
    return
end
%%%%%%%%%%%%%%%%%%%%
%if a zero stem has the same root as any other branch, error
%%%%%%%%%%%%%%%%%%%%
row = strmatch({' '},C(:,end));
for k=1:length(row)
    root0 = C(row(k),1:end-1);
    for kk=1:size(C,1)
        if kk~=row(k)
            root1 = C(kk,1:end-1);
            if isequal(root0,root1)
                error('Overwriting error. A stem from row %.0f is empty, but rows %.0f and %.0f have the same roots.',...
                    row(k) , min(row(k),kk) , max(row(k),kk) );
            end
        end
    end
end
hereCheckOverWrite(C(:,1:end-1));   %recurse



