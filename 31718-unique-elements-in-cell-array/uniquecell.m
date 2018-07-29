function [Au, idx ,idx2] = uniquecell(A)
    %function [Au, idx, idx2] = uniquecell(A)
    %For A a cell array of matrices (or vectors), returns 
    %Au, which contains the unique matrices in A, idx, which contains
    %the indices of the last appearance of each such unique matrix, and
    %idx2, which contains th indices such that Au(idx2) == A
    %
    %Example usage:
    %
    %A = {[1,2,3],[0],[2,3,4],[2,3,1],[1,2,3],[0]};
    %[Au,idx,idx2] = uniquecell(A);
    %
    %Results in:
    %idx = [6,5,4,3]
    %Au  = {[0],[1,2,3],[2,3,1],[2,3,4]}
    %idx2 = [2,1,4,3,2,1]
    %
    %Algorithm: uses cellfun to translate numeric matrices into strings
    %           then calls unique on cell array of strings and reconstructs
    %           the initial matrices
    %
    %See also: unique
    B = cellfun(@(x) num2str(x(:)'),A,'UniformOutput',false);
    if nargout > 2
        [~,idx,idx2] = unique(B);
        Au = A(idx);
    else
        [~,idx] = unique(B);
        Au = A(idx);
    end
end
    
