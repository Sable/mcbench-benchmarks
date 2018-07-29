function H = aggvar(sequence,isplot)
%
% 'aggvar' estimate the hurst parameter of a given sequence with aggregate
%     variance method.
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

N = length(sequence);
mlarge = floor(N/5);
M = [floor(logspace(0,log10(mlarge),50))];
M = unique(M(M>1));
n = length(M);
cut_min = ceil(n/10);
cut_max = floor(6*n/10);

V = zeros(1,n);
for i = 1:n
    m = M(i);
    k = floor(N/m);
    matrix_sequence = reshape(sequence(1:m*k),m,k);
    V(i) = var(sum(matrix_sequence,1)/m);
end

x = log10(M);
y = log10(V);
y1 = -x+y(1)+x(1);
X = x(cut_min:cut_max);
Y = y(cut_min:cut_max);
p1 = polyfit(X,Y,1);
Yfit = polyval(p1,X);
yfit = polyval(p1,x);
beta = -(Yfit(end)-Yfit(1))/(X(end)-X(1));
H = 1-beta/2;

if isplot ~= 0
    figure,hold on;
    plot(x,y,'b*');
    h = plot(x,y1);
    plot(X,Yfit,'r-','LineWidth',2);
    plot(x(1:cut_min),yfit(1:cut_min),'r:','LineWidth',2);
    plot(x(cut_max:end),yfit(cut_max:end),'r:','LineWidth',2);
    xlabel('log10(Aggreate Level)'), ylabel('log10(Viance)'), title('Time Viance Method');
end