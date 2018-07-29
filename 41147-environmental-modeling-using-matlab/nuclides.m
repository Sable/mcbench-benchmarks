function nuclides
% Solution for a chain of radionuclides
%    using MATLAB expm                   
%   $Ekkehard Holzbecher  $Date: 2006/28/12 $
%--------------------------------------------------------------------------

T = 10;                % maximum time
lambda = [1; 0.1; 0.5];% decay rates  
c0 = [1; 0; 0];        % initial concentrations
q = [0.1; 0; 0];       % source rates
N = 60;                % discretization of time

t = linspace (0,T,N);
B = -diag(lambda);
for i = 2:size(lambda,1)
    B(i,i-1) = lambda(i-1); 
end
c = c0;

for i = 2:N
    E = expm(B*t(i));
    c = [c E*c0-(eye(size(B,1))-E)*inv(B)*q];
end  
plot (t,c');
legend ('mother','daughter 1','daughter 2');
text (T/2,0.8,'Steady state:'); text (T/2,0.7,num2str(-(inv(B)*q)')); 
xlabel ('time');