% solution of Poisson equation using sparse matrix
%
%  E.Holzbecher,    18.3.2011 
%
%--------------------------------------------------
nx = 12; ny = 12;      % dimensions in x- and y-direction
h = 1/4;                % grid spacing

% boundary type indicators (1=Dirichlet, 0=Neumann no-flow)
ltop = logical(zeros(1,nx));         % top
lbottom = logical(zeros(1,nx));      % bottom
lleft = logical([ones(6,1) zeros(6,1)]);       % left
lright = logical([zeros(6,1) ones(6,1)]);      % right

% boundary values (Dirichlet only)
btop = ones(1,nx);                  % top
bbottom = zeros(1,nx);              % bottom
bleft = ones(ny,1);                 % left
bright = zeros(ny,1);               % right

q = 1*ones(nx,ny);                  % right hand side (source term)

N = nx*ny;
d = [-nx,-1,0,1,nx];
B = [ones(N,2) -4*ones(N,1) ones(N,2)];
q = reshape(q,N,1);
b = -h*h*q.*ones(N,1);
for i = 1:nx
    if ltop(i)
        b(i) = b(i)-btop(i);
    else
        B(i,3) = -3;
        %B(i-1,1) = 0;
    end
    if lbottom(i)
        b(N-nx+i) = b(N-nx+i)-bbottom(i);
    else
        B(N-nx+i,3) = -3;
        % B(N-nx+i,5) = 0;
    end
end
for i = 1:ny
    B(i*nx,2) = 0; 
    if i<ny B(i*nx+1,4) = 0; end    
    if lleft(i)
        b((i-1)*nx+1) = b((i-1)*nx+1)-bleft(i);
    else
        B((i-1)*nx+1,3) = B((i-1)*nx+1,3)+1;
    end
    if lright(i)
        b(i*nx) = b(i*nx)-bright(i);
    else
        B(i*nx,3) = B(i*nx,3)+1;
    end
end

A = spdiags(B,d,N,N);

% processing: solution
U = A\b;
U = reshape(U,nx,ny);

% check & visualize
4*del2(U) 
surf (U)

