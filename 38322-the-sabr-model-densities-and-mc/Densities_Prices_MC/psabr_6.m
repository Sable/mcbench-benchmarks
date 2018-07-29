% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code.

function y = psabr_6(asabr,b,r,nsabr,f,fbar,t,eps)
% SABR risk neutral density calculated using the Doust approximation

a = asabr / eps;            % Doust sigma
n = nsabr / eps;            % Doust nu

zF = f^(1-b) / (asabr*(1-b));
zFbar = fbar.^(1-b) ./ (asabr*(1-b));
CF = f^b; CFbar = fbar.^b;
z = zF - zFbar;
Jz = sqrt(1-2*nsabr*r*z + nsabr^2*z.^2);
xz = 1 / nsabr * log((Jz -r + nsabr*z)/(1-r));
%q2 = (asabr*b*fbar.^b)./(-fbar + asabr*(b-1)*fbar.^b.*z);
q2 = b/f^(1-b);
kappa1 =0.125*n^2*(2-3*r^2) - 0.25*r*n*a*q2;
%q1 = (b*fbar.^(2*b)*asabr^2)./(fbar - (b-1)*asabr*fbar.^b.*z).^2;
q1 = b*(2*b-1)/f^(2*(1-b));
kappa2 = a^2*(0.25*q1-0.375*q2.^2);
gamma = 0.5 / (1-b);

if b == 1    
    hz = 0.5*r*a/(nsabr*eps) *(ln(Jz)+r/sqrt(1-r^2)*(atan((nsabr * z -r)/sqt(1-r^2))+atan(r/sqrt(1-r^2))));
else
    JzF = sqrt(1+2*nsabr*r*zFbar + nsabr^2*zFbar.^2);
    hz = 0.5 * b * r / eps^2 / (1-b) ./JzF.^2 ...
        .* (nsabr * zFbar .* log(zFbar.*Jz) + (1+r*nsabr*z)/sqrt(1-r^2).*(atan((nsabr * z -r)/sqrt(1-r^2))+atan(r/sqrt(1-r^2))));
end
%hz = zeros(1,length(fbar));
%for kk = 1:length(fbar)
%    G = @(x) (asabr * b * fbar(kk)^b * x)./((fbar(kk)-asabr*(b-1) * fbar(kk).^b * x) ...
%        .* (1 + nsabr * x .* (nsabr * x-2*r)));
%    hz(kk) = 0.5*r*a*n * quadgk(G,0,z(kk));
%end

if 1 > b & b > 0
    y = 1./(asabr*CFbar) ./ sqrt(Jz).^3 /t .* zFbar.^(1-gamma).*zF.^(gamma) ...
        .* exp(-0.5*(xz.^2 + 2*zF*zFbar)/t+eps^2*(hz+kappa1*t)) ...
        .* besseli(gamma,zF*zFbar/t);
else
    y = 1./(asabr*CFbar) ./ sqrt(Jz).^3 / (2*pi*t) * sqrt(CF./CFbar) ...
        .* exp(-0.5*xz.^2/t + eps^2*hz + eps^2*(kappa1+kappa2)*t);
end
    
end