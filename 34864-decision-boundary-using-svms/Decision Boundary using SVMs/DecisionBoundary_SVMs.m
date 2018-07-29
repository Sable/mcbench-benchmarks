%% ===== Machine Learning | Support Vector Machines ====================

% This code is completed by Krishna Prasad, IIT Delhi,New Delhi
% For further information email to kprasad.iitd@gmail.com

%  This file contains code that helps you gain an intuition of how
%  SVMs works and how to use Gaussian kernel with SVMs to find out the decision doundary.
%  This code also demonstrating with various 2D datasets example. For more visibility I
%  have divided the program in the following functions
%     gaussianKernel.m & linearKernel.m
%     example3parameters.m
%     svmTrain.m
%     svmPredict.m
%     DecsionBoundary.m & DecisionBoundaryLinear.m
%     plotData.m
%     

%% Initialization
clear ; close all; clc
 
%% %%%%%%%%%% Example 1: Demonstration of Linear SVM %%%%%%
% Loading and Visualizing training dataset.
fprintf('Loading and Visualizing Data ...\n')
% Loading dataset from example1.mat: 
% You will have X, y in your environment
load('example1.mat');
% Plot training data
plotData(X, y);
title('Traning Dataset');
% Training Linear SVM 
% The following code will train a linear SVM on the dataset and plot the
% decision boundary learned.
fprintf('\nTraining Linear SVM ...\n')
% You should try to change the C value below and see how the decision
% boundary varies (e.g., try C = 1000)
C = 1;
model = svmTrain(X, y, C, @linearKernel, 1e-3, 20);
figure;
visualizeBoundaryLinear(X, y, model);
title('Decision Boundary');
 
%% =============== Example2: SVM with Gaussian Kernel ===============
fprintf('Program paused. Press enter to continue with example 2.\n');
pause; 
% Loading and Visualizing Dataset 2 ================
fprintf('Loading and Visualizing Data ...\n')
load('example2.mat'); 
% Loaded dataset from example2 : 
% You will have X, y in your environment
% Plot training data
figure,
plotData(X, y);
title('Traning Dataset');
% Training SVM with RBF Kernel (Dataset example2) ==========
fprintf('\nTraining SVM with RBF Kernel (this may take 1 to 2 minutes) ...\n');
C = 1; sigma = 0.1;
% I set the tolerance and max_passes lower here so that the code will run
% faster. However, in practice, you will want to run the training to
% convergence.
model= svmTrain(X, y, C, @(x1, x2) gaussianKernel(x1, x2, sigma)); 
figure,
visualizeBoundary(X, y, model);
title('Decision boundary with RBF kernel');

%% %%%%%%%Example 3 : SVM with Gaussian Kernel and Cross Validation%%%%
fprintf('Program paused. Press enter to continue with example 3.\n');
pause; 
%In this I have used the cross validation set Xval, yval to determine the
%best C and sigma parameter to use, this is done in the function
%examples3parameters.m
% The following code will load the next dataset into your environment and 
% plot the data.  
fprintf('Loading and Visualizing Data ...\n')
%  Loading  from example3: 
%  You will have X, y in your environment
load('example3.mat'); 
% Plot training data
figure,
plotData(X, y);
fprintf('Program paused. Press enter to continue.\n');
pause;
% Training SVM with RBF Kernel (Dataset 3)
load('example3.mat');
% finding the best C and sigma using example3paramters.m
[C, sigma] = example3parameters(X, y, Xval, yval);
% Train the SVM
model= svmTrain(X, y, C, @(x1, x2) gaussianKernel(x1, x2, sigma));
figure,
visualizeBoundary(X, y, model);
title('Decision boundary with RBF kernel');
%end of the examples