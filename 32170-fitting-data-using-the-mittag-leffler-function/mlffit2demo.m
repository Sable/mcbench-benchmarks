%% An illustration of the use of MLFFIT2
% 
% Igor Podlubny
%
% BERG Faculty, Technical University of Kosice, Slovakia

%% Introduction 
%
% Several examples of the use of the 
% two-parameter Mittag-Leffler function 
%%
% 
% $$y(x) = C t^{\beta -1} E_{\alpha,\beta}(a x^\alpha)$$
% 
% for fitting data are provided below. 
%



%% 1. Fitting back the noised Mittag-Leffler function:
%
% The first example is the "restoration" of the function
% $y(x) = 0.8 E_{1.5}(-0.2 x^{1.5})$. Three series of "measured" data
% are created by adding noise to the values of the Mittag-Leffler
% function at the same set of nodes x. Such moisy data
% are fitted using MLFFIT1.M function. 
%

% Clear the workspace:
clear

% Define the set of nodes (x) and the parameters $\alpha$ 
% and $\beta$ of the % Mittag-Leffler function:

x = 0.1:0.35:16;
alfa = 1.5;
beta = 0.8;

% Now let us simulate measurements by adding noise to 
% the exact values of the original function

y1 = 1 * x.^(beta-1) .* mlf(alfa, beta, -0.2*x.^alfa, 7) + (-.05 + .1*rand(size(x)));
y2 = 1 * x.^(beta-1) .* mlf(alfa, beta, -0.2*x.^alfa, 7) + (-.05 + .1*rand(size(x)));
y3 = 1 * x.^(beta-1) .* mlf(alfa, beta, -0.2*x.^alfa, 7) + (-.05 + .1*rand(size(x)));

% and fit these "measurements" by calling MLFFIT2:
[c, R2] = mlffit2([x x x], [y1 y2 y3], [2; 2; .5; -1], 6);

% Let us check if the coefficients of the fitting Mittag-Leffler
% function are close to the original coefficients:
alpha = c(1)
beta = c(2)
C = c(3)
a = c(4)

% Finally, we can plot the "measurements", the original function
% and the function that fits the "measurement":

xfine = x(1):0.01:x(end);
yfit = c(3)* xfine.^(c(2)-1) .* mlf(c(1), c(2), c(4)*xfine.^c(1), 6);
yorig = 1 * xfine.^(beta-1) .* mlf(alfa, beta, -0.2*xfine.^alfa, 6); 

figure(1)
plot(xfine, yorig, 'r', x,y1, '.b', x, y2, '.g', x, y3, '.m', xfine, yfit, 'k')
grid on
legend('original function', 'noised data', 'noised data', 'noised data', 'fitting')



%% 2. Fitting the classics:
%
%

% Clear the workspace and define the set of nodes (x):
clear
x = 0.1:0.35:16;

% Now let us simulate measurements by adding noise to 
% the exact values of the original function

y1 = exp(x).*erfc(sqrt(x))  + (-.02 + .04*rand(size(x)));
y2 = exp(x).*erfc(sqrt(x))  + (-.02 + .04*rand(size(x)));
y3 = exp(x).*erfc(sqrt(x))  + (-.02 + .04*rand(size(x)));


% and fit these "measurements" by calling MLFFIT2:
[c, R2] = mlffit2([x x x], [y1 y2 y3], [0.5; 0.5; .5; -0.5], 6);

% Let us check if the coefficients of the fitting Mittag-Leffler
% function:
alpha = c(1)
beta = c(2)
C = c(3)
a = c(4)

% Finally, we can plot the "measurements", the original function
% and the function that fits the "measurement":

xfine = x(1):0.01:x(end);
yfit = c(3)* xfine.^(c(2)-1) .* mlf(c(1), c(2), c(4)*xfine.^c(1), 6);
yorig = exp(xfine).*erfc(sqrt(xfine)); 

figure(2)
plot(xfine, yorig, 'r', x,y1, '.b', x, y2, '.g', x, y3, '.m', xfine, yfit, 'k')
grid on
legend('original function', 'noised data', 'noised data', 'noised data', 'fitting')




%% 3. Fitting the cosine function:

% Clear the workspace and define the set of nodes (x):
clear
x = 0.1:0.35:16;

% Now let us simulate measurements by adding noise to 
% the exact values of the original function

y1 = cos(x)  + (-.1 + .2*rand(size(x)));
y2 = cos(x)  + (-.1 + .2*rand(size(x)));
y3 = cos(x)  + (-.1 + .2*rand(size(x)));

% and fit these "measurements" by calling MLFFIT2:
[c, R2] = mlffit2([x x x], [y1 y2 y3], [0.5; 0.5; .5; -0.5], 6);

% Let us check if the coefficients of the fitting Mittag-Leffler
% function:
alpha = c(1)
beta = c(2)
C = c(3)
a = c(4)

% Finally, we can plot the "measurements", the original function
% and the function that fits the "measurement":

xfine = x(1):0.01:x(end);
yfit = c(3)* xfine.^(c(2)-1) .* mlf(c(1), c(2), c(4)*xfine.^c(1), 6);
yorig = cos(xfine); 

figure(3)
plot(xfine, yorig, 'r', x,y1, '.b', x, y2, '.g', x, y3, '.m', xfine, yfit, 'k')
grid on
legend('original function', 'noised data', 'noised data', 'noised data', 'fitting')




%% 4. Fitting the sine function:

% Clear the workspace and define the set of nodes (x):
clear
x = 0.1:0.35:16;

% Now let us simulate measurements by adding noise to 
% the exact values of the original function

y1 = sin(x)  + (-.2 + .4*rand(size(x)));
y2 = sin(x)  + (-.2 + .4*rand(size(x)));
y3 = sin(x)  + (-.2 + .4*rand(size(x)));


% and fit these "measurements" by calling MLFFIT2:
[c, R2] = mlffit2([x x x], [y1 y2 y3], [1.5; 1.5; .5; -1], 6);

% Let us check if the coefficients of the fitting Mittag-Leffler
% function:
alpha = c(1)
beta = c(2)
C = c(3)
a = c(4)

% Finally, we can plot the "measurements", the original function
% and the function that fits the "measurement":

xfine = x(1):0.01:x(end);
yfit = c(3)* xfine.^(c(2)-1) .* mlf(c(1), c(2), c(4)*xfine.^c(1), 6);
yorig = sin(xfine); 

figure(3)
plot(xfine, yorig, 'r', x,y1, '.b', x, y2, '.g', x, y3, '.m', xfine, yfit, 'k')
grid on
legend('original function', 'noised data', 'noised data', 'noised data', 'fitting')




%% 5. Dumped oscillation fitting:


% Clear the workspace and define the set of nodes (x):
clear
x = 0.1:0.35:16;

% Now let us simulate measurements by adding noise to 
% the exact values of the original function

y1 = exp(-0.1*x).*cos(x) + (-.05 + .1*rand(size(x)));
y2 = exp(-0.1*x).*cos(x) + (-.05 + .1*rand(size(x)));
y3 = exp(-0.1*x).*cos(x) + (-.05 + .1*rand(size(x)));

% and fit these "measurements" by calling MLFFIT2:
[c, R2] = mlffit2([x x x], [y1 y2 y3], [2; 2; .5; -1], 6);

% Let us check if the coefficients of the fitting Mittag-Leffler
% function:
alpha = c(1)
beta = c(2)
C = c(3)
a = c(4)

% Finally, we can plot the "measurements", the original function
% and the function that fits the "measurement":

xfine = x(1):0.01:x(end);
yfit = c(3)* xfine.^(c(2)-1) .* mlf(c(1), c(2), c(4)*xfine.^c(1), 6);
yorig = exp(-0.1*xfine).*cos(xfine); 

figure(3)
plot(xfine, yorig, 'r', x,y1, '.b', x, y2, '.g', x, y3, '.m', xfine, yfit, 'k')
grid on
legend('original function', 'noised data', 'noised data', 'noised data', 'fitting')



