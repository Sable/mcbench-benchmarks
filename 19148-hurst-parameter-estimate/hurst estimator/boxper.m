function H = boxper(sequence,isplot,boxnumber)
%
% 'boxper' estimate the hurst parameter of a given sequence with modified
%     periodogram method.
%     
% Inputs:
%     sequence: the input sequence for estimate 
%     isplot: whether display the plot. without a plot if isplot equal to 0  
% Outputs:
%     H: the estimated hurst coeffeient of the input sequence

%  Author: Chu Chen 
%  Version 1.0,  03/10/2008
%  chen-chu@163.com
%

if nargin == 1
    boxnumber = 50;
    isplot = 0;
end

if nargin == 2
    boxnumber = 50;
end

if boxnumber < 30 || boxnumber > 100
     error('The input argument boxnumber must be a integer between [30,100]');
end

n = length(sequence);
Xk = fft(sequence);
P_origin = abs(Xk).^2/(2*pi*n);
P = P_origin(1:floor(n/2)+1);

cut_min = ceil(0.001*n/2);
M = floor(logspace(log10(cut_min),log10(0.1*n-cut_min),boxnumber+1));
M = unique(M);
N = length(M)-1;

x = zeros(1,N);
y = zeros(1,N);
for i = 1:N
    m1 = M(i) + cut_min;
    m2 = M(i+1) + cut_min;
    x(i) = log10((pi * (m2 - m1))/(n));
    y(i) = log10(sum(P(m1:m2))/(m2-m1+1));
end

X = x;
Y = y;
p1 = polyfit(X,Y,1);
Yfit = polyval(p1,X);
H = (1-(Yfit(end)-Yfit(1))/(X(end)-X(1)))/2;

if isplot ~= 0
    figure,clf,hold on;
    plot(x,y,'b.');
    plot(X,Yfit,'r-','LineWidth',2);
    xlabel('Log10(Frequency)'),ylabel('Log10(Periodogram)'),title('Boxed Periodogram Method');
end