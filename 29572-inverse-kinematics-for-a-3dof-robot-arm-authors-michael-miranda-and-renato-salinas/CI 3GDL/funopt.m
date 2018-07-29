function puntos = funopt(P)

% El largo de los segmentos es dado
l1 = 30; 
l2 = 20;
l3 = 10;
Px3 = 40;
Py3 = 20;

% l1^2 = (Px1^2 + Py1^2);
% l2^2 = (Px2 - Px1)^2 + (Py2 - Py1)^2;
% l3^2 = (Px2 - Px3)^2 + (Py2 - Py3)^2;

% puntos = [(Px1^2 + Py1^2) -  l1^2;
%           (Px2 - Px1)^2 + (Py2 - Py1)^2 - l2^2; 
%           (Px2 - Px3)^2 + (Py2 - Py3)^2 - l3^2];

puntos = [(P(1)^2 + P(2)^2) -  l1^2;
          (P(3) - P(1))^2 + (P(4) - P(2))^2 - l2^2; 
          (P(3) - Px3)^2 + (P(4) - Py3)^2 - l3^2];