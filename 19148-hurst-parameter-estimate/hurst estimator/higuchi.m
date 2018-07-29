function H = higuchi(sequence,isplot)
%
% 'higuchi' estimate the hurst parameter of a given sequence with
%     higuchi's method.
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

sequence = cumsum(sequence);
N = length(sequence);
mlarge = floor(N/5);
M = [floor(logspace(0,log10(mlarge),50))];
M = unique(M(M>1));
n = length(M);
cut_min = ceil(n/10);
cut_max = floor(6*n/10);

curve_length = zeros(1,n);
for h = 1:n
    m = M(h);
    k = floor((N-m)/m);
    temp_length = zeros(m,k);
    
    for i = 1:m
        for j = 1:k
            temp_length(i,j) = abs(sequence(i+j*m)-sequence(i+(j-1)*m));
        end
    end
    
    curve_length(h) = sum(mean(temp_length,2)) * ((N-1)/m^3);
end

x = log(M);
y = log(curve_length);
X = x(cut_min:cut_max);
Y = y(cut_min:cut_max);
p1 = polyfit(X,Y,1);
Yfit = polyval(p1,X);
yfit = polyval(p1,x);
H = 2 + (Yfit(end)-Yfit(1))/(X(end)-X(1));

if isplot ~= 0
    figure,hold on;
    plot(x,y,'b*');
    plot(X,Yfit,'r-','LineWidth',2);
    plot(x(1:cut_min),yfit(1:cut_min),'r:','LineWidth',2);
    plot(x(cut_max:end),yfit(cut_max:end),'r:','LineWidth',2);
    xlabel('Log10(Aggregate Level)'),ylabel('Log10(Curve Legnth)'),title('Higuchi Method');
end