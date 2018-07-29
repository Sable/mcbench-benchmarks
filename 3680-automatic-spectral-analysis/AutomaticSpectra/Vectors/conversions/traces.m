function tr = traces(a)

%function tr = traces(a)
%
% Provides a vector of traces of the vector LTI a
%

%S. de Waele, March 2003.

a_len = kingsize(a,3);
tr = zeros(a_len,1);

for t = 1:a_len,
   tr(t) = trace(a(:,:,t));
end