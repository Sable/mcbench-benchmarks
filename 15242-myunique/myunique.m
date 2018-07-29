function [a ndx h]=myunique(a,mode)
% MYUNIQUE is a function to find unique elements in a numeric vector
% without sorted output. "mode" is used to store first or last repeting
% entries (default is first). "ndx" is the indices of the unique elements
% and "h" is number of occurances of repeating entries respectively
% 
% Example:
% >> a=[9 3 6 2 7 1 2 1 1 1 9 9 3 3];
% >> myunique(a)
%  ans =
%
%      9     3     6     2     7     1
% >> myunique(a,'last')
% ans =
% 
%      6     7     2     1     9     3
%
% Mehmet OZTURK

if nargin==1
    mode='first';
end

[r c]=size(a); u=max(r,c);
[s si]=sort(a);
ds = false(r,c);
v=1:(u+1);
esit=diff(s)==0;

if strcmpi(mode,'last')
    ds(1:end-1) = esit;
    v=v(not([false;ds(:)]));
    h=diff(v);
else
    ds(2:end)   = esit;
    v=v(not([ds(:);false]));
    h=diff(v);
end

si(ds)=[];
[ndx ndxi]=sort(si);
h=h(ndxi);
a=a(ndx);