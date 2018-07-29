% Plotting Mode Shapes
function PlotModeShapes(vec,fsol,beam,nbc) 

%--------------------------------------------------------------------------
% Purpose :                                                                
%         To Plot the Mode Shapes  
%
% Synopsis : 
%          PlotModeShapes(vec,fsol,beam,nbc) 
% 
% Variable Description:
% INPUT parameters:
%           vec : Eigenvector
%           fsol : Eigenvalues
%           beam : length vector of the beam (length discretization)
%           nbc : Number of boundary conditions 
%--------------------------------------------------------------------------
v = vec(1:2:end,:) ;    % Collecting only displacememtn degree's of Freedom
%
V = zeros(size(v)) ;
for i = 1:size(v,2)
    V(:,i) = v(:,i)./(max(abs(v(:,i)))) ;
end
%  

L = max(beam) ;         % Length of the beam
n = 1 ;
% 
% Plot First Mode shape
subplot(1,4,1)
plot(V(:,nbc+1),beam,'-ob','linewidth',n) ;
h = fsol(nbc+1) ;
title(num2str(h))
axis([-1 ,+1,0,L])
axis off 
%
% Plot Second Mode shape 
subplot(1,4,2) 
plot(V(:,nbc+2),beam,'-ob','linewidth',n) ;
h = fsol(nbc+2) ;
title(num2str(h))
axis([-1 ,+1,0,L])
axis off
%
% Plot Third Mode shape
subplot(1,4,3) 
plot(V(:,nbc+3),beam,'-ob','linewidth',n) ;
h = fsol(nbc+3) ;
title(num2str(h))
axis([-1 ,+1,0,L])
axis off
%
% Plot Fourth Mode shape
subplot(1,4,4)
plot(V(:,nbc+4),beam,'-ob','linewidth',n) ;
h = fsol(nbc+4) ;
title(num2str(h))
axis([-1 ,+1,0,L])
axis off
%