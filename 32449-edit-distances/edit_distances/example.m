% Example for how to use of the edit distance funcions.
%
% @author: B. Schauerte
% @date:   2012
% @url:    http://cvhci.anthropomatik.kit.edu/~bschauer/

% let's compare s1 with s2 ...
s1={'the','quick','brown','fox','jumps','over','the','lazy','dog'};
s2={'the','quick','brown','dog','jumps','over','the','lazy','fox'};
% ... and let's use 'strcmp' to compare the cell array elements. You can
%     and define and use any compare function that works with the cell 
%     array elements.
cmp_func=@strcmp;
% @note: don't forget that there are specialized versions if you just want
%        to work with "simple" arrays and not with cell arrays with
%        arbitrary elements and compare functions.

d0=edit_distance_damerau_keylist(s1, ...
    s2, ...
    cmp_func);
d1=edit_distance_damerau_keylist(s1, ...
    s2, ...
    cmp_func);
d2=edit_distance_levenshtein_keylist(s1, ...
    s2, ...
    cmp_func);
d3=edit_distance_weighted_keylist(s1, ...
    s2, ...
    1,1,10, ... % weights
    cmp_func);

d0
d1
d2
d3