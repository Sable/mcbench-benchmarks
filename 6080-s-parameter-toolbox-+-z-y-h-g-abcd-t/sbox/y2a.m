function A = y2a(y);

% ABCD = y2a(Y)
%
% Admittance to ABCD transformation
% only for 2x2xN matrices

% v1.1 - 03.02.2005 freq added

d = y(1,1,:).*y(2,2,:) - y(1,2,:).*y(2,1,:);

for i=1:size(y,3)
    while abs(y(2,1,i)) < 1e-8
        y(2,1,i) = y(2,1,i)*(1+rand*1e-8);
    end;
end;


A(1,1,:) = -y(2,2,:)./y(2,1,:);
A(1,2,:) = -1./y(2,1,:);
A(2,1,:) = -d./y(2,1,:);
A(2,2,:) = -y(1,1,:)./y(2,1,:);
