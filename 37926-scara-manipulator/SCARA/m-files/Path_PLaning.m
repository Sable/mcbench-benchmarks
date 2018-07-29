function Path_PLaning(OI,OF,TH4) % function take as input initial and                  
                                 % final position and orientation

 
a1=1;
a2=1;
d1=1;                             % definition of robot parameters
d2=.1;
d=.1;
L=.3;

Xi=OI(1,1);
Yi=OI(2,1);                       % definition of initial position
Zi=OI(3,1);

flag=0;                            % make signal flag to 0 value

Xf=OF(1,1);
Yf=OF(2,1);                        % definition of final position    
Zf=OF(3,1);
 
if sqrt(((Xi)^2)+((Yi)^2))>2     % test of initial position in or out     
                                 % work space  
fprintf('Out of work space')
 
flag=1;                          % if yes make signal flag=1
end
 
if sqrt(Xf^2+Yf^2)>2             % test of final position in or out     
                                 % work space 
fprintf('Out of work space')
flag=1;                          % if yes make signal flag=1
end
 
if flag==0                    % if flag=0 in this case we are in work
                              % space

[T1 T2 T4 d3]=Scara_Inverse(Xi,Yi,Zi,d1,d2,a1,a2) %call function
                                                  %Scara_Inverse
                                             % returning T1 T2 T4 d3
                                             % for initial point
 
 J=Jacobian(T1,T2)                 %call function jacobian to test
                                   % singularity of initial point
  J11=[J(1:3,1:3)]
 S=det(J11)
 if S==0
     flag=1
    fprintf('Singularity')
 end
 
 
 
[T1f T2f T4 d3]=Scara_Inverse(Xf,Yf,Zf,d1,d2,a1,a2) %call function
                                                    %Scara_Inverse
                                              % returning T1 T2 T4 d3
                                              % for initial point 
 
J=Jacobian(T1f,T2f)                %call function jacobian to test
                                   % singularity of final point
 J11=[J(1:3,1:3)]
  S=det(J11)
 if S==0
     flag=1
    fprintf('Singularity')
 end
end
 
% 
if flag==0
    
     
slope = (Yf-Yi)/(Xf-Xi);           % we make calculation of slope of 
                                   % second portion of path
  inc=.01           
  
for Z=0:inc:Zi                  % begin of first portion of path, 
                                % make the value of inc=0.01
                                % in this portion we maintain the
                                % value of X and Y and the only 
                                % variation is in Z axis

    d3=d1-Z-d2;                        
  
 SCARA_plot(T1,T2,T4,a1,a2,d1,d3,d2,L,d)
 

hold on 
 plot3([Xi Xi],[Yi  Yi],[0 Zi],'red','linewidth',2) %plotting first 
                                                   % portion of path 

hold on
 
    
 
 plot3([Xi Xf],[Yi  Yf],[Zi Zi],'red','linewidth',2) %plotting second 
                                                   % portion of path 

hold on
 
plot3([Xf Xf],[Yf  Yf],[Zi Zf],'red','linewidth',2) %plotting third 
                                                   % portion of path 

hold off
 
 pause(.01)
end
if Xi>Xf                      % if the desired position is < the
                              % initial position we decrement xi by
                              % -0.01
    inc=-.01;
else
    inc=.01;                   % if the desired position is > the
                               % initial position we increment xi by
                               % +0.01
end
 
for X=Xi:inc:Xf           % for any new value of X and Y we calculate
                          % [T1 T2 T4 d2] by call of function 
                          %  Scara_Inverse 

    Y=slope*(X-Xf)+Yf;
 [T1 T2 T4 d3]=Scara_Inverse(X,Y,Zi,d1,d2,a1,a2);
 
plot3([Xi Xi],[Yi  Yi],[0 Zi],'red','linewidth',2)  %plotting first 
                                                   % portion of path 
hold on
plot3([Xi Xf],[Yi  Yf],[Zi Zi],'red','linewidth',2)%plotting second 
                                                    % portion of path 
hold on
plot3([Xf Xf],[Yf  Yf],[Zi Zf],'red','linewidth',2) %plotting third 
                                                    % portion of path 
hold on  
  
 SCARA_plot(T1,T2,T4,a1,a2,d1,d3,d2,L,d)     % ploting the motion of
                                             % robot on the path

 pause(.01)
 
end
    inc=-.01;                   % begin of third portion of path, 
                                % make the value of inc=-0.01
                                % in this portion we maintain the
                                % value of X and Y and the only 
                                % variation is in Z axis

for Z=Zi:inc:Zf
    d3=d1-Z-d2;                 % we go down by decrementing Zi

    
 SCARA_plot(T1,T2,T4,a1,a2,d1,d3,d2,L,d)     % ploting the motion of
                                             % robot on the path

 
 hold on 
 plot3([Xi Xi],[Yi  Yi],[0 Zi],'red','linewidth',2) %plotting first 
                                                    % portion of path 

hold on
 
 plot3([Xi Xf],[Yi  Yf],[Zi Zi],'red','linewidth',2) %plotting second 
                                                     % portion of path 

hold on
 
plot3([Xf Xf],[Yf  Yf],[Zi Zf],'red','linewidth',2)  %plotting third 
                                                    % portion of path

hold off
pause(.01)
end
 
 for T4=0:1:TH4            % adjustement and orientation of end 
                           % effector
hold on
 plot3([Xi Xi],[Yi  Yi],[0 Zi],'red','linewidth',2) %plotting first 
                                                    % portion of path 

plot3([Xi Xf],[Yi  Yf],[Zi Zi],'red','linewidth',2) %plotting second 
                                                    % portion of path 

 
 plot3([Xf Xf],[Yf  Yf],[Zi Zf],'red','linewidth',2) %plotting third 
                                                    % portion of path 

 

hold off
  SCARA_plot(T1,T2,T4,a1,a2,d1,d3,d2,L,d)     % ploting the motion of
                                             % robot on the path
hold on
plot3([Xi Xi],[Yi  Yi],[0 Zi],'red','linewidth',2) %plotting first 
                                                    % portion of path
 
plot3([Xi Xf],[Yi  Yf],[Zi Zi],'red','linewidth',2) %plotting second 
                                                    % portion of path

plot3([Xf Xf],[Yf  Yf],[Zi Zf],'red','linewidth',2) %plotting third 
                                                    % portion of path
 
  pause(.01) 
 
  end 
hold off
end