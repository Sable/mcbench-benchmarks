% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



xvals = [1 .1 .01 .001 .0001 .00001] / 260;         % we assume 260 business days
x1 = -Stunorm4(xvals);   % the result
x2 = -Stunorm(xvals,3);
x3 = -QuantileN(xvals);

figure('Color',[1 1 1]); hold on;
plot(-log10(xvals)',x1, 'LineStyle','-','Color', [0 0 0]);
plot(-log10(xvals)', x2, 'LineStyle', ':','Color', [0 0 0]);
plot(-log10(xvals)', x3, 'LineStyle', '--','Color', [0 0 0]);
hold off;
title('VaR for T_4, T_3, N');
legend('VaR T_4', 'VaR T_3', 'VaR N');
box('on');

xvals = 10.^(-[1 2 3 4 5 6]);
x1 = -Stunorm4(xvals);   % the result
x2 = -Stunorm(xvals,3);
x3 = -QuantileN(xvals);
y1 = -StuCVaR4(xvals);
y2 = -StuCVaR(xvals,3);
y3 = -NCVaR(xvals);


figure('Color',[1 1 1]);hold on;
plot(-log10(xvals)',x1, 'LineStyle','-','Color', [0 0 0]);
plot(-log10(xvals)',x2,'LineStyle', ':','Color', [0 0 0]);
plot(-log10(xvals)',x3,'LineStyle', '--','Color', [0 0 0]);
plot(-log10(xvals)',y1, 'LineStyle','-','Color', [0 0 0]);
plot(-log10(xvals)',y2,'LineStyle', ':','Color', [0 0 0]);
plot(-log10(xvals)',y3,'LineStyle', '--','Color', [0 0 0]);
hold off;
title('CVaR and VaR for T_4, T_3 and N');
legend('CVaR T_4', 'CVaR T_3', 'CVaR N', 'VaR T_4', 'VaR T_3', 'VaR N');
box('on');
