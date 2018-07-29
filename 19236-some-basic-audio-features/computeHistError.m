function [E1, E2] = computeHistError(Data1, Data2)

NBins = 100;

minVal = min([Data1;Data2]);
maxVal = max([Data1;Data2]);

% define histogram beans
X = minVal : (maxVal-minVal) / (NBins-1) : maxVal;

% compute Histograms
[H1, X1] = hist(Data1, X);
[H2, X2] = hist(Data2, X);

% normalize histograms:
H1 = H1 ./ sum(H1);
H2 = H2 ./ sum(H2);

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

% figure;
% plot(X,H1);
% hold on;
% plot(X,H2,'r');