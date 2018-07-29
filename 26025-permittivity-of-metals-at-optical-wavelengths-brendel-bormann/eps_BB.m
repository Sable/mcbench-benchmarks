% Relative Permittivity of various metals originally coded by Collin
% Meierbachtol (C)2009 based on the Brendel-Bormann model described by 
% A. D. Rakic, et. al., App. Opt., vol. 37, no. 22, 1998.

% *** Requires the cef (complex error function) file 'cef.m' in order to run.

function w = cef(z,N);

%Visualization Parameters (USER INPUT)
lmin = 1e-7; %Minimum wavelength in visualization
lmax = 1e-5; %Maximum wavelength in visualization
dl = 5e-8; %Visualization wavelength incrament
N = 1000; %Number of iterations when calculating complex error function

%Inherent Physical constants
c = 2.997e8; %Speed of light [m/s]
h = 6.626e-34; %Planck's constant [J s]
hbar = h/(2*pi); %Normalized Planck's constant [J s]
q = 1.602e-19; %Quantized electronic charge
i = complex(0,1);

%Plasma Frequency constatns matrix generation (Table 1)
wpmat = [9.01 9.03 10.83 14.98 18.51 10.75 15.92 9.72 9.59 7.29 13.22];

%f0 and GAMMA0 constant matrix generation
f0mat = [0.821 0.770 0.562 0.526 0.081 0.154 0.083 0.330 0.333 0.126 0.197];
GAMMA0mat = [0.049 0.050 0.030 0.047 0.035 0.048 0.022 9e-3 0.080 0.067 0.057];

mj = input('Please choose metal (Ag=1,Au=2,Cu=3,Al=4,Be=5,Cr=6,Ni=7,Pd=8,Pt=9,Ti=10,W=11) ? ')

% Generation of Brendel-Bormann matrix elements for fj, GAMMAj, wj, and sigmaj
if (mj == 1 || mj == 2)
    fmat = [0.05 0.133 0.051 0.467 4;0.054 0.05 0.312 0.719 1.648;zeros(9,5)];
    GAMMAmat = [0.189 0.067 0.019 0.117 0.052;0.074 0.035 0.083 0.125 0.179;zeros(9,5)];
    wmat = [2.025 5.185 4.343 9.809 18.56;0.218 2.885 4.069 6.137 27.97;zeros(9,5)];
    sigmamat = [1.894 0.665 0.189 1.17 0.516;0.742 0.349 0.83 1.246 1.795;zeros(9,5)];
else
    fmat = [zeros(1,4);zeros(1,4);0.076 0.081 0.324 0.726;0.213 0.06 0.182 0.014;...
          0.066 0.067 0.346 0.311;0.338 0.261 0.817 0.105;0.357 0.039 0.127 0.654;...
          0.769 0.093 0.309 0.409;0.186 0.665 0.551 2.214;0.427 0.218 0.513 2e-4;...
          6e-3 0.022 0.136 2.648];
    GAMMAmat = [zeros(1,4);zeros(1,4);0.056 0.047 0.113 0.172;0.312 0.315 1.587 0.172;...
              2.956 3.962 2.398 3.904;4.256 3.957 2.218 6.983;2.82 0.12 1.822 6.637;...
              2.343 0.497 2.022 0.119;0.498 1.851 2.604 2.891;1.877 0.1 0.615 4.109;...
              3.689 0.277 1.433 4.555];
    wmat = [zeros(1,4);zeros(1,4);0.416 2.849 4.819 8.136;0.163 1.561 1.827 4.495;...
          0.131 0.469 2.827 4.318;0.281 0.584 1.919 6.997;0.317 1.059 4.583 8.825;...
          0.066 0.502 2.432 5.987;0.782 1.317 3.189 8.236;1.459 2.661 0.805 19.86;...
          0.481 0.985 1.962 5.442];
    sigmamat = [zeros(1,4);zeros(1,4);0.562 0.469 1.131 1.719;0.013 0.042 0.256 1.735;...
              0.277 3.167 1.446 0.893;0.115 0.252 0.225 4.903;0.606 1.454 0.379 0.510;...
              0.694 0.027 1.167 1.331;0.031 0.096 0.766 1.146;0.463 0.506 0.799 2.854;...
              3.754 0.059 0.273 1.912];
end

%Conversion of constants and calculations
f0 = f0mat(mj);
GAMMA0 = (q/hbar)*GAMMA0mat(mj);
wp = (q/hbar)*wpmat(mj);
f = fmat(mj,:);
GAMMA = (q/hbar).*GAMMAmat(mj,:);
w = (q/hbar).*wmat(mj,:);
sigma = (q/hbar).*sigmamat(mj,:);
OMEGA_P = sqrt(f0)*wp;

for lambda = lmin:dl:lmax;
    omega = 2*pi*c./lambda;
    
    %First component of relative permittivity
    epsf = 1 - OMEGA_P^2./(omega.*(omega + i*GAMMA0));

    %Second (summation) component of relative permittivity
    a = (omega^2 + i*omega.*GAMMA).^(0.5);
    zplus = (a+w)./(sqrt(2).*sigma);
    zminus = (a-w)./(sqrt(2).*sigma);
    epsb = (i*sqrt(pi).*f.*wp^2./(2*sqrt(2).*a.*sigma)).*(cef(zplus,N)+cef(zminus,N));
    
    %Total permittivity calculation
    eps = epsf + sum(epsb);
    
    %Visualzation over optical wavelengths (compare to Figure 2 of cited article) 
    figure(2)
    loglog(lambda,abs(real(eps)),'o',lambda,abs(imag(eps)),'+')
    hold on
    axis([lmin lmax 1e-1 1e4])
    xlabel('Wavelength [m]')
    ylabel('|\epsilon_{1r}| & \epsilon_{2r}')
    title('Relative Permittivity \epsilon_{r} = \epsilon_{1r} + j\epsilon_{2r}')
end
hold off