function [S,t,V] = AmericanOption(K,T,r,delta,sigma,type,m,n)

% Input:
%
%   K     = strike price
%   T     = maturity time
%   r     = interest rate
%   delta = rate of dividend payment
%   sigma = volatility
%   type  = type of option ('call' or 'put')
%
% Output:
%
%   S = range of stock prices
%   t = range of time points from 0 to T
%   V = corresponding option prices, i.e.
%   %   V(i,j) is an approximation of V(S(i),t(j))

%% Verification

switch type
    case 'call'
        % For a call, r must be larger than delta 
        if r <= delta
            error('r must be larger than delta')
        end
    case 'put'
    otherwise
        error('type must be call or put')
end
         
%% Define parameters

% dimensionless parameters
q       = 2*r/sigma^2;
q_delta = 2*(r-delta)/sigma^2;

% asset space
x_min = -5;
x_max = 5;
dx      = (x_max-x_min)/m;

% time space
tau_max = .5*sigma^2*T;
dtau    = tau_max/n;

% numerical parameters
eps     = 1e-6;
theta   = .5;
omega_R = 1;
lambda  = dtau/dx^2;
alpha   = lambda*theta;

% verify stability condition

if lambda > .5
    s = sprintf('lambda = %4.2f',lambda);
    disp(s)
    error(strcat('The algorithm is unstable. Stability can be obtained ',...
          ' by increasing the value of n or by decreasing the value of m'))
end
%% Initialization

% state and time space
x   = (x_min:dx:x_max)';
tau = 0:dtau:tau_max;

% For performance reasons we compute one matrix with all the g values
X = repmat(x,1,n+1);
Y = repmat(tau,m+1,1);
G = g(X,Y);

% dimensionless option value
w = zeros(m+1,n+1);

% boundary conditions
w(:,1)   = G(:,1);
w(1,:)   = G(1,:);
w(m+1,:) = G(end,:);

% righthandside is needed in core algorithm
b = zeros(m-1,1);

% SOR iteration vector needs to be pre-allocated only once
vnew = zeros(m-1,1);

%% Core algorithm

for j = 2:n+1

    % create righthandside b
    for k = 1:m-1
        switch k
            case 1
                b(k) = w(2,j-1)+lambda*(1-theta)*(w(1,j-1)-2*w(2,j-1)+w(3,j-1))+alpha*w(1,j);
            case m-1
                b(k) = w(m,j-1)+lambda*(1-theta)*(w(m-1,j-1)-2*w(m,j-1)+w(m+1,j-1))+alpha*w(m+1,j);
            otherwise
                b(k) = w(k+1,j-1)+lambda*(1-theta)*(w(k,j-1)-2*w(k+1,j-1)+w(k+2,j-1));
        end
    end
    
    % initialize vector v
    v    = max(w(2:m,j-1),G(2:m,j));

    % the variable iter is introduced to manage the SOR iteration
    iter = 1; 
    
    % SOR iteration
    while iter == 1
        for k = 1:m-1
            switch k
                case 1
                    rho = (b(k)+alpha*v(k+1))/(1+2*alpha);
                case m-1
                    rho = (b(k)+alpha*vnew(k-1))/(1+2*alpha);
                otherwise
                    rho = (b(k)+alpha*(vnew(k-1)+v(k+1)))/(1+2*alpha);
            end
            vnew(k) = max(G(k+1,j),v(k)+omega_R*(rho-v(k)));
        end
        if norm(v-vnew) <= eps
            iter = 0;
        else
            v = vnew;
        end
    end
    w(2:m,j) = vnew;                
end

%% Transformation to original dimensions

S = K*exp(x);
t = T-2*tau/sigma^2; 
V = K*exp(-.5*(q_delta-1)*x)*exp(-(.25*(q_delta-1)^2+q)*tau).*w;

% re-arrange t and V in increasing time order

t = fliplr(t);
V = fliplr(V);

%% Define function g as a nested function

function boundary = g(x,tau)
    
    % This function is the lower bound for the dimensionless solution
    % of the linear complementarity problem. It is also used for
    % the boundary and initial conditions. 
    
    abb1 = exp(((q_delta-1)^2+4*q)*tau/4);
    abb2 = exp((q_delta-1)*x/2);
    abb3 = exp((q_delta+1)*x/2);
    switch type
        case 'put'
            boundary = abb1.*max(abb2-abb3,0);
        case 'call'
            boundary = abb1.*max(abb3-abb2,0);
    end
end

end
