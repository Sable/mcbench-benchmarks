function N=nmultichoosek(n,k,type)
%NMULTICHOOSEK   Unordered samples WITH or WITHOUT repetition.
%   NMULTICHOOSEK(N,K) finds the number of multisets of length k on n
%   symbols. NMULTICHOOSEK can take vector or scalar input.
% 
%   NMULTICHOOSEK(N,K,'single') is the same as NCHOOSEK (unordered samples WITHOUT
%    repetition), except that it accepts vector inputs for both n and k.
% 
%   NMULTICHOOSEK(N,K,'multi') is the same as NMULTICHOOSEK(N,K).
% 
%   Examples:
%      N = nmultichoosek(5,1:5)
% 
%   finds the number of multisets of length 1 to 5 from a 5 symbol set
% 
%      N = nmultichoosek(5,1:5,'single')
% 
%   is the same as:
% 
%      for k=1:5
%         N(k) = nchoosek(5,k);
%      end
%
%   See also nchoosek, perms.

% Author: Peter (PB) Bodin
% Email: pbodin@kth.se
% Created: 14-Nov-2005 19:48:49

msg = nargchk(2,3,nargin);
error(msg);
n = n(:);           % Convert N-D arrays to 1-D
k = k(:);           % Convert N-D arrays to 1-D
if numel(n)>1 & numel(k)>1
    if numel(n)~=numel(k)
        error('vectors must have the same number of elements')
    end
end

if nargin > 2
    switch type
        case 'single'
            N = round(exp(gammaln(n+1) - gammaln(k+1) - gammaln(n-k+1)));
            return;
        case 'multi'
        otherwise
            error('valid types are ''multi'' and ''single''');
    end
end

N = round(exp(gammaln(n+k) - gammaln(k+1) - gammaln(n)));
N(n<k)=NaN;
