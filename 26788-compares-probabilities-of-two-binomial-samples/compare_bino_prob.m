function [z,pv1,pv2,pv3]=compare_bino_prob(X,Y)
% [z,pv1,pv2,pv3]=compare_bino_prob(X,Y)
% Compares probabilities of two binomial samples X, Y
% Let X and Y be sets of 0 or 1, results from a Bernoully experiments
% with probability p1 for set X and p2 for set Y.
% Test the null hypothesis
%       H_0: p1 = p2
%    vs alternatives
%       H_1: p1 > p2
%       H_2: p1 < p2
%       H_3: p1 != p2
%
% Input:
%       X - row of 0 or 1
%       Y - row of 0 or 1
%
% Output:
%       z   - normal statistics N(0,1) for H_0
%       pv1 - p-value for H_1
%       pv2 - p-value for H_2
%       pv3 - p-value for H_3

% Dimiar Atanasov (2008)
% datanasov@nbu.bg

if size(X,1) > 1 || size(Y,1) > 1
    error('Sets should be rows');
end;

n_x1 = size( find(X == 1), 1 );
n_x0 = size( find(X == 0), 1 );

n_y1 = size( find(Y == 1), 2);
n_y0 = size( find(Y == 0), 2);

n_x = n_x1 + n_x0;
n_y = n_y1 + n_y0;

n_1 = n_x1 + n_y1;
n_0 = n_x0 + n_y0;

n = n_0 + n_1;

h_x = n_x1 / n_x;
h_y = n_y1 / n_y;

h = (n_x1 + n_y1)/(n_x + n_y);

if (n_1^2  / n < 5) || (n_0^2 / n < 5) || ( n_1*n_0 / n < 5)
    disp('Missing asymptotic behaviour!!!');
end;

s = h*(1-h)*(1/n_x + 1/n_y);

z = (h_x - h_y) / sqrt(s);

pv1 = 1 - normcdf(z);
pv2 = normcdf(z);
pv3 = (1 - normcdf( abs(z) ))/2;