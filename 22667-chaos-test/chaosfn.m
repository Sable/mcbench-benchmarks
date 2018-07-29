function [y, J] = chaosfn(Theta, X, L, m, q, ActiveFN)
%CHAOSFN is the objective neural net function used to run
%   test for chaos and to compute the Lyapunov exponent.
%   Y = CHAOSFN(THETA, X, L, m, q, ActiveFN) where X is a
%   time series and THETA is a vector of parameters.

A   =   reshape(Theta(1:q*m), m, q)'; % size(A) = [q, m].
B   =   Theta(q*m+1:q*m+q)'; % size(B) = [q, 1].
C   =   Theta(q*m+q+1:q*m+q+q); % size(C) = [1, q].
D   =   Theta(q*m+2*q+1); % size(D) = 1.
%E   =   Theta(q*m+2*q+2:q*m+2*q+1+m); % size(E) = [1, m].

XLAG   =  lagmatrix(X, L:L:L*m); % size(XLAG) = [T, m].
XLAG   =  XLAG(m*L+1:end, :); % Remove all NaN observation.
T      =  length(X) - m*L; % New sample size.

u   =   A * XLAG' + repmat(B,1,T); % size(u) = [q, T].

%
% Initialize the analytical Jacobian needed to speed up nonlinear least
% square optimization carried out by LSQNONLIN, this Jacobian is relative
% to parameter THETA: Jacobian = dF(X)/d(THETA). Not to confuse with the
% Jacobian needed to compute the Lyapunov exponent.
%

J   =   ones(length(Theta), T);

switch upper(ActiveFN)
    case 'LOGISTIC'
        % Use the logistic function as the sigmoid activation function.
        y   =   D + C * (1 ./ (1 + exp(- u))); % size(y) = [1, T].
        %y   =   E * XLAG' + D + C * (1 ./ (1 + exp(- u))); % size(y) = [1, T].        
        
        J(1:q*m,:)   =   repmat(C', m, T) .* (repmat(XLAG', q, 1) .* ...
                        repmat(exp(- u) ./ (1 + exp(- u)).^2, m, 1)); % A.

        J(q*m+1:q*m+q,:) =  repmat(C', 1, T) .* (exp(- u) ./ (1 + exp(- u)).^2); % B.
        J(q*m+q+1:q*m+q+q,:) =  1 ./ (1 + exp(- u)); % C.
        %J(q*m+2*q+2:q*m+2*q+1+m,:)  =   XLAG'; % E.
        
    case 'TANH'
        % Use a hyperbolic tangent as the activation function. This is a
        % two layered feed-forward neural network.
        y   =   D + C * tanh(u); % size(y) = [1, T].
        %y   =   E * XLAG' + D + C * tanh(u); % size(y) = [1, T].
        
        J(1:q*m,:)   =   repmat(C', m, T) .* (repmat(XLAG', q, 1) .* ...
                        repmat(sech(u).^2, m, 1)); % A.

        J(q*m+1:q*m+q,:) =  repmat(C', 1, T) .* (sech(u).^2); % B.
        J(q*m+q+1:q*m+q+q,:) =  tanh(u); % C.
        %J(q*m+2*q+2:q*m+2*q+1+m,:)  =   XLAG'; % E.
            
    case 'FUNFIT'
        % Use another type of the activation function.
        y   =   D + C * (u .* (1 + abs(u / 2)) ./ (2 + abs(u) + u.^2 / 2));
        %y   =   E * XLAG' + D + C * (u .* (1 + abs(u / 2)) ./ (2 + abs(u) + u.^2 / 2));
        
        J(1:q*m,:)   =   repmat(C', m, T) .* (repmat(XLAG', q, 1) .* ...
                repmat(8*(1 + abs(u)) ./ (3 + (1 + abs(u)).^2).^2, m, 1)); % A.
       
        J(q*m+1:q*m+q,:) =  repmat(C', 1, T) .* (8*(1 + abs(u)) ./ ...
                            (3 + (1 + abs(u)).^2).^2); % B.
        J(q*m+q+1:q*m+q+q,:) =  u .* (1 + abs(u/2)) ./ (2 + abs(u) + u.^2 / 2); % C.
        %J(q*m+2*q+2:q*m+2*q+1+m,:)  =   XLAG'; % E.
    
    otherwise
        error(' Unrecognized activation function!')
end

%
% The obtained Jacobian is for F(x), transform it to the Jacobian of
% (X - F(X)) so it can be used by LSQNONLIN to estimate THETA.
%

J   =   - J';

%
% CHAOSFN returns (X - F(X)), because the function LSQNONLIN
% minimizes the sum of squares of the objective function.
%

y   =   X(m*L+1:end)' - y;