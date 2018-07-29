function [pos] = center(Pa,Pb,Pc,Type)
% CENTER calculates and shows the orthocenter, circumcenter, barycenter and
% incenter of a triangle, given their vertex's coordinates Pa, Pb and Pc
%
% Example: center([0 0.5 0], [1 0 0], [1 1 3], 'orthocenter')
%
% Made by: Ing. Gustavo Morales, University of Carabobo, Venezuela.
% 09/14/09
%
Pa = Pa(:); Pb = Pb(:); Pc = Pc(:); % Converting to column vectors (if needed)
AB = Pb - Pa; AC = Pc - Pa; BC = Pc - Pb; % Side vectors
switch Type
    case 'incenter'% 
        uab = AB./norm(AB); uac = AC./norm(AC); ubc = BC./norm(BC); uba = -uab; 
        L1 = uab + uac; L2 = uba + ubc; % directors
        P21 = Pb - Pa;      
        P1 = Pa;           
    case 'barycenter'
        L1 = (Pb + Pc)/2 -Pa; L2 = (Pa + Pc)/2 - Pb; % directors
        P21 = Pb - Pa;      
        P1 = Pa;            
    case 'circumcenter'
        N = cross(AC,AB);
        L1 = cross(AB,N); L2 = cross(BC,N); % directors
        P21 = (Pc - Pa)/2;  
        P1 = (Pa + Pb)/2;  
    case 'orthocenter'
        N = cross(AC,AB);
        L1 = cross(N,BC); L2 = cross(AC,N); % directors
        P21 = Pb - Pa;      
        P1 = Pa;           
    otherwise
        error('Unknown Center Type');
end
ML = [L1 -L2]; % Coefficient Matrix
lambda = ML\P21;  % Solving the linear system
pos = P1 + lambda(1)*L1; % Line Equation evaluated at lambda(1)
X = [Pa(1); Pb(1); Pc(1)]; Y = [Pa(2); Pb(2); Pc(2)]; 
if numel(Pa)== 3 % Tridimensional Case
    Z = [Pa(3); Pb(3); Pc(3)];
    patch(X,Y,Z,'b','FaceAlpha',0.5); hold on;
    plot3(pos(1),pos(2),pos(3),'o','Color','r'); view(3);
else             % Bidimensional case
    patch(X,Y,'b','FaceAlpha',0.5); hold on;
    plot(pos(1),pos(2),'o','Color','r');
end
 grid on; daspect([1 1 1]); 