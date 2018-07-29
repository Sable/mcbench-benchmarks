function field1=Brownian_field(H,n)
% generates Fractional Gaussian field with a given Hurst parameter 'H';
% the covariance function is isotropic and the method used is 
% Stein's intrinsic embedding method. Stein's method guarantees a nonnegative
% circulant embedding, see the article below for more details.


% inputs:
% 'H' is the Hurst parameter
% 'n' is the number of grid points on a square lattice that includes the 
% circular region of interest

% output:
% field1, which is also plotted as shown below

% reference:
% Kroese, D.P. and Botev, Z.I. (2013).
% "Spatial Process Generation."
% V. Schmidt (Ed.). Lectures on Stochastic Geometry, 
% Spatial Statistics and Random Fields, 
% Volume II: Analysis, Modeling and Simulation of Complex Structures, 
% Springer-Verlag, Berlin. 

%weblink:
%http://www.maths.uq.edu.au/~kroese/ps/MCSpatial.pdf
 
R=2; % [0,R]^2 grid, may have to extract only [0,R/2]^2
n=1000; m=n; % size of grid is m*n; covariance matrix is m^2*n^2
tx=[1:n]/n*R; ty=[1:m]/m*R; % create grid for field
Rows=zeros(m,n);
for i=1:n
    for j=1:m % rows of blocks of cov matrix
        Rows(j,i)=rho([tx(i),ty(j)],[tx(1),ty(1)],R,2*H);
    end
end
BlkCirc_row=[Rows, Rows(:,end-1:-1:2);
    Rows(end-1:-1:2,:), Rows(end-1:-1:2,end-1:-1:2)];
% compute eigen-values
lam=real(fft2(BlkCirc_row))/(4*(m-1)*(n-1));
lam=sqrt(lam);
% generate field with covariance given by block circular matrix
Z=complex(randn(2*(m-1),2*(n-1)),randn(2*(m-1),2*(n-1)));
F=fft2(lam.*Z);
F=F(1:m,1:n); % extract sub-block with desired covariance
[out,c0,c2]=rho([0,0],[0,0],R,2*H);
field1=real(F); field2=imag(F); % two independent fields
field1=field1-field1(1,1); % set field zero at origin
% make correction for embedding with a term c2*r^2
field1=field1 + kron(ty'*randn,tx*randn)*sqrt(2*c2);
[X,Y]=meshgrid(tx,ty);
field1((X.^2+Y.^2)>1)=nan;
field1=field1(1:n/2,1:m/2);
surf(tx(1:n/2),ty(1:m/2),field1,'EdgeColor','none')
colormap bone


function [out,c0,c2]=rho(x,y,R,alpha)
% embedding of covariance function on a [0,R]^2 grid
if alpha<=1.5 % alpha=2*H, where H is the Hurst parameter
    beta=0;c2=alpha/2;c0=1-alpha/2;
else % parameters ensure piecewise function twice differentiable
    beta=alpha*(2-alpha)/(3*R*(R^2-1)); c2=(alpha-beta*(R-1)^2*(R+2))/2;
    c0=beta*(R-1)^3+1-c2;
end
% create continuous isotropic function
r=sqrt((x(1)-y(1))^2+(x(2)-y(2))^2);
if r<=1
    out=c0-r^alpha+c2*r^2;
elseif r<=R
    out=beta*(R-r)^3/r;
else
    out=0;
end