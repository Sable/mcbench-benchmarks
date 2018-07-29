function phasediag
% Phase diagram visualisation  
%    using MATLAB expm                   
%
%   $Ekkehard Holzbecher  $Date: 2006/04/15 $
%--------------------------------------------------------------------------
T = 10;                % maximum time
C = [-1 1; 1 -3];      % matrix
f = [1; 0];            % input vector
cc = 1;                % initial concentrations (absolute value of the vector)
N = 60;                % discretization of time
M = 16;                % no. of trajectories  

%----------------------execution & output----------------------------------
equilibrium = -(C\f);
t = linspace (0,T,N);
for angle = linspace (0,pi+pi,M)
    c0 = equilibrium + cc*[sin(angle); cos(angle)]; c = c0;
    for i = 2:N
        E = expm(C*t(i));
        c = [c E*c0-(eye(size(C,1))-E)*(C\f)];
    end  
    plot (c(1,:)',c(2,:)'); hold on;
end

plot (equilibrium(1),equilibrium(2),'s');
xlabel ('variable 1'); ylabel ('variable 2')
title ('phase diagram')