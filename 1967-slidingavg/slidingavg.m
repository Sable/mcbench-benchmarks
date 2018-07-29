function out = slidingavg(in, N)
%   OUTPUT_ARRAY = SLIDINGAVG(INPUT_ARRAY, N)
%
%  The function 'slidingavg' implements a one-dimensional filtering, applying a sliding window to a sequence. Such filtering replaces the center value in
%  the window with the average value of all the points within the window. When the sliding window is exceeding the lower or upper boundaries of the input
%  vector INPUT_ARRAY, the average is computed among the available points. Indicating with nx the length of the the input sequence, we note that for values
%  of N larger or equal to 2*(nx - 1), each value of the output data array are identical and equal to mean(in).
%
%  *  The input argument INPUT_ARRAY is the numerical data array to be processed.
%  *  The input argument N  is the number of neighboring data points to average over for each point of IN.
%
%  *  The output argument OUTPUT_ARRAY is the output data array.
%
%     Š 2002 - Michele Giugliano, PhD and Maura Arsiero
%     (Bern, Friday July 5th, 2002 - 21:10)
%    (http://www.giugliano.info) (bug-reports to michele@giugliano.info)
%
% Two simple examples with second- and third-order filters are
%  slidingavg([4 3 5 2 8 9 1],2)   
%  ans =
%   3.5000  4.0000  3.3333  5.0000  6.3333  6.0000  5.0000
%
%  slidingavg([4 3 5 2 8 9 1],3)
%  ans =
%   3.5000  4.0000  3.3333  5.0000  6.3333  6.0000  5.0000
%

if (isempty(in)) | (N<=0)                                              % If the input array is empty or N is non-positive,
 disp(sprintf('SlidingAvg: (Error) empty input data or N null.'));     % an error is reported to the standard output and the
 return;                                                               % execution of the routine is stopped.
end % if

if (N==1)                                                              % If the number of neighbouring points over which the sliding 
 out = in;                                                             % average will be performed is '1', then no average actually occur and
 return;                                                               % OUTPUT_ARRAY will be the copy of INPUT_ARRAY and the execution of the routine
end % if                                                               % is stopped.

nx   = length(in);             % The length of the input data structure is acquired to later evaluate the 'mean' over the appropriate boundaries.

if (N>=(2*(nx-1)))                                                     % If the number of neighbouring points over which the sliding 
 out = mean(in)*ones(size(in));                                        % average will be performed is large enough, then the average actually covers all the points
 return;                                                               % of INPUT_ARRAY, for each index of OUTPUT_ARRAY and some CPU time can be gained by such an approach.
end % if                                                               % The execution of the routine is stopped.



out = zeros(size(in));         % In all the other situations, the initialization of the output data structure is performed.

if rem(N,2)~=1                 % When N is even, then we proceed in taking the half of it:
 m = N/2;                      % m = N     /  2.
else                           % Otherwise (N >= 3, N odd), N-1 is even ( N-1 >= 2) and we proceed taking the half of it:
 m = (N-1)/2;                  % m = (N-1) /  2.
end % if

for i=1:nx,                                                 % For each element (i-th) contained in the input numerical array, a check must be performed:
 if ((i-m) < 1) & ((i+m) <= nx)                             % If not enough points are available on the left of the i-th element..
  out(i) = mean(in(1:i+m));                                 % then we proceed to evaluate the mean from the first element to the (i + m)-th.
 elseif ((i-m) >= 1) & ((i+m) <= nx)                        % If enough points are available on the left and on the right of the i-th element..
  out(i) = mean(in(i-m:i+m));                               % then we proceed to evaluate the mean on 2*m elements centered on the i-th position.
elseif ((i-m) >= 1) & ((i+m) > nx)                          % If not enough points are available on the rigth of the i-th element..
  out(i) = mean(in(i-m:nx));                                % then we proceed to evaluate the mean from the element (i - m)-th to the last one.
 elseif ((i-m) < 1) & ((i+m) > nx)                          % If not enough points are available on the left and on the rigth of the i-th element..
  out(i) = mean(in(1:nx));                                  % then we proceed to evaluate the mean from the first element to the last.
 end % if
end % for i
