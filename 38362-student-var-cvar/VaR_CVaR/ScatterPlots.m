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



N = 1000;
corr = 0;

mu = [0 0];
Sigma = [1 corr; corr 1]; R = chol(Sigma);

z = repmat(mu,N,1) + randn(N,2)*R;

figure('Color',[1 1 1]);scatter(z(:,1),z(:,2)); ylim([-5,5]); xlim([-5,5]);
title('Independence');
xlabel('x'); ylabel('y');

corr = 0.99;
Sigma = [1 corr; corr 1]; R = chol(Sigma);

z = repmat(mu,N,1) + randn(N,2)*R;

figure('Color',[1 1 1]);scatter(z(:,1),z(:,2)); ylim([-5,5]); xlim([-5,5]);
title('Positive Dependence');
xlabel('x'); ylabel('y');


corr = -0.99;
Sigma = [1 corr; corr 1]; R = chol(Sigma);

z = repmat(mu,N,1) + randn(N,2)*R;

figure('Color',[1 1 1]);scatter(z(:,1),z(:,2)); ylim([-5,5]); xlim([-5,5]);
title('Negative Dependence');
xlabel('x'); ylabel('y');