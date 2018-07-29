% MutualInformation: returns mutual information (in bits) of the 'X' and 'Y'
% by Will Dwinnell
%
% I = MutualInformation(X,Y);
%
% I  = calculated mutual information (in bits)
% X  = variable(s) to be analyzed (column vector)
% Y  = variable to be analyzed (column vector)
%
% Note: Multiple variables may be handled jointly as columns in matrix 'X'.
% Note: Requires the 'Entropy' and 'JointEntropy' functions.
%
% Last modified: Nov-12-2006

function I = MutualInformation(X,Y);

if (size(X,2) > 1)  % More than one predictor?
    % Axiom of information theory
    I = JointEntropy(X) + Entropy(Y) - JointEntropy([X Y]);
else
    % Axiom of information theory
    I = Entropy(X) + Entropy(Y) - JointEntropy([X Y]);
end


% God bless Claude Shannon.

% EOF


