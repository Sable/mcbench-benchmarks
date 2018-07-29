% Use the MDL method as in Lin (1997) to compute the model
% order for the signal. You must pass the vector of
% singular values, i.e. the result of svd(T) and 
% N and L. This method is best explained by Scharf (1992).
%
% e.g. 
% N = length(y);
% L = floor(0.5*N);
% T = conj(hankel(y(1:N-L),y(N-L:N).'));
%
% M = estimate_model_order(svd(T), N, L);
%
function M = estimate_model_order(s, N, L)

mdl = [];

% copied direct from Lin's code - his transformation of
% the formula is more robust than just implementing what
% is stated in the analytic version
for k = 0:1:L-1
    val = -N*sum(log(s(k+1:L))) ...
        + N*(L-k)*log((sum(s(k+1:L))/(L-k))) + k*(2*L-k)*log(N)/2;

    mdl = [mdl; val];
end

[val, M] = min(mdl);
M = M - 1;
%fprintf('\nModel order is: %d', M);
