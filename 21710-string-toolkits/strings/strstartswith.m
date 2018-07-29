function b = strstartswith(s, pat)
%STRSTARTSWITH Determines whether a string starts with a specified pattern
%
%   b = strstartswith(s, pat);
%       returns whether the string s starts with a sub-string pat.
%

%   History
%   -------
%       - Created by Dahua Lin, on Oct 9, 2008
%

%% main

sl = length(s);
pl = length(pat);

b = (sl >= pl && strcmp(s(1:pl), pat)) || isempty(pat);

