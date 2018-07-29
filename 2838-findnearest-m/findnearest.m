function [r,c,V] = findnearest(srchvalue,srcharray,bias)

% Usage:
% Find the nearest numerical value in an array to a search value
% All occurances are returned as array subscripts
%
% Output:
%
% For 2D matrix subscripts (r,c) use:
%
%       [r,c] = findnearest(srchvalue,srcharray,gt_or_lt)
%
%
% To also output the found value (V) use:
%
%       [r,c,V] = findnearest(srchvalue,srcharray,gt_or_lt)
%
%
% For single subscript (i) use:
%
%         i   = findnearest(srchvalue,srcharray,gt_or_lt)
% 
%
% Inputs:
%
%    srchvalue = a numerical search value
%    srcharray = the array to be searched
%    bias      = 0 (default) for no bias
%                -1 to bias the output to lower values
%                 1 to bias the search to higher values
%                (in the latter cases if no values are found
%                 an empty array is ouput)
%
%
% By Tom Benson (2002)
% University College London
% t.benson@ucl.ac.uk

if nargin<2
    error('Need two inputs: Search value and search array')
elseif nargin<3
    bias = 0;
end

% find the differences
srcharray = srcharray-srchvalue;

if bias == -1   % only choose values <= to the search value
    
    srcharray(srcharray>0) =inf;
        
elseif bias == 1  % only choose values >= to the search value
    
    srcharray(srcharray<0) =inf;
        
end

% give the correct output
if nargout==1 | nargout==0
    
    if all(isinf(srcharray(:)))
        r = [];
    else
        r = find(abs(srcharray)==min(abs(srcharray(:))));
    end 
        
elseif nargout>1
    if all(isinf(srcharray(:)))
        r = [];c=[];
    else
        [r,c] = find(abs(srcharray)==min(abs(srcharray(:))));
    end
    
    if nargout==3
        V = srcharray(r,c)+srchvalue;
    end
end


    
