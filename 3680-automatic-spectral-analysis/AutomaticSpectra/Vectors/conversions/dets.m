function d = dets(a)

%function d = dets(a)
%
% Provides a vector of determinants of the vector LTI a

%S. de Waele, March 2003.


a_len = kingsize(a,3);
d = zeros(a_len,1);

for t = 1:a_len,
   d(t) = det(a(:,:,t));
end