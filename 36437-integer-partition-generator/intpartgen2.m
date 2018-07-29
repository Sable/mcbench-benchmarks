function intlist = intpartgen2(N,maxnum,intlist,allowednumrange)
% lists all partitions of all integers up to N (first input) using at most 
% maxnum numbers (2nd input) out of the restricted range (if given) 
% allowednumrange (4th input), note if this doesn't include the number zero
% only partitions of using exactly maxnum numbers are output
% i.e. all the possible ways to express N as a sum of independent integers
% e.g. 3 = {3,2+1,1+1+1}, 4={4,3+1,2+1+1,2+2,1+1+1+1}... 
% stored as 1d cell array with each cell containing all the partitions as a
% matrix of size (m by n) (integer of size n can only be partitioned by n
% integers
% uses 16 bit integers so can't handle above 65535 unless you change this
%
%if "intlist" is given in the name the program will build on this as a
%starting block, allowing for use reccursively, although this wouldn't be
%that efficient, just use for extending the table slightly.  To not use a
%set just pass an empty argument [] to the function for input 3.
%
% The argument "maxnum" indiciates the maximum numbers of integers you
% wish to allow in this partition, for example if maxnum = 4 only
% partitions with 4 integers are allowed, the number of these partitions is
% equivalent to the number allowing only numbers l.t. N
%
% Allowednumrange is the range of allowed numbers 
%
% Example usage: to calculate the number of ways to pay a sum of money with british
% coins only
% intlist = intpartgen2(value,max_number_of_coins_allowed,[],[0,1,2,5,10,20,50]);
% ways_to_pay = intlist{value+1}; %0 indicates no coin
% If people wanted to further restrict this to limit the number of each
% coin this would have to be done post generation, for instance to insist
% that a penny is present
% constrained_ways_to_pay = ways_to_pay(any(ways_to_pay==1),:);
% or using exactly maxnum coins
% constrained_ways_to_pay2 = ways_to_pay(~any(ways_to_pay==0),:);
%
% it is best to include zero, if zero is not given any with zero are 
% removed post generation (see line 122), giving only those using exactly 
% maxnum numbers.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%David Holdaway : May 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%allowednumrange = uint16(allowednumrange);


if nargin == 1
    maxnum = N;
elseif isempty(maxnum)
    maxnum = N;
elseif maxnum>N
    maxnum=N;
end


if nargin < 3
    intlist = [];
end

if isempty(intlist)
intlist{1} = uint16(0); %partitions of 0
intlist{2} = uint16(1); %partitions of 1
intlist{3} = uint16([2,0;1,1]); %partitions of 2
kstart = 3;
else
    kstart = length(intlist);
end
%modify prefed list to remove disallowed values, this does not account for
%having more than max num
if nargin == 4
    for j = 1:length(intlist)
        tmp = intlist{j};
    lg = false(size(tmp));
   for k =allowednumrange

        lg = logical(lg + (tmp==k));
   end
   lg2 = ~any(lg==0,2);
   intlist{j} = tmp(lg2,:);
    end
    table = 1:N+1; %don't preallocate as it is not known how many
else
    allowednumrange = 0:N;
    table = integerparttable(N);
 %number of partitions for each number up to N
table = table(:,maxnum+1);
end
%in general   p{n} = [n , p{n-1}+1,p{n-2}+2 exc 1,p{n-3}+3 exc 1&2, 
                %..., p{ceil(n/2)}+floor(n/2),exc 1&2&...&floor(n/2)-1]


for k = kstart:N
%k  %uncomment to track output
    tempmat = uint16(zeros(table(k+1),min(ceil(k/min(allowednumrange(allowednumrange~=0))),maxnum))); 
    if any(allowednumrange==k)
    tempmat(1,1)=k;
    count = 1;
    else
        count = 0;
    end
    
    for j = allowednumrange(allowednumrange<=floor(k/2) & allowednumrange>0)
       temp = intlist{k-j+1};
       lg = temp>j-1 | temp == 0; %all non zero elements of temp 
       lg2 = all(lg==1,2);

       lg2 = lg2 & (any(temp==0,2)|size(temp,2)<maxnum); 
       %must have at least one space for another

       temp = temp(lg2,1:min(size(temp,2),maxnum-1));    
       %[temp,ones(size(temp,1),1)]

        tempmat(count+1:count+size(temp,1),1:size(temp,2)+1) = [temp,j*ones(size(temp,1),1)];

        count = count + size(temp,1);
    end

    tempmat = sort(tempmat,2,'descend');
    intlist{k+1} = tempmat(1:count,:);

end

if ~any(allowednumrange==0)  %for technical reasons this is done at the end
    %it is really better to just included zero in the allowed range
    for k =0:N
        tmp = intlist{k+1};
       intlist{k+1} =  tmp(all(tmp~=0,2),:); %only keep ones with no zeros
    end
end

end