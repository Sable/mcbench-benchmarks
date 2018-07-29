function [u,v] = GVF(f, alpha, mu, ITER)
%   GVF Compute gradient vector flow.
%   [u,v] = GVF(f, mu, ITER) computes the
%   GVF of an edge map f.  mu is the GVF regularization coefficient
%   and ITER is the number of iterations that will be computed.  

%   Chenyang Xu and Jerry L. Prince 6/17/97
%   Copyright (c) 1996-99 by Chenyang Xu and Jerry L. Prince
%   Image Analysis and Communications Lab, Johns Hopkins University

%   modified on 9/9/99 by Chenyang Xu
%   MATLAB do not deal their boundary condition for gradient and del2 
%   consistently between MATLAB 4.2 and MATLAB 5. Hence I modify
%   the function to take care of this issue by the code itself.
%   Also, in the previous version, the input "f" is assumed to have been
%   normalized to the range [0,1] before the function is called. 
%   In this version, "f" is normalized inside the function to avoid 
%   potential error of inputing an unnormalized "f".

[m,n] = size(f);
fmin  = min(f(:));
fmax  = max(f(:));
f = (f-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]

f = BoundMirrorExpand(f);  % Take care of boundary condition
[fx,fy] = gradient(f);     % Calculate the gradient of the edge map
u = fx; v = fy;            % Initialize GVF to the gradient
SqrMagf = fx.*fx + fy.*fy; % Squared magnitude of the gradient field
fprintf('Computing GVF...\n');
% Iteratively solve for the GVF u,v
for i=1:ITER,
  u = BoundMirrorEnsure(u);
  v = BoundMirrorEnsure(v);
  u = u + alpha * ( mu*4*del2(u) - SqrMagf.*(u-fx) );
  v = v + alpha * ( mu*4*del2(v) - SqrMagf.*(v-fy) );
%   fprintf(1, '%4d', i);
%   if (rem(i,20) == 0)
%      fprintf(1, '\n');
%   end 
end

u = BoundMirrorShrink(u);
v = BoundMirrorShrink(v);

