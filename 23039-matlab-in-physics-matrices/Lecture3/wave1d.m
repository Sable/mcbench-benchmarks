N=100;
col=ones(N,1);
% make differentiation matrix
D=-spdiags([col,-2*col,col],(-1:1),N,N);
% solve eigenvalue problem
[F,V]=eigs(D,10,'sa');
% fix boundary points
F=[zeros(1,10);F;zeros(1,10)];
plot(F(:,1:4),'linewidth',3), grid on, axis tight
title('Standing waves')

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $
