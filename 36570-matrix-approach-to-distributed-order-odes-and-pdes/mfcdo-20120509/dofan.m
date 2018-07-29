function B = dofan(phi, alphaFromTo, alphaStep, tN, tStep)
% Discretization matrix for 
% Left-sided Distributed-order fractional derivative 
%
% Function "phi", which describes the distribution 
% of the order of differentiation, must be given 
% as a string with variable "alf", for example: 
% '6*alf.*(1-alf)'
% 
% (C) Igor Podlubny, 2011


% Suppose the input parameters are given correctly
% (we do not validate the input parameters for now)


% Check if the FEX package 22071 is on your MATLAB path, 
% and if it is not there, then require the FEX packages 
% 31069 ("requireFEXpackage") and 22071 ("Matrix approach 
% to discretization of ODEs and PDEs of arbitrary real order"):
if ~(exist('ban', 'file') == 2 && exist('fan', 'file') == 2 ...
    && exist('ranort', 'file') && exist('eliminator', 'file') == 2)
    P = requireFEXpackage(31069); % "requireFEXpackage" 
    P = requireFEXpackage(22071);  % "Matrix approach..."
end



alphas = alphaFromTo(1):alphaStep:alphaFromTo(2); 
alphaCount = length(alphas);  

alf = alphas; 
phik = eval(phi); 

% Pre-allocate memory for layers with different orders 'alf'
B = zeros(tN, tN); 

for k = 1:alphaCount
    B = B + phik(k) * alphaStep * fan(alf(k), tN, tStep);    
end

 

