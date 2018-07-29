function h=hash(vargin)
% h=hash(vargin)
%   Hash table declaration 
%   Creates and returns a hash object
%
%   USSAGE:
%
%   H = hash;
%   H('key') = value; %assign value to key
%   v = H('key');     % retrieve value for a key
%   H.keys            % return cell array of keys
%   H. values         % return array of values
%   H.idx             % returns sparse matrix of indexes
%
%   Remark:
%   The hash function used is sum of the key.
%   It can easilly be changed if needed.

% Some ideas were taken from Matthew Krauski 
% (mkrauski@uci.edu) pachage HASHTABLE
%

% Dimitar Atanasov, 2010
% datanasov@nbu.bg

if nargin == 0
    h.keys = {};
    h.values = {};
    h.idx = sparse([]);
    h = class(h,'hash');
    
elseif nargin == 1
    if isa(vargin{1},'hash')
        h = vargin{1};
    else
        error('Input argument is not hash object')
    end;
elseif nargin == 3
    h.keys = vargin{1};
    h.values = vargin{2};
    h.idx = vargin{3};
    
    h = class(h,'hash');
    
else
    error('Wrong hash definition');
end;
