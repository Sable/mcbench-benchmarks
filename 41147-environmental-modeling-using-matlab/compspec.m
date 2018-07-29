function compspec
% Competing species phase diagram  
%    using MATLAB ode                   
%
%   $Ekkehard Holzbecher  $Date: 2006/09/04 $
%--------------------------------------------------------------------------
T = 1000;                % maximum time
r = [1; 1];              % rates 
e = [1; 1];              % equilibria
lambda = 1;              % lambda parameter
c0 = [1; 1];             % initial concentrations

gtraj = 1;               % trajectory plot
gquiv = 20;              % arrow field plot; value for no. of arrows in 1D
xmin = 0; xmax = 1;      % x- interval for arrow field plot
ymin = 0; ymax = 1;      % y-     "     "    "     "     "
scale = 2;               % scaling factor for arrows 
%----------------------execution-------------------------------------------

options = odeset('AbsTol',1e-20);
[~,c] = ode15s(@CS,[0 T],c0,options,r,e,lambda);

%---------------------- graphical output ----------------------------------

if (gtraj)
    plot (c(:,1)',c(:,2)'); hold on;
    plot (e(1),0,'s'); plot (0,e(2),'s');
    legend ('trajectory');
    xlabel ('specie 1'); ylabel ('specie 2');
    title ('Competing species');
end
if (gquiv)
    [x,y] = meshgrid (linspace(xmin,xmax,gquiv),linspace(ymin,ymax,gquiv));
    dy = zeros(gquiv,gquiv,2);
    for i = 1:gquiv 
        for j = 1:gquiv
            dy(i,j,:) = CS(0,[x(i,j);y(i,j)],r,e,lambda);
        end
    end
    quiver (x,y,dy(:,:,1),dy(:,:,2),scale);
end

%---------------------- function ------------------------------------------
function dydt = CS(~,y,r,e,lambda)
k = [e(1)/(1+lambda*y(2)/y(1)); e(2)/(1+y(1)/y(2)/lambda)];
dydt = r.*y.*(1-y./k);
