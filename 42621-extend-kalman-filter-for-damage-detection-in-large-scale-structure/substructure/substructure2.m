    % Distributed identification of  a 8-DOF shear-type frame by a substructure approach  

    clear all
    % time step
    dt=input('Time step  ');
    % Measured acceleration responses
    load response.mat
    [ll,nn]=size(accn);
    
    % Substructure 2: (5th-8th floors)
    n2=6; % The number of DDOF
    l2=6; % The number of accelerometers
    %dd2=zeros(l2,n2); dd2(1,1)=1.0; dd2(2,2)=1; dd2(3,4)=1.0;dd2(4,6)=1.0 ;% Locations of accelerometers (on the 6th,7th and 8th floors)
    dd2=eye(n2);
    y2=dd2*accn(:,11:16)';
    m2(1:6)=10^6*1.1;
    mass2=diag(m2);

%     % Two unknown input to substructutre 1
    Bl2=zeros(n2,2);
    Bl2(1,1)=1.0;  % The unknown interaction force at the 5th floor
    Bl2(n2,2)=1.0;  % The unknown external excitation at the 8th floor
    F2_un=inv(mass2)*Bl2;
    G2_un=dd2*F2_un;

    % Initial values for LSE of substructue 2
    X2(1:2*n2,1)=zeros(2*n2,1);  % Initial values of displacements and velocities
    X2(2*n2+1:3*n2-1,1)=10^8*3.5*ones(n2-1,1); % Initial values of stiffness 
    X2(3*n2,1)=0.1292*0.8; % Initial values of damping 
    X2(3*n2+1,1)=0.0155*0.8; % Initial values of damping 
    
    

    p2k=zeros(3*n2+1);
    p2k(1:2*n2,1:2*n2)=eye(2*n2);  % Initial values for error covariance of matrix 
    p2k(2*n2+1:3*n2-1,2*n2+1:3*n2-1)=10^16*eye(n2-1);  % Initial values of stiffness error covariance matrix
    p2k(3*n2,3*n2)=0.1;  % Initial values of damping error covariance matrix 
    p2k(3*n2+1,3*n2+1)=0.01;  % Initial values of damping error covariance matrix 
    f2_un(:,1)=zeros(2,1);

    Q2=10^-10;
    R2=0.01*eye(l2); % measurement noise 

    load xstate.mat
    load force.mat

    % Recursive LSE
    for k=1:ll-1;
           
            
            % Substructure 2
            A2=zeros(3*n2+1);  % State transition matrix dX/dt=A*X+B_un*force; 
            A2(1:n2,n2+1:2*n2)=eye(n2);
            [stiff2,damp2,x2kp, xap,xbp]=kcm(n2,X2(:,k));
            A2(n2+1:2*n2,:)=-inv(mass2)*[stiff2,damp2,x2kp, xap,xbp];
            A2=eye(3*n2+1)+dt*A2;
            %  [A2d,B2d_un]=c2d(A2,B2_un,dt);

            h2k=dd2*inv(mass2)*(-stiff2*X2(1:n2,k)-damp2*X2(n2+1:2*n2,k));
            H2=-dd2*inv(mass2)*[stiff2,damp2,x2kp, xap,xbp];

            % The predicted extended state vector of substructure 2 by numerical integration
            OPTIONS = [];
            pre2=ode45(@predict,[dt*k dt*(k+1)],X2(:,k),OPTIONS,n2,f2_un(:,k),F2_un,mass2); % Assume f2_un is constant, so dt must be small
            X2bk_1=pre2.y(:,end); 
            [X2(:,k+1),p2k_1]=klm(X2bk_1,p2k,y2(:,k),h2k,f2_un(:,k),A2,H2,G2_un,R2,Q2);
            p2k=p2k_1;

            % Estimation of the unknown interaction/excitation forces
            % Estimation of the external excitation on substructure 2 by LSE  
            [stiff2,damp2,x2kp, xap,xbp]=kcm(n2,X2(:,k+1));
            h2k_1=dd2*inv(mass2)*(-stiff2*X2(1:n2,k+1)-damp2*X2(n2+1:2*n2,k+1));
            [f2_un(:,k+1)]=rlse(y2(:,k+1),h2k_1,G2_un,R2);
               
             k
             X2(2*n2+1:3*n2-1,k+1)
             X2(3*n2:end,k+1);
    end

