%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function kurt:	 								       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function gets a signal, X, and calculates the value 
% of its' Kurtosis, according to the definition of Kurtosis:
%  		K=(sum(Xi-Miu)^4)/(N*Sigma^4)-3					   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example use:
%      x = rand(100, 1);
%      k = kurt(x);

function K = kurt(X)
Miu = mean(X);          % Mean value of the vector X (Average).
Sigma = std(X); 		% Standard deviation of vector X.
N = length(X);          % No. of measurements.
K = 0;					% Initialization of K.
% The calculation takes place only when Sigma > 0.
% Otherwise, there is a division by 0.
if Sigma > 0.01         % The tolerance value.
    K = (sum((X-Miu).^4));
    K = (K/(N*Sigma^4))-3;		% Final equation.
end
