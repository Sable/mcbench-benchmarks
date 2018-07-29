function s = t2s4(t);

% S = t2s4(T)
%
% Transmission to Scattering transformation
% only for N-by-4 matrix

if size(t, 2) ~= 4
disp(' screwed up data ');
end;

s(:,1) = t(:,3)./t(:,1);
s(:,2) = t(:,4) - t(:,2).*t(:,3)./t(:,1);
s(:,3) = 1./t(:,1);
s(:,4) = -t(:,2)./t(:,1);