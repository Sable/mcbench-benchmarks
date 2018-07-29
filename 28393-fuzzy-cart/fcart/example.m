%   This example demonstrates the using of fuzzy CART for approximation of
%   the function 
%       y = sin(sqrt(x1^2 + x2^2)) / sqrt(x1^2 + x2^2).
%   of two variables x1 and x2.
%   It also compares results with results obtained by FCM.

%   Per Konstantin A. Sidelnikov, 2010.

clc;
clear all;

%####### Function to be approximated ######################################

% Set number of points in x1- and x2-axis
N = 101;
% Set limits for x1- and x2-axis
xmin = -10; xmax = 10;
% Generate mesh to evaluate functions of two variables
[X1, X2] = meshgrid(linspace(xmin, xmax, N));
% Calculate function values
y = sin(sqrt(X1.^2 + X2.^2)) ./ sqrt(X1.^2 + X2.^2); 
y(isnan(y)) = 1;
% Get min and max of function values
ymin = min(y(:)); ymax = max(y(:));

%####### Learning, validation and test data sets ##########################

% Set size of learning sample
Nl = 600;
% Set size of validation sample
Nv = 200;
% Set size of test sample
Nt = 200;

% Generate random indices for both samples
inds = randperm(N^2);
indl = inds(1 : Nl);
indv = inds(Nl + (1 : Nv));
indt = inds(Nl + Nv + (1 : Nt));

% Form learning data set 
Xl = [X1(indl)', X2(indl)'];
yl = y(indl)';
% Form validation data set 
Xv = [X1(indv)', X2(indv)'];
yv = y(indv)';
% Form test data set
Xt = [X1(indt)', X2(indt)'];
yt = y(indt)';

%######## Generation of FIS using training data ###########################

% Set bounds for FIS inputs
bounds = [ ...
    xmin,    xmax; ...   
    xmin,    xmax];

% Set options for CART algorihtm
treeopts = {'minparent', 15, 'prune', 'off'};
tstopts = {'test', Xt, yt};
% Generate FIS structure based on CART algorithm
fis_cart = genfis4(Xl, yl, 'sugeno', 'auto', treeopts, tstopts);
% Reset IO bounds
for ind = 1 : 2
    fis_cart = setfisx(fis_cart, 'input', ind, 'range', bounds(ind, :));
end
fis_cart = setfisx(fis_cart, 'output', 1, 'range', [ymin, ymax]);

% Set number of clusters equal to number of classes found by CART
cluster_n = getfisx(fis_cart, 'numrules');
% Set options for FCM algorihtm
fcmopts = [NaN, 1000, NaN, NaN];
% Generate FIS structure based on FCM algorithm
fis_fcm = genfis3(Xl, yl, 'sugeno', cluster_n, fcmopts);
% Reset IO bounds
for ind = 1 : 2
    fis_fcm = setfis(fis_fcm, 'input', ind, 'range', bounds(ind, :));
end
fis_fcm = setfis(fis_fcm, 'output', 1, 'range', [ymin, ymax]);

%####### ANFIS training with checking #####################################

% Set number of epochs for ANFIS training
Nepoch = 100;

% Perform fuzzy CART training with checking
[~, t_error_cart, ~, c_cart, c_error_cart] = ...
    anfisx([Xl, yl], fis_cart, Nepoch, [], [Xt, yt]);
% Reset IO bounds
for ind = 1 : 2
    c_cart = setfis(c_cart, 'input', ind, 'range', bounds(ind, :));
end
c_cart = setfis(c_cart, 'output', 1, 'range', [ymin, ymax]);

% Perform FCM training with checking
[~, t_error_fcm, ~, c_fcm, c_error_fcm] = ...
    anfis([Xl, yl], fis_fcm, Nepoch, [], [Xt, yt]);
% Reset IO bounds
for ind = 1 : 2
    c_fcm = setfis(c_fcm, 'input', ind, 'range', bounds(ind, :));
end
c_fcm = setfis(c_fcm, 'output', 1, 'range', [ymin, ymax]);

%####### Results ##########################################################

% Calculate RMSE using all data points
y_cart = zeros(size(y));
y_cart(:) = evalfisx([X1(:), X2(:)], c_cart);
y_fcm = zeros(size(y));
y_fcm(:) = evalfis([X1(:), X2(:)], c_fcm);
rmse_cart = norm(y_cart(:) - y(:)) / sqrt(N^2);
rmse_fcm = norm(y_fcm(:) - y(:)) / sqrt(N^2);

figure('Name', 'Original function and its approximation');
subplot(2, 2, [1, 2]); mesh(X1, X2, y);
axis([xmin, xmax, xmin, xmax, ymin, ymax]); axis square;
title('Original function');
subplot(2, 2, 3); mesh(X1, X2, y_cart);
axis([xmin, xmax, xmin, xmax, ymin, ymax]); axis square;
title(['Fuzzy CART with RMSE = ', num2str(rmse_cart)]);
subplot(2, 2, 4); mesh(X1, X2, y_fcm);
axis([xmin, xmax, xmin, xmax, ymin, ymax]); axis square;
title(['Fuzzy FCM with RMSE = ', num2str(rmse_fcm)]);

% Calculate correlation coefficient using validation data
yv_cart = evalfisx(Xv, c_cart);
yv_fcm = evalfis(Xv, c_fcm);
yv_norm = (yv - ymin) ./ (ymax - ymin);
yv_norm_cart = (yv_cart - ymin) ./ (ymax - ymin);
yv_norm_fcm = (yv_fcm - ymin) ./ (ymax - ymin);
R_cart = corrcoef(yv, yv_cart);
R_fcm = corrcoef(yv, yv_fcm);

figure('Name', 'Scatter diagramm for test data errors');
subplot(1, 2, 1); 
plot(yv_norm_cart, yv_norm, 'o'); hold; 
plot([0, 1], [0, 1], 'k');
axis([0, 1, 0, 1]); axis square;
title(['Fuzzy CART with R = ', num2str(R_cart(1, 2))]);
subplot(1, 2, 2); 
plot(yv_norm_fcm, yv_norm, 'o'); hold; 
plot([0, 1], [0, 1], 'k');
axis([0, 1, 0, 1]); axis square;
title(['FCM with R = ', num2str(R_fcm(1, 2))]);

% Get minimum checking error location
[minrmse_cart, minloc_cart] = min(c_error_cart);
[minrmse_fcm, minloc_fcm] = min(c_error_fcm);

figure('Name', 'Training (solid) and checking (dash) errors');
subplot(2, 1, 1); 
plot(t_error_cart); hold; 
plot(c_error_cart, '--');
plot(minloc_cart, minrmse_cart, ...
    'rs', 'MarkerSize', 10, 'LineWidth', 1.5);
title('Fuzzy CART (red square marks chosen FIS)'); 
subplot(2, 1, 2); 
plot(t_error_fcm); hold; 
plot(c_error_fcm, '--');
plot(minloc_fcm, minrmse_fcm, ...
    'rs', 'MarkerSize', 10, 'LineWidth', 1.5);
title('FCM (red square marks chosen FIS)');