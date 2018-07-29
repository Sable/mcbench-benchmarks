    % Distributed identification of  a 8-DOF shear-type frame by a substructure approach  

    clear all
    % time step
    dt=input('Time step  ');
    % Measured acceleration responses
    load response.mat
    [ll,nn]=size(accn);
    
    % Substructure 2: (5th-8th floors)
    n3=6; % The number of DDOF
    l3=6; % The number of accelerometers
    %dd2=zeros(l2,n2); dd2(1,1)=1.0; dd2(2,2)=1; dd2(3,4)=1.0;dd2(4,6)=1.0 ;% Locations of accelerometers (on the 6th,7th and 8th floors)
    dd3=eye(n3);
    y3=dd3*accn(:,15:20)';
    m3(1:6)=10^6*1.1;
    mass3=diag(m3);

%     % Two unknown input to substructutre 1
    Bl3=zeros(n3,2);
    Bl3(1,1)=1.0;  % The unknown interaction force at the 5th floor
    Bl3(4,2)=1.0;  % The unknown external excitation at the 8th floor
    F3_un=inv(mass3)*Bl3;
    G3_un=dd3*F3_un;

    % Initial values for LSE of substructue 2
    X3(1:2*n3,1)=zeros(2*n3,1);  % Initial values of displacements and velocities
    X3(2*n3+1:3*n3-1,1)=10^8*2.4*ones(n3-1,1); % Initial values of stiffness 
    X3(3*n3,1)=0.1292*0.8; % Initial values of damping 
    X3(3*n3+1,1)=0.0155*0.8; % Initial values of damping 
    
    

    p3k=zeros(3*n3+1);
    p3k(1:2*n3,1:2*n3)=eye(2*n3);  % Initial values for error covariance of matrix 
    p3k(2*n3+1:3*n3-1,2*n3+1:3*n3-1)=10^12*eye(n3-1);  % Initial values of stiffness error covariance matrix
    p3k(3*n3,3*n3)=0.1;  % Initial values of damping error covariance matrix 
    p3k(3*n3+1,3*n3+1)=0.01;  % Initial values of damping error covariance matrix 
    f3_un(:,1)=zeros(2,1);

    Q3=10^-10;
    R3=0.01*eye(l3); % measurement noise 

    load xstate.mat
    load force.mat

    % Recursive LSE
    for k=1:ll-1;
           
            
            % Substructure 2
            A3=zeros(3*n3+1);  % State transition matrix dX/dt=A*X+B_un*force; 
            A3(1:n3,n3+1:2*n3)=eye(n3);
            [stiff3,damp3,x3kp, x3ap,x3bp]=kcm(n3,X3(:,k));
            A3(n3+1:2*n3,:)=-inv(mass3)*[stiff3,damp3,x3kp, x3ap,x3bp];
            A3=eye(3*n3+1)+dt*A3;
            %  [A2d,B2d_un]=c2d(A2,B2_un,dt);

            h3k=dd3*inv(mass3)*(-stiff3*X3(1:n3,k)-damp3*X3(n3+1:2*n3,k));
            H3=-dd3*inv(mass3)*[stiff3,damp3,x3kp, x3ap,x3bp];

            % The predicted extended state vector of substructure 2 by numerical integration
            OPTIONS = [];
            pre3=ode45(@predict,[dt*k dt*(k+1)],X3(:,k),OPTIONS,n3,f3_un(:,k),F3_un,mass3); % Assume f2_un is constant, so dt must be small
            X3bk_1=pre3.y(:,end); 
            [X3(:,k+1),p3k_1]=klm(X3bk_1,p3k,y3(:,k),h3k,f3_un(:,k),A3,H3,G3_un,R3,Q3);
            p3k=p3k_1;

            % Estimation of the unknown interaction/excitation forces
            % Estimation of the external excitation on substructure 2 by LSE  
            [stiff3,damp3,x3kp, x3ap,x3bp]=kcm(n3,X3(:,k+1));
            h3k_1=dd3*inv(mass3)*(-stiff3*X3(1:n3,k+1)-damp3*X3(n3+1:2*n3,k+1));
            [f3_un(:,k+1)]=rlse(y3(:,k+1),h3k_1,G3_un,R3);
               
             k
             X3(2*n3+1:3*n3-1,k+1)
             X3(3*n3:end,k+1);
    end

