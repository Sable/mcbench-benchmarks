%%%% Create animation for a 2-link serial chain manipiulator

% Course: Robotic Manipulation and Mobility
% Advisor: Dr. V. Krovi
% 
% Homework Number: MIDTERM
% 
% Names: Sourish Chakravarty 
% 	Hrishi Lalit Shah

function [aviobj]= CREATE_ANIME_1(aviobj,T,th1,x2,y2,th2,h)

global l1 lc1 l2 lc2
figure(h)
Z0=[0 0]; %%% Point of suspension
for i=1:length(T)
    
    c1=cos(th1(i));
    c2=cos(th2(i));
    s1=sin(th1(i));
    s2=sin(th2(i));
    %%% Plotting Link - 1
    Z1= Z0 + [l1*c1, l1*s1];% Coordinate of the hanging end link 1
    plot([Z0(1),Z1(1)],[Z0(2),Z1(2)],'b','linewidth',4);
    hold on
    Z1m= Z0 + [lc1*c1, lc1*s1];% Coordinate of the CM of link 1
    plot(Z1m(1), Z1m(2),'r*'); %Plots mid point
    plot(Z0(1),Z0(2),'k*'); % Plots point of suspension
    
    %%% Plotting Link - 2
    Z2m = [x2(i), y2(i)];% Coordinate of the CM of link 2
    Z2l = Z2m - [lc2*c2, lc2*s2]; % Coordinate of source-end of link - 2
    Z2r = Z2m + [(l2-lc2)*c2, (l2-lc2)*s2]; % Coordinate of effector-end of link-2 
    plot([Z2l(1),Z2r(1)],[Z2l(2),Z2r(2)],'m','linewidth',4);
    plot(Z2m(1), Z2m(2),'r*'); %Plots mid point
    xlim([-4,4]);
    ylim([-4,4]);
%     title('Midterm Animation');
    xlabel('X-axis');
    ylabel('Y-axis');
    grid on
    hold off
    pause(0.01);     %Stop execution for 0.01 to make animation visible
    frame= getframe(gcf);   %Step 2: Grab the frame
    aviobj = addframe(aviobj,frame); % Step 3: Add frame to avi object
end