function projectile_motion
% This program is used to view the path & distance covered by a particle in
% animated form.
% 
% Execute function in command window it will prompt yout to enter values 
% required by program, after getting input parameters it will calculate the 
% equations for projectile motion then it will show the animated path and
% distance covered by particle.
% 
% Created by M M Zafar
% Date 15.01.2010
%% Input Parameters for projrctile motion
theta = input('Enter launch angle= ');      %Launch angle, theta (degrees)
m = input('Enter mass of the body= ');  %Mass, m (grams)
Fs = input('Enter constant force spring force= ');    %Constant force spring force, Fs (N)
Ns = input('Enter number of springs= ');  %Number of springs, Ns
LL = input('Enter distance over which force is applied= ');   %Distance over which force is applied, LL (mm)
eta = input('Enter efficiency= ');    %efficiency, eta
g = input('Enter acceleration due to gravity= ');     %Acceleration due to gravity, g (m/s^2)
N = input('Enter no. of steps= ');

%% Calcultion for projectile motion
V = sqrt(2.*Ns.*Fs.*LL.*eta./m);    %Launch velocity, V (m/s)
Vy = V.*sind(theta);    %Vertical velocity component, Vy (m/s)
Vx = V.*cosd(theta);    %Horizontal velocity component, Vx (m/s)
tmh = V.*sind(theta)./g;    % Time to maximum height, tmh (seconds)
ttotal = 2.*tmh;    % Total travel time, ttotal (seconds)
ymax = (V.^2).*(sind(theta).^2)./(2.*g);    %Maximum height, ymax (m)
xmax = (V.^2).*(sind(2.*theta))./g;     %Maximum range, xmax (m)
tinc = ttotal./N;      %Time increment, tinc

%% Preallocation of answer spaces
time = zeros(N,1);      %Preallocation for time 
xpos = zeros(N,1);     %Preallocation for X-Position 
ypos = zeros(N,1);     %Preallocation for Y-Position 

%% Loop for generation of time vector
for l = 1:N-1
    time(l+1) = time(l)+tinc;
end

%% Loop for generation of x-position & y-position vector
for j = 1:N
    xpos(j) = time(j).*Vx;
    ypos(j) = V.*time(j).*sind(theta)-0.5.*g.*time(j).^2;
end

%% Loop for visualization of plot
for k = 1:N
    hold all
    h = plot(time(k),xpos(k),'p',time(k),ypos(k),'o',...
        'LineWidth',2,'MarkerEdgeColor','g',...
        'MarkerFaceColor','y','MarkerSize',2+k);
    pause(0.6)
    drawnow
end

%% Annotation of graph
    legend('Distance','Path','Location','NorthWest')
    title('Projetile Trajectory','FontSize',14,'FontWeight','Bold','FontName','Calibri')
    ylabel('Distance(m)','FontSize',12,'FontWeight','Bold','FontName','Calibri')
    xlabel('Time(s)','FontSize',12,'FontWeight','Bold','FontName','Calibri')
    grid on
    