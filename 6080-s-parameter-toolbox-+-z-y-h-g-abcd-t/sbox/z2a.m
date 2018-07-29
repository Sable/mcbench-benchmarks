function A = z2a(z,epsilon);

% ABCD = z2a(Z,epsilon)
%
% Impedance to ABCD transformation
% only for 2x2 matrices

if nargin < 2 epsilon = 1e-10; end;

d = z(1,1,:).*z(2,2,:) - z(1,2,:).*z(2,1,:);

for i=1:size(z,3)
    while abs(z(2,1,i)) < epsilon
        z(2,1,i) = z(2,1,i)*(1+rand*epsilon);
    end;
end;

A(1,1,:) = z(1,1,:)./z(2,1,:);
A(1,2,:) = d./z(2,1,:);
A(2,1,:) = 1./z(2,1,:);
A(2,2,:) = z(2,2,:)./z(2,1,:);
