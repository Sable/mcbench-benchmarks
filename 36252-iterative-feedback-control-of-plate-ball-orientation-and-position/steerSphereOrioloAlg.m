function steerSphereOrioloAlg
    % This MATLAB function applies the algorithm in 
    % 'A Framework for the Stabilization of General Nonholonomic Systems With an Application to the Plate-Ball Mechanism'
    % by Giuseppe Oriolo and Marilena Vendittelli
    % in IEEE TRANSACTIONS ON ROBOTICS, VOL. 21, NO. 2, APRIL 2005
    %
    %  It steers a sphere with a possibly unknown radius that rolls without
    %  slipping on the plane  to a desired position and orientation 
    %  by using iterative feedback control.
    %
    % inputs:
    % State = [u,v,phi,x,y], (u,v) = (lat, log) contact point, phi, angle between the  x-xis and the plane of the merdian trough the contact point
    % u is limited to +/-pi/2, v limited to +/-pi
    %
    % the actual sphere radius is rhoA, while the assumed radius is rho.  
    % It is 
    
    format compact
    clc

    global ai0 ai1 bi0 bi1 omega an1 an2 bn1 phase rho T1 T2 rhoA
    
    rho = 1; %nominal radius of the sphere
    rhoA = 1.0; % actual radius of the sphere  
    %rhoA = 1.1; % For his second plot, Oriolo sets this to 1.1

    %Initial Position   [rad,rad,rad,m,m]
    qi = [pi/4;pi/2;pi/12;1;-1/2]'; % (NOMINAL CASE used in paper)
    % Other interesting Initial positions
    % qi = [pi/8;pi/8;pi/12;1;-1/2]'; 
    % qi = [0;0;0;1;-1/2]'; 
    % qi = [0;0;0;2;0]'; 
    
    %current position
    qc = qi;
    %Desired Position (origin)
    qd = [0;0;0;0;0]';

    
    options = odeset('RelTol',1e-4,'AbsTol',1e-4);
    
    % Setup figures
    figuvphi = 1;
    figtxy   = 2;
    figxy    = 3;
    figure(figuvphi)
    clf
    figure(figtxy)
    clf
    figure(figxy)
    clf
    
    time_offset = 0;  
    
    smallNumber = 0.0001;  %if the norm of the position error is less than smallNumber, Phase I is skipped
    iterCount = 0;
    while iterCount < 18 %norm(qc - qd) > smallNumber 
            
        if norm(qc(1:3) - qd(1:3) ) > smallNumber 
            %PHASE 1  Drive the first three variables chi(1,2,3) to zero in finite time. 
            %Denote by "chi_i" the system  configuration at the end of this phase.
            % This phase moves to desired orientation, without caring for x and y.
            phase = 1; %#ok<*NASGU>
            chi = q2chi(qc);  %change variables
            [ai0,ai1,bi0,bi1,omega,T1] = phaseIcontrol(chi); %#ok<ASGLU>


            [T,Q] = ode45(@simSphereRoll,[0,T1],qc,options);
            
            T = T+time_offset;

            plot_x_y(T,Q,figtxy,figxy)
            plot_u_v_phi(T,Q,figuvphi)
            
            qc = Q(end,:);
            time_offset = time_offset+T1;
            iterCount = iterCount+1;
        end
        
        %PHASE 2  Apply the iterative Control Algorithm of Section IV-B to
        %obtain exponential convergence of chi(4,5) to zero while cycling over chi(1,2,3).
        phase = 2;
        
        chi = q2chi(qc);  %change variables
        [an1,an2,bn1,omega,T2] = phaseIIcontrol(chi);
        
        [T,Q] = ode45(@simSphereRoll,[0,T2],qc,options);
        T = T+time_offset;
        plot_u_v_phi(T,Q,figuvphi)
        plot_x_y(T,Q,figtxy,figxy)
        
        qc = Q(end,:);
        time_offset = time_offset+T2;
        iterCount = iterCount+1;
        
    end

end %main function


function [ai0,ai1,bi0,bi1,omega,T1] = phaseIcontrol(chi)  
    T1 = 1; %t \in [0,T1], Oriolo uses 
    sigma = 1;  % eq(18), must be greater than 0  (Oriolo uses 1)
    omega = 2*pi/T1;
    ai0 = -chi(1)/T1;
    bi0 = -chi(2)/T1;
   
   % SOME ERROR HERE: Oriolo's version
   % ai1 = -sigma*norm(chi,1)^(1/2);
   % bi1 = -2*(2*pi*chi(3) - pi*chi(1)*chi(2) + T1*ai1*chi(2))/(T1^2*ai1);
    
   %%% Aaron's solution:
   ai1 =  -2;%-(  chi(1)^2 + chi(2)^2+ chi(3)^2 )^(1/2);%2*(chi(1)+chi(2);%sigma*(norm( chi ))^(1/2);   %arbitrary, non zero eq(18)  he uses power of 1/2
   bi1 = -2*pi*(chi(1)*chi(2) - 2*chi(3))/(T1*(ai1*T1+2*chi(1))); %for


end
    
function [an1,an2,bn1,omega,T2] = phaseIIcontrol(chi)
    %Step II-1
    eta = 0.6; %Oriolo uses 0.6
    chi_f = (1-eta)*chi;
    z = phaseIIstate(chi_f, chi(4),chi(5));  

    %Step II-2
    T2 = 1;   %Oriolo uses 1
    omega = 2*pi/T2;
    bn1 =-10* -sign(z(4))*(norm([z(4),z(5)],1))^(1/3);

    k1 = T2^3/(32*pi^2);
    k2 = -T2^3/(128*pi^2);
    an1 = abs( z(4)/(k1*bn1) )^(1/2); % this should always be positive since z(4) and bn1 are same sign
    an2 =   z(5)/(k2*bn1^2);
    display(['z = [',num2str(z','%.2e,'),'],  (an1,an2,bn1) = (',num2str([an1,an2,bn1],'%.2f, '),')']);    
end


function chi = q2chi(q)  % CHANGE OF VARIABLES  q =   [u,v,phi,x,y], 
    chi = [ -q(2);      %-v
            sin(q(1));	%sin(u)
            q(3);       %phi
            q(4);       %x
            q(5)];      %y
end

function z = phaseIIstate(chi, chim4,chim5)     %%% eq(19)
    z = [ chi(1);
    	chi(2);
    	chi(3);
    	chi(2) - ( chi(4)-chim4 );
    	-chi(1) + ( chi(5) - chim5 )];
end
    
function [wx,wy]  = INPUT_TRANSFORMATION(u,phi, w1,w2)
    if u==pi/2 || u == -pi/2 
        display('INPUT_TRANSFORMATION, u = 0, problem')
        wx = 0;
        wy = 0;
    else
        wx = sin(phi)*cos(u)*w1 + cos(phi)/cos(u)*w2; %u cannot be +/-(pi/2)
        wy = cos(phi)*cos(u)*w1 - sin(phi)/cos(u)*w2; %u cannot be +/-(pi/2)
    end
end


function dq = simSphereRoll(t,q)
    global ai0 ai1 bi0 bi1 omega an1 an2 bn1 phase rhoA
    
    if phase == 1
        w1 = ai0 + ai1*cos(omega*t);  %16
        w2 = bi0 + bi1*sin(omega*t);  %17
    else
        w1 = an1*cos(omega*t) + an2*cos(4*omega*t); %%% eq(21)
    	w2 = bn1*cos(2*omega*t);                    %%% eq(22)        
    end
    u = q(1);
    if( abs(u-pi/2)<0.001 || abs(u+pi/2)<0.001 )
        display(['u has bad value, u=',num2str(u,'%.2f')])
    end
   
    phi = q(3);
    
    [wx,wy]  = INPUT_TRANSFORMATION(u,phi, w1,w2);
    
     dq = [
           cos(phi)/rhoA*wx - sin(phi)/rhoA*wy;  %dot(u) = cos(phi)*wx - sin(phi)*wy 
            -sin(phi)/(rhoA*cos(u))*wx - cos(phi)/(rhoA*cos(u))*wy;  %dot(v) = -sin(phi)/cos(u)*wx - cos(phi)/cos(u)*wy 
            tan(u)/rhoA*( sin(phi)*wx + cos(phi)*wy );  %dot(phi) = tan(u)(sin(pi)*wx+cos(phi)*wy)
            wx; %dot(x) = wx
            wy  %dot(y) = wy
     ];
end

%%%%%%%% PLOTTING FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_u_v_phi(t,Q,fig)
    global phase
    figure(fig)
    %clf
    u   = Q(:,1);
    v   = Q(:,2);
    phi = Q(:,3);
    if phase == 1
        plot(t,u,'-r',t,v,'--r',t,phi,':r')
    else
        plot(t,u,'-b',t,v,'--b',t,phi,':b')
    end
    hold on
    xlabel('sec','Interpreter','latex')
    ylabel('rad','Interpreter','latex')
    title('evolution of orientation $(u, v, \phi)$','Interpreter','latex')
    legend('u','v','\phi')
    drawnow
end

function plot_x_y(t,Q,figtxy,figxy)
    global phase
    
    x   = Q(:,4);
    y   = Q(:,5);
    figure(figtxy)
    %clf
    if phase == 1
        plot(t,x,'-r',t,y,':r')
    else
        plot(t,x,'-b',t,y,':b')
    end
    hold on
    xlabel('sec','Interpreter','latex')
    ylabel('m','Interpreter','latex')
    legend('x','y');
    title('evolution of position $(x,y)$','Interpreter','latex')

    figure(figxy)
    %clf
    if phase == 1
        plot(x,y,'r',x(1),y(1),'ro')
    else
        plot(x,y,'b',x(1),y(1),'bo')
    end
    hold on
    xlabel('x (m)')
    ylabel('y (m)')
    axis equal
    title('path of the contact point')
    drawnow
end



