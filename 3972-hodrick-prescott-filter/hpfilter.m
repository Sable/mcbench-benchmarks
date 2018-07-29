function [s,desvabs] = hpfilter(y,w,plotter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Wilmer Henao    wi-henao@uniandes.edu.co
%   Department of Mathematics
%   Universidad de los Andes
%   Colombia
%
%   Hodrick-Prescott filter extracts the trend of a time series, the output
%   is not a formula but a new filtered time series.  This trend can be
%   adjusted with parameter w; values for w lie usually in the interval
%   [100,20000], and it is up to you to use the one you like, As w approaches infty, 
%   H-P will approach a line.  If the series doesn't have a trend p.e.White Noise, 
%   doing H-P is meaningles
%
%   [s] = hpfilter(y,w)
%   w = Smoothing parameter (Economists advice: "Use w = 1600 for quarterly data")
%   y = Original series
%   s = Filtered series
%   This program can work with several series at a time, as long as the
%   number of series you are working with doesn't exceed the number of
%   elements in the series + it uses sparse matrices which improves speed
%   and performance in the longest series
%   
%   [s] = hpfilter(y,w,'makeplot')
%   'makeplot' in the input, plots the graphics of the original series
%   against the filtered series, if more than one series is being
%   considered the program will plot all of them in different axes
%
%   [s,desvabs] = hpfilter(y,w)
%   Gives you a mesure of the standardized differences in absolute values
%   between the original and the filtered series.  A big desvabs means
%   that the series implies a large relative volatility.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
tic
if nargin < 2
    error('Requires at least two arguments.');
end

[m,n] = size (y);
if m < n
    y = y';     m = n;
end
d = repmat([w -4*w ((6*w+1)/2)], m, 1);
d(1,2) = -2*w;      d(m-1,2) = -2*w;
d(1,3) = (1+w)/2;   d(m,3) = (1+w)/2;
d(2,3) = (5*w+1)/2; d(m-1,3) = (5*w+1)/2;
B = spdiags(d, -2:0, m, m);    %I use a sparse version of B, because when m is large, B will have many zeros     
B = B+B';
s = B\y;

if nargin == 3
    t = size(y,2);
    for i = 1:t
        figure(i)
        plot(s(:,i),'r');   grid on;   hold on;   plot(y(:,i));   title(['Series #',num2str(i)]);
    end
end
if nargout == 2
    desvabs = mean(abs(y-s)./s);
end
toc