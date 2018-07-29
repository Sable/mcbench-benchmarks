function vout=nextfor(v,lo,hi,dx)
%NEXTFOR  find the next vector in the multiple for loop
% usage: vout = nextfor(v,lo,hi)
%        vout = nextfor(v,lo,hi,dx)
%
% NEXTFOR(V,LO,HI), where V is an array of the same size as LO and HI,
% returns the next vector in the multiple for loop, by incrementing the
% right-most possible element of V(i) by 1 or returning [] otherwise.
%
% NEXTFOR(...,DX) where DX is a scalar or array with all non-zero elements
% increments the rightmost possible element V(i) by DX(i)
%
% NEXTFOR([],LO,...) returns LO if (HI-LO)./DX >= 0, or [] otherwise
%
% NEXTFOR can be used to emulate a vectorized for loop (for v=lo:dx:hi,)
%
% In the set of all vectors V=LO+K.*DX, K>=0, min(LO,HI)<=V<=max(LO,HI),
% with lexical order:
% - pairs are ordered according to the first elements that differ
% - the "first" vector is V0=LO (if W is sorted)
% - the "last" choice is V1=LO*floor((HI-LO)./DX).*DX (if (HI-LO)./DX>=0)
% - the successor of V is determined according to the rightmost elements
%   that can be incremented, i.e. (HI(i)-V(i))/DX(i)>=1.
%   Then V(i) -> V(i)+DX(i) and V(i+1:end) -> LO(i+1:end)
%
% Note: For execution speed, no error checking is performed on the inputs
%
% Example 1:
%   nextfor([],[0,0],[1,1])     % returns [0,0]
%   nextfor([0,0],[0,0],[1,1])  % returns [0,1]
%   nextfor([0,1],[0,0],[1,1])  % returns [1,0]
%   nextfor([1,0],[0,0],[1,1])  % returns [1,1]
%   nextfor([1,1],[0,0],[1,1])  % returns []
%
% Example 2: 
%   nextfor(1,0,1.5)                  % returns []
%   nextfor(1,0,1.5,0.5)              % returns 1.5
%   nextfor([],1,0)                   % returns []
%   nextfor([],1,0,-1)                % returns 1
%   nextfor([0,0],[0,1],[1,0],[1,-1]) % returns [1,1]
%
% Example 3: loop through all integer 4-vectors such that 1<=V<=10
%   n=4;
%   lo=ones(1,n);
%   hi=10*lo;
%   v=nextfor([],lo,hi);
%   M=zeros(prod(hi-lo+1),n);
%   i=0;
%   while ~isempty(v),
%     i=i+1;
%     M(i,:)=v;
%     v=nextfor(v,lo,hi);
%   end;
%   isequal(M,num2str((0:10^n-1)','%04d')-'0'+1)  % 1

% Author: Ben Petschel 4/7/2009
%
% Change history:
%  4/7/2009 - first release (modelled after nextperm.m)

if nargin<4,
  dx = 1;
end;

if isempty(v),
  if all((hi-lo)./dx>=0),
    vout = lo;
  else
    vout = [];
  end;
else

  vout = v;
  
  % find the rightmost element that can be increased
  ind = find((hi-v)./dx>=1,1,'last');
  
  if isempty(ind),
    % v is the last vector
    vout = [];
  else
    % increment vout(ind) and update the tail elements
    if isscalar(dx),
      vout(ind) = vout(ind)+dx;
    else
      vout(ind) = vout(ind)+dx(ind);
    end;
    vout(ind+1:end) = lo(ind+1:end);
  end;
end;
