function out = sort_back( data, ind, dim )
% SORT_BACK sort back data to original order
% ind is the indexes obtained from sorting
% dim is the sorted dimension of the data (assumed to be 1 if not specified)
% Ex:
% y = randn(3,4,2);
% [y,ind] = sort(y,2);
% do stuff with sorted y...
% y2 = sort_back( y, ind, 2 );
% 
% Works on arrays of any dimension
% Also works on cellstrings (vectors)
% 
% C = {'hello' 'yes' 'no' 'goodbye'};
% [C,ind] = sort(C);
% C2 = sort_back(C,ind);
%
% See also SORT

%Author Ivar Eskerud Smith

if size(ind)~=size(data)
    error('Different size of indexes and input data');
end

if iscell(data)
    if ~any(size(data)==1)
        error('Only vectors are supported in cell sorting/back-sorting');
    end
    out=cell(size(data));
    out(ind) = data;
    return;
end

if ~isnumeric(data) || ~isnumeric(ind)
    error('Inputs have to be numeric or cell');
end

n=ndims(ind);
if ~exist('dim','var')
    dim=1;
end
if dim>n
    error('Specified sorted dimension must be within array bounds');
end

%shift array so that the sorted dim is the first dimension
if dim~=1
    sortInd=1:1:n;sortInd(1)=dim;sortInd(dim)=1;
    data = permute(data,sortInd);
    ind = permute(ind,sortInd);
end
inds = repmat({1},1,n);inds{1}=':';
if ~issorted( data(inds{:}) )
    warning('The input data is not sorted along the specified dimension');
end

s = size(ind);
nData = numel(data);
inds = repmat({1},1,n);
inds(1:2)={':',':'};
shiftSize = s(1)*s(2);
out=nan(size(data));

%loop all 2d arrays within nd-array
for k=1:prod(s(3:end))
    tmpdata = data(inds{:});
    tmpind  = ind(inds{:});

    %data is shifted so that the sorted dim = 1
    for i=1:numel(tmpdata(1,:))
        out(tmpind(:,i),i) = tmpdata(:,i);
    end

    if n>2
        %shift to next 2d array within nd-array
        shiftInds = mod((1:nData)-shiftSize-1,nData)+1;
        out=reshape(out(shiftInds),s);
        data=reshape(data(shiftInds),s);
        ind=reshape(ind(shiftInds),s);
    end
end

%permute back to original order
sortInd=1:1:ndims(out);sortInd(1)=dim;sortInd(dim)=1;
out = permute(out,sortInd);

