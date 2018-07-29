function t = s2t(s);

% T = s2t(S)
%
% Scattering to Transmission transformation
% only for N-by-four matrix

if size(s, 2) ~= 4
disp(' screwed up data ');
end;

t(:,1) = 1./s(:, 3);
t(:,2) = -s(:, 4)./s(:, 3);
t(:,3) = s(:, 1)./s(:, 3);
t(:,4) = s(:, 2) - s(:, 1).*s(:, 4)./s(:, 3);