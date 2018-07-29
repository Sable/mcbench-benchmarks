function [ table ] = integerparttable(nfinal )
%Calculates a table of integer partions using numbers l.t. or e.t. k
%(or equivilently using k nonnegative integers which can be zero)
%Just calls with the largest value which has to recurrsively call all other
%possible values.  
%
%this table states with first row "ways to partition 0" and first column
%"using only numbers <=0", this gives the one in the top left, these two
%rows are essentially a definition limit to finish the reccurance relation.
%Row k+1 column j+1 contains the ways to partition k 
% using integers <= j (or equivilently j integers >= 0)
%
%to obtain the partitions of nfinal using numbers g.e. 2 and l.e. k do
%  [1;table(2:nfinal,k+1)-table(1:nfinal-1,k+1)]
%
%use of 32 bit integers means this is only good up to 2^32-1= 4294967295, 
%for larger values change to 64 bit or dp
% Scales as ~ exp(pi*sqrt(2*n/3))/(4*n*sqrt(3)) for n>>1 and k>n

%Author: David Holdaway
%Last update: 27/04/2012

intpart(1,nfinal,1,1); %clears table

for n = 2:nfinal
    intpart(uint32(n),uint32(n));
end
table = intpart(1,nfinal,2); %gets table

for n = 1:nfinal
 table(n+1,n+1:nfinal+1) =  table(n+1,n+1);  
end
end

function p = intpart(k,n,gettable,cleartable) %#ok<INUSD>
persistent table
if nargin == 4
    table = uint32(zeros(n+1)); %clears
%     table(1,:) = uint32(ones(1,1+n)); %n=0
%     table(2,2:n+1) = uint32(ones(1,n)); %n=1 k>1
%     table(:,2) = uint32(ones(n+1,1)); %k=0
    table(1,:) = uint32(1); %n=0
    table(2,2:n+1) = uint32(1); %n=1 k>1
    table(:,2) = uint32(1); %k=0
    p = 0; return
end
if nargin == 3
    p = table; return
end
k = uint32(k);
n = uint32(n);
if n < 0
    p = uint32(0); return
end
if k < 0
    p = uint32(0); return
end
if table(n+1,k+1) ~= 0
    p = table(n+1,k+1);  return
end

if n==0
    p = uint32(0); return
end

    table(n+1,k+1) = intpart(k,n-k) + intpart(k-1,n);
    p = table(n+1,k+1);
    for lp = n+2:length(table)
    table(n+1,lp) = table(n+1,n+1);
    end

end
