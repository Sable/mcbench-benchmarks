function y = s2y(s);

% Y = s2y(S)
%
% Scattering to Admittance transformation
%
% y = (I-s) * inv(I+s)
% 
% for square matrices at multiple frequencies
%
% 27.09.2002

I = diag(ones(1, size(s,2)));

for i=1:size(s,3)
   y(:,:,i) = (I-s(:,:,i)) * inv(I+s(:,:,i));
end;