function A = cgrscho(A)
%CGRSHO Classical Gram-Schmidt orthogonalization procedure. 
% This procedure construct an orthonormal basis from any set of N linearly
% independent vectors. Obviously, by skipping the normalization step, we 
% could also form simply an orthogonal basis. The key ingredient of this 
% procedure is that each new orthonormal basis vector is obtained by 
% subtracting out the projection of the next linearly independent vector 
% onto the vectors accepted so far into the set. We may say that each new
% linearly independent vector s_n is projected onto the subspace spanned by
% the vectors [o_0,...,o_n-1], and any nonzero projection in that subspace 
% is subtracted out of s_n to make the new vector orthogonal to the entire
% subspace. In other words, we retain only that portion of each new vector
% s_n which points along a new dimension. The first direction is arbitrary
% and is determined by whatever vector we choose first (s_0 here). The next
% vector is forced to be orthogonal to the first. The second is forced to be
% orthogonal to the first two, and so on.
% Orthogonalization methods play a key role in many iterative methods. The
% Gram–Schmidt process is a method for orthogonalizing a set of vectors in
% an inner product space. A set of vectors in an inner product space is 
% called an orthogonal set if all pairs of distinct vectors in the set are
% orthogonal (the angle between them is pi/2). An orthogonal set in which 
% each vector has a norm of 1 is called an orthonormal set. 
% The method is named for Jørgen Pedersen Gram (a Danish actuary) and Erhard
% Schmidt (a German mathematician) but it appeared earlier in the work of 
% Laplace and Cauchy. -Gram-Schmidt’s orthogonalization process- term 
% appeared by first time in 1936 on the Wong's paper 'An Application of 
% Orthogonalization Process to the Theory of Least Squares'.
% 
% Syntax: function cgrscho(A)
%
% Input:
%    A - matrix of n linearly independent vectors of equal size. Here, them
%        must be arranged as columns.
% Output:
%    Matrix of n orthogonalized vectors.
%
% Example: Taken the problem 18, S6.3, p308, from the Mathematics 206 Solutions
% for HWK 24b. Course of Math 206 Linear Algebra by Prof. Alexia Sontag at
% Wellesley Collage, Wellesley, MA, USA. URL address:
% http://www.wellesley.edu/Math/Webpage%20Math/Old%20Math%20Site/Math206sontag/
% Homework/Pdf/hwk24b_s02_solns.pdf
%           
% We are interested to orthogonalize the vectors,
%
%    v1 = [0 2 1 0], v2 = [1 -1 0 0], v3 = [1 2 0 -1] and v4 = [1 0 0 1]
%
% by the classical Gram-Schmidt process.
%
% Vector matrix must be:
%    A = [0 1 1 1;2 -1 2 0;1 0 0 0;0 0 -1 1];
%
% Calling on Matlab the function: 
%    cgrscho(A)
%
% Answer is:
%
% ans =
%         0    0.9129    0.3162    0.2582
%    0.8944   -0.1826    0.3162    0.2582
%    0.4472    0.3651   -0.6325   -0.5164
%         0         0   -0.6325    0.7746
%
% Created by A. Trujillo-Ortiz, R. Hernandez-Walls, A. Castro-Perez
%            and K. Barba-Rojo
%            Facultad de Ciencias Marinas
%            Universidad Autonoma de Baja California
%            Apdo. Postal 453
%            Ensenada, Baja California
%            Mexico.
%            atrujo@uabc.mx
%
% Copyright. September 28, 2006.
%
% To cite this file, this would be an appropriate format:
% Trujillo-Ortiz, A., R. Hernandez-Walls, A. Castro-Perez and K. Barba-Rojo. (2006). 
%   cgrscho:Classical Gram-Schmidt orthogonalization procedure. A MATLAB file.
%   [WWW document]. URL http://www.mathworks.com/matlabcentral/fileexchange/
%   loadFile.do?objectId=12465
%
% References:
% Gerber, H. (1990), Elementary Linear Algebra. Brooks/Cole Pub. Co. Pacific
%     Grove, CA. 
% Wong, Y.K. (1935), An Application of Orthogonalization Process to the 
%     Theory of Least Squares. Annals of Mathematical Statistics, 6:53-75.
%

if nargin ~= 1,
    error('You need to imput only one argument.');
end

[m n]=size(A);

for j= 1:n
    R(1:j-1,j)=A(:,1:j-1)'*A(:,j);
    A(:,j)=A(:,j)-A(:,1:j-1)*R(1:j-1,j);
    R(j,j)=norm(A(:,j));
    A(:,j)=A(:,j)/R(j,j);
end

return,