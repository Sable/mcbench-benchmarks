function [C,ugr] = group2cell(V,gr)
% GROUP2CELL - group values into cells
%   C = GROUP2CELL(V,G) returns a N-by-1 cell array in which the values V are
%   grouped as row vectors into separate cells according to the values in
%   G. Both G and V should have the same number of elements. N is the
%   number of different values in G. Each cell in C is a row vector.
%
%   [C,GR] = GROUP2CELL(V,G) also returns the groups in GR, so that 
%   C{i} = V(G==GR(i)).
%
%   The grouping variable can be a cell array of strings.
%
%   Examples:
%     [C, GG] = group2cell([1 2 3 4 5 6],[1 6 2 1 6 1]) ; 
%     % returns the cell array {[1 4 6] ; [3] ; [2 5]} in C
%     % and [1 2 6] in GG
%
%     years = [1956 1978 1982 1987 2001 2006] ;
%     temp  = {'normal','cold','hot','normal','cold','hot'} ;
%     C = group2cell(years,temp)
%
%   See also MAT2CELL, CELLFUN, CAT
%   and NONES, COUNTMEMBER (on the Matlab File Exchange)

% for Matlab R13
% version 1.2 (august 2006)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History:
% 1.0 may 2006 - creation
% 1.1 may 2006 - improved help section
% 1.2 august 2006 - grouping variable can be a cell array of strings

if numel(V) ~= numel(gr),
    error('Both inputs should have the same number of elements') ;
end

if isempty(gr),
    C = [] ;
    ugr = [] ;
else
    if iscell(gr), 
        % group should be a cell array of string
        if ~all(cellfun('isclass',gr,'char')),
            error('group2cell','Input must be a cell array of strings.') ;
        end
        [ugr,gri,gr] = unique(gr) ;
        gr = gri(gr) ;    
    end
    if any(isnan(gr(:))),
        % remove NaNs from grouping list
        warning('group2cell:ignorenans','Group specifier contains NaNs, these will be ignored') ;
        q = isnan(gr) ;
        gr(q) = [] ;
        V(q) = [] ;
    end
    
    [ugr,i] = sort(gr(:)) ;             % sort the group specifiers
    V = V(i) ;                          % sort the values accordingly
    n = histc(gr,ugr) ;                 % count the number for each group
    C = mat2cell(V(:).',1,n(n>0)).' ;   % use matcell to group the values
    
    if nargout > 1,
        ugr = ugr(n>0).' ;              % return the group identifiers when requested
    end
end