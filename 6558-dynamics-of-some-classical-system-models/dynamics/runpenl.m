function runpenl(w0) 

% runpenl(w0)  
% See Article 2.5 
% This example integrates the pendulum equation
%   theta"(t) + 0.1*theta'(t)+sin(theta) = 0
% and animates the motion

% The equation of motion of a pendulum is
% described by two first order equations:
% theta'(t)=w; w'(t)=-.1*w-sin(theta). Let 
% z=[theta; w], then
% z'(t)=[z(2); 0.2*z(2)-sin(z(1))]

% Create a function defining the differential
% equation in matrix form

% pendulum=inline('[z(2);-sin(z(1))]','t','z');
pendulum=inline(...
   '[z(2);-0.2*z(2)-sin(z(1))]','t','z');

% Choose time limits for the solution
tmax=30; n=501; t=linspace(0,tmax,n);

% Set integration tolerances
opts=odeset('reltol',1e-5,'abstol',1e-5);

% Input angular velocity repeatedly
if nargin==0  
  disp(' ')
  disp('   DAMPED PENDULUM MOTION DESCRIBED BY')
  disp(' theta"(t)+0.1*theta''(t)+sin(theta) = 0')
  while 1
    disp(' ')
    disp('Select the angular velocity at the lowest')
    disp('point. Values over 2.42 push the pendulum')
    disp('over the top. Input w0 (or press return')
    disp('to stop)')
    w0=input('w0 = ? > ');
    if isempty(w0)
      disp(' '), disp('All Done'), disp(' '), return
    end

    % Specify the initial conditions
    theta0=0; z0=[theta0;w0];

    % Solve the differential equation using ode45
    [t,th]=ode45(pendulum,t,z0,opts);

    % Plot the angular deflection of the pendulum
    plot(t,180/pi*th(:,1)), xlabel('time')
    ylabel('angular deflection (degrees)')
    title('ANGULAR DEFLECTION OF THE PENDULUM')
    disp(' ')
    disp('Press return to see the animation')
    grid on, shg, pause

    % Animate the motion
    for j=1:n
      T=th(j,1); X=[0;sin(T)]; Y=[0;-cos(T)];
      plot(X,Y,X(2),Y(2),'o','markersize',12)
      axis([-1,1,-1,1]), axis square, axis off
      drawnow, shg, pause(.05)
    end
    clf
  end
  return
else
  theta0=0; z0=[theta0;w0];
  [t,th]=ode45(pendulum,t,z0,opts);
  if max(th(:,1))>pi
     titl='OVER THE TOP';
  else
     titl='LARGE AMPLITUDE MOTION';
  end
  
  for j=1:n
     T=th(j,1); X=[0;sin(T)]; Y=[0;-cos(T)];
     plot(X,Y,X(2),Y(2),'o','markersize',12)
     axis([-1,1,-1,1]), axis square, axis off
     title(titl), drawnow, shg
  end
  pause(1), close, return
end