disp('.making a plant...')
%
% Make plant 
%

%
% Copyright 2004, Paul Lambrechts, The MathWorks, Inc.
%

% For discrete time approximation
Ts = 5e-3 ;

% Trajectory parameters
t0 = 0.3 ;  % starting time
d = 1000 ;  % derivative of jerk
j =   50 ;  % jerk
a =    5 ;  % acceleration
v =    1 ;  % velocity
p =    1 ;  % position
r  = 10*eps ; % resolution for position signal
s  = 15     ; % quantization to s decimals

m1  =   20    ;
m2  =   10    ;
c   =   6e5   ;
k12 =  500     ;
k1  =  10     ;
k2  =  10     ;

% simple second order:
As = [ 0           1  
       0   -(k1+k2)/(m1+m2)  ];
Bs = [ 0   ;   1/(m1+m2)     ];
Cs = [ 1 0 ];
Ds = 0 ;
syss=ss(As,Bs,Cs,Ds);

% Make fourth order plant 

Ap = [   0         1         0         0             % x1
       -c/m1  -(k1+k12)/m1  c/m1     k12/m1          % x1dot
         0         0         0         1             % x2
        c/m2     k12/m2    -c/m2  -(k2+k12)/m2 ];    % x2dot
   
Bp = [   0
        1/m1       % F
         0
         0   ];
 
%Cp = [   1         0        0         0            % x1
%         0         0        1         0     ];     % x2
Cp = [   0         0        1         0     ];      % x2
 
%Dp = [   0
%         0   ];
Dp=0;

sysp=ss(Ap,Bp,Cp,Dp);
     
%%%%%%%%

% Make approximate fourth order feedforward (k12 = 0)

Aff0 = [  0      1               0                  0
          0      0               1                  0
          0      0               0                  1
          0      0               0                  0   ];
     
Bff0 = [  0
          0
          0
          1  ];
     
Cff0 = [  0   k1+k2  (m1+m2)+k1*k2/c  (m1*k2+m2*k1)/c        % feedforward for x2  
          1     0           0              0                 % x2 ref
          0     1           0              0                 % velocity profile
          0     0           1              0                 % acceleration profile
          0     0           0              1                 % jerk profile
          0     0           0              0      ];   
         
Dff0 = [ m1*m2/c
           0
           0
           0
           0
           1   ];  % derivative of jerk profile
         
sysff0=ss(Aff0,Bff0,Cff0,Dff0);
sysff01=ss(Aff0,Bff0,Cff0(1,:),Dff0(1,:));

% Make discrete approximative fourth order feedforward (k12 = 0) with time delay corrections

Adff0 = [ 0    1  0   0   (k1+k2)*.5 ((m1+m2)+k1*k2/c)  (m1*k2+m2*k1)/c*.5      % FF time delay 1
          0    0  0   0      0            0             (m1*k2+m2*k1)/c*.5      % FF time delay 2
          0    0  0   1      0            0                    0                % x2ref delay for ZOH effect
          0    0  0   1      Ts           0                    0
          0    0  0   0      1            Ts                   0
          0    0  0   0      0            1                    Ts
          0    0  0   0      0            0                    1   ];
     
Bdff0 = [ 0
          m1*m2/c
          0
          0
          0
          0
          Ts  ];
     
Cdff0 = [ 1     0  0   0   (k1+k2)*.5     0                    0                 % feedforward for x2  
          0     0 1/2 1/2     0           0                    0                 % x2 ref
          0     0  0   0      1           0                    0                 % velocity profile
          0     0  0   0      0           1                    0                 % acceleration profile
          0     0  0   0      0           0                    1                 % jerk profile
          0     0  0   0      0           0                    0      ];   
         
Ddff0 = [  0
           0
           0
           0
           0
           1   ];  % derivative of jerk profile
         
sysdff0=ss(Adff0,Bdff0,Cdff0,Ddff0);
sysdff01=ss(Adff0,Bdff0,Cdff0(1,:),Ddff0(1,:));
       
if 1==0 % alternative delay calculation
    
Adff0 = [ 0    1  0   0      0    ((m1+m2)+k1*k2/c)*.5  (m1*k2+m2*k1)/c         % FF time delay 1
          0    0  0   0      0            0                    0                % FF time delay 2
          0    0  0   1      0            0                    0                % x2ref delay for ZOH effect
          0    0  0   1      Ts           0                    0
          0    0  0   0      1            Ts                   0
          0    0  0   0      0            1                    Ts
          0    0  0   0      0            0                    1   ];
     
Bdff0 = [ m1*m2/c/2
          m1*m2/c/2
          0
          0
          0
          0
          Ts  ];
     
Cdff0 = [ 1     0  0   0   (k1+k2)  ((m1+m2)+k1*k2/c)*.5       0                 % feedforward for x2  
          0     0  0   1      0           0                    0                 % x2 ref
          0     0  0   0      1           0                    0                 % velocity profile
          0     0  0   0      0           1                    0                 % acceleration profile
          0     0  0   0      0           0                    1                 % jerk profile
          0     0  0   0      0           0                    0      ];   
         
Ddff0 = [  0
           0
           0
           0
           0
           1   ];  % derivative of jerk profile
         
sysdff0=ss(Adff0,Bdff0,Cdff0,Ddff0);
sysdff01=ss(Adff0,Bdff0,Cdff0(1,:),Ddff0(1,:));

end


% Make ideal fourth order feedforward 

Aff = [-c/k12       0 (k1+k2)*c/k12  k1+k2+((m1+m2)*c+k1*k2)/k12  (m1+m2)+(m1*k2+m2*k1)/k12
         0        0       1                    0                        0
         0        0       0                    1                        0
         0        0       0                    0                        1
         0        0       0                    0                        0   ];
     
Bff = [ (m1*m2)/k12
            0
            0
            0
            1  ];
     
Cff = [  1    0          0               0                  0         % ideal feedforward for x2  
         0    1          0               0                  0         % x2 ref
         0    0          1               0                  0         % velocity profile
         0    0          0               1                  0         % acceleration profile
         0    0          0               0                  1         % jerk profile
         0    0          0               0                  0    ];   
         
Dff = [  0
         0
         0
         0
         0
         1   ];  % derivative of jerk profile
         
sysff=ss(Aff,Bff,Cff,Dff);
sysff1=ss(Aff,Bff,Cff(1,:),Dff(1,:));
    
%
% Make sixth order plant 
%

m3  =    3     ;
c1  =    c*1.21 ;   % 1.68 if c2=6e5   % 1.945 if c2=5e5   % 4th=6th: c1=c*1.21
d1  =    k12*1.78 ;
c2  =    5e5   ;
d2  =    0     ;
k3  =  0     ;

% corrections on second mass
m2  = m2-m3    ;

%w = 10000 ;  % resonance frequency [rad/s]
%b = 0.02 ;  % relative damping

A6 = [       0         1           0              0           0          0
          -c1/m1  -(d1+k1)/m1    c1/m1          d1/m1         0          0
             0         0           0              1           0          0
           c1/m2     d1/m2    -(c1+c2)/m2  -(d1+d2+k2)/m2   c2/m2      d2/m2
             0         0           0              0           0          1
             0         0         c2/m3          d2/m3      -c2/m3   -(d2+k3)/m3   ];
                 
B6 = [  0
       1/m1
        0
        0
        0
        0  ];

%C6 = [  1   0   0   0   0   0         %  x1
%        0   0   0   0   1   0  ];     %  x3
C6 = [ 0  0  0  0  1  0 ];

%D6 = Dp;    
D6 = 0;

sys6=ss(A6,B6,C6,D6);

% Make feedforward for 6th order plant
ma=(m3*(m1+m2)*c1+m1*(m2+m3)*c2)/(m3*(c1+c2)+m2*c2);  % equivalent actuator mass
mm=(m1+m2+m3)-ma;                                     % equivalent load mass
c6=mm*c1*c2/(m3*(c1+c2)+m2*c2);                       % equivalent stiffness

d6=k12*1.07; %85;

m2=m2+m3;

%c=c*0.625;
%m1=m1+0.5*m2;
%m2=m2*0.5;

Aff6 = [-c6/d6       0 (k1+k2)*c6/d6  k1+k2+((ma+mm)*c6+k1*k2)/d6  (ma+mm)+(ma*k2+mm*k1)/d6
           0         0       1                   0                        0
           0         0       0                   1                        0
           0         0       0                   0                        1
           0         0       0                   0                        0   ];
     
Bff6 = [ (ma*mm)/d6
            0
            0
            0
            1  ];
     
Cff6 = [  1    0          0               0                  0         % ideal feedforward for x2  
          0    1          0               0                  0         % x2 ref
          0    0          1               0                  0         % velocity profile
          0    0          0               1                  0         % acceleration profile
          0    0          0               0                  1         % jerk profile
          0    0          0               0                  0    ];   
         
Dff6 = [  0
          0
          0
          0
          0 
          1   ];  % derivative of jerk profile
         
sysff6=ss(Aff6,Bff6,Cff6,Dff6);
sysff61=ss(Aff6,Bff6,Cff6(1,:),Dff6(1,:));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple controller (PID plus notch)

Kp = 2e4  ;  % proportional gain
fi = 1*2*pi    ;  % integral frequency
fd = 1.5*2*pi   ;  % derivative frequency
wz = 3e6   ;  % notch frequency ----> so high it is actually a low pass filter
bz = 1  ;  % notch damping
wp = 120*2*pi  ;  % filter poles frequency
bp = 1   ;  % filter damping

Ki = fi*Kp;
Kd = Kp/fd;

num1 = [  Kd  Kp Ki ];
den1 = [ 1/wp 1  0  ];
sys1 = tf(num1,den1);
num2 = [ 1/wz^2 2*bz/wz 1 ];
den2 = [ 1/wp^2 2*bp/wp 1 ];
sys2 = tf(num2,den2);

sysc = series(sys1,sys2);
%sysc=sys1;
[Ac,Bc,Cc,Dc]=SSdata(sysc);

syscd=c2d(sysc,Ts);
[Acd,Bcd,Ccd,Ddd]=ssdata(syscd);

clear functions
disp('...finished')
