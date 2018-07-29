function s = findsum(total,digit)
s={};%start with an empty solution set
fullset = 1:9;%allowed digits
partset = partitions(total,fullset,1); %calculates all the ways to add 1:9 without replication to get total
count = sum(partset,2);%number of digits used in partition
goodrows = find(count==digit);%select only solutions of the correct number of digits
for r = 1:length(goodrows)
    soln = fullset(find(partset(goodrows(r),:)==1));%numbers used in this solution
    s=[s,soln];
end