%%
N=5;
I=ones(N,1);
D2 = spdiags([I, -2*I, I],[-1:1],N,N);
full(D2)
%%
% Here we use the construct 
%  spdiags
% to tell MATLAB that the matrix is sparse, i.e. is composed of mainly zero
% elements. In fact, this particular type of sparsity pattern is called
% *tridiagonal*. Consider the second row of this matrix multiplied by a
% vector which is the function evaluated on the grid of points $$x_i$,
% $$\left[f(x_0), f(x_1), f(x_2),\cdots,f(x_N)\right]^T$. We have the following 
% result:
%%
% <latex>
% $ \left(\begin{array}{cccccc} 1&-2&1&0&\cdots&0 \end{array}\right)\times
% \left(\begin{array}{c} f(x_0) \\ f(x_1) \\ f(x_2) \\ \vdots \\
% f(x_N)\end{array}\right) = f(x_0)-2\times f(x_1)+f(x_2)$
% </latex>
%%
% That is, the result of multiplying the second row of the differentiation
% matrix by a vector representing our function on the grid, gives an
% approximation to the derivative of our function on the grid. As an
% example, let's calculate the second derivative of $$ f(x)=\exp^{\sin(x)}$ 
% on a grid of 21 points:
N=21; x=linspace(0,2*pi,N)'; % set up the grid
I=ones(N,1); dx=x(2)-x(1);
D2 = spdiags([I, -2*I, I],[-1:1],N,N)/dx^2; %2nd derivative matrix
f=@(x)(exp(sin(x))) % function
d2 = D2*f(x);       % numerical derivative
d2(1)=1; d2(N)=1;   % fix boundary points
figure('color',[1 1 1])
plot(x,f(x),x,d2), grid on, hold on
d2f=@(x)(cos(x).^2.*exp(sin(x))-sin(x).*exp(sin(x))) % actual second derivative
plot(x,d2f(x),'r-.')
title('Approximating a second derivative using a differentiation matrix');
legend('f(x)=exp^{sin(x)}','Approximate 2^{nd} deriv','Actual 2^{nd} deriv');
hold off

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $
