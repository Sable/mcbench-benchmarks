function [t, st] = f2t(f, sf)
% This function calculates the time signal using ifft fcn.
%
% Phymhan Studio, $ 18-May-2013 15:46:55 $

if nargin < 2
    fprintf('Not enough input arguments.\n')
    return
end
if length(f) < 2
    fprintf('length of time must greater than 2.\n')
    return
end

df = f(2)-f(1);
F = f(end)-f(1)+df;
dt = 1/F;
N = length(sf);

% t = (-N/2:N/2-1)*dt; %symmetry in time space
t = (0:N-1)*dt; %time starts from zero

sff = ifftshift(sf);  % rearranges the outputs of ifft
st = F*ifft(sff);

end
