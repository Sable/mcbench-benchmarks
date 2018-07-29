%% An illustration of the use of MLFFIT1
% 
%            Igor Podlubny
%
% Technical University of Kosice, Slovakia

%% Introduction 
%
% Several examples of the use of the 
% one-parameter Mittag-Leffler function 
%
% $$y(x) = C E_{\alpha,\beta}(a x^\alpha)$$
%
% for fitting data are provided below. 
%



%% 1. Fitting back the noised Mittag-Leffler function:
%
% The first example is the "restoration" of the function
% $y(x) = 0.8 E_{1.5}( - 0.2 x^{1.5})$. Three series of "measured" data
% are created by adding noise to the values of the Mittag-Leffler
% function at the same set of nodes x. Such moisy data
% are fitted using MLFFIT1.M function. 
%


% Clear the workspace:
clear

% Define the set of nodes (x) and the parameter $\alpha$ of the
% Mittag-Leffler function:

x = 0:0.35:20;
alfa = 1.5;

% Since for computing the one-parameter Mittag-Leffler function 
% we call the Matlab function for computing the two-parameter
% Mittag-Leffler function, the second parameter is equal to 1:

beta = 1;

% Now let us simulate measurements by adding noise to 
% the exact values of the original function

y1 = 0.8*mlf(alfa, beta, -0.2*x.^alfa, 6) + (-.05 + .1*rand(size(x)));
y2 = 0.8*mlf(alfa, beta, -0.2*x.^alfa, 6) + (-.05 + .1*rand(size(x)));
y3 = 0.8*mlf(alfa, beta, -0.2*x.^alfa, 6) + (-.05 + .1*rand(size(x)));


% and fit these "measurements" by calling MLFFIT1:
[c, R2] = mlffit1([x x x], [y1 y2 y3], [0.5; 0.5; 0.5; -0.5], 6);


% Let us check if the coefficients of the fitting Mittag-Leffler
% function are close to the original coefficients:
alpha = c(1)
C = c(3)
a = c(4)

% Finally, we can plot the "measurements", the original function
% and the function that fits the "measurement":

xfine = x(1):0.01:x(end);
yfit = c(3)*mlf(c(1), c(2), c(4)*xfine.^c(1), 6);
yorig = 0.8*mlf(alfa, beta, -0.2*xfine.^alfa, 6); 

figure(1)
plot(xfine, yorig, 'r', x,y1, '.b', x, y2, '.g', x, y3, '.m', xfine, yfit, 'k')
grid on
legend('original function', 'noised data', 'noised data', 'noised data', 'fitting')




%% 2. Fitting the classics (cmplementary error function):
%
% Let us "restore" the following function:
% $y(x) = e^x erfc(\sqrt{x})$.
% 


% Clear the workspace:
clear

% Define the set of nodes (x)
x = 0:0.35:20;

% Now let us simulate measurements by adding noise to 
% the exact values of the original function

y1 = exp(x).*erfc(sqrt(x))  + (-.02 + .04*rand(size(x)));
y2 = exp(x).*erfc(sqrt(x))  + (-.02 + .04*rand(size(x)));
y3 = exp(x).*erfc(sqrt(x))  + (-.02 + .04*rand(size(x)));


% and fit these "measurements" by calling MLFFIT1:

[c, R2] = mlffit1([x x x], [y1 y2 y3], [0.5; 0.5; 0.5; -0.5], 6);

% Let us check the coefficients of the fitting Mittag-Leffler function:
alpha = c(1)
C = c(3)
a = c(4)

% Finally, we can plot the "measurements", the original function
% and the function that fits the "measurement":

xfine = x(1):0.01:x(end);
yfit = c(3)*mlf(c(1), c(2), c(4)*xfine.^c(1), 6);
yorig = exp(xfine).*erfc(sqrt(xfine));

figure(2)
plot(xfine, yorig, 'r', x,y1, '.b', x, y2, '.g', x, y3, '.m', xfine, yfit, 'k')
grid on
legend('original function', 'noised data', 'noised data', 'noised data', 'fitting')


%% 3. Dumped oscillation fitting:

% Let us test if the Mittag-Leffler function
% is abe to fit dumped oscillation:
% $y(x) = e^(-\alpha x) cos(x)$.

% Clear the workspace:
clear

% Define the dumping coefficient:
alfa = 0.2;

% Define the set of nodes (x)
x = 0:0.35:20;

% Now let us simulate measurements by adding noise to 
% the exact values of the original function
y1 = exp(-alfa*x).*cos(x) + (-.05 + .1*rand(size(x)));
y2 = exp(-alfa*x).*cos(x) + (-.05 + .1*rand(size(x)));
y3 = exp(-alfa*x).*cos(x) + (-.05 + .1*rand(size(x)));

% and fit these "measurements" by calling MLFFIT1:
[c, R2] = mlffit1([x x x], [y1 y2 y3], [0.5; 0.5; 0.5; -0.5], 6);


% Let us check if the coefficients of the fitting Mittag-Leffler function:
alpha = c(1)
C = c(3)
a = c(4)

% Finally, we can plot the "measurements", the original function
% and the function that fits the "measurement":
xfine = x(1):0.01:x(end);
yfit = c(3)*mlf(c(1), c(2), c(4)*xfine.^c(1), 6);
yorig = exp(-alfa*xfine).*cos(xfine);

figure(3)
plot(xfine, yorig, 'r', x,y1, '.b', x, y2, '.g', x, y3, '.m', xfine, yfit, 'k')
grid on
legend('original function', 'noised data', 'noised data', 'noised data', 'fitting')

