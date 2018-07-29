function intlist = intpartgen(N,maxnum,intlist)
%lists all partitions of all integers up to N (first input) using at most 
%maxnum integers (second argument)
%
% i.e. all the possible ways to express N as a sum of independent integers
% e.g. 3 = {3,2+1,1+1+1}, 4={4,3+1,2+1+1,2+2,1+1+1+1}... 
%stored as 1d cell array with each cell containing all the partitions as a
%matrix of size (m by n) (integer of size n can only be partitioned by n
%integers)
%program uses 8 bit integers so can't handle above 255 unless you change 
%this, the table would become unbearably large by N = 255 anyway
%
%if "intlist" is given in the name the program will build on this as a
%starting block, allowing for use reccursively, although this wouldn't be
%that efficient, just use for extending the table slightly
%
% The argument "maxnum" indiciates the maximum numbers of integers you
% wish to allow in this partition, for example if maxnum = 4 only
% partitions with 4 integers (which can be zero) are allowed, the number 
% of these partitions is equivalent to the number allowing only numbers 
% l.t. N

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This was written to generate all the quantum numbers for 1D many body
% harmonic oscillator states satisfying E < N where E = sum(qns) for n
% particles 

% Another example problem this could solve is finding all the possible ways 
% to pay a particular sum of money in british coinage (or equivilently in
% notes /  £1 and £2 coins)
% intlist = intpartgen(value,max_number_of_coins_allowed);
% tmp = intlist(value+1)
% lg = tmp==50 | tmp == 20 | tmp==10 | tmp==5 | tmp==2 | tmp==1;
% lg2 = ~any(lg==0);
% ways_to_pay = tmp(lg2,:); %0 indicates no coin

%although it would be better to use intpartgen2 as this allows restriction
%of the range of numbers making the calculation more efficient

%David Holdaway : May 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

table = integerparttable(N);
 %number of partitions for each number up to N

if nargin == 1
    maxnum = N;
elseif isempty(maxnum)
    maxnum = N;
elseif maxnum>N
    maxnum=N;
end
table = table(:,maxnum+1);

if nargin < 3
intlist{1} = uint8(0); %partitions of 0
intlist{2} = uint8(1); %partitions of 1
intlist{3} = uint8([2,0;1,1]); %partitions of 2
kstart = 3;
else
    kstart = length(intlist);
end
    

%in general   p{n} = [n , p{n-1}+1,p{n-2}+2 exc 1,p{n-3}+3 exc 1&2, 
                %..., p{ceil(n/2)}+floor(n/2),exc 1&2&...&floor(n/2)-1]
                

for k = kstart:N
%k  %uncomment to track output
    tempmat = uint8(zeros(table(k+1),min(k,maxnum))); count = 1;
    tempmat(1,1)=k;
    
    for j = 1:floor(k/2)
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
    if ~isequal(count,table(k+1))
        'fail'
        k
    end
    tempmat = sort(tempmat,2,'descend');
    intlist{k+1} = tempmat;

end

if nargout == 0 %save if not outputting
    
    save(strcat('intpartlist_N=',num2str(N),'_maxnum=',num2str(maxnum),'.mat'),'intlist')
    
end
    
    