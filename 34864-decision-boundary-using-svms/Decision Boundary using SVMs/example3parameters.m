function [C, sigma] = example3parameters(X, y, Xval, yval)
% Initialization
C = 1;
sigma = 0.3;
% This function returns the optimal C and sigma learning parameters 
% found using the cross validation set. I have used svmPredict to predict 
% the labels on the cross validation set. For example, predictions = svmPredict(model, Xval);
% will return the predictions on the cross validation set.
% Prediction error can be computed by using mean(double(predictions ~= yval))

set = [0.01,0.03,0.1,0.3,1,3,10,30];
for i= 1:8
    c(i) = set(i);
    for j = 1:8
       ss(j) = set(j);  
        
       model = svmTrain(X, y, c(i), @(x1, x2) gaussianKernel(x1, x2, ss(j)));
       
       predictions  = svmPredict(model,Xval);
       
       error(i,j) = mean(double(predictions~=yval));
    end
end

%error;
x = min(min(error));
for i =1:8
    for j =1:8
        if error(i,j) == x
            C = set(i);
            sigma = set(j);
            break;
        end
    end
end

end
