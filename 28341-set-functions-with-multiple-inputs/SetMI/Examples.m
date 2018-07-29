%% EXAMPLES
% Some basic examples on how to use mutliple input set functions:
%%
format short
%% ISMEMBERM
% *Retrieve TF and LOC index arrays for elements of "a" in sets "s1" and "s2"*

a  =  1:5   ;
s1 = (3:9).';
s2 = -1:4   ;

[tf loc] = ismemberm(a, s1, s2)
%%
% *Rretrieve TF and LOC index arrays for rows of "a" in sets "s1" and "s2"*

a  = [ 1:5 ;11:15];
s1 =   6:10;
s2 = [16:20;11:15];

[tf loc] = ismemberm(a, s1, s2,'rows')
%%     
% *NOTE* : the n-th column of TF/LOC referes to the n-th set as listed in the syntax.
%% INTERSECTM
% *Retrieve Z the set intersection of the elements in "a", "b" and "c" and the column indexes IA, IB and IC*

a =  1:5   ;
b = (3:9).';
c = -1:4   ;

[z, ia, ib, ic] = intersectm(a, b, c)
%%
% *NOTE*: Z has the size of A.
%%
% *Retrieve Z the set intersection of the rows "a", "b" and "c" and the indexes IA, IB and IC*

a = [ 1:5 ;11:15];
b =  11:15;
c = [16:20;11:15];

[z, ia, ib, ic] = intersectm(a, b, c, 'rows')
%% SETDIFFM
% *Retrieve Z the set difference of the elements in "a" that are not in "s1" OR "s2" and the column index IA*

a  =  9:12  ;
s1 = (3:9).';
s2 = -1:4   ;

[z, ia] = setdiffm(a, s1, s2)
%%
% *Retrieve Z the set difference of the rows in "a" that are not in "s1" OR "s2" and the column indexe IA*

a  = [ 1:5 ;11:15];
s1 =  11:15;
s2 = [16:20;11:15];

[z, ia] = setdiffm(a, s1, s2, 'rows')
%% UNIONM
% *Retrieve Z the set union of the elements in "a", "b" and "c" and the column indexes IA, IB and IC*

a =  1:2   ;
b = (3:4).';
c = -1:2   ;

[z, ia, ib, ic] = unionm(a, b, c)
%%
% *Retrieve Z the set union of the rows "a", "b" and "c" and the indexes IA, IB and IC*

a = [ 1:5 ;11:15];
b =  11:15;
c = [16:20;11:15];

[z, ia, ib, ic] = unionm(a, b, c, 'rows')
%%
% *NOTE*: If a value appears in several sets, UNIONM indexes its occurrence in the last set supplied. If a value
%       appears more than once in a set, UNIONM indexes the last occurrence of the value.
%% SETXORM
% *Retrieve Z the set exclusive OR of the elements in "a", "b" and "c" (elements that are not in the set
% intersection of "a", "b" and "c") and the column indexes IA, IB and IC*

a =  1:2   ;
b = (1:4).';
c = -1:2   ;

[z, ia, ib, ic] = setxorm(a, b, c)
%%
% *Retrieve Z the set exclusive OR of the rows in "a", "b" and "c" (rows that are not in the set
% intersection of "a", "b" and "c") and the column indexes IA, IB and IC*

a = [11:15;13:17];
b =  11:15;
c = [16:20;11:15];

[z, ia, ib, ic] = setxorm(a, b, c, 'rows')