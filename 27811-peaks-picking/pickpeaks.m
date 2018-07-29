function [Vo,Io] = pickpeaks(X,npts,dim,mode)

% PICKPEAKS finds local peaks or troughs in a vector or 2-D array
% 
% CALL
%   [Vo,Io] = pickpeaks(X,npts,dim,mode);
%   [Vo,Io] = pickpeaks(X,npts,dim);
%   [Vo,Io] = pickpeaks(X,npts);
%   [Vo,Io] = pickpeaks(X);
% 
% INPUT
%    X:    input vector or 2D array.
%    npts: minimum number of points separating two peaks. Default is 1 (all
%          peaks).
%    dim:  dimension of X across which, the peaks are sought. Default is 1.
%    mode: can be 'peaks' or 'troughs'. Default is 'peaks'.
%
%
% OUTPUT
%   Vo:    value of peaks in descending ('peaks') or ascending ('troughs')
%          order (sorting is per column or if dim==2, per row).
%   Io:    corresponding index of peaks in X, i.e. Vo = X(Io). If X is a
%          matrix, then Io is the linear index.
%  
% C. Saragiotis, June 2010

%% Initialization
if ~exist('npts','var') || isempty(npts), npts = 1;       end
if ~exist('dim', 'var') || isempty(dim),  dim  = 1;       end
if ~exist('mode','var') || isempty(mode), mode = 'peaks'; end

[X,npts,mode,r,c] = checkInput(X,npts,dim,mode);

%% Main
switch mode(1)
    case {'p','peaks'}
        [V, I]  = allPeaks(X);
        [Vo,Io] = main(I,V,r,c,npts,dim);
    case {'t','troughs'}
        [V, I]  = allPeaks(-X);
        [Vo,Io] = main(I,V,r,c,npts,dim);
        Vo = -Vo;
    otherwise
        error('%s: Unknown localpeak mode. Please specify ''peaks'', ''troughs''.',upper(mfilename));
end



end

%% #### Local functions ####

%% checkInput  
function [X,npts,mode,r,c] = checkInput(X,npts,dim,mode)
    if numel(size(X))>2
        error('%s: X must be at most 2D.',upper(mfilename))
    elseif ~isreal(X),
        error('%s: X is not real.',upper(mfilename));
    end

    if dim == 2, X = X.'; end

    [r,c] = size(X);
    if r < 3,
        error('%s: X must have at least 3 elements across the specified dimension.',upper(mfilename));
    end
    
    if npts < 0 || round(npts)~=npts,
        fprintf('%s: npts must be an integer >= 1. Setting npts=1.\n',upper(mfilename));
        npts = 1;
    end
    
    
    mode = lower(mode);


end

%% main        
function [Vo,Io] = main(I,V,r,c,npts,dim)
    Vo = [];
    Io = [];
    for j = 1:c
        [Is,Vs] = columnPeaks(I,V,j,r);                   % Is and Vs are sorted (ascending order)
        if ~isempty(Is)
            [Is,Vs] = discardPeaks(Is,Vs,npts, dim,r,c); % Is, Vs are sorted in descending order.
            Vo = [Vo; Vs]; %#ok<AGROW>
            Io = [Io; Is]; %#ok<AGROW>
        end
    end 

end



%% allPeaks   
function [V,I] = allPeaks(X)
    val = false(size(X));
    val(2:end-1,:) = sign(diff(X(1:end-1,:),1,1)) - sign(diff(X(2:end,:),1,1)) > 1;
    I = find(val>0);
    V = X(I);
end

%% columnPeaks   
function [Ij,Vj] = columnPeaks(I,V,j,r)
% Gets the indices and values of the peaks for column j
    i1 = find(I>(j-1)*r,1);
    i2 = find(I>j*r,1)-1;
    if ~isempty(i1)
        if isempty(i2), i2 = length(I); end
        if ~isempty(i1) && ~isempty(i2)
            J = i1:i2;
            Vj = V(J);
            [Vj,jj] = sort(Vj,'ascend');
            Ij      = I(J(jj));
        end
    else
        Ij = [];
        Vj = [];
    end
end

%% discardPeaks 
function [Is,Vs] = discardPeaks(Is,Vs,npts, dim,r,c)
% Discards peaks, whose distance is not at least npts samples from an
% already selected peak (descending order). 

    if length(Is)>1 && npts>1
        js = length(Is);
        while js > 1
            for jj = js-1:-1:1
                    if abs(Is(jj)-Is(js)) <= npts
                        Vs(jj) = [];
                        Is(jj) = [];
                        js = js-1;
                    end
            end
            js = js-1;
        end

        if dim==2,
            i  = rem(Is,r);
            j  = fix(Is/r)+1; 
            Is = (i-1)*c+j;
        end

        [Vs,j] = sort(Vs,'descend');
        Is     = Is(j);
    end
    

end

