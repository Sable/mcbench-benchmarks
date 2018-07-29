function X = resample_particles(X, L_log)

% Calculating Cumulative Distribution

L = exp(L_log - max(L_log));
Q = L / sum(L, 2);
R = cumsum(Q, 2);

% Generating Random Numbers

N = size(X, 2);
T = rand(1, N);

% Resampling

[~, I] = histc(T, R);
X = X(:, I + 1);
