function z = s2z(s);

% Z = s2z(S)
%
% Scattering to Impedance transformation
% S, Z are matrices of size [P,P,F], 
% where P is the number of ports, F the number of frequencies
%
% z = (I+s) * inv(I-s)
% 
% ver 0.0 original	31.03.1998
% ver 0.1 +freq		11.01.2003

I = diag(ones(1, size(s,2)));

for i=1:size(s,3)
    z(:,:,i) = (I+s(:,:,i)) * inv(I-s(:,:,i));
end;