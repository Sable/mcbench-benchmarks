%%
% This file contains an explanation of the difference between implicit and
% explicit time integration schemes.  The content is intended for those who
% want to learn a bit more than what the ForwardandBackwardEulerExplorer
% GUI can offer.This file contains an explanation of the difference between
% implicit and explicit time integration schemes.  The content is intended
% for those who want to learn a bit more than what the
% ForwardandBackwardEulerExplorer GUI can offer.  
%   Copyright 2013 The MathWorks, Inc.
clear all;
%%
% 
% Start with a simple linear ODE,
%
% $$u_t = \lambda u$$
% 
% From ODE stability analysis we know that our eigenvalues need to be in
% the left half plane.  In this case we only have one eigenvalue,
% $\lambda$.  So for stability we need $\lambda < 0$.
%
%
% Now  we can analyzed the staiblity for finite $\Delta t$.  Given the
% general for of an ODE
%
% $$ u_t = f(u,t),$$ 
%
% the Forward Euler method is expressed as:
%
% $$ u(t^{n+1}) = u(t^{n}) + \Delta t f(u(t^{n}),t^{n}).$$
%
% Applying Forward Euler to $u_t = \lambda u$ gives,
%
% $$ v^{n+1} = v^n + \lambda \Delta t v^n $$
%
% The solution has the following form,
%
% $$ v^n = g^n v^0 $$
%
% where $g$ is the amplification factor such that,
%
% $$ g = 1 + \lambda \Delta t $$
%
% We want to determine under what conditions $|g|>1$ since this would mean 
% that $v^n$ would grow unbounded as $n\rightarrow \infty$.  One way to do
% this is to solve for the stability boundary for which $|g|=1$.  To do
% this, let $g = e^{i \theta}$ (since $| e^{i \theta} |=1$) where $\theta
% = [0,2 \pi]$.  Making this substitution into the amplification factor we
% get:
%
% $$ e^{i \theta} = 1+ \lambda \Delta t \quad\Rightarrow\quad \lambda\Delta t = e^{i
% \theta} - 1.   $$
%
% For stability using Forward Euler we need
%
% $$ \lambda\Delta t \leq e^{i \theta} - 1 $$
%
theta = linspace(0,2*pi,100);
lambda_delta_t = exp(i*theta)-1;
plot(real(lambda_delta_t),imag(lambda_delta_t))
grid on;
axis([-3 3 -3 3])
text(-1.0,.3,'stable','HorizontalAlignment','center');
xlabel('real(\lambda\Delta t)')
ylabel('imag(\lambda\Delta t)')
title('Stability Region for Forward Euler')
%%
% For a given problem, i.e. with a given $\lambda$, the timestep, $\Delta
% t$, must be chosen so that the algorithm remains stable for
% $n\rightarrow\infty$. 
%
% As an example let's take $u_t = -2 u$, $u(0) = 1$.  This ODE has an exact
% solution of $u_{ex} = e^{-2t}$ which we can compare to the results of
% Forward Euler for $\Delta t = 0.9$ and $\Delta t = 1.1$.
v0 = 1;
lambda = -2;
tex = linspace(0,20);
uex = exp(-2*tex);
dt = [0.1 0.9 1.1];
for ind=1:3
    N = ceil(20/dt(ind));
    t{ind} = dt(ind)*[0:N];
    v{ind} = (1+lambda*dt(ind)).^[0:N] * v0;
end
subplot(3,1,1)
plot(tex,uex,t{1},v{1})
xlabel('t'); ylabel('v'); xlim([0 20]);
text(15,0.5,'\Delta t = 0.1')
subplot(3,1,2)
plot(tex,uex,t{2},v{2})
xlabel('t'); ylabel('v'); xlim([0 20]);
text(15,0.5,'\Delta t = 0.9')
subplot(3,1,3)
plot(tex,uex,t{3},v{3})
xlabel('t'); ylabel('v'); xlim([0 20]);
text(15,25,'\Delta t = 1.1')

%%
% If we have a stiff system with large negative real eigenvalues, using an
% explicit time integration scheme can be very inefficent as we will need
% to use very small time steps.  A more efficient approach to numerically
% integrate a stiff problem would be to use a metho with eigenvalue
% stability for large negative real eigenvalues.  Implicit methods often
% have good stability along the negative real axis.  The simplice implicit
% metho is the Backward Euler Method,
%
% $$ u(t^{n+1}) = u(t^{n}) + \Delta t f(u(t^{n+1}),t^{n+1}).$$
%
% The amplification factor for Backword Euler is 
%
% $$ g = \frac{1}{1-\lambda\Delta t}, $$
%
% and for stability using Backward Euler we need
%
% $$ \lambda\Delta t \geq e^{i\theta}+1, $$
%
% which is shown below
clf;
theta = linspace(0,2*pi,100);
lambda_delta_t = exp(i*theta)+1;
plot(real(lambda_delta_t),imag(lambda_delta_t))
grid on;
axis([-3 3 -3 3])
text(1.0,.3,'unstable','HorizontalAlignment','center');
xlabel('real(\lambda\Delta t)')
ylabel('imag(\lambda\Delta t)')
title('Stability Region for Backward Euler')
%%
% Returning to the example problem, $u_t = -2 u$, $u(0) = 1$.  We can compare to the results of
% Backward Euler for $\Delta t = 0.9$ and $\Delta t = 1.1$.
v0 = 1;
lambda = -2;
tex = linspace(0,20);
uex = exp(-2*tex);
dt = [0.1 0.9 1.1];
for ind=1:3
    N = ceil(20/dt(ind));
    t{ind} = dt(ind)*[0:N];
    v{ind} = (1/(1-lambda*dt(ind))).^[0:N] * v0;
end
subplot(3,1,1)
plot(tex,uex,t{1},v{1})
xlabel('t'); ylabel('v'); xlim([0 20]);
text(15,0.5,'\Delta t = 0.1')
subplot(3,1,2)
plot(tex,uex,t{2},v{2})
xlabel('t'); ylabel('v'); xlim([0 20]);
text(15,0.5,'\Delta t = 0.9')
subplot(3,1,3)
plot(tex,uex,t{3},v{3})
xlabel('t'); ylabel('v'); xlim([0 20]);
text(15,0.5,'\Delta t = 1.1')
%%
% So implicit methods are WAY better.  Why don't we use them all the time?
%
% Consider the Forward Euler method applied to $u_t = A u$ where $A$ is a
% $d\times d$ matrix,
%
% $$ v^{n+1} = v^{n} + \Delta t A v^{n} $$
%
% In this explicit algorithm, the largest computational cost is the matrix
% vector multiply, $Av^{n}$, which is an $\mathcal{O}(d^2)$ operation.  Now
% for the implicit Backward Euler method,
%
% $$ v^{n+1} = v^{n} + \Delta t A v^{n+1}$$
%
% Re-arraging to solve for $v^{n+1}$ gives:
%
% $$v^{n+1} - \Delta t A v^{n}= v^{n}, $$
%
% $$(I - \Delta t A) v^{n}= v^{n}. $$
%
% Thus to vind $v^{n+1}$ for Backward Euler requires the solution of a $d
% \times d$ system of equations which is an $\mathcal{O}(d^3)$ cost.  As a
% result, for large systems, the cost of the $\mathcal{O}(d^3)$ linear
% solution may begin to outweigh the benefits of the larger timesteps that
% are possible when using implicit methods.

