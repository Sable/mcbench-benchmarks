function y = h2y(h)

% Y = h2y(H)
%
% Hybrid-H to Admittance transformation
%
% H and Y are matrices of size [2,2,F]
% where F is the number of frequencies

% 30.09.2011    - better 0-protection, faster division
%                 add multiple frequencies (old: martie 27)

if any(h(1,1,:) == 0)
    disp('h2y > correspondent admittance matrix non-existent');
else
    y = zeros(size(h));
    den = 1./h(1,1,:);
    y(1,1,:) = den;
    y(1,2,:) = -h(1,2,:).*den;
    y(2,1,:) = h(2,1,:).*den;
    y(2,2,:) = h(2,2,:) - h(1,2,:).*h(2,1,:).*den;
end