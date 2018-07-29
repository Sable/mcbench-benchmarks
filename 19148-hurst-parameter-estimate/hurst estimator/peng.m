function H = peng(sequence,isplot)
%
% 'peng' estimate the hurst parameter of a given sequence with residuals
%     of regression method. 
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

% Calculate aggregate level.
N = length(sequence);
FBM = cumsum(sequence);
mlarge = floor(N/5);
msmall = max(10,log10(N)^2);
M = floor(logspace(log10(msmall),log10(mlarge),50));
M = unique(M);
n = length(M);
cut_min = ceil(n/10);
cut_max = floor(7*n/10);

% Calculate residuals under different aggregate level.
Goble_residuals = zeros(1,n);
for i = 1:n
    m = M(i);
    k = floor(N/m);
    matrix_FBM = reshape(FBM(1:m*k),m,k);
    x = 1:m;
    Local_residual = zeros(1,k);
    
    for j = 1:k
        y = matrix_FBM(:,j);
        vv=[x' ones(length(x),1)];
        p=vv\y;
        norm_xx=norm(y-vv*p);
        Local_residual(j) = norm_xx.^2/m;
    end
    
    Goble_residuals(i) = mean(Local_residual);
end

% Fit and calculate H.
x = log10(M);
y = log10(Goble_residuals);
X = x(cut_min:cut_max);
Y = y(cut_min:cut_max);
p1 = polyfit(X,Y,1);
Yfit = polyval(p1,X);
yfit = polyval(p1,x);
H = 0.5*(Yfit(end)-Yfit(1))/(X(end)-X(1));

if isplot ~= 0
    figure,hold on;
    plot(x,y,'b*');
    plot(X,Yfit,'r-','LineWidth',2);
    plot(x(1:cut_min),yfit(1:cut_min),'r:','LineWidth',2);
    plot(x(cut_max:end),yfit(cut_max:end),'r:','LineWidth',2);
    xlabel('Log of Aggregate Level'),ylabel('Log of Residual Vaiance'),title('Peng Method');
end