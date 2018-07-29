function y=mode(x)
% MODE finds the mode of a sample.  The mode is the
% observation with the greatest frequency.
%
% i.e. in a sample x=[0, 1, 0, 0, 0, 3, 0, 1, 3, 1, 2, 2, 0, 1]
% the mode is the most frequent item, 0.


% IT'S NOT FANCY BUT IT WORKS
% Michael Robbins
% robbins@bloomberg.net
% michael.robbins@us.cibc.com

%tic;
[b,i,j] = unique(x);
h = hist(j,length(b));
m=max(h);
y=b(h==m);
%toc

% FEX SUGGESTION IS SLOWER
% tic;
% sorted=sort(x(:));
% [d1, i1]=unique(sorted);
% h=[i1(1); diff(i1)];
% m=max(h);
% m=d1(h==m); 
% toc