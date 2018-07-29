function [gamma, Fu_bar, Fv_bar, Fw_bar]=VortexStrength(panel,phi)
% Implement Vortex Lattice Method
%Input: panel geometry
%Output vortex strength (gamma)
%Influence coefficients (Fx_bar)

ns = size(panel,1);
nc = size(panel,2);
%Preallocate memory for large variables where first dimension points to controls points; second dimension points to horseshoe vortices; 
%  third dimension points to three dimensional coordinates
r0 = zeros(ns*nc,2*ns*nc,3);
r1 = zeros(ns*nc,2*ns*nc,3);
r2 = zeros(ns*nc,2*ns*nc,3);
omega_bound = zeros(ns*nc,2*ns*nc,3);
omega_a_inf = zeros(ns*nc,2*ns*nc,3);
omega_b_inf = zeros(ns*nc,2*ns*nc,3);
Fu = zeros(ns*nc,2*ns*nc);
Fv = zeros(ns*nc,2*ns*nc);
Fw = zeros(ns*nc,2*ns*nc);

%Determine influence coefficients

%Iterate through all control points
for i = 1:ns
    for j = 1:nc
        n=(j-1)*ns+i;
        %Iterate through all bound vortices
        for k = 1:ns
            for p=1:nc
                m=(p-1)*ns+k;
                
                %Code derived from Bertin, Aerodynamics for Engineers, ed.
                %4, pg 263-266
                r0(n,m,:)=panel(k,p).BV2-panel(k,p).BV1;
                r1(n,m,:)=panel(i,j).CP-panel(k,p).BV1;
                r2(n,m,:)=panel(i,j).CP-panel(k,p).BV2;
                
                Fac1=shiftdim(cross(r1(n,m,:),r2(n,m,:)))/(norm(shiftdim(cross(r1(n,m,:),r2(n,m,:)))))^2;
                Fac2=dot(r0(n,m,:),(r1(n,m,:)/norm(shiftdim(r1(n,m,:)))))-dot(r0(n,m,:),(r2(n,m,:)/norm(shiftdim(r2(n,m,:)))));
        
                Fac1a(1,1)=0;
                Fac1a(1,2)=(panel(i,j).CP(3)-panel(k,p).BV1(3))/((panel(i,j).CP(3)-panel(k,p).BV1(3))^2+(panel(k,p).BV1(2)-panel(i,j).CP(2))^2);
                Fac1a(1,3)=(panel(k,p).BV1(2)-panel(i,j).CP(2))/((panel(i,j).CP(3)-panel(k,p).BV1(3))^2+(panel(k,p).BV1(2)-panel(i,j).CP(2))^2);
                Fac2a=-1+((panel(i,j).CP(1)-panel(k,p).BV1(1))/norm(shiftdim(r1(n,m,:))));  %'-1' due to change in axes
        
                Fac1b(1,1)=0;
                Fac1b(1,2)=-(panel(i,j).CP(3)-panel(k,p).BV2(3))/((panel(i,j).CP(3)-panel(k,p).BV2(3))^2+(panel(k,p).BV2(2)-panel(i,j).CP(2))^2);
                Fac1b(1,3)=-(panel(k,p).BV2(2)-panel(i,j).CP(2))/((panel(i,j).CP(3)-panel(k,p).BV2(3))^2+(panel(k,p).BV2(2)-panel(i,j).CP(2))^2);
                Fac2b=(-1+((panel(i,j).CP(1)-panel(k,p).BV2(1))/norm(shiftdim(r2(n,m,:)))));
        
                omega_bound(n,m,:)=Fac1*Fac2;
                omega_a_inf(n,m,:)=Fac1a*Fac2a;
                omega_b_inf(n,m,:)=Fac1b*Fac2b;
        
                Fu(n,m)=omega_bound(n,m,1)+omega_a_inf(n,m,1)+omega_b_inf(n,m,1);
                Fv(n,m)=omega_bound(n,m,2)+omega_a_inf(n,m,2)+omega_b_inf(n,m,2);
                Fw(n,m)=omega_bound(n,m,3)+omega_a_inf(n,m,3)+omega_b_inf(n,m,3);
%Performing identical operations on opposite wing
                r0(n,m+ns*nc,:)=[panel(k,p).BV1(1) -panel(k,p).BV1(2) panel(k,p).BV1(3)]'-[panel(k,p).BV2(1) -panel(k,p).BV2(2) panel(k,p).BV2(3)]';
                r1(n,m+ns*nc,:)=panel(i,j).CP-[panel(k,p).BV2(1) -panel(k,p).BV2(2) panel(k,p).BV2(3)]';
                r2(n,m+ns*nc,:)=panel(i,j).CP-[panel(k,p).BV1(1) -panel(k,p).BV1(2) panel(k,p).BV1(3)]';
                
                Fac1=shiftdim(cross(r1(n,m+ns*nc,:),r2(n,m+ns*nc,:)))/(norm(shiftdim(cross(r1(n,m+ns*nc,:),r2(n,m+ns*nc,:)))))^2;
                Fac2=dot(r0(n,m+ns*nc,:),(r1(n,m+ns*nc,:)/norm(shiftdim(r1(n,m+ns*nc,:)))))-dot(r0(n,m+ns*nc,:),(r2(n,m+ns*nc,:)/norm(shiftdim(r2(n,m+ns*nc,:)))));
        
                Fac1a(1,1)=0;
                Fac1a(1,2)=(panel(i,j).CP(3)-panel(k,p).BV2(3))/((panel(i,j).CP(3)-panel(k,p).BV2(3))^2+(-panel(k,p).BV(2)-panel(i,j).CP(2))^2);
                Fac1a(1,3)=(-panel(k,p).BV2(2)-panel(i,j).CP(2))/((panel(i,j).CP(3)-panel(k,p).BV2(3))^2+(-panel(k,p).BV2(2)-panel(i,j).CP(2))^2);
                Fac2a=-1+((panel(i,j).CP(1)-panel(k,p).BV2(1))/norm(shiftdim(r1(n,m+ns*nc,:))));
        
                Fac1b(1,1)=0;
                Fac1b(1,2)=-(panel(i,j).CP(3)-panel(k,p).BV1(3))/((panel(i,j).CP(3)-panel(k,p).BV1(3))^2+(-panel(k,p).BV1(2)-panel(i,j).CP(2))^2);
                Fac1b(1,3)=-(-panel(k,p).BV1(2)-panel(i,j).CP(2))/((panel(i,j).CP(3)-panel(k,p).BV1(3))^2+(-panel(k,p).BV1(2)-panel(i,j).CP(2))^2);
                Fac2b=(-1+((panel(i,j).CP(1)-panel(k,p).BV1(1))/norm(shiftdim(r2(n,m+ns*nc,:)))));
        
                omega_bound(n,m+ns*nc,:)=Fac1*Fac2;
                omega_a_inf(n,m+ns*nc,:)=Fac1a*Fac2a;
                omega_b_inf(n,m+ns*nc,:)=Fac1b*Fac2b;
        
                Fu(n,m+ns*nc)=omega_bound(n,m+ns*nc,1)+omega_a_inf(n,m+ns*nc,1)+omega_b_inf(n,m+ns*nc,1);
                Fv(n,m+ns*nc)=omega_bound(n,m+ns*nc,2)+omega_a_inf(n,m+ns*nc,2)+omega_b_inf(n,m+ns*nc,2);
                Fw(n,m+ns*nc)=omega_bound(n,m+ns*nc,3)+omega_a_inf(n,m+ns*nc,3)+omega_b_inf(n,m+ns*nc,3);
                
                %Code derived from NASA TN D-6142 (Vortex Lattice Fortran
                %program for estimating subsonic aerodynamic
                %characteristics of complex planforms
%                 x=-panel(i,j).CPprime+panel(k,p).BVprime;
%                 y=-panel(i,j).CP(2)+panel(k,p).BV(2);
%                 z=-panel(i,j).CP(3)+panel(k,p).BV(3);
%                 s=panel(i,j).s;
%                 psi=panel(i,j).sweepprime;
%                 Fw(n,m)=((y*tan(psi)-x)*cos(phi))...
%                     /(x^2+(y*sin(phi))^2+cos(phi)^2*(y^2*tan(psi)^2+z^2*sec(psi)^2-2*y*x*tan(psi))-2*z*cos(phi)*sin(phi)*(y+x*tan(psi)))...
%                     *(((x+s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y+s*cos(phi))*cos(phi)+(z+s*sin(phi))*sin(phi))...
%                     /sqrt((x+s*cos(phi)*tan(psi))^2+(y+s*cos(phi))^2+(z+s*sin(phi))^2)...
%                     -((x-s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y-s*cos(phi))*cos(phi)+(z-s*sin(phi))*sin(phi))...
%                     /sqrt((x-s*cos(phi)*tan(psi))^2+(y-s*cos(phi))^2+(z-s*sin(phi))^2))...
%                     -(y-s*cos(phi))/((y-s*cos(phi))^2+(z-s*sin(phi))^2)...
%                     *(1-(x-s*cos(phi)*tan(psi))/sqrt((x-s*cos(phi)*tan(psi))^2+(y-s*cos(phi))^2+(z-s*sin(phi))^2))...
%                     +(y+s*cos(phi))/((y+s*cos(phi))^2+(z+s*sin(phi))^2)...
%                     *(1-(x+s*cos(phi)*tan(psi))/sqrt((x+s*cos(phi)*tan(psi))^2+(y+s*cos(phi))^2+(z+s*sin(phi))^2));
%                 Fv(n,m)=(x*sin(phi)-z*cos(phi)*tan(psi))/(x^2+(y*sin(phi))^2+cos(phi)^2*(y^2*tan(psi)^2+z^2*sec(psi)^2-2*y*x*tan(psi))-2*z*cos(phi)*sin(phi)*(y+x*tan(psi))...
%                     *(((x+s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y+s*cos(phi))*cos(phi)+(z+s*sin(phi))*sin(phi))/sqrt((x+s*cos(phi)*tan(psi))^2+(y+s*cos(phi))^2+(z+s*sin(phi))^2))...
%                     -((x-s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y-s*cos(phi))*cos(phi)+(z-s*sin(phi))*sin(phi))/sqrt((x-s*cos(phi)*tan(psi))^2+(y-s*cos(phi))^2+(z-s*sin(phi))^2))...
%                     -(z-s*cos(phi))/((y-s*cos(phi))^2+(z-s*sin(phi))^2)*(1-(x-s*cos(phi)*tan(psi))/sqrt((x-s*cos(phi)*tan(psi))^2+(y-s*cos(phi))^2+(z-s*sin(phi))^2))...
%                     +(z+s*cos(phi))/((y+s*cos(phi))^2+(z+s*sin(phi))^2)*(1-(x+s*cos(phi)*tan(psi))/sqrt((x+s*cos(phi)*tan(psi))^2+(y+s*cos(phi))^2+(z+s*sin(phi))^2));
%                 Fu(n,m)=(z*cos(phi)-y*sin(phi))/(x^2+(y*sin(phi))^2+cos(phi)^2*(y^2*tan(psi)^2+z^2*sec(psi)^2-2*y*x*tan(psi))-2*z*cos(phi)*sin(phi)*(y+x*tan(psi))...
%                     *(((x+s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y+s*cos(phi))*cos(phi)+(z+s*sin(phi))*sin(phi))/sqrt((x+s*cos(phi)*tan(psi))^2+(y+s*cos(phi))^2+(z+s*sin(phi))^2))...
%                     -((x-s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y-s*cos(phi))*cos(phi)+(z-s*sin(phi))*sin(phi))/sqrt((x-s*cos(phi)*tan(psi))^2+(y-s*cos(phi))^2+(z-s*sin(phi))^2));
% 
%                 %Determining influence coefficients from symmetric wing and
%                 %adding that to the original wing to "fold" influence
%                 %matrices and create F_bar
%                 y=y+2*panel(k,p).BV(2);
%                 Fw(n,m+ns*nc)=((y*tan(psi)-x)*cos(phi))/(x^2+(y*sin(phi))^2+cos(phi)^2*(y^2*tan(psi)^2+z^2*sec(psi)^2-2*y*x*tan(psi))-2*z*cos(phi)*sin(phi)*(y+x*tan(psi)))...
%                     *(((x+s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y+s*cos(phi))*cos(phi)+(z+s*sin(phi))*sin(phi))...
%                     /sqrt((x+s*cos(phi)*tan(psi))^2+(y+s*cos(phi))^2+(z+s*sin(phi))^2)...
%                     -((x-s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y-s*cos(phi))*cos(phi)+(z-s*sin(phi))*sin(phi))...
%                     /sqrt((x-s*cos(phi)*tan(psi))^2+(y-s*cos(phi))^2+(z-s*sin(phi))^2))...
%                     -(y-s*cos(phi))/((y-s*cos(phi))^2+(z-s*sin(phi))^2)...
%                     *(1-(x-s*cos(phi)*tan(psi))/sqrt((x-s*cos(phi)*tan(psi))^2+(y-s*cos(phi))^2+(z-s*sin(phi))^2))...
%                     +(y+s*cos(phi))/((y+s*cos(phi))^2+(z+s*sin(phi))^2)...
%                     *(1-(x+s*cos(phi)*tan(psi))/sqrt((x+s*cos(phi)*tan(psi))^2+(y+s*cos(phi))^2+(z+s*sin(phi))^2));
%                 Fv(n,m+ns*nc)=(x*sin(phi)-z*cos(phi)*tan(psi))/(x^2+(y*sin(phi))^2+cos(phi)^2*(y^2*tan(psi)^2+z^2*sec(psi)^2-2*y*x*tan(psi))-2*z*cos(psi)*sin(psi)*(y+x*tan(psi))...
%                     *(((x+s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y+s*cos(phi))*cos(phi)+(z+s*sin(phi))*sin(phi))/sqrt((x+s*cos(phi)*tan(psi))^2+(y+s*cos(phi))^2+(z+s*sin(phi))^2))...
%                     -((x-s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y-s*cos(phi))*cos(phi)+(z-s*sin(phi))*sin(phi))/sqrt((x-s*cos(phi)*tan(psi))^2+(y-s*cos(phi))^2+(z-s*sin(phi))^2))...
%                     -(z-s*cos(phi))/((y-s*cos(phi))^2+(z-s*sin(phi))^2)*(1-(x-s*cos(phi)*tan(psi))/sqrt((x-s*cos(phi)*tan(psi))^2+(y-s*cos(phi))^2+(z-s*sin(phi))^2))...
%                     +(z+s*cos(phi))/((y+s*cos(phi))^2+(z+s*sin(phi))^2)*(1-(x+s*cos(phi)*tan(psi))/sqrt((x+s*cos(phi)*tan(psi))^2+(y+s*cos(phi))^2+(z+s*sin(phi))^2));
%                 Fu(n,m+ns*nc)=(z*cos(phi)-y*sin(phi))/(x^2+(y*sin(phi))^2+cos(phi)^2*(y^2*tan(psi)^2+z^2*sec(psi)^2-2*y*x*tan(psi))-2*z*cos(psi)*sin(psi)*(y+x*tan(psi))...
%                     *(((x+s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y+s*cos(phi))*cos(phi)+(z+s*sin(phi))*sin(phi))/sqrt((x+s*cos(phi)*tan(psi))^2+(y+s*cos(phi))^2+(z+s*sin(phi))^2))...
%                     -((x-s*cos(phi)*tan(psi))*cos(phi)*tan(psi)+(y-s*cos(phi))*cos(phi)+(z-s*sin(phi))*sin(phi))/sqrt((x-s*cos(phi)*tan(psi))^2+(y-s*cos(phi))^2+(z-s*sin(phi))^2));
            end
        end
    end
end
% [panel.CP]
% [panel.BV1]
% [panel.BV2]
% r0
% r1
% r2
% omega_bound
% omega_a_inf
% omega_b_inf
% Fv
% Fw
Fu_bar=Fu(:,1:ns*nc)+Fu(:,ns*nc+1:2*ns*nc);
Fv_bar=Fv(:,1:ns*nc)+Fv(:,ns*nc+1:2*ns*nc);
Fw_bar=Fw(:,1:ns*nc)+Fw(:,ns*nc+1:2*ns*nc);
%Determine vortex strength using boundary conditions considering just twist and camber
c=inv(Fw_bar-Fv_bar*tan(phi))*4*pi*sin([panel.twist]'-[panel.dzdx]');  %Eqn 16 in NASA paper and removing small angle assumption on alpha

%Determine vortex strength using boundary conditions where alpha = 1 rad
alpha=4*pi*inv(Fw_bar-Fv_bar*tan(phi))*sin(ones(ns*nc,1));  %Eqn 16 in NASA paper and removing small angle assumption on alpha

for i = 1:ns
    for j = 1:nc
        k=(j-1)*ns+i;
        gamma(i,j).c=c(k);
        gamma(i,j).alpha=alpha(k);
    end
end

