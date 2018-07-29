function ndx = array2ind( siz, in_array, ~ )
%ARRAY2IND Linear index from multiple subscripts.
%   ARRAY2IND is used to determine the equivalent single index
%   corresponding to a given set of subscript values.
%
%   IND = ARRAY2IND(SIZ,[I,J]) returns the linear index equivalent to the
%   row and column subscripts in the arrays I and J for a matrix of
%   size SIZ. 
%
%   IND = ARRAY2IND(SIZ,[I1,I2,...,IN]) returns the linear index
%   equivalent to the N subscripts in the arrays I1,I2,...,IN for an
%   array of size SIZ.
%
%   I1,I2,...,IN must have the same size, and IND will have the same size
%   as I1,I2,...,IN. For an array A, if IND = ARRAY2IND(SIZE(A),I1,...,IN)),
%   then A(IND(k))=A(I1(k),...,IN(k)) for all k.
siz = double(siz);
if length(siz)<2
    error('Invalid Input Size');
end

if length(siz)~=length(in_array)
    error('Invalid Input Size');
end

%Compute linear indices
k = [1 cumprod(siz(1:end-1))];
ndx = 1;
s = size(in_array(1)); %For size comparison

for i = 1:length(siz),
    v = in_array(i);
    %%Input checking
    if ~isequal(s,size(v))
        %Verify sizes of subscripts
        error('SubscriptVectorSize');
    end
    if (any(v(:) < 1)) || (any(v(:) > siz(i)))
        %Verify subscripts are within range
        error('IndexOutOfRange');
    end
    ndx = ndx + (v-1)*k(i);
end

end

