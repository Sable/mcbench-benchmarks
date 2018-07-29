function [airfoildata] = PerformRegression(data)
% Relate the coefficients of the drag polar to Re as parabolic functions.
% Drag polar is Cd = a0 + a1*alpha + a2*alpha^2
% The contents of airfoildata are the coefficients resulting from the
% polynomial regression with respect to Reynolds number:
%'NACA 4 or 5 digit' | 3 coefficients for a0 |
% 3 coefficients for a1 | 3 coefficients for a2 | 
% 3 coefficients for alpha_stall 
% so that:
% a0 = b1 + b2*log10(Re) + b3*log10(Re)^2
% a1 = c1 + c2*log10(Re) + c3*log10(Re)^2
% a2 = d1 + d2*log10(Re) + d3*log10(Re)^2
% and:
% alphastall = k1 + k2*log10(Re) + k3*log10(Re)^2

for i = 1:length(data)
    if length(data(i).Re) >= 2
        airfoildata{1}{i} = data(i).airfoil;
        airfoildata{2}{i} = [ones(size(data(i).Re)) log10(data(i).Re) log10(data(i).Re).^2]\[data(i).a0];
        airfoildata{3}{i} = [ones(size(data(i).Re)) log10(data(i).Re) log10(data(i).Re).^2]\[data(i).a1];
        airfoildata{4}{i} = [ones(size(data(i).Re)) log10(data(i).Re) log10(data(i).Re).^2]\[data(i).a2];
        airfoildata{5}{i} = [ones(size(data(i).Re)) log10(data(i).Re) log10(data(i).Re).^2]\[data(i).alphastall];
    end
end
