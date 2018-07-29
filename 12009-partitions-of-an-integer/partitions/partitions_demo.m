%% Find all (7) partitions of the number 5
partitions(5)

%% Find all ways to break a dollar into coins of denomination [1 5 10 25 50]
plist = partitions(100,[1 5 10 25 50]);
% There are 292 of them...
size(plist,1)

plist

%% Break a dollar into coins of denomination [1 5 10 25 50], but use no more than 4 of any coin
% This means no pennies. There are only 11 ways to do this.
plist = partitions(100,[1 5 10 25 50],4)

%% Partitions of the number 13 into a sum of even integers
partitions(13,2:2:12)
% It can't be done, of course.

%% Partitions of 29 into integers 1:29, but use no single element more than once
plist = partitions(25,1:29,1);
size(plist,1)

%% Partitions of 100 into a sum of exactly 4 squares of the integers 1:9
partitions(100,(1:9).^2,[],4)

