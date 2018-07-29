function y = g2y(g)

% Y = g2y(G)
%
% Hybrid-G to Admittance transformation
% 
% G and Y are matrices of size [2,2,F]
% where F is the number of frequencies

% 30.09.2011    - better 0-protection, faster division
%                 fixed bug that swapped out rows
%                 (since 26 martie...)

if any(g(2,2,:) == 0)
    disp('g2y > correspondent Y matrix non-existent');
else
    y = zeros(size(g)); % to check input size, maybe...
    den = 1./g(2,2);
    y(1,1,:) = g(1,1,:) - g(1,2,:).*g(2,1,:).*den;
    y(1,2,:) = g(1,2,:).*den;

    y(2,1,:) = -g(2,1,:).*den;
    y(2,2,:) = den;
end