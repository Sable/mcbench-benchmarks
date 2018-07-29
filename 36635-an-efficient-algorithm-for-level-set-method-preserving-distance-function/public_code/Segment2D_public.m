function phi = Segment2D_public( wb, wr, lambda, phi0, Nit )
% wb>0 edge detector
% wr region term
% lambda weight of region term over edge term
% phi0 initialization
% Nit number of iterations


verb = 1; fig_it = figure;
[Nx,Ny] = size(wb);
N = Nx*Ny;

% Parameters of augemented Lagrangian and minimizers
r1 = 1;
r2 = 1;
r3 = 0.1;
r4 = 0.1; 
Njvarphi = 3; % increase it to get a better approximation to the minimizar with respect to varphi
Njphi = 2; % increase it to get better approximation to | grad phi | = 1 
epsilon = 1; % controls smoothness of approximation to Heaviside and Dirac

% usufelu for FFT-based minimization
[Y,X] = meshgrid(0:Ny-1,0:Nx-1); 
auxFFT = cos(2*pi/Nx*X)+cos(2*pi/Ny*Y)-2;

% initialize Lagrange multipliers and splitting variables
l1 = zeros(Nx,Ny);
l2x = zeros(Nx,Ny);
l2y = zeros(Nx,Ny);
l3 = zeros(Nx,Ny);
l4x = zeros(Nx,Ny);
l4y = zeros(Nx,Ny);
phi = phi0;
varphi = phi0;
u = H(phi0,epsilon);
dx = Fx(u);
dy = Fy(u);
px = Fx(phi);
py = Fy(phi);

wr = -lambda* wr;
% Start iterations: minimize w.r.t. each variable and update lagrange multipliers
for i=1:Nit
    
    % u^n+1 solved in Fourier domain
    b = r1*(H(varphi,epsilon)- l1/r1) - wr -r2* ( Bx(dx+l2x/r2)+By(dy+l2y/r2) );
    u = real(ifft2( fft2( b )./( -2*r2*auxFFT + r1 )));
    
    % d^n+1 solved by shrinkage
    Fxu = Fx(u);
    Fyu = Fy(u);
    [dx,dy] = shrink(Fxu - l2x/r2,Fyu - l2y/r2,wb/r2);
 
    % varphi^n+1 approx initialization and Newton method
    v = u + l1/r1;
    z = phi- l3/r3;
    E_0 = 0.5*r3*z.^2 + 0.5*r1*( 0.5 - v ).^2;
    E_z = 0.5*r1*( H(z,epsilon) - v ).^2;
        % initialize with solution to ideal Heaviside
    cond_m2 = ( z>=0 ).*( v>=0.5 ) + ( z<0 ).*( v<0.5 );
    varphi = z.*cond_m2 + (1-cond_m2).*( E_z < E_0 ).*z;  
        % newton method to find zeros of derivative
    for j=1:Njvarphi
         df = r3*( varphi - z) + r1*( H(varphi,epsilon) - v ).*D(varphi,epsilon);
         hf = r3 + r1*D(varphi,epsilon).*D(varphi,epsilon) + r1*(H(varphi,epsilon) - v ).*dD(varphi,epsilon);
         varphi = varphi - df./( hf + (abs(hf)<1e-3) ); 
    end
    
    % lambda^n+1 update lagrangians
    l1 = l1 + r1* (u-H(varphi,epsilon));
    l2x = l2x + r2* (dx-Fxu);
    l2y = l2y + r2* (dy-Fyu);
    l3 = l3 + r3* (varphi- phi);

    %%%%%%%%%%%%%%%%%%%%%%%%%
    for jphi=1:Njphi

        % p^n+1 solved projecting in sphere
        ex = Fx(phi)-l4x/r4;
        ey = Fy(phi)-l4y/r4;
        norm_e = sqrt( ex.^2 + ey.^2 );
        px = ex./(norm_e + (norm_e==0));
        py = ey./(norm_e + (norm_e==0));

        % phi^n+1 solved in Fourier domain
        b = r3* (varphi+l3/r3) -r4.* ( Bx(px+l4x/r4)+By(py+l4y/r4) );
        phi = real(ifft2( fft2( b )./( -2*r4.*auxFFT + r3 )));

        % lambda^n+1 update lagrangians
        l4x = l4x + r4.*(px-Fx(phi));
        l4y = l4y + r4.*(py-Fy(phi));
    end     
    
    %plotting
    if ((rem(i,5)==0)&&(verb==1))
        pause(0.01);
        figure(fig_it)
        clf; imagesc(phi); colormap(gray); colorbar; 
        title([num2str(i), ' iterations']); hold on; contour(phi,[0 0],'m');
        for ct=-2:2; contour(phi,[ct ct],'k'); end; contour(phi,[0 0],'m');        
    end
end

return;


% shrinkage function
function [xs,ys] = shrink(x,y,lambda)

s = sqrt(x.*conj(x)+y.*conj(y));
ss = s-lambda;
ss = ss.*(ss>0);

s = s+(s<lambda);
ss = ss./s;

xs = ss.*x;
ys = ss.*y;

return;

% smooth approximation of Heaviside function
function v = H(phi,epsilon)
v = 0.5*( 1 + 2/pi*atan(phi/epsilon) );
return;

% smooth approximation of Dirac distribution
function v = D(phi,epsilon)
v = 1/pi* epsilon./ (epsilon^2 + phi.^2);
return;

% smooth approximation of derivative of the Dirac distribution
function v = dD(phi,epsilon)
v = -2/pi* epsilon*phi./ (epsilon^2 + phi.^2).^2;


% Forward derivative operator on x with boundary condition u(:,1,:)=u(:,Nx,:)
function Fxu = Fx(u)
[Ny,Nx] = size(u);
Fxu = circshift(u,[0 -1])-u;
Fxu(:,Nx) = zeros(Ny,1);

% Forward derivative operator on y with boundary condition u(1,:,:)=u(Ny,:,:)
function Fyu = Fy(u)
[Ny,Nx] = size(u);
Fyu = circshift(u,[-1 0])-u;
Fyu(Ny,:) = zeros(1,Nx);

% Backward derivative operator on x with boundary condition Bxu(:,1)=u(:,1)
function Bxu = Bx(u)
[Ny,Nx] = size(u);
Bxu = u - circshift(u,[0 1]);
Bxu(:,1) = u(:,1);
Bxu(:,Nx) = -u(:,Nx-1);

% Backward derivative operator on x with boundary condition Bxu(1,:)=u(1,:)
function Byu = By(u)
[Ny,Nx] = size(u);
Byu = u - circshift(u,[1 0]);
Byu(1,:) = u(1,:);
Byu(Ny,:) = -u(Ny-1,:);
