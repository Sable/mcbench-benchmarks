function c = convv(a,b);
%function c = convv(a,b);
%
%Convolves 3-D matrices a and b

% S. de Waele, March 2003.

sa = kingsize(a);
sb = kingsize(b);
s = sb;
s(3) = sa(3)+sb(3)-1;
b_z = zeros(s);

b_z(:,:,1:sb(3)) = b;
c = armafilterv(b_z,1,a);
