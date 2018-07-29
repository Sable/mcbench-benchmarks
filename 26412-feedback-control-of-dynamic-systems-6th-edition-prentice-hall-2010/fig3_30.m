%  Figure 3.30      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.30
% Pole-zero effects
%

t=0:.01:2.5;
Den=conv([1 4],[1 6]);

z=1;
Num=4*6*[1/z 1];
[y1]=step(Num,Den,t);
plot(t,y1);
hold on;
z=2;
Num=4*6*[1/z 1];
[y2]=step(Num,Den,t);
plot(t,y2);
z=3;
Num=4*6*[1/z 1];
[y3]=step(Num,Den,t);
plot(t,y3);
z=4;
Num=4*6*[1/z 1];
[y4]=step(Num,Den,t);
plot(t,y4,'--');
z=5;
Num=4*6*[1/z 1];
[y5]=step(Num,Den,t);
plot(t,y5);
z=6;
Num=4*6*[1/z 1];
[y6]=step(Num,Den,t);
plot(t,y6,'-.');
text(.2,2.2,'{\it z} =1');
text(.2,1.3,'{\it z} =2');
text(.2,1.05,'{\it z} =3');
text(.2,0.5,'{\it z} =6');

xlabel('Time (sec)');
ylabel('Unit step response');
title('Fig. 3.30: Effect of zero location');
% grid
nicegrid