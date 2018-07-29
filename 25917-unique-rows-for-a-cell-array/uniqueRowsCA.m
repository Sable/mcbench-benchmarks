function [uCA,ndx,pos] = uniqueRowsCA(iCA,TREAT_NAN_EQUAL,FIRST_LAST)
%uniqueRowsCA  unique Rows for a Cell Array
%   U_CA = uniqueRowsCA(I_CA) returns Unique rows of the Input Cell Array, I_CA
%
%   [U_CA,I,J] = uniqueRowsCA(...) also returns index vectors I and J such
%   that U_CA = iCA(I,:) and iCA = B(J,:).
%
%   uniqueRowsCA(I_CA,TREAT_NAN_EQUAL), treats NaN comparisions as equal if
%   TREAT_NAN_EQUAL is true, the default is to treat NaN as equal
%
%   uniqueRowsCA(I_CA,[],'first'), returns the first instance
%   of the match of the index where I_CA matches U_CA, the default
%   is 'last'
%   
%   NOTE: This function only handles strings and scalars, and N-D matrices
%   that are the same size for every row within the same column
%      
%   See also: isequal, isequalwithequalnans

    %INPUT HANDLING
    %===========================================================
    if nargin == 1, TREAT_NAN_EQUAL = true; FIRST_LAST = 'last'; 
    elseif nargin == 2,
        if isempty(TREAT_NAN_EQUAL)
            TREAT_NAN_EQUAL = true;
        end
    elseif nargin ~= 3
        error('Incorrect number of input arguments to %s',mfilename)
    end

    %SOME BASIC INITIALIZATION
    %=====================================================
    [M,N] = size(iCA);
    COL_ORDER = 1:N; %Could make this an input argument, 
    %affects order of unique output => see sortrows

    %HANDLING THE SIMPLE CASE
    %======================================================
    if M == 1, uCA = iCA; ndx = 1; pos = 1; return, end
  
    
    %ERROR CHECKING - CHECK CONSISTENCY FOR EACH COLUMN
    %===========================================================
    for iCol = 1:N
        %NOT YET DONE
    end

    
    %THE SORT_CELL_BACK_TO_FRONT FUNCTION & SORTROWS
    %=================================================================
    %Note, cell2mat is very slow, rewrote sortrows
    
    ndx = (1:M)';
    for k = N:-1:1
        colUse = abs(COL_ORDER(k));
        %NOTE: right here we make an assumption about the types being consistent in a given column
        if isnumeric(iCA{1, colUse})
            sz = cellfun('prodofsize',iCA(:,colUse)); %sz = cellfun(@numel,iCA(:,k));
            if isempty(find(sz > 1,1))
                tmp = fastC2M(iCA(ndx,colUse));
                ind = sortrowsc(tmp, sign(COL_ORDER(k))*1); 
            else %We are dealing with matrices
                
                %SOME ERROR CHECKING ON THE MATRICES
                %=========================================
                szS = cellfun(@size,iCA(:,colUse),'UniformOutput',false);
  
                %1) DIMENSION SAME CHECK
                %----------------------------------------------
                nDims = cellfun('ndims',szS);
                if length(unique(nDims)) ~= 1
                    error('%s not setup to handle varying size matrices yet',mfilename)
                end
                
                %2) EACH DIMENSION THE SAME CHECK
                %----------------------------------------------
                szMat = fastC2M(szS); %NOTE: we had to first check that each input is 
                %the same size, i.e. that the dimensions were the same otherwise fastC2M barfs
                %We are checking dimensions here instead of number of elements as perhaps someone
                %cares if the dimensions are different, even though the linearized contents might
                %not be ex. a = [1 3;2 4] vs b = [1 2 3 4], size(a) = [2 2], size(b) = [1 4], but
                %all(a(:) == b(:)) is true, note that the matrix code linearizes the inputs for
                %sorting purposes
                curCol = 1;
                notMatchSz = [];
                while curCol <= nDims(1) && isempty(notMatchSz)
                    notMatchSz = find(diff(szMat(:,curCol)) ~= 0,1);
                    curCol = curCol + 1;
                end
                
                if ~isempty(notMatchSz)
                    error('%s not setup to handle varying size matrices yet',mfilename)
                end
                %=============================================
                
                tmp = fastC2M(iCA(ndx,colUse));
                ind = sortrowsc(tmp, sign(COL_ORDER(k))*(1:size(tmp,2))); 
            end
            
        else
            tmp = char(iCA(ndx,k)); %Nice and quick
            ind = sortrowsc(tmp, sign(COL_ORDER(k))*(1:size(tmp,2)));
        end
        ndx = ndx(ind);
    end
    
    %NOW RESORTING AND OBTAINING UNIQUE
    %=========================================
    %NOTE: ndx is the 2nd output of sortrows
    iCA = iCA(ndx,:);
    
    sameVector = false(M,N);
    
    if TREAT_NAN_EQUAL
        for iCol = 1:N
            sameVector(2:end,iCol) = arrayfun(@isequalwithequalnans,iCA(2:end,iCol),iCA(1:end-1,iCol));
        end 
    else
        for iCol = 1:N
            sameVector(2:end,iCol) = arrayfun(@isequal,iCA(2:end,iCol),iCA(1:end-1,iCol));
        end
    end
    
    d = ~all(sameVector,2);
    uCA = iCA(d,:);
    
    %ADDITIONAL OUTPUT HANDLING
    %===========================================
    if nargout == 3
        pos = cumsum(d);
        pos(ndx) = pos;             % Re-reference POS to indexing of SORT.
    end
    
    % Create indices if needed.
    if nargout > 1
        if FIRST_LAST(1) == 'l'
            ndx = ndx([d(2:end); true]);  % Final element is always a member of unique list.
        else
            ndx = ndx(d); % First element is always a member of unique list.
        end
    else
        ndx = [];
        pos = [];
    end   
end

function m = fastC2M(CA)
%ASSUMPTIONS -> all elements of CA have the same size
%TO REPLACE SLOW CELL2MAT FOR MATRICES

    szCA = size(CA);
    sz = numel(CA{1});
   
    m = zeros(szCA(1),sz(1));
    for iRow = 1:szCA(1)
        m(iRow,:) = CA{iRow}(:);
    end
end