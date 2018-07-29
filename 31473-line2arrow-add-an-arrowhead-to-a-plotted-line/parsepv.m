function [Param, extra] = parsepv(Param, pvpairs, varargin)
%PARSEPV Parses parameter/value pairs
%
% NewParam = parsepv(Param, pvpairs)
% [NewParam, extra] = parsepv(Param, pvpairs, 'returnextra')
%
% This function is an extension of parse_pv_pairs.  It allows the option of
% returning unrecognized parameter/value pairs, rather than erroring.
%
% Input variables:
%
%   Param:          1 x 1 structure holding default parameters (fieldnames)
%                   and values 
%
%   pvpairs:        1 x n cell array of parameter/value pairs
%
%   'returnextra':  if this string is included, the function will return a
%                   cell array holding any unrecognized parameters and the
%                   corresponding values.  Otherwise, it will error if a
%                   parameter is not recognized.  
%
% Output variables:
%
%   NewParam:       1 x 1 struct identical to Param but with defaults
%                   replaced by the values from pvpairs  
%
%   extra:          1 x m cell array of any unrecognized parameter/value
%                   pairs

% Copyright 2009 Kelly Kearney

if nargin == 3
    returnextra = strcmpi(varargin{1}, 'returnextra');
else
    returnextra = false;
end

npv = length(pvpairs);
n = npv/2;

if n~=floor(n)
  error 'Property/value pairs must come in PAIRS.'
end
if n<=0
  % just return the defaults
  if returnextra
      extra = cell(0);
  end
  return
end

if ~isstruct(Param)
    error 'No structure for defaults was supplied'
end


if returnextra
    extra = cell(0);
end

% there was at least one pv pair. process any supplied
propnames = fieldnames(Param);
lpropnames = lower(propnames);
for i=1:n
    p_i = lower(pvpairs{2*i-1});
    v_i = pvpairs{2*i};
  
    ind = strmatch(p_i,lpropnames,'exact');
    if isempty(ind)
        ind = find(strncmp(p_i,lpropnames,length(p_i)));
        if isempty(ind)
            if returnextra
                extra = [extra pvpairs(2*i-1:2*i)];
                continue;
            else
                error(['No matching property found for: ',pvpairs{2*i-1}]);
            end
        elseif length(ind)>1
            error(['Ambiguous property name: ',pvpairs{2*i-1}])
        end
    end
    p_i = propnames{ind};

    % override the corresponding default in params
    Param = setfield(Param,p_i,v_i);
  
end