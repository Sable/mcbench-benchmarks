function xdot=ode1000(t,x); % called from ode23
  %% Ordinary differential equation / Równanie rozniczkowe zwyczajne 
        % use e.g. ode23 solver, u¿yj np. ode23
        % y''= -1001y' -1000y
        % Bjorck & Dalquist "Numerical Methods, 1974"                   
xdot=zeros(2,1);    % zerowy wektor 2-elementowy
xdot(1)=x(2);  
xdot(2)=-1001*x(2) -1000*x(1);