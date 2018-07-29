%% Calculation of distance between strings
%   Function strdist(r,b,krk,cas) is intended for calculation of distance
% between strings.It computes Levenshtein and editor distances with use of
% Vagner-Fisher algorithm. Levenshtein distance is the minimal quantity of
% character substitutions, deletions and insertions for transformation of
% string r into string b. An editor distance is computed as Levenstein
% distance with substitutions weight of 2. 
%% DESCRIPTION
% *d=strdist(r)* computes numel(r); *d=strdist(r,b)* computes Levenshtein
% distance between r and b. If b is empty string then d=numel(r);
% *d=strdist(r,b,krk)* computes both Levenshtein and editor distance when
% krk=2. *d=strdist(r,b,krk,cas)*  computes
% a distance in accordance with krk and cas.If cas>0 then case is ignored. 
%% EXAMPLE
% d1 - Levenstein distance, d2 - Levenstein and editor distances
d1=strdist('statistics','mathematics')
d2=strdist('statistics','mathematics',2)
%%
% |How to count substitutions:|
disp('Quantity of substitutions:')
disp(d2(2)-d2(1))
%%
% |Case sensitive:|
strdist('MATLAB','MathWorks',2)
%%
% |Case non-sensitive:|
strdist('MATLAB','MathWorks',2,1)


