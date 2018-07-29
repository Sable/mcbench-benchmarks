function [P orderstruct] = mmtimes(varargin)
% P = mmtimes(M1, M2, ... Mn)
%   return a chain matrix product P = M1*M2* ... *Mn
%
% {Mi} are matrices with compatible dimension: size(Mi,2) = size(Mi+1,1)
% 
% Because the matrix multiplication is associative; the chain product can
% be carried out with different order, leading to the same result (up to
% round-off error). MMTIMES uses "optimal" order of binary product to
% reduce the computational effort (probably the accuracy is also improved).
%
% The function assumes the cost of the product of (m x n) with (n x p)
% matrices is (m*n*p). This assumption is typically true for full matrix.
%
% Notes:
%   Scalar matrix are groupped together, and the rest will be
%   multiplied with optimal order.
%
%   To get the the structure that stores the best order, call with the
%   second outputs:
%   >> [P orderstruct] = mmtimes(M1, M2, ... Mn);
%   % This structure can be used later if the input matrices have the
%   % same sizes as those in the first call (but with different contents)
%   >> P = mmtimes(M1, M2, ... Mn, orderstruct);
%
% See also: mtimes
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% Orginal: 19-Jun-2010
%          20-Jun-2010: quicker top-down algorithm
%          23-Jun-2010: treat the case of scalars
%          16-Aug-2010: passing optimal order as output/input argument

Matrices = varargin;

buildexpr = false;
if ~isempty(Matrices) && isstruct(Matrices{end})
    orderstruct = Matrices{end};
    Matrices(end) = [];
else
    % Detect scalars
    iscst = cellfun('length',Matrices) == 1;
    if any(iscst)
        % scalars are multiplied apart
        cst = prod([Matrices{iscst}]);
        Matrices = Matrices(~iscst);
    else
        cst = 1;
    end
    % Size of matrices
    szmats = [cellfun('size',Matrices,1) size(Matrices{end},2)];
    s = MatrixChainOrder(szmats);

    orderstruct = struct('cst', cst, ...
                         's', s, ...
                         'szmats', szmats);
                     
    if nargout>=2
        % Prepare to build the string expression
        vnames = arrayfun(@inputname, 1:nargin, 'UniformOutput', false);
        % Default names, e.g., M1, M2, ..., for inputs that is not single variable 
        noname = cellfun('isempty', vnames);
        vnames(noname) = arrayfun(@(i) sprintf('M%d', i), find(noname), 'UniformOutput', false);
        if any(iscst)
            % String '(M1*M2*...)' for constants
            cstexpr = strcat(vnames(iscst),'*');
            cstexpr = strcat(cstexpr{:});
            cstexpr = ['(' cstexpr(1:end-1) ')'];
        else
            cstexpr = '';
        end
        vnames = vnames(~iscst);
        buildexpr = true;
    end
end

if ~isempty(Matrices)
    P = ProdEngine(1,length(Matrices),orderstruct.s,Matrices);    
    if orderstruct.cst~=1
        P = orderstruct.cst*P;
    end
    if buildexpr
        expr = Prodexpr(1,length(Matrices),orderstruct.s,vnames);
        if ~isempty(cstexpr)
            % Concatenate the constant expression in front
            expr = [cstexpr '*' expr];
        end
        orderstruct.expr = expr;
    end
else
    P = orderstruct.cst;
    if nargout>=2
        orderstruct.expr = cstexpr;       
    end
end

end % mmtimes


%%
function [s qmin] = MatrixChainOrder(szmats)
% Find the best ordered chain-product, the best splitting index
% of M(i)*...*M(j) is stored in s(j,i) of the array s (only the lower
% part is filled)
% Top-down dynamic programming, complexity O(n^3)

n = length(szmats)-1;
s = zeros(n);

pk = szmats(2:n);
ij = (0:n-1)*(n+1)+1;
left = zeros(1,n-1);
right = zeros(1,n-1);
L = 1;
while true % off-diagonal offset
    q = zeros(size(pk));
    for j=1:n-L % this is faster and BSXFUN or product with DIAGONAL matrix
        q(:,j) = (szmats(j)*szmats(j+L+1))*pk(:,j);
    end
    q = q + left + right;
    [qmin loc] = min(q, [], 1);
    s(ij(1:end-L)+L) = (1:n-L)+loc;
    
    if L<n-1
        pk = [pk(:,1:end-1);
              pk(end,2:end)];
        left = [left(:,1:end-1);
                qmin(1:end-1)];
        right = [qmin(2:end);
                 right(:,2:end)];
        L = L+1;
    else
        break
    end % if
end % while-loop

end % MatrixChainOrder

%%
function P = ProdEngine(i,j,s,Matrices)
% Perform matrix product from the optimal order, recursive engine
if i==j
    P = Matrices{i};
else
    k = s(j,i);
    P = ProdEngine(i,k-1,s,Matrices)*ProdEngine(k,j,s,Matrices);
end

end

%%
function expr = Prodexpr(i,j,s,vnames)
% Return the string expression of the optimal order 
if i==j
    expr = vnames{i};
else
    k = s(j,i);
    expr = ['(' Prodexpr(i,k-1,s,vnames) '*' Prodexpr(k,j,s,vnames) ')'];
end

end % Prodexpr


