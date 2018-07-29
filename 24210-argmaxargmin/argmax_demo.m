function argmax_demo
% ARGMAX_DEMO    This function demonstrates the usefulness of ARGMAX.
%   A similar function could be written to demonstrate the usefulness of
%   ARGMIN.
%
%   See also ARGMAX, ARGMIN, ARGMAXMIN_MEX, MAX, MIN, MEDIAN, MEAN, SORT.

% Copyright 2009, Marco Cococcioni
% $Revision: 1.0 $  $Date: 2009/02/16 19:24:01 $

A=rand(3000, 3000);

disp(' ');
disp(' ');
disp('Comparing ARGMAX to Matlab builtin MAX:');
disp(' ');
disp(' ');

st=cputime; [V, C1max]=max(A, [], 1); ft1max = cputime-st; 
disp(sprintf('Elapsed time using Matlab builtin function ''max'' along FIRST dimension: %g sec', ft1max));
st=cputime; C1argmax=argmax(A, 1); ft1argmax = cputime-st; 
disp(sprintf('Elapsed time using function ''argmax'' along FIRST dimension: %g sec', ft1argmax)); 

st=cputime; [V, C2max]=max(A, [], 2); ft2max = cputime-st;
disp(sprintf('Elapsed time using Matlab builtin function ''max'' along SECOND dimension: %g sec', ft2max));
st=cputime; C2argmax=argmax(A, 2); ft2argmax = cputime-st;
disp(sprintf('Elapsed time using function ''argmax'' along SECOND dimension: %g sec', ft2argmax));
disp(' ');
disp(sprintf('Saved time along FIRST  dimension: %2.2f%%', 100*(ft1max-ft1argmax)/ft1max));
disp(sprintf('Saved time along SECOND dimension: %2.2f%%', 100*(ft2max-ft2argmax)/ft2max));


disp(' ');
disp(' ');
disp('Comparing MEX function ARGMAXMIN_MEX to Matlab builtin MAX:');
disp(' ');
disp(' ');


st=cputime; [V, C1max]=max(A, [], 1); ft1max = cputime-st; 
disp(sprintf('Elapsed time using Matlab builtin function ''max'' along FIRST dimension: %g sec', ft1max));
st=cputime; C1argmax=argmaxmin_mex(A, 1, 1); ft1argmax = cputime-st; 
disp(sprintf('Elapsed time using MEX function ''ARGMAXMIN_MEX'' along FIRST dimension: %g sec', ft1argmax)); 

st=cputime; [V, C2max]=max(A, [], 2); ft2max = cputime-st;
disp(sprintf('Elapsed time using Matlab builtin function ''max'' along SECOND dimension: %g sec', ft2max));
st=cputime; C2argmax=argmaxmin_mex(A, 2, 1); ft2argmax = cputime-st;
disp(sprintf('Elapsed time using MEX function ''ARGMAXMIN_MEX'' along SECOND dimension: %g sec', ft2argmax)); 
disp(' ');
disp(sprintf('Saved time along FIRST  dimension: %2.2f%%', 100*(ft1max-ft1argmax)/ft1max));
disp(sprintf('Saved time along SECOND dimension: %2.2f%%', 100*(ft2max-ft2argmax)/ft2max));


disp(' ');
disp(' ');
disp('Final considerations:');
disp(' ');
disp(' ');
disp('In general, ARGMAX is more efficient than Matlab builtin function MAX (at least, along one dimension).');
disp('There are a lot of reasons for this: the different argument checking method, ');
disp('ARGMAX is less general and thus easier to be optimized than MAX, etc...' );
disp(' ');
disp(' ');
disp('The use of ARGMAXMIN_MEX result to be SIGNIFICANTLY faster than Matlab builtin MAX in both dimensions.');
disp('This is due mainly due to the absence of argument checking, but other factors play an important role here.');
disp(' ');
disp(' ');
disp('Working on different dimensions dramatically changes the elapsed times.');
disp('This is due to the fact that Matlab stores matrices column-wise into the physical memory.');
