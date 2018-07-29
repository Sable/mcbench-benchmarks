function [A,B,C,D,dx,y]=linearizor(f,x,u,h)
%LINEARIZOR A linearization tool for nonlinear dynamic systems
%For a nonlinear dynamic system:
%       dx/dt = f(x,u)
%           y = h(x,u)
%or a nonlinear discrete system
%       x_k+1 = f(x_k,u_k)
%       y_k   = h(x_k,u_k)
%[A,B,C,D]=linearizor(f,x,u,h) linearizes the system at the reference point 
% specified by the state vector, x and input vector, u and returns matrices 
% corresponding to the linearized state space model:
%       dx/dt = Ax + Bu
%           y = Cx + Du
% or in discrete form (if original nonlinear system is discrete)
%       x_k+1 = Ax_k + Bu_k
%       y_k   = Cx_k + Du_k
%With the full output, [A,B,C,D,dx,y]=linearizor(f,x,u,h) also returns
%          dx = f(x,u) and y = h(x,u)
%
%In inputs, if h is not specified, it assumes y = x, and if u is an empty
%vector or not specified, then dx/dt = f(x) and y = h(x).
%
%Algorithm: the code uses the complex step differentiation to get the
%Jacobians of nonlinear functions, f and h at the point specified by x and u.
%
%The code is a complement to the existing MATLAB functions, linmod,
%linmod2, dlinmod, and linmodev5, which can only perform linearization on
%Simulink models.
%
%Example: A recurrent neural network model dx/dt=W2*tanh(Wx*x+Wu*u); y=Cx;
%nx = 4;                            % number of states
%nu = 2;                            % number of inputs
%nh = 6;                            % number of hidden nodes
%ny = nu;                           % number of inputs
%Wx = rand(nh,nx);                  % Weight of states
%Wu = rand(nh,nu);                  % Weight of inputs
%W2 = rand(nx,nh);                  % Weight of the second layer
%C = eye(ny,nx);                    % Output matrix
%f = @(x,u) W2*tanh(Wx*x+Wu*u);     % state equation
%h = @(x) C*x;                      % output equation
%x = randn(nx,1);                   % reference state
%u = randn(nu,1);                   % reference input
%[A,B,C,D] = linearizor(f,x,u,h);   % linearization
%
%By Yi Cao, at Cranfield University, 03/01/2008
%

%Input check
error(nargchk(2,4,nargin))
if nargin<3 || isempty(u)       
    [A,dx]=jaccsd(f,x);             %state equations without input
    B=[];
    nu = 0;
else
    [A,dx]=jaccsd(@(x)f(x,u),x);    %state equations with input
    B=jaccsd(@(u)f(x,u),u);
    nu = numel(u);
end
if nargout<3
    return
end
if nargin<4                         
    C=eye(numel(x));                %cases full state output
    D=zeros(numel(x),nu);
    y=x;
else
    try 
        [C,y]=jaccsd(@(x)h(x,u),x);     %output equation with input
        D=jaccsd(@(u)h(x,u),u);
    catch
        [C,y]=jaccsd(h,x);              %output equations without input
        D=[];
    end
end

function [A,z]=jaccsd(fun,x)
% JACCSD    Complex Step Jacobian
% J = jaccsd(f,x) returns the numberical (m x n) Jacobian matrix of a 
% m-vector function, f(x) at the refdrence point, x (n-vector).
% [J,z] = jaccsd(f,x) also returns the function value, z=f(x).
%
%
z=fun(x);                       % function value
n=numel(x);                     % size of independent
m=numel(z);                     % size of dependent
A=zeros(m,n);                   % allocate memory for the Jacobian matrix
h=n*eps;                        % differentiation step size
for k=1:n                       % loop for each independent variable 
    x1=x;                       % reference point
    x1(k)=x1(k)+h*i;            % increment in kth independent variable
    A(:,k)=imag(fun(x1))/h;     % complex step differentiation 
end
