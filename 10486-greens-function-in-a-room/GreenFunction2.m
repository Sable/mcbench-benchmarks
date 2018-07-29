function [GF2] = GreenFunction2(r0,r,f0)

parameter; % Define parameters
k0    = 2*pi*f0/c; % fixed wavenumber

GF2   = zeros(1,N+1); % Initialisation of array vector
mode0 = zeros(1,N+1);


% Construct a line from r0 to r
diff_r_r0 = r - r0;    %distance between r and r0
rz0 = [r(1);r(2);0];   %Projection onto x-y plane
diff_rz0_r = rz0 - r0; %distance between r in z-axis and r0

% Calculate the angles between the lines 
angle1 = acos((diff_r_r0'*diff_rz0_r)/(norm(diff_r_r0)*norm(diff_rz0_r)));
angle2 = acos((diff_rz0_r'*rz0)/(norm(rz0)*norm(diff_rz0_r)));

Lvec = norm(diff_r_r0);  %length of line
Nvec = (0:1:N);
xpos = Nvec.*Lvec/N*cos(angle1)*sin(angle2) + r0(1);
ypos = Nvec.*Lvec/N*cos(angle1)*cos(angle2) + r0(2);
zpos = Nvec.*Lvec/N*sin(angle1)             + r0(3);

for d = 1:N+1
     
%%% Calculate the AXIAL MODE %%%
    %lx
    	N = fix(2*2*lx*f0/c); %number of axial modes below frequency f0
        nx = 1:N;
        rx = xpos(d);
    	[modeshape,k_term] = AxialMode(nx,lx,rx,r0(1),k0);
    	GF2(d) = GF2(d) + (-1/V)*sum(sum(modeshape./k_term));
    %ly
        N = fix(2*2*ly*f0/c); %number of axial modes below frequency f0
        ny = 1:N;
        ry = ypos(d);
    	[modeshape,k_term] = AxialMode(ny,ly,ry,r0(2),k0);
    	GF2(d) = GF2(d) + (-1/V)*sum(sum(modeshape./k_term));
    %lz
        N = fix(2*2*lz*f0/c); %number of axial modes below frequency f0
        nz = 1:N;
        rz = zpos(d);
    	[modeshape,k_term] = AxialMode(nz,lz,rz,r0(3),k0);
    	GF2(d) = GF2(d) + (-1/V)*sum(sum(modeshape./k_term)); 
            
%%% Calculate the TANGENTIAL MODE %%%
    %lx,ly
    	N = fix(2*pi*lx*ly*f0^2/c^2); %number of tangential modes below frequency f0
    	nx = 1:N; ny = nx;
        rx = xpos(d); ry = ypos(d);
    	[modeshape,k_term] = TangentialMode(nx,ny,lx,ly,rx,ry,r0(1),r0(2),k0);
    	GF2(d) = GF2(d) + (-1/V)*sum(sum(modeshape./k_term));
    %ly,lz
		N = fix(2*pi*ly*lz*f0^2/c^2); %number of tangential modes below frequency f0    
        ny = 1:N; nz = ny;
        ry = ypos(d); rz = zpos(d);
    	[modeshape,k_term] = TangentialMode(ny,nz,ly,lz,ry,rz,r0(2),r0(3),k0);
    	GF2(d) = GF2(d) + (-1/V)*sum(sum(modeshape./k_term));
    %lx,lz
    	N = fix(2*pi*lx*lz*f0^2/c^2); %number of tangential modes below frequency f0
        nx = 1:N; nz = nx;
        rx = xpos(d); rz = zpos(d);
    	[modeshape,k_term] = TangentialMode(nx,nz,lx,lz,rx,rz,r0(1),r0(3),k0);
    	GF2(d) = GF2(d) + (-1/V)*sum(sum(modeshape./k_term));
       
%%% Calculate the OBLIQUE MODE %%%    
    %lx,ly,lz
    	N = fix(2*4*pi*lx*ly*lz*f0^3/(3*c^3)); %number of oblique modes below frequency f0
        ny = 1:N; nz = ny;
        rx = xpos(d); ry = ypos(d); rz = zpos(d);
        for nx = 1:N,
            [modeshape,k_term] = ObliqueMode(nx,ny,nz,lx,ly,lz,rx,ry,rz,r0(1),r0(2),r0(3),k0);
            GF2(d) = GF2(d) + (-1/V)*sum(sum(modeshape./k_term));
        end;

%%% Calculate the (0,0,0) mode %%%
    mode0 = -8/(V*k0.^2);

%%% Calculate the Green function plus the (0,0,0) mode
    GF2(d) = GF2(d) + mode0; 
end;    