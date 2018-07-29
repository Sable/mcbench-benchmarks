% ConditionalEntropy: Calculates conditional entropy (in bits) of Y, given X
% by Will Dwinnell
%
% H = ConditionalEntropy(Y,X)
%
% H  = calculated entropy of Y, given X (in bits)
% Y  = dependent variable (column vector)
% X  = independent variable(s)
% 
% Note: requires 'Entropy' and 'MutualInformation' functions
%
% Example: 'X' (1 bit of entropy), 'Y' (2 bits of entropy)
%   Given 'X', 'Y's conditional entropy is 1 bit.
%
% Note: Estimated entropy values are slightly less than true, due to
% finite sample size.
%
% Y = ceil(4 * rand(1e3,1));  X = double(Y <= 2);
% ConditionalEntropy(Y,X)
%
% Last modified: Nov-12-2006

function H = ConditionalEntropy(Y,X)

% Axiom of information theory
H = Entropy(Y) - MutualInformation(X,Y);


% God bless Claude Shannon.

% EOF


