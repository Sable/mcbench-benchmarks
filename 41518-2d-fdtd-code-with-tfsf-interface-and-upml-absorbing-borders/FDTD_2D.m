%% FDTD 2D with UPML and TF/SF interface example. 
function FDTD_2D
%% Initialize workspace
clear all; close all; clc; format short;

%% Fundamental physical constants
% Absolute vacuum permittivity
epsilon_0 = 8.854*1e-12;
% Absulute vacuum permeability
mu_0 = 4*pi*1e-7;
% Light speed in vacuum
c = 1/sqrt(epsilon_0*mu_0);

%% Main parameters
% Calculation area length per x and y axes
L = [2.5, 2.5];
% Uniform grid points for x and y axes
nx = 500; ny = 500;
% Perfect match layer (PML) thickness in uniform grid cells
PML = 10;
% End time [s]
t_end = 15e-9;
% Excitation source amplitude and frequency [Hz]
E0 = 1.0;     
f = 2.0e+9;   % 2 GHz
% Number of materials (include vacuum backrgound)
number_of_materials = 2;
% Background relative permittivity, relative permeability and absolute
% conductivity
eps_back = 1.0; mu_back = 1.0; sig_back = 0.0;
% Width of alinea between total field area and calculation area border
% (scattered field interface width) [m]
len_tf = 0.5;

% Grid calculation
X = linspace(0,L(1),nx)-L(1)/2;
Y = linspace(0,L(2),ny)-L(2)/2;
dx = X(nx)-X(nx-1);
dy = Y(ny)-Y(ny-1);
% Time step from CFL condition
dt = ( 1/c/sqrt( 1/(dx^2) + 1/(dy^2) ) )*0.99;
number_of_iterations = round(t_end/dt);

%% Geometry matrix 
Index = zeros(nx,ny);

%% Materials matrix 
Material = zeros(number_of_materials,3);
Material(1,1) = eps_back;
Material(1,2) = mu_back;
Material(1,3) = sig_back;

%% Simple geometry (here metal round cylinder 1/2)
% Diameter [m]
d0 = 1.3;
% Cylinder materials  
Material(2,1) = 1;       % relative permittivity
Material(2,2) = 1;       % relative permeability
Material(2,3) = 1.0e+70; % absolute conductivity
% Fill geometry matrix for 1/2 cylinder (no vectorization here)
for I = 1:nx
    for J = 1:ny
        if ((J-nx/2)^2 + (I-ny/2)^2 <= 0.25*(d0/dx)^2 && (L(1)-I*dx<=J*dy))
            Index(J,I) = 1;
        end
    end
end

%% Calculate size of total field area in TF/SF formalism
nx_a = round(len_tf/dx);
nx_b = round((L(1)-len_tf)/dx);
ny_a = round(len_tf/dy);
ny_b = round((L(2)-len_tf)/dy);

%% Pre-allocate 1D fields for TF/SF interface 
% TM components
Ez_1D = zeros(nx_b+1,1); Fz_1D = zeros(nx_b+1,1); Hy_1D = zeros(nx_b,1);
k_Fz_a = zeros(nx_b+1,1); k_Fz_b = zeros(nx_b+1,1); k_Hy_a = zeros(nx_b,1);
k_Hy_b = zeros(nx_b,1);
k_Ez_a = (2.0*epsilon_0*Material(1,1) - Material(1,3)*dt)/(2.0*epsilon_0*Material(1,1) + Material(1,3)*dt);
k_Ez_b =  2.0/(2.0*epsilon_0*Material(1,1) + Material(1,3)*dt);
% TE components
Hz_1D = zeros(nx_b+1,1); Ey_1D = zeros(nx_b,1);
k_Hz_a = zeros(nx_b+1,1); k_Hz_b = zeros(nx_b+1,1); 
k_Ey_a = zeros(nx_b,1); k_Ey_b = zeros(nx_b,1);

% Free space plane wave coefficients
k_Hy_a(:) = 1.0; k_Hy_b(:) = dt/(mu_0*Material(1,2)*dx);
k_Fz_a(:) = 1.0; k_Fz_b(:) = dt/dx;

k_Hz_a(:) = 1.0; k_Hz_b(:) = dt/(mu_0*Material(1,2)*dx);
k_Ey_a(:) = 1.0; k_Ey_b(:) = dt/(epsilon_0*Material(1,1)*dx);

ka_max = 1; m = 4; R_err = 1e-16; eta = sqrt(mu_0*Material(1,2)/epsilon_0/Material(1,1));

sigma_max = -(m+1)*log(R_err)/(2*eta*PML*dx);
sigma_x = sigma_max*((PML - (0:PML-1))/ PML).^m;
ka_x = 1 + (ka_max - 1)*((PML - (0:PML-1))/ PML).^m;
k_Fz_a(end-(0:PML-1)) = (2*epsilon_0*ka_x - sigma_x*dt)./...
                        (2*epsilon_0*ka_x + sigma_x*dt);
k_Fz_b(end-(0:PML-1)) = 2*epsilon_0*dt./(2*epsilon_0*ka_x+sigma_x*dt)/dx;
k_Hz_a(end-(0:PML-1)) = (2*epsilon_0*ka_x - sigma_x*dt)./(2*epsilon_0*ka_x + sigma_x*dt);
k_Hz_b(end-(0:PML-1)) = 2*epsilon_0*dt./(2*epsilon_0*ka_x+sigma_x*dt)/(mu_0*Material(1,2)*dx);

sigma_x = sigma_max*((PML - (0:PML-1) - 0.5)/ PML).^m;
ka_x = 1 + (ka_max - 1)*((PML - (0:PML-1) - 0.5)/ PML).^m;
k_Hy_a(end-(0:PML-1)) = (2*epsilon_0*ka_x - sigma_x*dt)./(2*epsilon_0*ka_x + sigma_x*dt);
k_Hy_b(end-(0:PML-1)) = 2*epsilon_0*dt./(2*epsilon_0*ka_x + sigma_x*dt)/(mu_0*Material(1,2)*dx);
k_Ey_a(end-(0:PML-1)) = (2*epsilon_0*ka_x - sigma_x*dt)./(2*epsilon_0*ka_x + sigma_x*dt);
k_Ey_b(end-(0:PML-1)) = 2*dt./(2*epsilon_0*ka_x + sigma_x*dt)/(Material(1,1)*dx);

%% Another transformation coefficients
K_a(1:number_of_materials) = (2*epsilon_0*Material(1:number_of_materials,1) - ...
Material(1:number_of_materials,3)*dt)./(2*epsilon_0*Material(1:number_of_materials,1) + ...
Material(1:number_of_materials,3)*dt);
K_b(1:number_of_materials) = 2*epsilon_0*Material(1:number_of_materials,1)./ ...
(2*epsilon_0*Material(1:number_of_materials,1) + Material(1:number_of_materials,3)*dt);

K_a1(1:number_of_materials) = 1./(2*epsilon_0*Material(1:number_of_materials,1) + ...
  	 		                 Material(1:number_of_materials,3)*dt);
K_b1(1:number_of_materials) = 2*epsilon_0*Material(1:number_of_materials,1) - ...
                             Material(1:number_of_materials,3)*dt;

K_a = K_a(Index(2:nx-1,2:ny-1)+1);                                                 
K_b = K_b(Index(2:nx-1,2:ny-1)+1);

%% Allocate 2D arrays
% TM physical and auxiliary fields
Fz = zeros(nx,ny); Tz = zeros(nx,ny);   Gx = zeros(nx,ny-1); Gy = zeros(nx-1,ny);
Ez = zeros(nx,ny); Hx = zeros(nx,ny-1); Hy = zeros(nx-1,ny);
% TE physical and auxiliary fields
Wz = zeros(nx,ny); Mx = zeros(nx,ny-1); My = zeros(nx-1,ny);
Hz = zeros(nx,ny); Ex = zeros(nx,ny-1); Ey = zeros(nx-1,ny);

%% Allocate UPML FDTD 1D coefficient arrays
% TM coefficients
k_Fz_1 = zeros(ny,1);   k_Fz_2 = zeros(ny,1);   
k_Ez_1 = zeros(nx,1);   k_Ez_2 = zeros(nx,1);   
k_Gx_1 = zeros(ny-1,1); k_Gx_2 = zeros(ny-1,1);
k_Hx_1 = zeros(nx,1);   k_Hx_2 = zeros(nx,1);   
k_Gy_1 = zeros(nx-1,1); k_Gy_2 = zeros(nx-1,1); 
k_Hy_1 = zeros(ny,1);   k_Hy_2 = zeros(ny,1);
% TM coefficients
k_Hz_1 = zeros(nx,1);   k_Hz_2 = zeros(nx,1);   
k_Ex_1 = zeros(nx,1);   k_Ex_2 = zeros(nx,1);   
k_Ey_1 = zeros(ny,1);   k_Ey_2 = zeros(ny,1);

%% Free space FDTD coefficients
k_Fz_1(:) = 1.0;      k_Fz_2(:) = dt;
k_Ez_1(:) = 1.0;      k_Ez_2(:) = 1.0/epsilon_0;
k_Gx_1(:) = 1.0;      k_Gx_2(:) = dt/dy;
k_Hx_1(:) = 1.0/mu_0; k_Hx_2(:) = 1.0/mu_0;
k_Gy_1(:) = 1.0;      k_Gy_2(:) = dt/dx;
k_Hy_1(:) = 1.0/mu_0; k_Hy_2(:) = 1.0/mu_0;
k_Hz_1(:) = 1.0;      k_Hz_2(:) = 1.0/mu_0;
k_Ex_1(:) = 2.0;      k_Ex_2(:) = 2.0;
k_Ey_1(:) = 2.0;      k_Ey_2(:) = 2.0;

%% Field transformation coefficients in PML areas for TM ans TE modes
% Along x-axis
sigma_max = -(m+1)*log(R_err)/(2*eta*PML*dx);
sigma_x = sigma_max*((PML-(1:PML)+1)/PML).^m;
ka_x = 1+(ka_max-1)*((PML-(1:PML)+1)/PML).^m;
k_Ez_1(1:PML) = (2*epsilon_0*ka_x-sigma_x*dt)./(2*epsilon_0*ka_x+sigma_x*dt);
k_Ez_1(end-(1:PML)+1) = k_Ez_1(1:PML);
k_Ez_2(1:PML) = 2./(2*epsilon_0*ka_x + sigma_x*dt);
k_Ez_2(end-(1:PML)+1) = k_Ez_2(1:PML);
k_Hx_1(1:PML) = (2*epsilon_0*ka_x+sigma_x*dt)/(2*epsilon_0*mu_0);
k_Hx_1(end-(1:PML)+1) = k_Hx_1(1:PML);
k_Hx_2(1:PML) = (2*epsilon_0*ka_x-sigma_x*dt)/(2*epsilon_0*mu_0);
k_Hx_2(end-(1:PML)+1) = k_Hx_2(1:PML);
k_Hz_1(1:PML) = (2*epsilon_0*ka_x-sigma_x*dt)./(2*epsilon_0*ka_x+sigma_x*dt);
k_Hz_1(end-(1:PML)+1) = k_Hz_1(1:PML);
k_Hz_2(1:PML) = 2*epsilon_0./(2*epsilon_0*ka_x+sigma_x*dt)/mu_0;
k_Hz_2(end-(1:PML)+1) = k_Hz_2(1:PML);
k_Ex_1(1:PML) = (2*epsilon_0*ka_x+sigma_x*dt)/epsilon_0;
k_Ex_1(end-(1:PML)+1) = k_Ex_1(1:PML);
k_Ex_2(1:PML) = (2*epsilon_0*ka_x-sigma_x*dt)/epsilon_0;
k_Ex_2(end-(1:PML)+1) = k_Ex_2(1:PML);

sigma_x = sigma_max*((PML-(1:PML)+0.5)/PML).^m;
ka_x = 1+(ka_max-1)*((PML-(1:PML)+0.5)/PML).^m;
k_Gy_1(1:PML) = (2*epsilon_0*ka_x-sigma_x*dt)./(2*epsilon_0*ka_x+sigma_x*dt);
k_Gy_1(end-(1:PML)+1) = k_Gy_1(1:PML);
k_Gy_2(1:PML) = 2*epsilon_0*dt./(2*epsilon_0*ka_x+sigma_x*dt)/dx;
k_Gy_2(end-(1:PML)+1) = k_Gy_2(1:PML);

% Along y-axis
sigma_max = -(m+1)*log(R_err)/(2*eta*PML*dy);
sigma_y = sigma_max*((PML-(1:PML)+1)/PML).^m;
ka_y = 1+(ka_max-1)*((PML-(1:PML)+1)/PML).^m;
k_Fz_1(1:PML) = (2*epsilon_0*ka_y-sigma_y*dt)./(2*epsilon_0*ka_y+sigma_y*dt);
k_Fz_1(end-(1:PML)+1) = k_Fz_1(1:PML);
k_Fz_2(1:PML) = 2*epsilon_0*dt./(2*epsilon_0*ka_y+sigma_y*dt);
k_Fz_2(end-(1:PML)+1) = k_Fz_2(1:PML);
k_Hy_1(1:PML) = (2*epsilon_0*ka_y+sigma_y*dt)/(2*epsilon_0*mu_0);
k_Hy_1(end-(1:PML)+1) = k_Hy_1(1:PML);
k_Hy_2(1:PML) = (2*epsilon_0*ka_y-sigma_y*dt)/(2*epsilon_0*mu_0);
k_Hy_2(end-(1:PML)+1) = k_Hy_2(1:PML);
k_Ey_1(1:PML) = (2*epsilon_0*ka_y+sigma_y*dt)/epsilon_0;
k_Ey_1(end-(1:PML)+1) = k_Ey_1(1:PML);
k_Ey_2(1:PML) = (2*epsilon_0*ka_y-sigma_y*dt)/epsilon_0;
k_Ey_2(end-(1:PML)+1) = k_Ey_2(1:PML);

sigma_y = sigma_max*((PML-(1:PML)+0.5)/PML).^m;
ka_y = 1+(ka_max-1)*((PML-(1:PML)+0.5)/PML).^m;
k_Gx_1(1:PML) = (2*epsilon_0*ka_y-sigma_y*dt)./(2*epsilon_0*ka_y+sigma_y*dt);
k_Gx_1(end-(1:PML)+1) = k_Gx_1(1:PML);
k_Gx_2(1:PML) = 2*epsilon_0*dt./(2*epsilon_0*ka_y+sigma_y*dt)/dy;
k_Gx_2(end-(1:PML)+1) = k_Gx_2(1:PML);

% Vectorize transformation coefficients
k_Fz_1 = repmat(k_Fz_1(2:ny-1)',nx-2,1); k_Fz_2 = repmat(k_Fz_2(2:ny-1)',nx-2,1);
k_Ez_1 = repmat(k_Ez_1(2:nx-1),1,ny-2);  k_Ez_2 = repmat(k_Ez_2(2:nx-1),1,ny-2);
k_Gx_1 = repmat(k_Gx_1(1:ny-1)',nx,1);   k_Gx_2 = repmat(k_Gx_2(1:ny-1)',nx,1);
k_Hx_1 = repmat(k_Hx_1(1:nx),1,ny-1);    k_Hx_2 = repmat(k_Hx_2(1:nx),1,ny-1);
k_Gy_1 = repmat(k_Gy_1(1:nx-1),1,ny);    k_Gy_2 = repmat(k_Gy_2(1:nx-1),1,ny);
k_Hy_1 = repmat(k_Hy_1(1:ny)',nx-1,1);   k_Hy_2 = repmat(k_Hy_2(1:ny)',nx-1,1);
k_Hz_1 = repmat(k_Hz_1(2:nx-1),1,ny-2);  k_Hz_2 = repmat(k_Hz_2(2:nx-1),1,ny-2);
k_Ex_1 = repmat(k_Ex_1(1:nx),1,ny-1);    k_Ex_2 = repmat(k_Ex_2(1:nx),1,ny-1);
k_Ey_1 = repmat(k_Ey_1(1:ny)',nx-1,1);   k_Ey_2 = repmat(k_Ey_2(1:ny)',nx-1,1);
M0 = reshape(Material(Index(2:nx-1,2:ny-1)+1,1),nx-2,[]);
M1 = reshape(Material(Index(2:nx-1,2:ny-1)+1,2),nx-2,[]);
M2 = reshape(Material(Index(1:nx,1:ny-1)+1,2),nx,[]);
M3 = reshape(Material(Index(1:nx-1,1:ny)+1,2),[],ny);

%% Create fullscreen figure and set a double-buffer
figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'doublebuffer','on');

tic; 
%% Main FDTD UPML routine with TF/SF excitation interface calculates TE and
%% TM modes simultaneously
for T = 1:number_of_iterations
    %% Calculate incident 1D plain waves for TF/SF implementation
    % TE mode (Hz)
    Ey_1D(1:nx_b) = k_Ey_a(1:nx_b).*Ey_1D(1:nx_b) ...
                  - k_Ey_b(1:nx_b).*(Hz_1D(2:nx_b+1)-Hz_1D(1:nx_b));
    Hz_1D(1) = E0*sin(2*pi*f*(T-1)*dt);
    Hz_1D(2:nx_b) = k_Hz_a(2:nx_b).*Hz_1D(2:nx_b) ...
                  - k_Hz_b(2:nx_b).*(Ey_1D(2:nx_b)-Ey_1D(1:nx_b-1));
    % TM mode (Ez)            
    Hy_1D(1:nx_b) = k_Hy_a(1:nx_b).*Hy_1D(1:nx_b) + ...
		            k_Hy_b(1:nx_b).*(Ez_1D(2:nx_b+1)-Ez_1D(1:nx_b));
    Ez_1D(1) = E0*sin(2*pi*f*(T-1)*dt);
    Fz_1D_r = Fz_1D(2:nx_b);
    Fz_1D(2:nx_b) = k_Fz_a(2:nx_b).*Fz_1D(2:nx_b) + ...
                    k_Fz_b(2:nx_b).*( Hy_1D(2:nx_b) - Hy_1D(1:nx_b-1) );
    Ez_1D(2:nx_b) = k_Ez_a*Ez_1D(2:nx_b) + k_Ez_b*( Fz_1D(2:nx_b) - Fz_1D_r );

    %% Calculate Ez (TM mode) and Hz (TE mode) total fields 
    % TE: Wz -> Hz                
    Fz_r1 = Wz(2:nx-1,2:ny-1);
    Wz(2:nx-1,2:ny-1) = k_Fz_1.*Wz(2:nx-1,2:ny-1) + ...
                        k_Fz_2.*( (Ex(2:nx-1,2:ny-1)-Ex(2:nx-1,1:ny-2))/dy - ...
                        (Ey(2:nx-1,2:ny-1)-Ey(1:nx-2,2:ny-1))/dx );
    Hz(2:nx-1,2:ny-1) = k_Hz_1.*Hz(2:nx-1,2:ny-1) + ...
                        k_Hz_2.*( Wz(2:nx-1,2:ny-1)-Fz_r1 )./M1;
    % TM: Fz -> Tz -> Ez                
    Fz_r = Fz(2:nx-1,2:ny-1);
    Tz_r = Tz(2:nx-1,2:ny-1);
    Fz(2:nx-1,2:ny-1) = k_Fz_1.*Fz(2:nx-1,2:ny-1) + k_Fz_2.*( (Hy(2:nx-1,2:ny-1) - ...
                        Hy(1:nx-2,2:ny-1))/dx - (Hx(2:nx-1,2:ny-1) - ...
                        Hx(2:nx-1,1:ny-2))/dy );
    Tz(2:nx-1,2:ny-1) = K_a.*Tz(2:nx-1,2:ny-1) + ...
                        K_b.*( Fz(2:nx-1,2:ny-1) - Fz_r);
    Ez(2:nx-1,2:ny-1) = k_Ez_1.*Ez(2:nx-1,2:ny-1) + ...
                        k_Ez_2.*( Tz(2:nx-1,2:ny-1) - Tz_r )./M0;                   

    %% Calculate scattered field Ez and Hz in TF/SF
    % TE mode                     
    Hz(nx_a+1,ny_a+1:ny_b+1) = Hz(nx_a+1,ny_a+1:ny_b+1) + ...
    dt./(mu_0*Material(Index(nx_a+1,ny_a+1:ny_b+1)+1,2)'*dx)*Ey_1D(1);
    Hz(nx_b+1,ny_a+1:ny_b+1) = Hz(nx_b+1,ny_a+1:ny_b+1) - ...
    dt./(mu_0*Material(Index(nx_b+1,ny_a+1:ny_b+1)+1,2)'*dx)*Ey_1D(nx_b-nx_a+2);
    % TM mode                     
    Ez(nx_a+1,ny_a+1:ny_b+1) = Ez(nx_a+1,ny_a+1:ny_b+1) - ...
    dt./(epsilon_0*Material(Index(nx_a+1,ny_a+1:ny_b+1)+1,1)'*dx)*Hy_1D(1);
    Ez(nx_b+1,ny_a+1:ny_b+1) = Ez(nx_b+1,ny_a+1:ny_b+1) + ...
    dt./(epsilon_0*Material(Index(nx_b+1,ny_a+1:ny_b+1)+1,1)'*dx)*Hy_1D(nx_b-nx_a+2);

    %% Calculate Hx and Ex total fields 
    % TE mode
    Gx_r1 = Mx(1:nx,1:ny-1);
    Mx(1:nx,1:ny-1) = k_Gx_1.*Mx(1:nx,1:ny-1) + ...
                      k_Gx_2.*( Hz(1:nx,2:ny)-Hz(1:nx,1:ny-1) );
    Ex(1:nx,1:ny-1) = K_a1(Index(1:nx,1:ny-1)+1).*( K_b1(Index(1:nx,1:ny-1)+1).*...
                      Ex(1:nx,1:ny-1) + k_Ex_1.*Mx(1:nx,1:ny-1)-k_Ex_2.*Gx_r1 );
    % TM mode 
    Gx_r = Gx(1:nx,1:ny-1);
    Gx(1:nx,1:ny-1) = k_Gx_1.*Gx(1:nx,1:ny-1) - ...
                      k_Gx_2.*( Ez(1:nx,2:ny)-Ez(1:nx,1:ny-1) );
    Hx(1:nx,1:ny-1) = Hx(1:nx,1:ny-1) + (k_Hx_1.*Gx(1:nx,1:ny-1) - k_Hx_2.*Gx_r)./M2;

    %% Calculate Hy and Ey total fields 
    % TE mode
    Gy_r1 = My(1:nx-1,1:ny);
    My(1:nx-1,1:ny) = k_Gy_1.*My(1:nx-1,1:ny) - ...
                      k_Gy_2.*( Hz(2:nx,1:ny)-Hz(1:nx-1,1:ny) );
    Ey(1:nx-1,1:ny) = K_a1(Index(1:nx-1,1:ny)+1).*( K_b1(Index(1:nx-1,1:ny)+1).*...
                      Ey(1:nx-1,1:ny) + k_Ey_1.*My(1:nx-1,1:ny)-k_Ey_2.*Gy_r1 );
    % TM mode 
    Gy_r = Gy(1:nx-1,1:ny);
    Gy(1:nx-1,1:ny) = k_Gy_1.*Gy(1:nx-1,1:ny) + ...
                      k_Gy_2.*(Ez(2:nx,1:ny)-Ez(1:nx-1,1:ny));
    Hy(1:nx-1,1:ny) = Hy(1:nx-1,1:ny) + ...
                      (k_Hy_1.*Gy(1:nx-1,1:ny) - k_Hy_2.*Gy_r)./M3;

    %% Calculate scattered field Hx and Ex in TF/SF
    % TE mode
    Ex(nx_a+1:nx_b+1,ny_a) = Ex(nx_a+1:nx_b+1,ny_a) - ...
    2*dt/dy*K_a1(Index(nx_a+1:nx_b+1,ny_a)+1)'.*Hz_1D(2:(nx_b-nx_a+2));
    Ex(nx_a+1:nx_b+1,ny_b+1) = Ex(nx_a+1:nx_b+1,ny_b+1) + ...
    2*dt/dy*K_a1(Index(nx_a+1:nx_b+1,ny_b+1)+1)'.*Hz_1D(2:(nx_b-nx_a+2));
    % TM mode                     
    Hx(nx_a+1:nx_b+1,ny_a) = Hx(nx_a+1:nx_b+1,ny_a) + ...
    dt./(mu_0*dy*Material(Index(nx_a+1:nx_b+1,ny_a)+1,2)).*Ez_1D(2:(nx_b-nx_a+2));
    Hx(nx_a+1:nx_b+1,ny_b+1) = Hx(nx_a+1:nx_b+1,ny_b+1) - ...
    dt./(mu_0*dy*Material(Index(nx_a+1:nx_b+1,ny_b+1)+1,2)).*Ez_1D(2:(nx_b-nx_a+2));

    %% Calculate scattered field Hy and Ey in TF/SF
    % TE mode
    Ey(nx_a,ny_a+1:ny_b+1) = Ey(nx_a,ny_a+1:ny_b+1) + ...
    2*dt/dx*K_a1(Index(nx_a,ny_a+1:ny_b+1)+1,1)'.*Hz_1D(2);
    Ey(nx_b+1,ny_a+1:ny_b+1) = Ey(nx_b+1,ny_a+1:ny_b+1) - ...
    2*dt/dx*K_a1(Index(nx_b+1,ny_a+1:ny_b+1)+1,1)'.*Hz_1D(nx_b-nx_a+2);
    % TM mode                     
    Hy(nx_a,ny_a+1:ny_b+1) = Hy(nx_a,ny_a+1:ny_b+1) - ...
    dt./(mu_0*dx*Material(Index(nx_a,ny_a+1:ny_b+1)+1,2)')*Ez_1D(2);
    Hy(nx_b+1,ny_a+1:ny_b+1) = Hy(nx_b+1,ny_a+1:ny_b+1) + ...
    dt./(mu_0*dx*Material(Index(nx_b+1,ny_a+1:ny_b+1)+1,2)')*Ez_1D(nx_b-nx_a+2);

    %% Plot Ez and Hz fields dynamics
    if (mod(T,10) == 0)
    subplot(1,2,1);    
	pcolor(Y(PML:ny-PML),X(PML:nx-PML),Ez(PML:nx-PML,PML:ny-PML));
	shading interp;
	caxis([-E0 E0]);
	axis image;
	colorbar;
	title('E_{z}(x,y)', 'FontSize',18, 'FontName', 'Arial', 'FontWeight', 'Bold');
	xlabel('x, [m]', 'FontSize',18, 'FontName', 'Arial', 'FontWeight', 'Bold');
	ylabel('y, [m]', 'FontSize',18, 'FontName', 'Arial', 'FontWeight', 'Bold');
    subplot(1,2,2);    
	pcolor(Y(PML:ny-PML),X(PML:nx-PML),Hz(PML:nx-PML,PML:ny-PML));
    shading interp;
	caxis([-E0 E0]);
	axis image;
	colorbar;
	title('H_{z}(x,y)', 'FontSize',18, 'FontName', 'Arial', 'FontWeight', 'Bold');
	xlabel('x, [m]', 'FontSize',18, 'FontName', 'Arial', 'FontWeight', 'Bold');
	ylabel('y, [m]', 'FontSize',18, 'FontName', 'Arial', 'FontWeight', 'Bold');
	drawnow;
    end
end
disp(['Time elapsed - ',num2str(toc/60),' minutes']);
