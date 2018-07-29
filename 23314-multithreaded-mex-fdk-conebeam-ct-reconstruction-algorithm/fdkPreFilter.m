function P = fdkPreFilter(P, D, Filter)
% This function applies the weighting and filtering steps necessary for FDK
% reconstruction of a conebeam CT sinogram
%
% P: conebeam CT sinogram
% D: rotation radius
% Filter: filter to apply ('Shepp-Logan', 'Cosine', 'Hamming', 'Hann' or
% 'None')
%
% Author: Rene Willemink (Signals and Systems Group, University of Twente)
% Date: 2009-03-11

if nargin<3
    Filter = 'None';
end

% Pre-calculate some things
[U V] = ndgrid(1:size(P,1), 1:size(P,2));
U = U-(size(P,1)-1)/2;
V = V-(size(P,2)-1)/2;

% Calculate filter to use in backprojection (in frequency domain)
% Frequency range of filter
w = (0:(size(P,1)-1))' * 2*pi/size(P,1);
H = w;

% Filter with hamming window
switch Filter
  case 'Shepp-Logan'
    % Sinc window
    wind = [0; sin(w(2:end)/2)./(w(2:end)/2)];
  case 'Cosine'
    wind = cos(w/2);
  case 'Hamming'
    alpha = 0.54;
    wind = alpha + (1-alpha)*cos(w);
  case 'Hann'
    wind = (1 + cos(w))/2;
  case 'None'
    wind = ones(size(w));
end
H = H.*wind;

% Step 1 Weighting
P = P .* repmat(D./sqrt(D^2 + U.^2 + V.^2), [1 1 size(P,3)]);

% Step 2 Filtering
P = ifft(fft(P) .* repmat(H, [1 size(P,2) size(P,3)]), 'symmetric');

% Step 3 Normalizing for the backprojection:
P = double(0.5*1/size(P,3)*P);