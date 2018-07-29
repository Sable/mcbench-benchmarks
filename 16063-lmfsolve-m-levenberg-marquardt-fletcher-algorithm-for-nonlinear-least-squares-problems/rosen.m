function r = rosen(x)
%%%%%%%%%%%%%%%%%%%%%   Rosenbrock valey with a constraint

R = sqrt(x(1)^2+x(2)^2)-.5;
%R = sqrt(x(1)^2+x(2)^2)-1;
%R = sqrt(x(1)^2+x(2)^2)-2;

%   Residuals:
r = [ 10*(x(2)-x(1)^2)  %   first part
      1-x(1)            %   second part
     (R>0)*R*500.     %   penalty
    ];
