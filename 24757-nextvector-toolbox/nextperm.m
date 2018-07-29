function vout=nextperm(v)
%NEXTPERM  determine the next permutation of a row vector
% usage: vout = nextperm(v)
%
% NEXTPERM(V), where V is a row or column vector possibly with repeats,
% returns the next permutation of V by lexical ordering (see below)
% or [] if there is none.  Elements of v can be any value except NaN.
%
% NEXTPERM can be used to iterate through all unique permutations of a vector
% but keep in mind that the number increases factorially with the length of V!
%
% In the set of all permutations of V, with lexical order:
% - pairs are ordered according to the first elements that differ
% - the "first" permutation is V0=sort(V)
% - the "last" permutation is V1=sort(V,'descend')
% - the successor of V is determined by swapping an element with the next
%   smallest element to its right and sorting the rest, at the rightmost
%   place where this is possible
%
% Example 1:
%   nextperm([1,2,3])       % returns [1,3,2]
%   nextperm([1,3,2])       % returns [2,1,3]
%   nextperm([3,2,1])       % returns []
%   nextperm([1,3,2,1])     % returns [2,1,1,3]
%   nextperm('abc')         % returns 'acb'
%   nextperm([-inf,-1,inf]) % returns [-inf,inf,1]
%
% Example 2: determine all permutations of 1:8
%   % iterating through sets with more than about 10 unique elements is not recommended!
%   n=8;
%   v=1:n;
%   M=zeros(factorial(n),n);
%   k=0;
%   while ~isempty(v),
%     k=k+1;
%     M(k,:)=v;
%     v=nextperm(v);
%   end;
%   isequal(M,sortrows(perms(1:n))) % =1

% Author: Ben Petschel 18/2/2009
%
% Change history:
%  18/2/2009 - first release
%  11/3/2009 - changed to allow vectors with negative or inf values
%              (now uses NaN's in searching for the smallest larger value)

vout = v;

% find the rightmost element that is smaller than its successor
ind = find(diff(v)>0,1,'last');

if isempty(ind),
  % v is in descending order, so it is the last vector
  vout = [];
else
  % swap v(ind) with the next smallest value to the right
  this=v(ind);
  tail=v(ind+1:end);
  [next,pos]=min(tail+0./(tail>this)); % find the smallest larger value by using NaN's
  tail(pos)=this;
  vout(ind)=next;
  % sort the remaining values
  vout(ind+1:end)=sort(tail);
end;
