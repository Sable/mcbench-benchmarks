%CUDACONV Fast 2-D convolution.
%   C = CUDACONV(A, B) performs the 2-D convolution of matrices
%   A and B, assuming that A is the 'data' and B is the 'kernel.'
%   
%   C will contain the central part of the convolution that is the
%   same size as A (similar to CONV2 with 'same').
%   
%   NOTE:
%   CUDACONV assumes repeating edge conditions, i.e. A(-i,j) = A(1,j)
%   for i = [0,inf) for the top edge of A and similarly elsewhere.
%   
%   CONV2, however, assumes zero edge conditions, so different
%   results may be obtained.
%   
%   Class support for inputs A,B: 
%      float (real): double
%   
%   See also TESTCUDACONV, CONV2
    
%   By Alexander Huth, California Institute of Technology, 2008
%   based on code by the NVIDIA Corporation