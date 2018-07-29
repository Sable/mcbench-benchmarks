function OUT=lorenzeq(t,X)
%LORENZEQ  Lorenz equation 
%          (a 3rd-order continuous autonomous system):
%
%               dx/dt = SIGMA*(y - x)
%               dy/dt = RHO*x - y -x*z
%               dz/dt= x*y - BETA*z
%
%        In this demo, SIGMA = 16, RHO = 45.92, BETA = 4
%        Initial conditions: x(0) = 1, y(0) = 1, z(0) = 1;
%        Reference values: LE1 = 1.497, LE2 = 0.00, LE3 = -22.46, LD = 2.07
%
%        The reference values are from the following references:
%
%        [1] A. Wolf, J. B. Swift, H. L. Swinney and J. A. Vastano,
%            "Determining Lyapunov Exponents from a Time Series,"
%            Physica D, Vol. 16, pp. 285-317, 1985.
%
%        [2] Keith Briggs, "An Improved Method for Estimating Liapunov
%            Exponents of Chaotic Time Series," Phys. Lett. A, Vol. 151,
%            pp. 27-32, Nov. 1990.

%        by Steve Wai Kam SIU, Jun. 29, 1998.

%PARAMETERS
SIGMA = 16;
RHO = 45.92;
BETA = 4;

%Rearrange input data in desired format
%Note: the input data is a column vector
x=X(1);y=X(2);z=X(3);
Q=[X(4), X(7), X(10);
    X(5), X(8), X(11);
    X(6), X(9), X(12)];

%Lorenz equation
dx=SIGMA*(y-x);
dy=-x*z+RHO*x-y;
dz=x*y-BETA*z;

DX1=[dx;dy;dz];	%Output data

%Linearized system
 J=[-SIGMA, SIGMA,     0;
     RHO-z,    -1,    -x;
         y,     x, -BETA];
  
%Variational equation   
F=J*Q;

%Output data must be a column vector
OUT=[DX1; F(:)];

