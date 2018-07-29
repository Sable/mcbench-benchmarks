function vout=nextchoose(v,w)
%NEXTCHOOSE  find the next choice of k elements from a vector (with possible repeats)
% usage: vout = nextchoose(v,w)
%
% NEXTCHOOSE(V,W), where V is a row or column vector of integers in W,
% returns the next choice of length(V) elements from W by lexical ordering
% (see below) or [] if there is none.  W can also be specified as a
% positive integer N, in which case W=1:N.
%
% NEXTCHOOSE can be used to iterate through all unique k-combinations in
% 1:N but keep in mind that the number is nchoosek(N,length(V))
%
% In the set of all k-combinations of W, with lexical order:
% - V is equivalent to sort(V)
% - pairs are ordered according to the first sorted elements that differ
% - the "first" choice is V0=W(1:k) (if W is sorted)
% - the "last" choice is V1=W(N-k+1:N) (if W is sorted, and N=numel(W))
% - the successor of V is determined according to the rightmost elements
%   such that V(i)=W(j) and j < N-(k-i). Then V(i:k) -> W(j+1:j+k-i+1)
%
% Example 1:
%   nextchoose([1,2,3],4)       % returns [1,2,4]
%   nextchoose([1,2,4],4)       % returns [1,3,4]
%   nextchoose([1,3,4],4)       % returns [2,3,4]
%   nextchoose([2,3,4],4)       % returns []
%
% Example 2: choose 2 elements from a vector with repeats
%   nextchoose([1,2],[1,2,2,3]) % returns [1,3]
%   nextchoose([1,3],[1,2,2,3]) % returns [2,2]
%   nextchoose([2,2],[1,2,2,3]) % returns [2,3]
%   nextchoose([2,3],[1,2,2,3]) % returns []
%
% Example 3: determine all 4-combinations of 1:8
%   n=8;
%   k=4;
%   v=1:k;
%   M=zeros(nchoosek(n,k),k);
%   i=0;
%   while ~isempty(v),
%     i=i+1;
%     M(i,:)=v;
%     v=nextchoose(v,n);
%   end;
%   isequal(M,sortrows(nchoosek(1:n,k))) % =1

% Author: Ben Petschel 25/6/2009
%
% Change history:
%  25/6/2009 - first release (modelled after nextperm.m)
%  29/6/2009 - added support for general choice vectors

vout = sort(v);
k = length(v);

if isscalar(w),
  W = 1:w;
else
  W = sort(w);
end;

% find the rightmost element that can be increased
ind = find(vout<W(end-k+1:end),1,'last');

if isempty(ind),
  % v is the last vector
  vout = [];
else
  % increment vout(ind) and update the tail elements
  j = find(vout(ind)==W,1,'last');
  if isempty(j),
    error('an element of V is not in W');
  end;
  vout(ind:k) = W(j+1:j+k-ind+1);
end;
