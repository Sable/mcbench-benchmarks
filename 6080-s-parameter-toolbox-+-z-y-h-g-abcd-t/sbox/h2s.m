function s = h2s(h);

% S = h2s(H)
%
% Hybrid to Admittance Transformation
% only for 2-by-2 matrices
%
% H and S are matrices of size [2,2,F]
% where F is the number of frequencies
% (the number of ports is always 2)
% 
% EPSILON is a limit used in finding correspondent S matrices in the
% vicinity of singularities; by default 1e-12, should be enough for most
% realistic problems; could be increased for a gain in speed
%
% tudor dima, tudima@zahoo.com, change the z into y

if nargin < 2 epsilon = 1e-12; end;
d = (h(1,1,:)+1) .* (h(2,2,:)+1) - h(1,2,:).*h(2,1,:);
[n,i] = min(abs(d));
exact_s = 1;
while n <= epsilon
    exact_s = 0;
    p1 = 1+round(rand); p2 = 1+round(rand);
    h(p1,p2,i) = h(p1,p2,i)+(rand-0.5)*epsilon;
    d = (h(1,1,:)+1) .* (h(2,2,:)+1) - h(1,2,:).*h(2,1,:);
    [n,i] = min(abs(d));
end;

if exact_s == 0
    fprintf(1,'%s\n%s\n', 'h2s: correspondent S matrix non-existent', 'an approximation is produced');
end;

s(1,1,:) = ( (h(1,1,:)-1).*(h(2,2,:)+1) - h(1,2,:).*h(2,1,:) )./ d;
s(1,2,:) = 2*h(1,2,:)./d;
s(2,1,:) = -2*h(2,1,:)./d;
s(2,2,:) = ( (h(1,1,:)+1).*(-h(2,2,:)+1) + h(1,2,:).*h(2,1,:) )./ d;