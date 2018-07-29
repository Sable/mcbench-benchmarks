function [x_guess Iter] = VMPCM(ode,tau,x_guess,omega1,omega2,errTol,varargin)
%Purpose:
%Generic Function wrapper for the Vectorized Picard Chebyshev Method
%-------------------------------------------------------------------------%
%                                                                         %
% Inputs:                                                                 %
%--------                                                                  
%ode                    object                          function name to
%                                                       evaluate i.e.
%                                                       @jatForces
%
%tau                    [N x 1]                         transformed time
%                                                       domain vector
%
%x_guess                [N x M]                         Initial Guess of
%                                                       solution values for
%                                                       the Picard
%                                                       Chebyshev Method
%
%omega1                 double                          First Omega Term
%
%omega2                 double                          Second Omega Term
%
%errTol                 double                          Error Tolerance of
%                                                       solution
%
%varargin                                                Additional inputs
%                                                       which are needed to
%                                                       be passed to the
%                                                       evaluation function
%                                                       ode
%
% Outputs:
%---------                                                                %
%x_guess                  [N x M]                        Refined solution
%                                                        meeting the error
%                                                        tolerances defined
%                                                        by errTol
%
%--------------------------------------------------------------------------
% Programmed by Darin Koblick 03-04-2012                                  %
%-------------------------------------------------------------------------- 
tau = tau(:)';
N = numel(tau)-1;
err1 = Inf;
err2 = Inf;
Iter = 0;
MaxIter = 300;
%disp('Running The Picard Chebyshev Algorithm')
tic;
%Initialize Constant Matricies up front so we don't have to recompute them
%which would slow down the iterative process
%--------------------------------------------------------------------------
T = ChebyshevPolynomial((0:N+1)',tau);
V = ones(1,length(tau))./N;
V(2:end-1) = V(2:end-1).*2;
TV1 = bsxfun(@times,T(1:N,:),V);
TV2 = bsxfun(@times,T(3:N+2,:),V);
TV = bsxfun(@rdivide,(TV1-TV2),(2.*(1:N))');
TV(end,:) = TV1(end,:)./(2*N)';
S = 2.*((-1).^((1:N)+1));
Cx = T(1:N+1,1:N+1)';
Cx(:,1) = Cx(:,1)./2;
%--------------------------------------------------------------------------
while (any(errTol < err1 ) || any(errTol < err2)) && Iter < MaxIter
    Iter = Iter + 1;
    %disp(['-------- Iteration # ',num2str(Iter),' -----------']);
    input = {omega2.*tau+omega1,x_guess,varargin{:}};
    F = ode(input{:}).*omega2;
    if size(F,2) == 1 || size(F,1) == 1
       F = F'; 
    end
    Beta_r = NaN(size(TV,1),size(F,2));
    Beta_k = NaN(size(TV,1) + 1, size(F,2));
    x_new = Beta_k;
    %Matrix Multiply
    for i=1:size(F,2)
        Beta_r(:,i) = TV*F(:,i);
        Beta_k(:,i) = [S*Beta_r(:,i) + 2.*x_guess(1,i); Beta_r(:,i)];
        x_new(:,i) = (Cx*Beta_k(:,i));
    end
    if any(size(x_new) ~= size(F))
       x_new = x_new'; 
    end
    err2 = err1;
    err1 = max(abs(x_new - x_guess),[],2);
    disp(['Max Error Is found to be: ', num2str(max(err1))]);
    x_guess = x_new;
end
end

function Tk = ChebyshevPolynomial(k,tau)
%The Chebyshev polynomial,T, corresponding to degree k
Tk = cos(bsxfun(@times,k,acos(tau)));
end