clear all;
clc;

% Forward Euclidean
[d, q, a, b, f] = extendedEuclidean_forward(1239,735);
%[d, q, a, b, f] = extendedEuclidean_forward(65, 40);
%[d, q, a, b, f] = extendedEuclidean_forward(36163, 21199);
%[d, q, a, b, f] = extendedEuclidean_forward(36163, 1058);
[d, q, a, b, f] = extendedEuclidean_forward(819, 462); % -9*819 + 16*462 = gcd(819, 462) = 21.
[d, q, a, b, f] = extendedEuclidean_forward(3210, 17);

% Euclidean (method of back-substitution)
[x, y] = extendedEuclidean_backSubstitution (d, q, a, b, f);

%{
 *     % java ExtendedEuclid 36163 21199
 *     gcd(36163, 21199) = 1247
 *     -7(36163) + 12(21199) = 1247
 *
 *     % java ExtendedEuclid 36163 1058
 *     gcd(36163, 1058) = 1
 *     493(36163) + -16851(1058) = 1
%}