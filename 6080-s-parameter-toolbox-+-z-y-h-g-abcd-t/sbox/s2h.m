function h = s2h(s, epsilon);

% H = s2h(S,EPSILON)
%
% Scattering to Hybrid transformation
%
% H and S are matrices of size [2,2,F]
% where F is the number of frequencies
% (the number of ports is always 2)
% 
% EPSILON is a limit used in finding correspondent Hybrid-H matrices in the
% vicinity of singularities; by default 1e-12, should be enough for most
% realistic problems; could be increased for a gain in speed
%
% tudor dima, tudima@zahoo.com, change the z into y

if nargin < 2 epsilon = 1e-12; end;

d = (1 - s(1,1,:)) .* (1 + s(2,2,:)) + s(1,2,:) .* s(2,1,:);
[n,i] = min(abs(d));
exact_h = 1;
while n <= epsilon
    exact_h = 0;
    p1 = 1+round(rand); p2 = 1+round(rand);
    s(p1,p2,i) = s(p1,p2,i)+(rand-0.5)*epsilon;
    d = (1 - s(1,1,:)) .* (1 + s(2,2,:)) + s(1,2,:) .* s(2,1,:);
    [n,i] = min(abs(d));
end;

if exact_h == 0
    fprintf(1,'%s\n%s\n', 's2h: correspondent hybrid matrix non-existent', 'an approximation is produced');
end;

h(1,1,:) = ( (1 + s(1,1,:)).*(1 + s(2,2,:)) - s(1,2,:).*s(2,1,:) ) ./ d;
h(1,2,:) = 2*s(1,2,:) ./d;
h(2,1,:) = -2*s(2,1,:) ./d;
h(2,2,:) = ( (1 - s(1,1)).*(1 - s(2,2,:)) - s(1,2,:).*s(2,1,:) ) ./ d;