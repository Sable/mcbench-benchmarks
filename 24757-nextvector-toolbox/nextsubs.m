function vout=nextsubs(v,w)
%NEXTSUBS  find the next subset of a vector (with possible repeats)
% usage: vout = nextsubs(v,w)
%
% NEXTSUBS(V,W), where V is a row or column vector of values in W,
% returns the next subset (or sub-multiset if W has repeats) of elements
% from W by degree-lexical ordering (see below) or [] if there is none. 
%
% NEXTSUBS can be used to iterate through all unique subsets of 1:N
% but keep in mind that the number is 2^N
%
% In the set of all subsets of W, with degree-lexical order:
% - V is equivalent to sort(V)
% - pairs are ordered according to size or the first sorted elements that
%   differ if the sizes are equal
% - the "first" choice is V0=[] followed by W(1) (if W is sorted)
% - the "last" choice is V1=W (if W is sorted)
% - the successor of V is determined according to the rightmost elements
%   such that V(i)=W(j) and j < N-(k-i). Then V(i:k) -> W(j+1:j+k-i+1)
%   otherwise V -> W(1:numel(V)+1)
%
% NEXTSUBS(V,W) returns NEXTCHOOSE(V,W), except if V is empty or W is
%   scalar or if V is the "last" k-choice of W where k<numel(W).
%   Scalar W are treated as single-element vectors to avoid potential
%   near-infinite loops when W >> 1.
%
% Note: for speed of execution, input checking is not performed.
%
% Example 1:
%   nextsubs([],1:4)        % returns 1
%   nextsubs([1],1:4)       % returns 2
%   nextsubs([1,2,3],1:4)   % returns [1,2,4]
%   nextsubs([2,3,4],1:4)   % returns 1:4
%   nextsubs(1:4,1:4)       % returns []
%
% Example 2: subsets of a multiset (vector with repeats)
%   nextsubs([1,2],[1,2,2,3]) % returns [1,3]
%   nextsubs([1,3],[1,2,2,3]) % returns [2,2]
%   nextsubs([2,3],[1,2,2,3]) % returns [1,2,2]
%
% Example 3: determine all subsets of 1:8
%   n=8;
%   v=[];
%   w=1:n;
%   M=cell(1,2^n);
%   M{1}=v;
%   v=nextsubs(v,w);
%   i=1;
%   while ~isempty(v),
%     i=i+1;
%     M{i}=v;
%     v=nextsubs(v,w);
%   end;
%
% See also: NEXTCHOOSE

% Author: Ben Petschel 11/7/2009
%
% Change history:
%  11/7/2009 - first release (based on nextchoose.m)

if isempty(v),
  vout=min(w);
else
  if isscalar(w),
    % assume v=w, since v is non-empty
    vout = [];
  else
    vout = nextchoose(v,w);
    if isempty(vout) && (numel(v)<numel(w)),
      % vout was the last k-subset; get the first subset with k+1 elements
      W = sort(w);
      vout = W(1:numel(v)+1);
    end;
  end;
end;

end
