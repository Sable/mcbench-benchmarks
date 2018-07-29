function [x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,fx,fy,ITER)
% SNAKEDEFORM  Deform snake in the given external force field
%     [x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,fx,fy,ITER)
%
%     alpha:   elasticity parameter
%     beta:    rigidity parameter
%     gamma:   viscosity parameter
%     kappa:   external force weight
%     fx,fy:   external force field

%      Chenyang Xu and Jerry L. Prince, 4/1/95, 6/17/97
%      Copyright (c) 1995-97 by Chenyang Xu and Jerry L. Prince
%      Image Analysis and Communications Lab, Johns Hopkins University


% generates the parameters for snake

N = length(x);

alpha = alpha* ones(1,N); 
beta = beta*ones(1,N);

% produce the five diagnal vectors
alpham1 = [alpha(2:N) alpha(1)];
alphap1 = [alpha(N) alpha(1:N-1)];
betam1 = [beta(2:N) beta(1)];
betap1 = [beta(N) beta(1:N-1)];

a = betam1;
b = -alpha - 2*beta - 2*betam1;
c = alpha + alphap1 +betam1 + 4*beta + betap1;
d = -alphap1 - 2*beta - 2*betap1;
e = betap1;

% generate the parameters matrix
A = diag(a(1:N-2),-2) + diag(a(N-1:N),N-2);
A = A + diag(b(1:N-1),-1) + diag(b(N), N-1);
A = A + diag(c);
A = A + diag(d(1:N-1),1) + diag(d(N),-(N-1));
A = A + diag(e(1:N-2),2) + diag(e(N-1:N),-(N-2));

invAI = inv(A + gamma * diag(ones(1,N)));

for count = 1:ITER,
   vfx = interp2(fx,x,y,'*linear');
   vfy = interp2(fy,x,y,'*linear');
   
   idx = isnan(vfx) | isnan(vfy);
    vfx(idx) = 0.0;
    vfy(idx) = 0.0;
    norm_f = sqrt(vfx.*vfx + vfy.*vfy);
    min_f = min(min(norm_f));
    max_f = max(max(norm_f));
    if min_f == max_f
        norm_fn = 0.5;
    else
        k = 1 / (max_f-min_f);
        b = 1 - k*max_f;
        norm_fn = k*norm_f + b;
%   &nbsp; 
    end
    vfx = (vfx ./ (norm_f+1e-5)) .* norm_fn;
    vfy = (vfy ./ (norm_f+1e-5)) .* norm_fn;


   % deform snake
   x = invAI * (gamma* x + kappa*vfx);
   y = invAI * (gamma* y + kappa*vfy);
end
