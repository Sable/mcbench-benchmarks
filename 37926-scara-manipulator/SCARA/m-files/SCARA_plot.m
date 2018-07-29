function plotSCARA=SCARA_plot(T1,T2,T4,a1,a2,d1,d2,d3,L,d)
 
if T1<0;
    T1=T1+360;
end
if T2<0;
    T2=T2+360;
end
if T4<0;
    T4=T4+360;
end
if T4>180
    T4=T4-180;
end
%%%%%%%%for a1
X_1=a1*cosd(T1);
Y_1=a1*sind(T1);
plot3([0 X_1],[0 Y_1],[d1 d1],'b','linewidth',7)
 
%%%%%%%%for a2
X_2=X_1+(a2*cosd(T1+T2));
Y_2=Y_1+(a2*sind(T1+T2));
hold on
plot3([X_2 X_1],[Y_2 Y_1],[d1 d1],'r','linewidth',7)
 
%%%%%%%%%%%%%%%%%%% for d1
hold on
plot3([0 0],[0 0],[0 d1],'black','linewidth',8)
%%%%%%%%%%%%%%%%%%%%% for d2
hold on
plot3([X_2 X_2],[Y_2 Y_2],[d1 d1-d2],'black','linewidth',5)
% plot3([X_2 X_2],[Y_2 Y_2],[d1 d1+.4],'blue','linewidth',7)    % tube
%%%%%%%%%%%% End effector
hold on
if (T4 < 90)
XP=[min(X_2-(L/2)*cosd(T4),X_2+(L/2)*cosd(T4)),max(X_2-(L/2)*cosd(T4),X_2+(L/2)*cosd(T4))];
YP=[min(Y_2-(L/2)*sind(T4),Y_2+(L/2)*sind(T4)),max(Y_2-(L/2)*sind(T4),Y_2+(L/2)*sind(T4))];
plot3([XP(1),XP(2)],[YP(1),YP(2)],[d1-d2 d1-d2],'linewidth',5)
hold on
 
XP=[min(X_2-(d/2)*cosd(T4),X_2+(d/2)*cosd(T4)),max(X_2-(d/2)*cosd(T4),X_2+(d/2)*cosd(T4))];
YP=[min(Y_2-(d/2)*sind(T4),Y_2+(d/2)*sind(T4)),max(Y_2-(d/2)*sind(T4),Y_2+(d/2)*sind(T4))];
plot3([XP(1),XP(1)],[YP(1),YP(1)],[d1-d2 d1-d2-d3])
hold on
plot3([XP(2),XP(2)],[YP(2),YP(2)],[d1-d2 d1-d2-d3])
else
XP=[min(X_2-(L/2)*cosd(T4),X_2+(L/2)*cosd(T4)),max(X_2-(L/2)*cosd(T4),X_2+(L/2)*cosd(T4))];
YP=[max(Y_2-(L/2)*sind(T4),Y_2+(L/2)*sind(T4)),min(Y_2-(L/2)*sind(T4),Y_2+(L/2)*sind(T4))];
plot3([XP(1),XP(2)],[YP(1),YP(2)],[d1-d2 d1-d2],'linewidth',5)
hold on
 
XP=[min(X_2-(d/2)*cosd(T4),X_2+(d/2)*cosd(T4)),max(X_2-(d/2)*cosd(T4),X_2+(d/2)*cosd(T4))];
YP=[max(Y_2-(d/2)*sind(T4),Y_2+(d/2)*sind(T4)),min(Y_2-(d/2)*sind(T4),Y_2+(d/2)*sind(T4))];
plot3([XP(1),XP(1)],[YP(1),YP(1)],[d1-d2 d1-d2-d3])
hold on
plot3([XP(2),XP(2)],[YP(2),YP(2)],[d1-d2 d1-d2-d3]) 
plot3([XP(2),XP(2)],[YP(2),YP(2)],[d1-d2 d1-d2-d3])    
hold on
end
% %%%%%%%%%%%%%%%%%%%% Joints
% hold on
% plot3([0 0],[0 0],[d1*.98 d1*1.02],'black','linewidth',5.5)
% figure
% plot([0 X_1],[0 Y_1])
% hold on
% plot([X_2 X_1],[Y_2 Y_1])
 axis([-(a1+a2) (a1+a2) -(a1+a2) (a1+a2) 0 d1])
hold off