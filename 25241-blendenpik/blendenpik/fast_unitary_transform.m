function B = fast_unitary_tranform(A, D, type)
% B = fast_unitary_tranform(A, D, type)
%
% Applies a fast unitary transform (DCT, DHT and WHT) to D * A
% after padding with zeros.
% 
% type is either 'DCT', 'DHT' or 'WHT'.
%
% 6-December 2009, Version 1.3
% Copyright (C) 2009, Haim Avron and Sivan Toledo.