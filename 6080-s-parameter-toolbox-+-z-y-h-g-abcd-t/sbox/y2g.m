function g = y2g(y)

% G = y2g(Y)
%
% Admittance to Hybrid-G transformation
%
% G and Y are matrices of size [2,2,F]
% where F is the number of frequencies

% 30.09.2011    - better 0-protection, faster division
%                 add multiple frequencies (old: martie 26)

if any(y(2,2,:) == 0)
    disp('correspondent hybrid-G matrix non-existent');
else
    g = zeros(size(y)); % to 2xcheck input size, later...
    den = 1./y(2,2,:);
    g(1,1,:) = y(1,1,:) - y(1,2,:).*y(2,1,:).*den;
    g(1,2,:) = y(1,2,:).*den;
    g(2,1,:) = -y(2,1,:).*den;
    g(2,2,:) = den;
end