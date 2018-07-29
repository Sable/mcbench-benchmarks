function [N,R]=repeatv(A)
%[number,repeat]=repeatv(input vector)
%
%these function calculate number of repeat all array of a input vector
%input must be a vector
%vector is var(1,:) or var(:,1)  var==>variable
%these function calculate repeats by deleting column or row
%
%for example:
%[n,r]=repeatv([1 2 3 4 9 6 5 2 3 1])
%n =
%
%     1     2     3     4     9     6     5
%
%
%r =
%
%     2     2     2     1     1     1     1

if isempty(A)
    N=[];
    R=[];
else
    l=length(A);
    i=1;
    while i<=l
        t=0;
        b(1,i)=A(i);
        j=i;
        while j<=l
            if A(i)==A(j)
                t=t+1;
                if i~=j
                    A(j)=[];
                    l=l-1;
                    j=j-1;
                end
            end
            j=j+1;
        end
        b(2,i)=t;
        i=i+1;
    end
    N=b(1,:);
    R=b(2,:);
end