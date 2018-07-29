function cdfplot(X)
% cdfplot(X) 
% displays a plot of the Empirical Cumulative Distribution Function 
% (CDF) of the input array X in the current figure. The empirical 
% CDF y=F(x) is defined as the proportion of X values less than or equal to x.
% If input X is a matrix, then cdfplot(X) parses it to the vector and 
% displays CDF of all values.
%
% EXAMPLE:
% figure;
% cdfplot(randn(1,100));
% hold on;
% cdfplot(-log(1-rand(1,100)));
% cdfplot(sqrt(randn(1,100).^2 + randn(1,100).^2))
% legend('Normal(0,1) CDF', 'Exponential(1) CDF', 'Rayleigh(1) CDF', 4)

% Version 1.0
% Alex Podgaetsky, September 2003
% alex@wavion.co.il
%
% Revisions:
%       Version 1.0 -   initial version

tmp = sort(reshape(X,prod(size(X)),1));
Xplot = reshape([tmp tmp].',2*length(tmp),1);

tmp = [1:length(X)].'/length(X);
Yplot = reshape([tmp tmp].',2*length(tmp),1);
Yplot = [0; Yplot(1:(end-1))];

figure(gcf);
hp = plot(Xplot, Yplot);

ColOrd = get(gca, 'ColorOrder'); 
ord = mod(length(get(gca,'Children')), size(ColOrd,1)); 
set(hp, 'Color', ColOrd((ord==0) + (ord>0)*ord, :));
if ~ishold
     xlabel('X', 'FontWeight','b','FontSize',12);
     ylabel('F(X)', 'FontWeight','b','FontSize',12);
     title('Empirical CDF', 'FontWeight','b','FontSize',12);
     grid on;
end
