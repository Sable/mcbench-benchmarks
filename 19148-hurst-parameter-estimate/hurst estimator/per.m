function H = per(sequence,isplot)
%
% 'per' estimate the hurst parameter of a given sequence with periodogram
%     method.
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
    isplot = 0;
end

n = length(sequence);
Xk = fft(sequence);
P_origin = abs(Xk).^2/(2*pi*n);
P = P_origin(1:floor(n/2)+1);

x = log10((pi/n)*[2:floor(0.5*n)]);
y = log10(P(2:floor(0.5*n)));

% Use the lowest 20% part of periodogram to estimate the similarity.
X = x(1:floor(length(x)/5));
Y = y(1:floor(length(y)/5));
p1 = polyfit(X,Y,1);
Yfit = polyval(p1,X);
H = (1-(Yfit(end)-Yfit(1))/(X(end)-X(1)))/2;

if isplot ~= 0
    figure,clf,hold on;
    plot(x,y,'b.');
    plot(X,Yfit,'r-','LineWidth',3);
    xlabel('log10(Frequency)'),ylabel('log10(Periodogram)'),title('Periodogram Method');
end