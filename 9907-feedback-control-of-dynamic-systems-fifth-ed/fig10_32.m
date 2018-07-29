%  Figure 10.32      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% Fig. 10.32 Script for computation of the root locus of yaw response, 
% with no compensation, direct feedback 


f =[-0.0558   -0.9968    0.0802    0.0415;
    0.5980   -0.1150   -0.0318         0 ;
   -3.0500    0.3880   -0.4650         0 ;
         0    0.0805    1.0000         0] ;
g =[0.0073;
   -0.4750;
    0.1530;
         0];
h = [0     1     0     0];
j =[0];
% the equations of the actuator:

na=[0 10];
da=[1 10];
[fa,ga,ha,ja]=tf2ss(na,da);

% the equations of the aircraft with actuator:

[fp,gp,hp,jp]=series(fa,ga,ha,ja,f,g,h,j);
% the uncompensated rootlocus
 hold off; clf
 rlocus(fp,-gp,hp,jp);
 axis([-2, 2, -1.5, 1.5]);
 grid;
 title('Fig. 10.32 Root locus of the aircraft with positive feedback')
 
