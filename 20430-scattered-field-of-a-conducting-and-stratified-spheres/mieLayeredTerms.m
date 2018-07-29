function [An Bn] = mieLayeredTerms(mu, epsilon, radius, isPEC, frequency, nmax)

% Compute the sphere coefficients An and Bn for a sphere having a number 
% of homogeneous dielectric layers, with or without a perfectly
% electrically conducting (PEC) core. Follows the treatment in
% Chapter 3 of 
%
% Ruck, et. al. "Radar Cross Section Handbook", Plenum Press, 1970.
%  
% The incident electric field is in the -z direction (theta = 0) and is
% theta-polarized. The time-harmonic convention exp(jwt) is assumed, and
% the Green's function is of the form exp(-jkr)/r.
% 
% Inputs:
%   mu: Relative complex permeability for each dielectric region
%   epsilon: Relative complex permittivity for each dielectric region
%       (the unbounded (free space) region should be the first entry)
%   radius: Radius of each spherical dielectric interface, from outermost
%           to innermost
%   isPEC: A flag for when the innermost sphere is conducting
%   frequency: Operating frequency (Hz)
%   nmax: Maximum mode for computing Bessel functions
% Outputs:
%   An: Array of Mie solution constants (used in mieScatteredField)
%   Bn: Array of Mie solution constants (used in mieScatteredField)
%
%   Author: Walton C. Gibson, email: kalla@tripoint.org

% speed of light
c = 299792458.0;

% radian frequency
w = 2.0*pi*frequency;

% wavenumber
k0 = w/c;

% total number of dielectric interfaces
numInterfaces = length(mu);

% free space impedance
eta0 = 376.7303134617707;

% impedance of each dielectric region
eta = eta0 * sqrt(mu./epsilon);

% scale factor
m = sqrt(mu.*epsilon);

% mode numbers
mode = 1:nmax; 

Z = zeros(numInterfaces, length(mode));
Y = zeros(numInterfaces, length(mode));

numIFC = numInterfaces - 1;

for L = numIFC:-1:1
    
    if L == numIFC
        if isPEC == 0
            x = k0 * m(L + 1) * radius(L);
            [J JP] = SphericalBessel_JJP(mode, x);
            % Ruck, et. al. (3.4-23)
            P = (J ./ JP);
            % Ruck, et. al. (3.4-26), at innermost interface
            Z(L,:) = eta(L + 1) * P;
            % Ruck, et. al. (3.4-26), at innermost interface
            Y(L,:) = P / eta(L + 1);
        end
    else
        x1 = k0 * m(L + 1) * radius(L);
        x2 = k0 * m(L + 1) * radius(L + 1);
        [J1 JP1] = SphericalBessel_JJP(mode, x1);
        [H1 HP1] = SphericalHankel_HHP(mode, 2, x1);
        [J2 JP2] = SphericalBessel_JJP(mode, x2);
        [H2 HP2] = SphericalHankel_HHP(mode, 2, x2);
        % Ruck, et. al. (3.4-24)
        U = JP2 .* HP1 ./ (JP1 .* HP2);
        % Ruck, et. al. (3.4-25)
        V = (J2 .* H1) ./ (J1 .* H2);
        % Ruck, et. al. (3.4-23)
        P1 = J1 ./ JP1;
        % Ruck, et. al. (3.4-23)
        P2 = J2 ./ JP2;
        % Ruck, et. al. (3.4-23)
        Q2 = H2 ./ HP2;
        if (L == numIFC - 1) && (isPEC == 1)
            % Ruck, et. al. (3.4-27) for PEC boundary condition
            Z(L,:) = eta(L + 1) * P1 .* (1.0 - V) ./ (1.0 - U .*  P2 ./ Q2);
            % Ruck, et. al. (3.4-28) for PEC boundary condition
            Y(L,:) = (P1 / eta(L + 1)) .* (1.0 - V .*  Q2 ./ P2) ./ (1.0 - U);
        else
            % Ruck, et. al. (3.4-27)
            Z(L,:) = eta(L + 1) * P1 .* (1.0 - V .*((1.0 - Z(L+1,:)./(eta(L+1)*P2))./(1.0 - Z(L+1,:)./(eta(L+1)*Q2)))) ./ ...
                (1.0 - U .* ((1.0 - eta(L+1)*P2./Z(L+1,:))./(1.0 - eta(L+1)*Q2./Z(L+1,:))));
            % Ruck, et. al. (3.4-28)
            Y(L,:) = (P1 / eta(L + 1)) .* (1.0 - V .*((1.0 - eta(L+1)* Y(L+1,:)./ P2)./(1.0 - eta(L+1)*Y(L+1,:)./Q2))) ./ ...
                (1.0 - U .* ((1.0 - P2./(eta(L+1)*Y(L+1,:)))./(1.0 - Q2./(eta(L + 1)*Y(L+1,:)))));
        end
    end
    
end

% Ruck, et. al. (3.4-29)
Zn = i*Z(1,:)/eta0;
% Ruck, et. al. (3.4-29)
Yn = i*eta0*Y(1,:);

x = k0*radius(1);
[J JP] = SphericalBessel_JJP(mode, x);
[H HP] = SphericalHankel_HHP(mode, 2, x);

% Ruck, et. al. (3.4-1)
An = -((i).^(mode)) .* (2*mode + 1) ./ (mode.*(mode + 1)) .* (J + i*Zn .* JP) ./ (H + i*Zn .* HP);

% Ruck, et. al. (3.4-2) - there is an error in Ruck which is fixed here
Bn = ((i).^(mode+1)) .* (2*mode + 1) ./ (mode.*(mode + 1)) .* (J + i*Yn .* JP) ./ (H + i*Yn .* HP);

    function [J JP] = SphericalBessel_JJP(mode, x)
        
        % compute spherical bessel functions and their derivatives
        
        s = sqrt(0.5*pi/x);
        
        [J] = besselj(mode + 1/2, x); J = J*s;
        [J2] = besselj(mode - 1/2, x); J2 = J2*s;
         
        JP = (x * J2 - mode .* J);
        J = x*J;
        
    end

    function [H HP] = SphericalHankel_HHP(mode, arg, x)
        
        % compute spherical hankel functions and their derivatives
        
        s = sqrt(0.5*pi/x);
        
        [H] = besselh(mode + 1/2, arg, x); H = H*s;
        [H2] = besselh(mode - 1/2, arg, x); H2 = H2*s;

        HP = (x * H2 - mode .* H);
        H = x*H;
    end


end
