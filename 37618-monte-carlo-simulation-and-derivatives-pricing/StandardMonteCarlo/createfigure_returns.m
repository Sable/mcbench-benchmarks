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



function createfigure_returns(x,y1, y2, y3,tit,legend1,legend2,legend3)
%CREATEFIGURE(X1,YMATRIX1)
%  x:  vector of xvalue data
%  y1,y2,y3:  vectors of densities yvalue data

% Create figure
figure('PaperSize',[20.98 29.68],...
    'Name',tit,'Color',[1 1 1]);

% Create axes
box('on');
hold('all');

ylow = min(min(y2),min(y3)); ylow = min(ylow,min(y1));
yhigh = max(max(y2),max(y3)); yhigh = max(yhigh, max(y1));

%ylow = -0.1;
%yhigh = 0.1;

subplot(3,1,1); plot(x,y1, 'black','DisplayName',legend1); xlabel('Time'); ylabel('Return Value');ylim([ylow yhigh]);title(legend1);
subplot(3,1,2); plot(x,y2, 'black', 'DisplayName',legend2); xlabel('Time'); ylabel('Return Value');ylim([ylow yhigh]);title(legend2);
subplot(3,1,3); plot(x,y3, 'black', 'DisplayName',legend3); xlabel('Time'); ylabel('Return Value');ylim([ylow yhigh]);title(legend3);


