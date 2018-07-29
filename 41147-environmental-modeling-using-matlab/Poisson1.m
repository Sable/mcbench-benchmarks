% solution of Poisson equation using sparse matrix
%
%  E.Holzbecher,    18.3.2011 
%
%--------------------------------------------------
nx = 12; ny = 4;       % dimensions in x- and y-direction
h = 1/4;                % grid spacing 
btop = 1;             % boundary condition at top side 
bbottom = 0;          % boundary condition at bottom side
q = 1;               % right hand side (source term)

N = nx*ny;
d = [-nx,-1,0,1,nx];
B = [ones(N,2) -4*ones(N,1) ones(N,2)];
b = -q*h*h*ones(N,1);
for i = 1:nx
    b(i) = b(i)-btop;
    b(N+1-i) = b(N+1-i)-bbottom;
end
for i = 1:ny
   B((i-1)*nx+1,3) = -3;
   B(i*nx,2) = 0;
   B(i*nx,3) = -3;
   B(i*nx+1,4) = 0;
end

A = spdiags(B,d,N,N);

% processing: solution
U = A\b;
U = reshape(U,nx,ny);

% check & visualize
4*del2(U)
% surf(U)                % does not include boundary values 
surf([btop*ones(nx,1) U bbottom*ones(nx,1)])

