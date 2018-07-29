function g = h2g(h, epsilon, WordToReport)

% G = h2g(H,EPSILON)
%
% Hybrid-H to Hybrid-G transformation
% H and G are matrices of size [2,2,F]
% where F is the number of frequencies
% (the number of ports is always 2)
% 
% EPSILON is a limit used in finding correspondent Hybrid-H matrices in the
% vicinity of singularities; by default 1e-12, should be enough for most
% realistic problems; could be increased for a gain in speed
%
% written by tudor dima, tudima@zahoo.com, change the z into y
if nargin < 3, WordToReport = 'hybrid-G'; end;
if nargin < 2, epsilon = []; end;
if isempty(epsilon), epsilon = 1e-12; end;
% 30.09.2011    - clear bug in D calculation

d = h(1,1,:).*h(2,2,:) - h(1,2,:).*h(2,1,:);
[n,i] = min(abs(d));
flagApproxG = false;
while n <= epsilon
    % 'fix' only the i-th D
    flagApproxG = true;
    p1 = 1+round(rand); p2 = 1+round(rand);
    h(p1,p2,i) = h(p1,p2,i)+(rand-0.5)*epsilon;
    % was:
    %h(1+csi,1+~csi,i) = h(1+csi,1+~csi,i)+(rand-0.5)*epsilon;
    d = h(1,1,i).*h(2,2,i) - h(1,2,i).*h(2,1,i);
    [n,i] = min(abs(d));
end

if flagApproxG
    fprintf(1,'%s%s%s\n%s\n', 'caution: correspondent ', ...
        WordToReport, ' matrix non-existent', ...
        'an approximation is produced');
end

g(1,1,:) = h(2,2,:)./d;
g(1,2,:) = -h(1,2,:)./d;
g(2,1,:) = -h(2,1,:)./d;
g(2,2,:) = h(1,1,:)./d;
