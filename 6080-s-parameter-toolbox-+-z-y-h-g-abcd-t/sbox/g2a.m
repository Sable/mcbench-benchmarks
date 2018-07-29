function A = g2a(g);

% ABCD = g2a(G)
%
% Hybrid G to ABCD transformation
% only for 2x2 matrices


[n,i] = min(abs(g(2,1,:)));
epsilon = 1e-14;
while n <= epsilon
    g(2,1,i) = g(2,1,i)+rand*epsilon;
    [n,i] = min(abs(g(2,1,:)));
end;

d = g(1,1,:) .* g(2,2,:) - g(1,2,:) .* g(2,1,:);

A(1,1,:) = 1./g(2,1,:);
A(1,2,:) = g(2,2,:)./g(2,1,:);
A(2,1,:) = g(1,1,:)./g(2,1,:);
A(2,2,:) = d./g(2,1,:);

