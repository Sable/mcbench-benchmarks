function outVec = vecInsert(elemToInsert,position,vecIn)

%Inserts a vector of elements into the given positions.  elemToInsert is a
%vector that can be as small as 1 element and as large as desired.
%Position is an array of positions that can be as small as one element and
%as large as the number of elements you wish to insert.
%
%If position is smaller than the number of elements, this function will
%assume that the remaining elements will be inserted sequentially.
%
%If position is larger than the number of elements, this function will insert the
%last element of elemToInsert at the remaining given positions.

N = max(length(elemToInsert),length(position));
tmpVec = zeros(length(vecIn) + N,1);
tmpVec(:,1) = NaN;
if length(position) == length(elemToInsert)
    tmpVec(position) = elemToInsert;
elseif length(position) < length(elemToInsert)
    %More elements to insert than given positions
    tmpVec(position,1) = elemToInsert(1:length(position));
    tmpVec(position(end) + 1:position(end) + (length(elemToInsert) - length(position))) = elemToInsert(length(position)+1:end);
else
    %More positions than elements to insert
    tmpVec(position(1:length(elemToInsert))) = elemToInsert;
    tmpVec(position(length(elemToInsert)+1:end)) = elemToInsert(end);
end

%put vecIn back in
tmpVec(find(isnan(tmpVec(:)))) = vecIn;

outVec = tmpVec;