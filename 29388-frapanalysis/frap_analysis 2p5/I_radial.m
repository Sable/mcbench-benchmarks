%I_radial - calculates an averaged radial function
%   [Ir,r,R]=I_radial(N,x_cm,y_cm,Xx,Yy,I,rmax) where:
%
%   Ir =  radial intensities
%   r = the radial distances
%   R = a parameter roughly equal to max(r)
%   rmax = max(r) used
%
%   N = the number of data points in r
%   x_cm and y_cm = the centre of mass coordinates
%   Xx and Yy = grid matrixes with pixel positions
%   I = 2D data to be averaged
%   rmax = max(r) (rmax=[] means that the program uses the largest value
%       possible from the image for rmax)

function [Ir,r,R,rmax]=I_radial(N,x_cm,y_cm,Xx,Yy,I,rmax)

% Calculates the first N+1 zeros of the zeroth order Besselfunction
m=(6:1:N+1);
alpha_t=[2.404825558,5.520078110,8.653727913,11.79153444,14.93091771];
c=[alpha_t,pi/4*(4*m-1)+1./(2*pi*(4*m-1))-31./(6*pi^3*(4*m-1).^3)+3779./(15*pi^5*(4*m-1).^5)];

if isempty(rmax)
    R=double(min([x_cm-1,size(Xx,2)-x_cm,y_cm-1,size(Yy,1)-y_cm])-1);
else
    R=rmax;
end
rmax=R;

% Specifies variours parameters 
alpha=c(1,1:N);
V=c(1,N+1)/(2*pi*R);
r=alpha/(2*pi*V);

% Performs the radial averaging by interpolating the value for I at a fixed
% radial distance, but for different angles
Ir=zeros(length(r),1);
for i=1:length(r)
    Isum=0;
    j_sum=min(ceil(2*pi*R),max(10,ceil(2*pi*r(i))));
    j_sum2=0;

    for j=1:j_sum
        theta=2*pi*j/j_sum;
        x=x_cm+r(i)*cos(theta);
        y=y_cm+r(i)*sin(theta);
        nx=round(x/1);
        ny=size(Yy,1)-round(y/1)+1;
        if nx<size(I,2) && nx>1 && ny>1 && ny<size(I,1)
            Isum=Isum+I(ny,nx)+(I(ny-1,nx)-I(ny+1,nx))/2*(y-round(y/1))+(I(ny,nx+1)-I(ny,nx-1))/2*(x-round(x/1));
            j_sum2=j_sum2+1;
        end
    end
    Ir(i)=Isum/j_sum2;
end
