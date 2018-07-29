function [Y] = ignoreNaN(X,fun,dim)
%IGNORENAN returns the result of the function as specified by handle fun
% of the elements of X that are not NaN
%   X is a n-dimensional array
%   fun is the function handle
%       (@std returns std of X with NaN elements ignored)
%       You can only use functions that can vectors as an argument
%        (note X does not have to be a vector), for example do not use
%        fun=@(x) (std(x,0,2)
%        rather, specify 2 in dim
%   dim is the dimension to preform the function on
%   Y is a m-dimension array of results from the function (dim is
%       length of one) 

%{
08/15/2007
    rev 1  
        changed 
        Y=accumarray(sub, X(~isnan(X)),[],fun);
        to
        Y=accumarray(sub, X(ind),sz,fun,NaN);
        
        this correction will return NaN if all element operated on are NaNs

        also with the previous version if a vector of NaNs was on the 
        outside dimension the correct result was not returned
            
%}

if nargin==2 
    dim=1;
end

if dim>ndims(X)
    error('dim is too large')
end

if  isvector(X)&&dim==1
    if nargin==2
        %confirm vector is a column vector
        if size(X,2)>1
            X=X';
        end
    end
end

if isscalar(X)
    if  isnan(X)
        Y=[]; % if scalar nan then return nothing
    else
        Y=fun(X); % no need for futher computation
    end
else
    ind=find(~isnan(X)); %find indices where X is not NaN

    c=cell(1,ndims(X));%cell which will convert to matrix later

    [c{:}]=ind2sub(size(X),ind);%turn indicies into subs 
                    %(one cell column per dimension)

    if isvector(X) && size(X,2)>1
        c=cellfun(@(x) (x'),c,'UniformOutput',false);
    end
    
    sub=cell2mat(c); %convert cell to matrix

    sub(:,dim)=[]; %remove column corresponding to dim

    %get proper size for output array
    siz=size(X); 
    siz(dim)=1;
    
    if isvector(sub)
        sz=[siz(siz>1) 1];
        if length(sz)==1
            sz=[1 1]; %correction for case of size(X,2)=1, and nargin==2
        end
    else
        sz=siz(siz>1);
    end
    
    Y=accumarray(sub, X(ind),sz,fun,NaN);
    
    Y=reshape(Y,siz); %reshape output

end

