function s = t2s(t, epsilon);

% S = t2s(T, EPSILON)
%
% Transmission to Scaterring Transformation
%
% since 2 is the only allowed number of ports for a T-matrix,
% S, T are matrices of size [2,2,F], 
% where F is the number of frequencies
% 
% EPSILON is used to produce an approximation of the corresponding S-matrix
% in exceptional cases
%
% 3-d version 4 nov 1999

if nargin < 2 epsilon = 1e-14; end;
[n,i] = min(abs(t(1,1,:)));
while n <= epsilon
    t(1,1,i) = t(1,1,i)+rand*epsilon;
    [n,i] = min(abs(t(1,1,:)));
end;

s(1,1,:) = t(2,1,:)./t(1,1,:);
s(1,2,:) = t(2,2,:) - t(1,2,:).*t(2,1,:) ./t(1,1,:);
s(2,1,:) = 1./t(1,1,:);
s(2,2,:) = -t(1,2,:) ./t(1,1,:);