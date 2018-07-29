function s = z2s(z);

% S = z2s(Z)
%
% Impedance to Scattering transformation
% S, Z are matrices of size [P,P,F], 
% where P is the number of ports, F the number of frequencies
%
% s = inv(z+I) * (z-I)

I = diag(ones(1, size(z,2)));

for i=1:size(z,3)
    s(:,:,i) = inv(z(:,:,i)+I) * (z(:,:,i)-I) ;
end;