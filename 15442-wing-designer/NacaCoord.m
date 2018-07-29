function [C,T,A]=naca4_3d(airfoil,y,nc)
% determine airfoil skin and camber coordinates from NACA designation
%% NacaCoord.m
% NACA 4-digit or 5-digit series airfoil
%
% outputs:  C = matrix of camber line coordinates, x,y,z
%               ordered trailing edge first
%           T = matrix of skin coordinates
%               ordered from trailing edge over top surface then
%               along bottom surface to trailing edge
%           A = area of airfoil cross section (normalized)
%
% NOTE: Chord of output airfoil is 1
%
% inputs:   airfoil = NACA 4- or 5-digit airfoil as string
%           y = spanwise location
%           nc = number of chordwise panels
%
% Ref:      http://www.aerospaceweb.org/question/airfoils/q0041.shtml

%           Ira H. Abbott and Albert E. Von Doenhoff, Theory of Wing
%           Sections, 1959, Dover Publications, NY.
%
% Coordinate system:
%   x: chord direction, origin at LE, positive is pointing toward TE
%   y: station along span, perpendicular to aircraft midplane
%   z: perpendicular to chord, positive is up

%This 'if' statement establishes the constants for either 4- or 5- digit
%airfoils.
if length(airfoil) == 4
    m = str2num(airfoil(1))/100;
    p = str2num(airfoil(2))/10;
    t = str2num(airfoil(3:4))/100;

elseif length(airfoil) == 5
    switch airfoil(1:3)
        case '210'
            m = 0.0580;
            k1 = 361.4;
        case '220'
            m = 0.1260;
            k1 = 51.64;
        case '230'
            m = 0.2025;
            k1 = 15.957;
        case '240'
            m = 0.2900;
            k1 = 6.643;
        case '250'
            m = 0.3910;
            k1 = 3.230;
        otherwise
    end
    t = str2num(airfoil(4:5))/100;
end





%% Constants
% nc          % number of line segments describing top surface
% (= number of line segments describing bottom surface)
npc = nc+1;      % number of points along mean camber line
nps = 2*nc+1;    % number of points along surface
dx=1/nc;        % x-direction increment (along chord)

%% Fill coordinate matrices with y coordinate
C = zeros(npc,3); % mean camber
C(:,2) = y;
T = zeros(nps,3); %skin
T(:,2) = y;

%% Mean Camber Line and Slope
% dzcdx is the derivative of the mean camber line
% theta is the local angle of the mean camber line
% x=1:-dx:0; % order x locations starting at trailing edge, x=1
x=0:dx:1; % order x locations starting at leading edge, x=0
if length(airfoil) == 4
    for i = 1:nc+1
        if x(i)<p    % leading edge
            zc(i) = m/(p^2)*(2*p*x(i)-x(i)^2);  %Eqn 6.4 Abbot
            dzcdx(i) = m/p^2*(2*p-2*x(i));
            theta(i) = atan(dzcdx(i));
        else            % trailing edge
            zc(i) = m/(1-p)^2*((1-2*p)+2*p*x(i)-x(i)^2);    %Eqn 6.4 Abbot
            dzcdx(i) = m/(1-p)^2*(2*p-2*x(i));
            theta(i) = atan(dzcdx(i));
        end
    end
elseif length(airfoil) == 5
    for i = 1:nc+1
        if x(i)<m    % leading edge
            zc(i) = 1/6*k1*(x(i)^3-3*m*x(i)^2+m^2*(3-m)*x(i));  %Eqn 6.6 Abbot
            dzcdx(i) = 1/6*k1*(3*x(i)^2-6*m*x(i)+m^2*(3-m));
            theta(i) = atan(dzcdx(i));
        else            % trailing edge
            zc(i) = 1/6*k1*m^3*(1-x(i));    %Eqn 6.6 Abbot
            dzcdx(i) = -1/6*k1*m^3;
            theta(i) = atan(dzcdx(i));
        end
    end
end

C(:,1)=-x;  % output mean camber line coordinates; negative x due to axis convention
C(:,3)=-zc; %negative z due to axis convention

%% Thickness distribution is the same for both 4- and 5-digit airfoils
for i=1:nc+1
    zt(i) = t/0.2*[0.2969*x(i)^0.5-0.1260*x(i)-0.3516*x(i)^2+0.2843*x(i)^3-0.1015*x(i)^4];  %Eqn 6.2 Abbott
end

%% Area
A=0;
for i=1:nc
    da=dx*(zt(i)+zt(i+1));  %Take the average of zt(i) and zt(i+1) and double it
    A=A+da;
end
A;

%% Upper skin
for i=1:nc+1
    xu(i) = x(i)-zt(i)*sin(theta(i));  %Eqn 6.1 Abbott
    zu(i) = zc(i)+zt(i)*cos(theta(i));  %Eqn 6.1 Abbott
    T(i,1) = -xu(i);  %negative x due to sign convention
    T(i,3) = -zu(i);  %negative z due to sign convention
end

%% lower skin
% exclude point nc+1 at leading edge
% because it is included as the last point of the upper surface

for i=1:nc
    xl(i) = x(i)+zt(i)*sin(theta(i));    %Eqn 6.1 Abbott
    zl(i) = zc(i)-zt(i)*cos(theta(i));    %Eqn 6.1 Abbott
end

% reverse order so LE to TE
for i=nc+2:nps
    T(i,1) = -xl(2*(nc+1)-i);%negative x due to sign convention
    T(i,3) = -zl(2*(nc+1)-i);%negative z due to sign convention
end
%figure
%plot(xu,zu,'o')
%hold on
%plot(xl,zl,'or')
%axis equal
