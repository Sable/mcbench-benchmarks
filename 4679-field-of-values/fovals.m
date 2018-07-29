function fovals(A,k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author: Wilmer Henao    wi-henao@uniandes.edu.co
%   Department of Mathematics
%   Universidad de los Andes
%   Colombia
%
%   The Field of values of a matrix is a convex set in the complex plane
%   that contains all eigenvalues of the given matrix, this m-file plots 
%   boundary points of this set and the eigenvalues of the given matrix.
%
%   fovals(A,k)
%   A = The square matrix
%   k = The number of steps (500 by default) you can call FoV, without
%   this argument
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

EPS = 0.0000000000000000000001*i;
[m,n]=size(A);
if m ~= n
   disp('The matrix must be square')
   return
end

[Vo,Do] = eig(A);

tr = trace(A)/m;
A = A - tr.*eye(m);

if nargin == 1
    k = 500;
end

for ind = 1:k
    theta = 2*pi*ind/k;
    [vect,D] = eig(0.5.*((exp(i*theta).*A)+(exp(i*theta).*A)'));
    [a,b] = max(D*ones(m,1));
    V = vect(:,b)./norm(vect(:,b));
    pto(ind) = V'*A*V;
end

plot(pto + (tr*ones(1,k)) + (EPS*ones(1,k)));
hold on
plot(Do*ones(m,1) + (EPS*ones(m,1)),'o','MarkerSize',10, 'MarkerEdgeColor', 'k', 'MarkerFaceColor','c', 'LineWidth',2)
hold off