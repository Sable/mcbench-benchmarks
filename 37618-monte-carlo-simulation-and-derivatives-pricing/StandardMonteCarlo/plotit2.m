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



function plotit2(data1,option1,m1, m2, m3, m4, m5)
figure('Color', [1 1 1]); hold on;
plot(real(data1(:,1)),'-','Color',[0 0 0],'MarkerSize',5, 'LineWidth', 2);
plot(real(data1(:,2)),'-x','Color',[0.1 0.1 0.1],'MarkerSize',5);
plot(real(data1(:,3)),':','Color',[0 0 0],'MarkerSize',5, 'LineWidth', 1);
plot(real(data1(:,4)),'--o','Color',[0.4 0.4 0.4],'MarkerSize',5);
plot(real(data1(:,5)),'--<','Color',[0.3 0.3 0.3],'MarkerSize',5); 
hold off;
title(option1); legend(m1, m2, m3, m4, m5);
end