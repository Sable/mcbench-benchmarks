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



function plotit(data1,option1,m1, m2, m3, m4, m5, m6, m7, m8, m9, m10)
figure('Color', [1 1 1]); hold on;
plot(real(data1(:,1)),'-x','Color',[0 0 0],'MarkerSize',4);
plot(real(data1(:,2)),'-o','Color',[0.1 0.1 0.1],'MarkerSize',4);
plot(real(data1(:,3)),'--x','Color',[0.4 0.4 0.4],'MarkerSize',4);
plot(real(data1(:,4)),'--o','Color',[0.4 0.4 0.4],'MarkerSize',4);
plot(real(data1(:,5)),'-<','Color',[0.3 0.3 0.3],'MarkerSize',4);
plot(real(data1(:,6)),'--<','Color',[0.3 0.3 0.3],'MarkerSize',4);
plot(real(data1(:,7)),'-s','Color',[0.4 0.4 0.4],'MarkerSize',4);
plot(real(data1(:,8)),'-o','Color',[0.2 0.2 0.2],'MarkerSize',4);
plot(real(data1(:,9)),'--s','Color',[0.4 0.4 0.4],'MarkerSize',4);
plot(real(data1(:,10)),'--o','Color',[0.2 0.2 0.2],'MarkerSize',4); 
hold off;
title(option1); legend(m1, m2, m3, m4, m5, m6 ,m7, m8, m9, m10);
end