function result = strRemoveChars( text, chars )
%
% Purpose : This function removes the set of characters defined in chars
% from the string text.
%
% Use (syntax):
%   result = strRemoveChars( text, chars )
%
% Input Parameters :
%   text: an array of characters to be processed
%   chars: an array of characters to be removed.
%
% Return Parameters :
%   result: the modified string
%
% Description and algorithms:
%
% References : 
%
% Author :  Matther Harker and Paul O'Leary
% Date :    29. Jan 2013
% Version : 1.0
%
% (c) 2013 Matther Harker and Paul O'Leary
% url: www.harkeroleary.org
% email: office@harkeroleary.org
%
% History:
%   Date:           Comment:
%
result = text;
for k=1:length(chars)
    result = strRemoveChar( result, chars(k) );
end;
%
function result = strRemoveChar( text, charr )
%
at = strfind( text, charr );
inds = [1:length(text)];
%
useInds = setdiff( inds, at );
result = text(useInds);