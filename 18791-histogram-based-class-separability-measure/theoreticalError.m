function [E, E1, E2, x] = theoreticalError(m1, s1, m2, s2)

%
% ARGUMENTS:
% m1, s1: average and std values of the Gaussian distribution of the 1st class
% m2, s2: average and std values of the Gaussian distribution of the 2nd class
%
% RETURN VALUES:
% E1: the probability a sample from the 1st class is (mis)classified to class 2
% E2: the probability a sample from the 2nd class is (mis)classified to class 1
% E: (E1+E2)/2
% x: histogram values range
%
% Computes the theoretical BAYES error for two random GAUSSIAN
% distribution.

step = 0.00050;
x = min(m1-3*s1,m2-3*s2): step : max(m1+3*s1,m2+3*s2);


% generate pdfs:
PDF1 = (1/(sqrt(2*pi*s1))) * exp(-((x-m1).^2)/(2*s1));
PDF2 = (1/(sqrt(2*pi*s2))) * exp(-((x-m2).^2)/(2*s2));

if (m1<m2)
    [MM,I1] = (min(abs(x-m1)));
    [MM,I2] = (min(abs(x-m2)));
else
    [MM,I1] = (min(abs(x-m2)));
    [MM,I2] = (min(abs(x-m1)));
end

% find x0:

[MIN, IMIN] = min(abs(PDF1(I1:I2)-PDF2(I1:I2)));

IMIN = IMIN + I1;
x0 = x(IMIN);

if (m1<m2)
    E1 = sum(PDF1(IMIN:end)) / sum(PDF1);
    E2 = sum(PDF2(1:IMIN)) / sum(PDF2);
else
    E1 = sum(PDF1(1:IMIN)) / sum(PDF1);
    E2 = sum(PDF2(IMIN:end)) / sum(PDF2);
end
E1 = 100 * E1;
E2 = 100 * E2;
E = (E1 + E2)/2;

hold on;
plot(x,PDF1);
plot(x,PDF2,'r');
L = line([x0 x0],[0 PDF1(IMIN)]);
set(L, 'color', [0.2 0.5 0]);
set(L, 'LineWidth', 2);
