function str = StrrepLikeRegexprep(str,tokens,replace)
% STRREPLIKEREGEXPREP Replace string with another.
%   This function uses STRREP, but uses the input and output format of
%   REGEXPREP so it can be easily substituted.
%
%   S = STRREPLIKEREGEXPREP(STRING,SEARCH,REPLACE) replaces all occurrences of
%   the the search string, SEARCH, in string, STRING, with the string,
%   REPLACE. The new string is returned.  If no matches are found 
%   STRREPLIKEREGEXPREP returns STRING unchanged.
%
%   If STRING is a cell array of strings, STRREPLIKEREGEXPREP returns a
%   cell array of strings replacing each element of STRING individually.
%
%   If SEARCH is a cell array of strings, STRREPLIKEREGEXPREP
%   replaces each element of SEARCH sequentially.
%
%   If REPLACE is a cell array of strings, then SEARCH must be a cell array
%   of strings with the same number of elements.  STRREPLIKEREGEXPREP
%   will replace each element of SEARCH sequentially with the
%   corresponding element of REPLACE.
%
%   Example:
%      InputStr  = {'we the people,','in oder to form','a more perfct'}
%      SearchStr = {'we','oder','perfct'};
%      ReplaceStr = {'We','order','perfect'};
%      StrrepLikeRegexprep(InputStr, SearchStr, ReplaceStr)
%         returns {'We the people,','in order to form','a more perfect'}
%
% IT'S NOT FANCY, BUT IT WORKS
%
%   See also strrep, strfind, regexprep.

% MICHAEL ROBBINS
% MichaelRobbins1@yahoo.com
% MichaelRobbinsUsenet@yahoo.com
% robbins@bloomberg.net

IsCell=1;
if ~iscell(str)     str     = {str};     IsCell=0; end;
if ~iscell(tokens)  tokens  = {tokens};  end;
if ~iscell(replace) replace = {replace}; end;
for i=1:length(str)
    for j=1:length(tokens)
        str{i} = strrep(str{i},tokens{j},replace{j});
    end;
end;

if ~IsCell str = str{:}; end;