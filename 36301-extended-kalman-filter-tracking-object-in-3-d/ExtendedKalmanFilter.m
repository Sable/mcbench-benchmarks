%ALEX DYTSO
%KALMAN FITLER PROJECT
%estimating trajectory of an object in 3-D
function ExtendedKalmanFilter
clc, clear all, clf

Q=[0 0 0 0 0 0;
   0 0 0 0 0 0;
   0 0 0 0 0 0;
   0 0 0 0.01 0 0;
   0 0 0 0 0.01 0;
   0 0 0 0 0 0.01];% Covarience matrix of process noise 


M=[0.001 0 0;
    0 0.001 0;
    0 0 0.001]; % Covarience matrix of measurment noise 


d=.1;% sampling time 

A=[1 0 0 d 0 0;
   0 1 0 0 d 0;
   0 0 1 0 0 d;
   0 0 0 1 0 0;
   0 0 0 0 1 0;
   0 0 0 0 0 1]; % System Dynamics 

X(:,1)=[1;1;1;2;2;2]; % Actual initial conditions 



Z(:,1)=[3;3;3];% initial observation 


Xh(:,1)=[1.6;1.6;1.6;20;20;20];%Assumed initial conditions

P(:,:,1)=[0.1 0 0 0 0 0;
          0 0.1 0 0 0 0;
          0 0 0.1 0 0 0;
          0 0 0 0.1 0 0;
          0 0 0 0 0.1 0;
          0 0 0 0 0 0.1]; %inital value of covarience of estimation error
  
%
   


% Setting up plots 
subplot(3,3,1)
xlabel('time') 
ylabel('X')
title('X possition')
hold on 

subplot(3,3,4)
xlabel('time') 
ylabel('Y')
title('Y possition')
hold on 
      
subplot(3,3,7)
xlabel('time') 
ylabel('Z')
title('Z possition')
hold on 

 subplot(2,2,2)
 xlabel('time') 
 title('Minimum MSE')

hold on 

subplot(2,2,4)
 plot3(0,0,0)
 title('3-D trajectory ')
 xlabel('X')
 ylabel('Y')
 zlabel('Z')
 hold on 
 
 
 ind=0; % indicator function. Used for unwrapping of tan
for n=1:200
    
    %%% Genetatubg a process and observations 
    [X(:,n+1),Z(:,n+1),w,u]=proccesANDobserve(A,X(:,n),Z(:,n),Q,M,ind);
    
    subplot(3,3,1)
    line([n,n+1],[X(1,n),X(1,n+1)])  % plot of the process that we try to observe in z coordinate
    
    hold on 
    
    drawnow
    
    subplot(3,3,4)
    line([n,n+1],[X(2,n),X(2,n+1)])  % plot of the process that we try to observe in y coordinate
    hold on 
    
    drawnow
    subplot(3,3,7)
    line([n,n+1],[X(3,n),X(3,n+1)]) % plot of the process that we try to observe in z coordinate
    hold on 
    
    drawnow
    
    
    
    % PREDICTION EQUTIONS
    [Xh(:,n+1),P(:,:,n+1)]=predict(A,Xh(:,n),P(:,:,n),Q); %prediction of next state
    
    
    
  
 
    
    %%%%%%%%%%%%%%%%%%% 
    %CORRECTION EQUTIONS
      
   H(:,:,n+1)=Jacobian(Xh(1,n+1),Xh(2,n+1),Xh(3,n+1));% subroutine computes evaluetes Jacobian matrix
   
   K(:,:,n+1)=KalmanGain(H(:,:,n+1),P(:,:,n+1),M); %subroutine computes Kalman Gain
   
   Inov=Inovation(Z(:,n+1),Xh(:,n+1),ind); %subroutine computes innovation
   
   Xh(:,n+1)=Xh(:,n+1)+ K(:,:,n+1)*Inov; %computes final estimate
   
   P(:,:,n+1)=(eye(6)-K(:,:,n+1)*H(:,:,n+1))*P(:,:,n+1);% %computes covarience of estimation error
   
   % Some Plots
   
   subplot(2,2,4)
   line([Xh(1,n) Xh(1,n+1)],[Xh(2,n) Xh(2,n+1)],[Xh(3,n) Xh(3,n+1)],'Color','r')% 3-d plot of estimated trajectory 
   hold on 
   
   drawnow
   line([X(1,n) X(1,n+1)],[X(2,n) X(2,n+1)],[X(3,n) X(3,n+1)])% 3-d plot of actual trajectory 
   hold on 
   drawnow
   
   
   subplot(2,2,2)
   line([n,n+1],[(X(1,n)-Xh(1,n))^2,(X(1,n+1)-Xh(1,n+1))^2]) % ploting MSE
   hold on
   drawnow
   line([n,n+1],[(X(2,n)-Xh(2,n))^2,(X(2,n+1)-Xh(2,n+1))^2],'Color','r') % ploting MSE
   hold on
   drawnow
   line([n,n+1],[(X(3,n)-Xh(3,n))^2,(X(3,n+1)-Xh(3,n+1))^2],'Color','c') % ploting MSE
   hold on
   drawnow
   legend('Square erro in X direction','Square erro in Y direction','Square erro in Z direction')
   
   
   subplot(3,3,1)
  line([n,n+1],[Xh(1,n),Xh(1,n+1)],'Color','r') %plotting estimated trajectory for x coordinate
    hold on 
    drawnow 
    subplot(3,3,4)
     line([n,n+1],[Xh(2,n),Xh(2,n+1)],'Color','r')%plotting estimated trajectory for y coordinate
    hold on 
    drawnow 
    subplot(3,3,7)
    line([n,n+1],[Xh(3,n),Xh(3,n+1)],'Color','r') %plotting estimated trajectory for z coordinate
    hold on 
    drawnow 
    
    
    theta1=arctang(Xh(1,n+1),Xh(2,n+1),0); % this part is used for unwrapping the tan function
    theta=arctang(Xh(1,n),Xh(2,n),0);
    
    if abs(theta1-theta)>=pi
        if ind==1
            ind=0
        
    else
        ind=1
        
        end
    end
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%THIS IS A SUBROUTINE THAT CORRECTS ARCTAN.
%SUBROUTINE PLACES ANGLE IN THR RIGHT QUADRANT
%SUBROUTIEN ALSO HELPS TO UNWRAPE THE ARCTAN
function   [ARG]=arctang(A,B,ind)

if B<0 && A>0 % PLACING IN THE RIGHT QUADRANT

ARG=abs(atan(A/B))+pi/2;

elseif B<0 && A<0

 ARG=abs(atan(A/B))+pi;
 
elseif B>0 && A<0
   
ARG=abs(atan(A/B))+3*pi/2;

else
    ARG=atan(A/B);
end


if ind==-1 % UNWARPPING PART
    ARG=ARG-2*pi;
else if ind==1;
  
            ARG=ARG+2*pi;
    end
end
end

%THIS SUBROTINE COMPUTES INNOVATION PART OF THE FILTER 
function   Inov=Inovation(Z,Xh,ind)


hsn=[sqrt(Xh(1)^2+Xh(2)^2);arctang(Xh(2),Xh(1),ind);Xh(3)]; %COMPUTES VALUES OF NONLINEAR MAPPING 

Inov=Z-hsn;% INNOVATION 

end

%THIS SUBROTINE COMPUTES VALUES OF THE JACOBIAN MATRIX 
function  H=Jacobian(X,Y,Z)

H=[X/(sqrt(X^2+Y^2)), Y/(sqrt(X^2+Y^2)),0,0,0,0;
   -Y/(sqrt(X^2+Y^2)), X/(sqrt(X^2+Y^2)),0,0,0,0;
   0,0,1,0,0,0]; 

end
      
%THIS SUBROTINE COMPUTES KALMAN GAIN 
function   K=KalmanGain(H,P,M)

K=P*H'*(M+H*P*H')^(-1);

end

%THIS SUBROTINE DOES THE PREDICTION PART OF THE KALMAN ALGORITHM
function   [Xh,P]=predict(A,Xh,P,Q)


Xh=A*Xh;% ESTIMATE

P=A*P*A'+Q;% PRIORY ERROR COVARIENCE


end

%THIS SUBROTINE GENERATES STATE PROCESS AND OBSERVATION PROCESS WITH
%GAUSSINA NOISE
function   [D,Z,W,U]=proccesANDobserve(A,D,Z,Q,M,ind)


W=[0;0;0;sqrt(Q(4,4))*randn(1);sqrt(Q(5,5))*randn(1);sqrt(Q(6,6))*randn(1)]; % generating process noise
U=[sqrt(M(1,1))*randn(1);sqrt(M(1,1))*randn(1);sqrt(M(1,1))*randn(1)]; %generating observation noise

D=A*D+W; % State process


ARG=arctang(D(2),D(1),ind);% ARGUMENT 


 Z=[sqrt(D(1)^2+D(2)^2);ARG;D(3)]+U; % observation 


end
end