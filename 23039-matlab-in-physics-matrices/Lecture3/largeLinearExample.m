% large linear system example
N=500;
A=cumsum(randn(N));
c= randn(N,1);
y= A*c;
% lets take a look at A and y
subplot(2,1,1), plot(A), grid on
subplot(2,1,2), plot(y), grid on, hold on
% now solve for c using a matrix factorisation
tic, cn = A\y; toc
pause
% now take a look at the result of the factorisation
plot(A*cn,'r:')

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $
