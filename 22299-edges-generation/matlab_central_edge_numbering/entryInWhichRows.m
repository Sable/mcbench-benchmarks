function entryrows=entryInWhichRows(A)
%function: entryrows=entryInWhichRows(A)
%requires: none
%for every entry of integer matrix A, 
%its rows indices are stored in output matrix,
%zeros entries indicate no more occurence
%example: entryrows=entryInWhichRows([1 2; 1 3; 2 2]) returns
%         entryrows=[1   2   0; 
%                    1   3   3; 
%                    2   0   0]   
%meaning: entry 1 appears in rows 1 and 2
%         entry 2 appears in rows 1 and 3 (twice)
%         entry 3 appears in row  2 only

%size computation; 
r=max(max(A));
repetition=accumarray(A(:),ones(numel(A),1));
c=max(repetition);

%filling rows occurences
%this part should be somehow vectorized!
entryrows=zeros(r,c);
repetition=zeros(r,1);
for i=1:size(A,1)
    for j=1:size(A,2)
       index=A(i,j); 
       repetition(index)=repetition(index)+1; 
       entryrows(index,repetition(index))=i;
    end
end





