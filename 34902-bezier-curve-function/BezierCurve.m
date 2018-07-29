function y = BezierCurve(N, P)
% This function constructs a Bezier curve from given control points. P is a
% vector of control points. N is the number of points to calculate.
%
% Example:
%
% P = [0 0; 1 1; 2 5; 5 -1];
% x = (0:0.0001:5);
% y = BezierCurve(length(x), P);
% plot(x, y, P(:, 1), P(:, 2), 'x-', 'LineWidth', 2); set(gca, 'FontSize', 16)
%
% Prakash Manandhar, pmanandhar@umassd.edu 

Np = size(P, 1); 
u = linspace(0, 1, N);
B = zeros(N, Np);
for i = 1:Np
   B(:,i) = nchoosek(Np,i-1).*(u.^(i-1)).*((1-u).^(Np-i+1)); %B is the Bernstein polynomial value
end
B1 = (nchoosek(Np,Np).*(u.^Np))';
S = B*P + B1*P(Np,:);
y = S(:, 2);