function vout=nextwhile(v,lo,cond,dx)
%NEXTWHILE  find the next vector in the vectorized while loop
% usage: vout = nextfor(v,lo,cond)
%        vout = nextfor(v,lo,cond,dx)
%
% NEXTWHILE(V,LO,COND), where V is an array of the same size as LO, and
% COND is a function handle accepting inputs the same size as LO and V,
% returns the next vector in the vectorized while loop by incrementing the
% right-most possible element of V(i) by 1 such that COND(VOUT)=true or
% returning [] otherwise.
%
% NEXTWHILE(...,DX) where DX is a scalar or array with all non-zero
% elements increments the rightmost possible element V(i) by DX(i)
%
% NEXTWHILE([],LO,...) returns LO if COND(LO)=true, or [] otherwise
%
% NEXTWHILE can be used to emulate a vectorized while loop
%
% In the set of all vectors V=LO+K.*DX, K>=0 with lexical order:
% - pairs are ordered according to the first elements that differ
% - the "first" vector is V0=LO (if W is sorted)
% - the successor of V is determined according to the rightmost element
%   that can be incremented,
%     i.e. COND([V(1),...,V(i-1),V(i)+DX(i),LO(i+1),...,LO(end)]) = true
%   Then V(i) -> V(i)+DX(i) and V(i+1:end) -> LO(i+1:end)
%
% Note: For execution speed, no error checking is performed on the inputs.
%
% The function COND should generally be specified as a comparison test on a
% monotonic function, for example COND = @(x)(prod(x)<=m) is valid with
% LO=ones(1,n).  COND is treated as a "black box" and no checks are
% performed to determine whether the feasible space is finite.
%
% Example 1: emulate behaviour of NEXTFOR:
%   cond=@(x)all(x<=1);
%   lo=[0,0];
%   nextwhile([],lo,cond)     % returns [0,0]
%   nextwhile([0,0],lo,cond)  % returns [0,1]
%   nextwhile([0,1],lo,cond)  % returns [1,0]
%   nextwhile([1,0],lo,cond)  % returns [1,1]
%   nextwhile([1,1],lo,cond)  % returns []
%
% Example 2: iterate over all positive 4-vectors satisfying prod(x)<=10
%   cond=@(x)prod(x)<=10;
%   lo=ones(1,4);
%   v=nextwhile([],lo,cond);
%   M=[];
%   while ~isempty(v),
%     M=[M;v];
%     v=nextwhile(v,lo,cond);
%   end;
%   M % returns 89x4 array
%   all(prod(M,2)<=10) % 1

% Author: Ben Petschel 4/7/2009
%
% Change history:
%  11/8/2009 - first release (modelled after nextfor.m)

if nargin<4,
  dx = 1;
end;

if isempty(v),
  if cond(lo)
    vout = lo;
  else
    vout = [];
  end;
else

  % find the rightmost element that can be increased
  ind = numel(v)+1;
  keepgoing = true;
  while keepgoing && ind>1
    ind=ind-1;
    if isscalar(dx)
      vout = [v(1:ind-1),v(ind)+dx,lo(ind+1:end)];
    else
      vout = [v(1:ind-1),v(ind)+dx(ind),lo(ind+1:end)];
    end;
    keepgoing = ~cond(vout);
  end;
  if keepgoing
    % didn't find an index where v could be incremented
    vout = [];
  end;
end;
