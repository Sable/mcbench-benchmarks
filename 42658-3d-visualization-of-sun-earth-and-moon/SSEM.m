function SSEM(show)
% This function SSEM implements the visualization of SUN, EARTH and its
% MOON in three dimensional space.
%
% INPUT:
%       show = is a string which takes two option as
%               1. 'fun'; for simple visualization with no actual data, and
%               2. 'actual'; with actual data
% OUTPUT:
%       View of SUN, EARTH and MOON
%
% USAGE EXAMPLE:
% SSEM('fun');
% SSEM('actual');
%
%
%
% Implemented by ASHISH MESHRAM
% meetashish85@gmail.com http://www.facebook.com/ashishmeet

% Checking input arguments
if nargin<1,error(['Not enough input argument.',' Please see documentation']);end

% Implementation starts here
% Initializing figure window
HSSEM = figure('Name','SUN EARTH & MOON',... % Figure winndow with specified
               'NumberTitle','off',...       % properties
               'Menubar','none',...
               'Color',[0 0 0]);

t = linspace(0,150*pi,20000);  % Reference Time vector
[X Y Z] = sphere(50);          % Reference Sphere

switch show
    case 'fun'
        Rm = [30 4 1];  % Mean Radius
        a = [70 8];     % Semi Major Axis
        b = [90 8.5];   % Semi Minor Axis
        T = [45 5];   % Time Period
        
        % Place SUN
        HSUN = surf(Rm(1)*X,Rm(1)*Y,Rm(1)*Z);
        % http://stereo.gsfc.nasa.gov/img/stereoimages/preview/euvisdoCarringtonMap.jpg
        % Load Sun Image
        topoSUN = imread('euvisdoCarringtonMap.jpg');
        % Set it on SUN
        set(HSUN,'facecolor','texture',...
                'cdata',im2double(topoSUN),...
                'edgecolor','none');
        
        hold on;
        % Calculate Planet Earth's Orbital coordinates
        xEarth = a(1)*cos(2*pi*t/T(1));
        yEarth = b(1)*sin(2*pi*t/T(1));
        zEarth = zeros(1,length(t));
        % Place Planet Earth's Orbital Path around SUN
        HEO = plot3(xEarth,yEarth,zEarth);
        set(HEO,'LineWidth',0.1,'color',[0.75,0.75,0.75]);
        % Place Planet Earth in an Orbital Path around SUN
        HEARTH = surf(xEarth(1)+Rm(2)*X,...
                      yEarth(1)+Rm(2)*Y,...
                      zEarth(1)+Rm(2)*Z);
        % Load Earth Image
        load topo;
        % Set it on EARTH
        set(HEARTH,'facecolor','texturemap',...
                   'cdata',topo,...
                   'edgecolor','none');
        
        % Calculate Moon's Orbital coordinates
        xMoon = a(2)*cos(2*pi*t/T(2));
        yMoon = b(2)*sin(2*pi*t/T(2));
        zMoon = zeros(1,length(t));
        % Place Moon's Orbital Path around SUN
        HMO = plot3(xMoon + xEarth(1),...
                    yMoon + yEarth(1),...
                    zMoon);
        set(HMO,'LineWidth',0.1,'color',[0.75,0.75,0.75]);
        % Place Planet Earth in an Orbital Path around SUN
        HMOON = surf(xMoon(1) + xEarth(1) + Rm(3)*X,...
                     yMoon(1) + yEarth(1) + Rm(3)*Y,...
                     zMoon(1) + zEarth(1) + Rm(3)*Z);
        % Load Moon Image
        topoMoon = imread('moon.jpg');
        % Set it on MOON
        set(HMOON,'facecolor','texture',...
                  'cdata',im2double(topoMoon),...
                  'edgecolor','none');
             
        % Axis and Visualization
        axis([-100 100 -100 100 -100 100]);     
        axis equal;
        set(gca,'color','k');
        rotate3d;
        
    case 'actual'
        % Mean Radius of SUN, EARTH & MOON
        Rm =  [695508,6371,1737.5];
        % Semi Major Axis of EARTH around SUN and MOON around EARTH
        a = [149598262 384400];
        % Semi Minor Axis of EARTH around SUN and MOON around EARTH
        b = [149577371.75 384346.32];
        % Sidereal Orbit Period (Length of Year) Time Period
        T = [365.26 27.322];
        disp('Under Construction');
               
    otherwise
        error('Unhandeled view');
end

%-------------------------------------------------------------------------%
%               Traversing Planet EARTH and MOON around SUN               %
%-------------------------------------------------------------------------%

for k = 2:length(t)
    % Rotating SUN on its axis
    rotate(HSUN,[0,0,1],0.02,[0 0 0]);
       
    % Traversing Planet Earth on Orbital Path around SUN
    set(HEARTH,'xdata',xEarth(k) + Rm(2)*X,...
               'ydata',yEarth(k) + Rm(2)*Y,...
               'zdata',zEarth(k) + Rm(2)*Z);
    % Rotating EARTH on its axis
    rotate(HEARTH,[0,0,1],0.25,[xEarth(k) yEarth(k) zEarth(k)]);

    % Traversing Moon's orbital path around Earth's around Orbital Path
    set(HMO,'xdata',xMoon + xEarth(k),...
            'ydata',yMoon + yEarth(k),...
            'zdata',zMoon);
    % Traversing Moon on Orbital Path around EARTH
    set(HMOON,'xdata',xMoon(k) + xEarth(k) + Rm(3)*X,...
              'ydata',yMoon(k) + yEarth(k) + Rm(3)*Y,...
              'zdata',zMoon(k) + Rm(3)*Z);
    % Rotating Moon on its axis
    rotate(HMOON,[0,0,1],0.25,[xMoon(k) + xEarth(k),...
                               yMoon(k) + yEarth(k),...
                               zMoon(k)]);
    
%     camtarget([xEarth(k),yEarth(k),zEarth(k)]);
%     campos([2*xEarth(k),2*yEarth(k),2*zEarth(k)]);
    drawnow;
end
