function y = a2y(A);

% Y = a2y(ABCD)
%
% ABCD to Admittance transformation
% only for 2x2 matrices

[n,i] = min(abs(A(1,2,:)));
epsilon = 1e-11;
while n <= epsilon
    y(1,2,i) = y(1,2,i)+rand*epsilon;
    [n,i] = min(abs(A(1,2,:)));
end;

d = A(1,1,:).*A(2,2,:) - A(1,2,:).*A(2,1,:);

y(1,1,:) = A(2,2,:)./A(1,2,:);
y(1,2,:) = -d./A(1,2,:);
y(2,1,:) = -1./A(1,2,:);
y(2,2,:) = A(1,1,:)./A(1,2,:);
