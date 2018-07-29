function comparts
% Solution of a linear compartment model with constant input
%    using MATLAB expm                   
%    example see: Walter / Contreras p.181
%   $Ekkehard Holzbecher  $Date: 2006/04/08 $
%--------------------------------------------------------------------------


T = 10;                % maximum time 
C = [-1 1; 1 -3];      % matrix
f = [1; 0];            % input vector
c0 = [1; 1];           % initial concentrations
N = 60;                % discretization of time

t = linspace (0,T,N);
c = c0;
for i = 2:N
    E = expm(C*t(i));
    c = [c E*c0-(eye(size(C,1))-E)*inv(C)*f];
end  
plot (t,c');
legend ('1','2');
text (T/2,1.2,'Eigenvalues:'); text (T/2,1.1,num2str(eig(C)')); 
text (T/2,0.8,'Steady state:'); text (T/2,0.7,num2str(-(inv(C)*f)')); 
xlabel ('time');