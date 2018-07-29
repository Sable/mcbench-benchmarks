% Demo

% Generate Sparse Signal
signal = GenSig(150, 10);
% Create Measurement Matrix
A=matrix_normalizer(randn(100,150));
% Create Measured Signal
y = A*signal;

% reconstruct Signal by OLS
[s1, residual] = OLS(A, y, 10);
stem(signal), hold on, stem(s1,'r+')
close
% reconstruct Signal by ROLS
[s2, residual] = ROLS(A, y, 10);
stem(signal), hold on, stem(s2,'r+')
close
% reconstruct Signal by StOLS
[s3, residual] = StOLS(A, y);
stem(signal), hold on, stem(s3,'r+')
close all