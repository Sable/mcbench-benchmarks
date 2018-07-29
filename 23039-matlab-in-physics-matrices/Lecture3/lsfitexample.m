% load the data
load lsfitexampledata
[N,M]=size(data);
% prepare the "quadratic regression matrix" A
% also known as the Vandermonde matrix
A = [ones(N,1),data(:,1), data(:,1).^2];
b = data(:,2);
% solve using least-squares
c = A\b;
% examine the fit
plot(data(:,1),data(:,2),'o',data(:,1),A*c)
grid on, title('Quadratic fit of experimental data')
xlabel('Time'), ylabel('Distance fallen')
% g is twice the coefficient of the quadratic term
g=2*c(3)

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $
