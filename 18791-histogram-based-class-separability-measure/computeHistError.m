function [E1, E2] = computeHistError(Data1, Data2)

%
% function [E1, E2] = computeHistError(Data1, Data2)
% 
% This function calculates the error probability for a binary
% classification problem (for both classes), given the data of the two
% classes. This trainning data classification error can also be used as a
% measure of class seperability. The larger the error is the "more
% difficult" the respective classification error is.
%
% ARGUMENTS:
% Data1: array containing the data samples of the 1st class
% Data2: array containing the data samples of the 2nd class
%
% RETURN VALUES:
% E1: error probability for the 1st class
% E2: error probability for the 2nd class 
%
% --------------------------------------------
% Theodoros Giannakopoulos
% Dep. of Informatics and Telecommunications
% University of Athens, Greece
% http://www.di.uoa.gr/~tyiannak
% --------------------------------------------

N = length(Data1);

if (N<1000)
    NBins = 20;
else
    if (N<10000)
        NBins = 100;
    else
        NBins = 200;
    end
end


minVal = min([Data1;Data2]);
maxVal = max([Data1;Data2]);

% define histogram beans
X = minVal : (maxVal-minVal) / (NBins-1) : maxVal;

% compute Histograms
[H1, X1] = hist(Data1, X);
[H2, X2] = hist(Data2, X);

% normalize histograms:
%H1 = H1 ./ sum(H1);
%H2 = H2 ./ sum(H2);

% 
E1 = 0.0;
E2 = 0.0;
for (i=1:length(X))
    if (H1(i)<H2(i))
        E1 = E1 + H1(i);
    else
        E2 = E2 + H2(i);
    end
end
E1 = E1 / sum(H1);
E2 = E2 / sum(H2);
%figure;
%plot(X,H1);
%hold on;
%plot(X,H2,'r');