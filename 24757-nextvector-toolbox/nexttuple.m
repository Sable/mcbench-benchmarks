function vout=nexttuple(v,varargin)
%NEXTTUPLE  find the next tuple in the cartesian product
% usage: vout = nexttuple(v,A)
%        vout = nexttuple(v,A1,A2)
%        vout = nexttuple(v,A1,...,An)
%
% NEXTTUPLE(V,A1,...,An), where V is an array of length n, returns the next
% vector in the cartesian product A1 x ... x An, by incrementing the
% right-most possible element of V(i) or returning [] otherwise.
%
% Note: the arrays A1,...,An can be any size and unordered but should not
% contain repeats, otherwise an error may occur.  To emulate the desired
% behaviour when there are repeats, use NEXTFOR on the indices instead.
%
% In the set of all vectors V in A1 x ... x An with lexical order:
% - pairs are ordered according to the first elements that differ and the
%   elements respective order in Ak
% - the "first" vector is V0=[A1(1),...,An(1)] (if no Ak are empty)
% - the "last" vector is V1=[A1(end),...,An(end)] (if no Ak are empty)
% - the successor of V is determined according to the rightmost elements
%   that do not equal Ak(end)
%
% Note: For execution speed, minimal error checking is performed
%
% Example 1:
%   nexttuple([],[0,1],[0,1])     % returns [0,0]
%   nexttuple([0,0],[0,1],[0,1])  % returns [0,1]
%   nexttuple([0,1],[0,1],[0,1])  % returns [1,0]
%   nexttuple([1,0],[0,1],[0,1])  % returns [1,1]
%   nexttuple([1,1],[0,1],[0,1])  % returns []
%
% Example 2: 
%   nexttuple([],[4,1,2],[2,1,4]) % returns [4,2]
%
% Example 3: loop through all tuples in [4,1,2] x [2,1,4] and compare
% with results of nextfor:
%   A={[4,1,2],[2,1,4]};
%   v=nexttuple([],A{:});
%   lo=ones(1,numel(A));
%   hi=cellfun(@numel,A);
%   vf=nextfor([],lo,hi);
%   M=zeros(prod(cellfun(@numel,A)),numel(A));
%   Mf=zeros(prod(cellfun(@numel,A)),numel(A));
%   i=0;
%   while ~isempty(v),
%     i=i+1;
%     M(i,:)=v;
%     Mf(i,:)=arrayfun(@(x)A{x}(vf(x)),1:numel(vf));
%     v=nexttuple(v,A{:});
%     vf=nextfor(vf,lo,hi);
%   end;
%   isequal(M,Mf)  % 1

% Author: Ben Petschel 17/7/2009
%
% Change history:
%  17/7/2009 - first release (modelled after nextfor.m)

nA = numel(varargin);

if isempty(v),
  if min(cellfun(@numel,varargin))==0,
    vout=[];
  else
    vout=cellfun(@(x)x(1),varargin);
  end;
else
  if nA~=numel(v),
    error('number of elements of V does not agree with number of sets in the cartesian product');
  end;
  if min(cellfun(@numel,varargin))==0,
    error('cartesian product is empty but V is non-empty');
  end;

  % determine the successor: find the rightmost element that can be incremented
  ind = nA;
  while (ind>0) && (varargin{ind}(end)==v(ind)),
    ind = ind-1;
  end;
  
  if ind==0,
    % v is the last vector
    vout = [];
  else
    % increment vout(ind) and update the tail elements
    k=find(varargin{ind}==v(ind));
    if numel(k)~=1,
      error('missing or repeated element of v: successor undetermined');
    end;
    vout = [v(1:ind-1),varargin{ind}(k+1),cellfun(@(x)x(1),varargin(ind+1:end))];
  end;
end;
