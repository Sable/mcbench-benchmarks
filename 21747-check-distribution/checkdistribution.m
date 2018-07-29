% Function to check distribution of unique elements in a vector or matrix.
% 
% result=checkdistribution(x)
% 
% 'result' would be a 2-column matrix, column 1 indicating which unique
% numbers are present (in ascending manner), column 2 indicating how many 
% of them. Sum of column 2 gives total number of elements in x. 
% Also, plots the result, no. of apperance vs. unique elements. 
% It is useful for integer vector/matrix with repeatations. For effective 
% use in float vector/matrix, one has to round the float vector/matrix 
% before checking the distribution.
% 
% Example: result=checkdistribution([1,1,2,2,2,3,3,3,3,10])
% result =
% 
%      1     2
%      2     3
%      3     4
%     10     1
% 
% i.e., there are two 1's, three 2's, four 3's and one 10 in x.
% 
% If x is a string, the result includes the ASCII values of the letters,
% and their countings. ASCII table can be found: www.asciitable.com
% 
% Example: result=checkdistribution('apple')
% result =
% 
%     97     1
%    101     1
%    108     1
%    112     2
% 
% i.e., one 'a'(97), 'e'(101), 'l'(108), and two 'p'(112).
% 
% Written by: Abhisek Ukil, abhiukil@gmail.com, 01.10.2008


function result=checkdistribution(x)

L=unique(x);
nL=numel(L);
result=zeros(nL,2);
for i=1:nL
    result(i,1:2)=[L(i) numel(find(x==L(i)))];
end

figure()
plot(result(:,1),result(:,2),'*-'),xlabel('Unique elements'),ylabel('No. of appearance')