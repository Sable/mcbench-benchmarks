function K = findK(S, variance)

% Find number of Principal Components (K) based on variance needed
% Formula for calculating minimum K : 
% {[trace from i=1 to K of S]/[trace of S]} >= variance

traceS = trace(S); % Calculate sum of diagonal elements of S

for i=1:size(S,2)
    tempS = sum(diag(S(1:i,1:i))); % sum of K diagonal elements
    if ((tempS/traceS) >= (variance/100))
        break;
    end
end

K = i;