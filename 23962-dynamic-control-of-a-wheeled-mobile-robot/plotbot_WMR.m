%% FUNCTION FOR PLOTTING THE SIMULATED OUTPUT FOR A GIVEN TIME VECTOR AND
%%% JOINT SPACE ANGLE VECTORS

% Course: Robotic Manipulation and Mobility
% Advisor: Dr. V. Krovi
%
% Homework Number: 6
%
% Names: Sourish Chakravarty
% 	Hrishi Lalit Shah

function plotbot_WMR(t,X,index,txt1)
global b d L1 L2%r a mc mw Ic Iw Im % WMR paramters
global xe ye rx ry ell_an start_an w % Trajectory information
aviobj = avifile([txt1,'.avi'],'compression','Cinepak'); % Declare an avi object
close all;
figure(index*3-2);
cla('reset');
axis manual;
axis([-1 5 -3 3]);
hold on;
grid on;
% T=[0:0.1:20]
x_E=xe+rx*cos(w*t + start_an)*cos(ell_an) + ry*sin(w*t + start_an)*(-sin(ell_an)); % Initial X on ellipse
y_E=ye+rx*cos(w*t + start_an)*sin(ell_an) + ry*sin(w*t + start_an)*(cos(ell_an)); % Initial Y on ellipse
plot(x_E,y_E,'-k');
x_E1=x_E; y_E1=y_E;
title(txt1);
%% Initial Sketch
x_C=X(1,1);
y_C=X(1,2);
phi=X(1,3);
wx=0.2; wy=wx*2;
TR_C2O= [cos(phi), -sin(phi), x_C;
        sin(phi), cos(phi), y_C;
        0,0,1]; % Transformation from CM cood system to Absolute cood sys
WMR_COORD=[    -d    -d -d+wy -d+wy d 1.5*d  d -d+wy -d+wy    -d;
            -b-wx  b+wx  b+wx     b b     0 -b    -b -b-wx -b-wx;
                1     1     1     1 1     1  1     1     1     1];
WMR_PLOT=TR_C2O*WMR_COORD;
WMR_PLOT1=TR_C2O*[L1;L2;1];
h1=plot(WMR_PLOT(1,:),WMR_PLOT(2,:),'r','Erasemode','xor');% WMR PLOTTING
h3=plot(WMR_PLOT1(1),WMR_PLOT1(2),'bo','Erasemode','xor'); % PLot Look ahead point
ctr=0;
for i=1:4:length(t)
    x_C=X(i,1);
    y_C=X(i,2);
    phi=X(i,3);
%     thR=X(i,4);
%     thL=X(i,5);
    ctr=ctr+1;
    TR_C2O= [cos(phi), -sin(phi), x_C;
             sin(phi), cos(phi), y_C;
             0,0,1]; % Transformation from CM cood system to Absolute cood sys
    
    %% ELLIPSE INFORMATION : DESIRED OUTPUTS
    
    x_E=xe+rx*cos(w*t(i) + start_an)*cos(ell_an) + ry*sin(w*t(i) + start_an)*(-sin(ell_an)); % Initial X on ellipse
    y_E=ye+rx*cos(w*t(i) + start_an)*sin(ell_an) + ry*sin(w*t(i) + start_an)*(cos(ell_an)); % Initial Y on ellipse

    WMR_PLOT=TR_C2O*WMR_COORD;
    WMR_PLOT1=TR_C2O*[L1;L2;1];
    x_L=WMR_PLOT1(1);
    y_L=WMR_PLOT1(2);
    WMR_Coord_List(ctr,:)=[WMR_PLOT1(1),WMR_PLOT1(2)]; %Store for later use

    err1(ctr)= sqrt((x_E-x_L)^2 + (y_E-y_L)^2);
    time(ctr)= t(i);
    set(h1,'Xdata',WMR_PLOT(1,:),'Ydata',WMR_PLOT(2,:));%WMR PLOTTING
    set(h3,'Xdata',WMR_PLOT1(1),'Ydata',WMR_PLOT1(2)); % PLot Look ahead point
    plot(WMR_Coord_List(ctr,1),WMR_Coord_List(ctr,2),'yo');

    pause(0.05);     %Stop execution for 0.01 to make animation visible
        frame= getframe(gcf);   %Step 2: Grab the frame
        aviobj = addframe(aviobj,frame); % Step 3: Add frame to avi object
end
aviobj = close(aviobj)  % Close the avi object
hold off
% axis equal;
% disp(max(err1));
figure(index*3-1);
plot(time,err1);
figure(index*3);
plot(WMR_Coord_List(:,1),WMR_Coord_List(:,2),'bo');
hold on;
plot(x_E1,y_E1,'-k');