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



function createfigure_path(x,y1, y2, y3,tit,legend1,legend2,legend3)
%CREATEFIGURE(X1,YMATRIX1)
%  x:  vector of xvalue data
%  y1,y2,y3:  vectors of densities yvalue data

YMatrix1 = [y1; y2; y3];

% Create figure
figure1 = figure('PaperSize',[20.98 29.68],...
    'Name',tit,'Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1);
box('on');
hold('all');

% Create multiple lines using matrix input to plot
plot1 = plot(x,YMatrix1,'LineWidth',1,'Color',[0 0 0],'Parent',axes1,...
    'MarkerSize',3);
set(plot1(1),'Marker','+','LineStyle','-','DisplayName',legend1);
set(plot1(2),'Marker','o','LineStyle','-.','DisplayName',legend2);
set(plot1(3),'Marker','diamond','LineStyle',':','DisplayName',legend3);

% Create xlabel
xlabel('Time');

% Create ylabel
ylabel('Value');

% Create title
title(tit);

% Create legend
legend(axes1,'show');

