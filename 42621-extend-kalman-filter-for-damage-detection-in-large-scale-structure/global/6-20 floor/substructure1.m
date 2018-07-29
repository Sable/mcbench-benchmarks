    % Distributed identification of  a 8-DOF shear-type frame by a substructure approach  
%20层benchmark 
%取6——16进行识别 6-11子结构1 ；11-16子结构2；
%结构参数与控制的相同
   
    
    clear all
    % time step
    %dt=input('Time step  ');
    dt=0.001;
    % Measured acceleration responses
    load response.mat
    [ll,nn]=size(accn);
    
    % Substructure 1: (6th-11th floors)
    n1=6; % The number of DDOF
    l1=6; % The number of accelerometers
    %dd2=zeros(l2,n2); dd2(1,1)=1.0; dd2(2,2)=1; dd2(3,4)=1.0;dd2(4,6)=1.0 ;% Locations of accelerometers (on the 6th,7th and 8th floors)
    dd1=eye(n1);
    y1=dd1*accn(:,5:10)';
    m1(1:6)=10^6*1.1;
    mass1=diag(m1);
%     % Two unknown input to substructutre 1
    Bl1=zeros(n1,2);
    Bl1(1,1)=1.0;  % The unknown interaction force at the 5th floor
    Bl1(n1,2)=1.0;  % The unknown external excitation at the 8th floor
    F1_un=inv(mass1)*Bl1;
    G1_un=dd1*F1_un;
    % Initial values for LSE of substructue 2
    X1(1:2*n1,1)=zeros(2*n1,1);  % Initial values of displacements and velocities
    X1(2*n1+1:3*n1-1,1)=10^8*5.5417*0.8*ones(n1-1,1); % Initial values of stiffness 
    X1(3*n1,1)=0.1298*0.8; % Initial values of damping 
    X1(3*n1+1,1)=0.0155*0.8; % Initial values of damping 
    
    p1k=zeros(3*n1+1);
    p1k(1:2*n1,1:2*n1)=0.1*eye(2*n1);  % Initial values for error covariance of matrix 
    p1k(2*n1+1:3*n1-1,2*n1+1:3*n1-1)=10^16*eye(n1-1);  % Initial values of stiffness error covariance matrix
    p1k(3*n1,3*n1)=0.1;  % Initial values of damping error covariance matrix 
    p1k(3*n1+1,3*n1+1)=0.01;  % Initial values of damping error covariance matrix 
    f1_un(:,1)=zeros(2,1);

    Q1=10^-8;
    R1=0.01*eye(l1); % measurement noise 
   

    
    % Substructure 2: (11th-16th floors)
    n2=6; % The number of DDOF
    l2=6; % The number of accelerometers
    %dd2=zeros(l2,n2); dd2(1,1)=1.0; dd2(2,2)=1; dd2(3,4)=1.0;dd2(4,6)=1.0 ;% Locations of accelerometers (on the 6th,7th and 8th floors)
    dd2=eye(n2);
    y2=dd2*accn(:,10:15)';
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
    X2(2*n2+1:3*n2-1,1)=10^8*3.8*ones(n2-1,1); % Initial values of stiffness 
    X2(3*n2,1)=0.1292*0.8; % Initial values of damping 
    X2(3*n2+1,1)=0.0155*0.8; % Initial values of damping 
    
    p2k=zeros(3*n2+1);
    p2k(1:2*n2,1:2*n2)=0.1*eye(2*n2);  % Initial values for error covariance of matrix 
    p2k(2*n2+1:3*n2-1,2*n2+1:3*n2-1)=10^16*eye(n2-1);  % Initial values of stiffness error covariance matrix
    p2k(3*n2,3*n2)=0.1;  % Initial values of damping error covariance matrix 
    p2k(3*n2+1,3*n2+1)=0.01;  % Initial values of damping error covariance matrix 
    f2_un(:,1)=zeros(2,1);
    Q2=10^-10;
    R2=0.01*eye(l2); % measurement noise  
    
    
    
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
   % X3(2*n3+1:3*n3-1,1)=10^8*2.4*ones(2,1); % Initial values of stiffness 
    X3(2*n3+1:2*n3+2,1)=10^8*2.4*ones(2,1)
       X3(2*n3+3:2*n3+5,1)=10^8*2.0*ones(3,1)
    
    
    
    X3(3*n3,1)=0.1292*0.8; % Initial values of damping 
    X3(3*n3+1,1)=0.0155*0.8; % Initial values of damping 
    
    
    
    p3k=zeros(3*n3+1);
    p3k(1:2*n3,1:2*n3)=eye(2*n3);  % Initial values for error covariance of matrix 
    p3k(2*n3+1:3*n3-1,2*n3+1:3*n3-1)=10^14*eye(n3-1);  % Initial values of stiffness error covariance matrix
    p3k(3*n3-1,3*n3-1)=10^12; 
    p3k(3*n3,3*n3)=0.1;  % Initial values of damping error covariance matrix 
    p3k(3*n3+1,3*n3+1)=0.01;  % Initial values of damping error covariance matrix 
    f3_un(:,1)=zeros(2,1);
    Q3=10^-10;
    R3=0.01*eye(l3); % measurement noise 
    
    
  
    
    
    load xstate.mat
    load force.mat

    % Recursive LSE
    for k=1:ll-1;
           
            
            % Substructure 1
            A1=zeros(3*n1+1);  % State transition matrix dX/dt=A*X+B_un*force; 
            A1(1:n1,n1+1:2*n1)=eye(n1);
            [stiff1,damp1,x1kp, x1ap,x1bp]=kcm(n1,X1(:,k));
            A1(n1+1:2*n1,:)=-inv(mass1)*[stiff1,damp1,x1kp, x1ap,x1bp];
            A1=eye(3*n1+1)+dt*A1;
            %  [A2d,B2d_un]=c2d(A2,B2_un,dt);
            h1k=dd1*inv(mass1)*(-stiff1*X1(1:n1,k)-damp1*X1(n1+1:2*n1,k));
            H1=-dd1*inv(mass1)*[stiff1,damp1,x1kp, x1ap,x1bp];
            % The predicted extended state vector of substructure 2 by numerical integration
            OPTIONS = [];
            pre2=ode45(@predict,[dt*k dt*(k+1)],X1(:,k),OPTIONS,n1,f1_un(:,k),F1_un,mass1); % Assume f2_un is constant, so dt must be small
            X1bk_1=pre2.y(:,end); 
            [X1(:,k+1),p1k_1]=klm(X1bk_1,p1k,y1(:,k),h1k,f1_un(:,k),A1,H1,G1_un,R1,Q1);
            p1k=p1k_1;
            % Estimation of the unknown interaction/excitation forces
            % Estimation of the external excitation on substructure 2 by LSE  
            [stiff1,damp1,x1kp, x1ap,x1bp]=kcm(n1,X1(:,k+1));
            h1k_1=dd1*inv(mass1)*(-stiff1*X1(1:n1,k+1)-damp1*X1(n1+1:2*n1,k+1));
            [f1_un(:,k+1)]=rlse(y1(:,k+1),h1k_1,G1_un,R1);
               
%              k
%              X1(2*n1+1:3*n1-1,k+1)
%              X1(3*n1:end,k+1);
             
             % Substructure 2
            A2=zeros(3*n2+1);  % State transition matrix dX/dt=A*X+B_un*force; 
            A2(1:n2,n2+1:2*n2)=eye(n2);
            [stiff2,damp2,x2kp, x2ap,x2bp]=kcm(n2,X2(:,k));
            A2(n2+1:2*n2,:)=-inv(mass2)*[stiff2,damp2,x2kp, x2ap,x2bp];
            A2=eye(3*n2+1)+dt*A2;
            %  [A2d,B2d_un]=c2d(A2,B2_un,dt);
            h2k=dd2*inv(mass2)*(-stiff2*X2(1:n2,k)-damp2*X2(n2+1:2*n2,k));
            H2=-dd2*inv(mass2)*[stiff2,damp2,x2kp, x2ap,x2bp];
            % The predicted extended state vector of substructure 2 by numerical integration
            OPTIONS = [];
            pre2=ode45(@predict,[dt*k dt*(k+1)],X2(:,k),OPTIONS,n2,f2_un(:,k),F2_un,mass2); % Assume f2_un is constant, so dt must be small
            X2bk_1=pre2.y(:,end); 
            [X2(:,k+1),p2k_1]=klm(X2bk_1,p2k,y2(:,k),h2k,f2_un(:,k),A2,H2,G2_un,R2,Q2);
            p2k=p2k_1;
            [stiff2,damp2,x2kp, x2ap,x2bp]=kcm(n2,X2(:,k+1));
            h2k_1=dd1*inv(mass2)*(-stiff2*X2(1:n2,k+1)-damp2*X2(n1+1:2*n1,k+1));
            [f2_un(:,k+1)]=rlse(y2(:,k+1),h2k_1,G2_un,R2);
                        

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
              ni=[ X1(2*n1+1:3*n1-1,k+1),X2(2*n2+1:3*n2-1,k+1),X3(2*n3+1:3*n3-1,k+1)]
             
             
             
    end

