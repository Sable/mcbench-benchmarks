function h = y2h(y)

% H = y2h(Y)
%
% Admittance to Hybrid-H transformation
%
% H and Y are matrices of size [2,2,F]
% where F is the number of frequencies

% 30.09.2011    - better 0-protection, faster division
%                 add multiple frequencies
%                 fixed out bug (since 27 martie...)

if any(y(1,1,:) == 0)
    disp('correspondent hybrid-H matrix non-existent');
else
    h = zeros(size(y)); % to check input size, maybe...
    den = 1./y(1,1,:);
    h(1,1,:) = den;
    h(1,2,:) = -y(1,2,:).*den;
    h(2,1,:) = y(2,1,:).*den;
    h(2,2,:) = y(2,2,:) - y(1,2,:).*y(2,1,:).*den;
end