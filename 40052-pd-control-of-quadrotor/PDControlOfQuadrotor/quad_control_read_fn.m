
% The function used with the program: Quadrotor control

function xdot = quad_control_fn(t,x)

global Jtp Ixx Iyy Izz b d l m g Kpz Kdz Kpp Kdp Kpt Kdt Kpps Kdps ZdF PhidF ThetadF PsidF ztime phitime thetatime psitime Zinit Phiinit Thetainit Psiinit Uone Utwo Uthree Ufour Ez Ep Et Eps

% The desired values
% Changes in Z start at t = 3, changes in Phi start at t = 1, changes in
% Theta start at the origin, and chanfes in Psi start at t= 2
% If you want that all start at the origin simply remove the conditions
    
% time for change start of each variable
ztime = 3;
phitime = 1;
thetatime = 0.2;
psitime = 2;
%%% HEIGHT %%%
if t < ztime
 Zd = Zinit;   
end

if t >= ztime
 Zd = ZdF;   
end
%%%%%%%%%%%%%%
%%% Phi %%%
if t < phitime
 Phid = Phiinit;   
end

if t >= phitime
 Phid = PhidF;   
end
%%%%%%%%%%%%%%
%%% Theta %%%
if t < thetatime
 Thetad = Thetainit;   
end

if t >= thetatime
 Thetad = ThetadF;   
end
%%%%%%%%%%%%%%
%%% Psi %%%
if t < psitime
 Psid = Psiinit;   
end

if t >= psitime
 Psid = PsidF;   
end
%%%%%%%%%%%%%%

PsidF = 2*pi;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

thetaddot = 0;
phiddot = 0;
psiddot = 0;
Zddot = 0;
% Zd = 10;

    % Bounding the angles within the -2*pi / 2*pi range
    if (x(7)> 2*pi || x(7)< - 2*pi)
        x(7) = rem(x(7),2*pi);
    end
    
    if (x(9)> 2*pi || x(9)< - 2*pi)
        x(9) = rem(x(9),2*pi);
    end
    
    if (x(11)> 2*pi || x(11)< - 2*pi)
        x(11) = rem(x(11),2*pi);
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%PD-Z-Control%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluate the Controls
    U = [];    % The control vector
    U(1) = m*(g + Kpz*(Zd - x(5)) + Kdz*( - x(6)))/(cos(x(9))*cos(x(7)));   % Total Thrust on the body along z-axis
    U(2) = (Kpp*(Phid - x(7)) + Kdp*( - x(8)));   % Roll input
	U(3) = (Kpt*(Thetad - x(9)) + Kdt*( - x(10)));   % Pitch input
	U(4) = (Kpps*(Psid - x(11)) + Kdps*( - x(12)));   % Yawing moment
    
    U = real(U);
    U = [U(1);U(2);U(3);U(4)];    % The control vector
    
%     % Bounding the controls
%     if U(1) > 15.7
%         U(1) = 15.7;
%     end
%     
%     if U(1) < 0
%         U(1) = 0;
%     end
%     
%     for j = 2:4
%         if U(j) > 1
%         U(j) = 1;
%         end
%     
%         if U(j) < -1
%         U(j) = -1;
%         end
%     end
    

    % Calculation of angular velocities 
    omegasqr(1) = (1/4*b)*U(1) + (1/2*b*l)*U(3) - (1/4*d)*U(4);
    omegasqr(2) = (1/4*b)*U(1) - (1/2*b*l)*U(2) + (1/4*d)*U(4);
    omegasqr(3) = (1/4*b)*U(1) - (1/2*b*l)*U(3) - (1/4*d)*U(4);
    omegasqr(4) = (1/4*b)*U(1) + (1/2*b*l)*U(2) + (1/4*d)*U(4);
    omegasqr = real(omegasqr);
    
    omega(1) = sqrt(omegasqr(1));
    omega(2) = sqrt(omegasqr(2));
    omega(3) = sqrt(omegasqr(3));
    omega(4) = sqrt(omegasqr(4));
        % Bounding the angular velocities
    for j = 1:4
        if omega(j) > 523
            omega(j) = 523;
        end
        
        if omega(j) < 125
            omega(j) = 125;
        end
    end
    omegasqr(1) = (omegasqr(1))^2;
    omegasqr(2) = (omegasqr(2))^2;
    omegasqr(3) = (omegasqr(3))^2;
    omegasqr(4) = (omegasqr(4))^2;
%     % Bounding the angular velocities
%     for j = 1:4
%         if omegasqr(j) > 523
%             omegasqr(j) = 523;
%         end
%         
%         if omegasqr(j) < 125
%             omegasqr(j) = 125;
%         end
%     end
    % Disturbance
    Omega = d*(- sqrt(omegasqr(1)) + sqrt(omegasqr(2)) - sqrt(omegasqr(3)) + sqrt(omegasqr(4)));

% Evaluation of the State space wrt H-frame
    xdot(1) = x(2); % Xdot
    xdot(2) = (sin(x(11))*sin(x(7)) + cos(x(11))*sin(x(9))*cos(x(7)))*(U(1)/m);    % Xdotdot
    xdot(3) = x(4); % Ydot
    xdot(4) = (-cos(x(11))*sin(x(7)) + sin(x(11))*sin(x(9))*cos(x(7)))*(U(1)/m);	% Ydotdot
    xdot(5) = x(6); % Zdot           
    xdot(6) = - g + (cos(x(9))*cos(x(7)))*(U(1)/m);    % Zdotdot
    xdot(7) = x(8); % phydot
    xdot(8) = ((Iyy - Izz)/Ixx)*x(10)*x(12) - (Jtp/Ixx)*x(10)*Omega + (U(2)/Ixx); % pdot = phydotdot
    xdot(9) = x(10);    % thetadot
    xdot(10) = ((Izz - Ixx)/Iyy)*x(8)*x(12) + (Jtp/Iyy)*x(8)*Omega + (U(3)/Iyy);	% qdot = thetadotdot
    xdot(11) = x(12);   % thetadot
    xdot(12) = ((Ixx - Iyy)/Izz)*x(8)*x(10) + (U(4)/Izz);	% rdot = psidotdot 

xdot = xdot';
