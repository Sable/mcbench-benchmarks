function [GF] = GreenFunction(r0,r)

parameter; % Define parameters

GF    = zeros(length(fd),1); % Initialisation of array vector
mode0 = zeros(length(fd),1);

for f = 1:length(fd),
    fd(f);
               
%%% Calculate the AXIAL MODE %%%
    %lx
    	N = fix(2*2*lx*fd(f)/c); %number of axial modes below frequency fd
    	nx = 1:N;
    	[modeshape,k_term] = AxialMode(nx,lx,r(1),r0(1),kd(f));
    	GF(f) = GF(f) + (-1/V)*sum(sum(modeshape./k_term));
    %ly
        N = fix(2*2*ly*fd(f)/c); %number of axial modes below frequency fd
    	ny = 1:N;
    	[modeshape,k_term] = AxialMode(ny,ly,r(2),r0(2),kd(f));
    	GF(f) = GF(f) + (-1/V)*sum(sum(modeshape./k_term));
    %lz
        N = fix(2*2*lz*fd(f)/c); %number of axial modes below frequency fd
    	nz = 1:N;
    	[modeshape,k_term] = AxialMode(nz,lz,r(3),r0(3),kd(f));
    	GF(f) = GF(f) + (-1/V)*sum(sum(modeshape./k_term)); 
              
%%% Calculate the TANGENTIAL MODE %%%
    %lx,ly
    	N = fix(2*pi*lx*ly*fd(f)^2/c^2); %number of tangential modes below frequency fd
    	nx = 1:N;
    	ny = nx;
    	[modeshape,k_term] = TangentialMode(nx,ny,lx,ly,r(1),r(2),r0(1),r0(2),kd(f));
    	GF(f) = GF(f) + (-1/V)*sum(sum(modeshape./k_term));
    %ly,lz
		N = fix(2*pi*ly*lz*fd(f)^2/c^2); %number of tangential modes below frequency fd    
    	ny = 1:N;
    	nz = ny;
    	[modeshape,k_term] = TangentialMode(ny,nz,ly,lz,r(2),r(3),r0(2),r0(3),kd(f));
    	GF(f) = GF(f) + (-1/V)*sum(sum(modeshape./k_term));
    %lx,lz
    	N = fix(2*pi*lx*lz*fd(f)^2/c^2); %number of tangential modes below frequency fd
    	nx = 1:N;
    	nz = nx;
    	[modeshape,k_term] = TangentialMode(nx,nz,lx,lz,r(1),r(3),r0(1),r0(3),kd(f));
    	GF(f) = GF(f) + (-1/V)*sum(sum(modeshape./k_term));
       
%%% Calculate the OBLIQUE MODE %%%  
    %lx,ly,lz
    	N = fix(2*4*pi*lx*ly*lz*fd(f)^3/(3*c^3)); %number of oblique modes below frequency fd
    	ny = 1:N;
    	nz = ny;
        for nx = 1:N,
            [modeshape,k_term] = ObliqueMode(nx,ny,nz,lx,ly,lz,r(1),r(2),r(3),r0(1),r0(2),r0(3),kd(f));
            GF(f) = GF(f) + (-1/V)*sum(sum(modeshape./k_term));
        end;
        
%%% Calculate the (0,0,0) mode %%%
    mode0 = -8/(V*kd(f).^2);

%%% Calculate the Green function plus the (0,0,0) mode
    GF(f) = GF(f) + mode0;
 end;