%% SPR Xphase input file - Modify me
% Multilayer transfer matrix model for thin film reflectance
% Rp/Rs: Kretschmann-configuration SPR
%
% To use, go through each section and specify the values for your
% experiment. You should specify the angles, frequency ranges, the
% substrate material dielectric function, the thin film materials
% dielectric functions and thicknesses, and the external material
% dielectric function. Use Ctrl+R and Ctrl+T to comment / uncomment
% sections. Hit F5 to run.
%
% After computing, you will have the following data in your workspace:
%   R_mat           Rp/Rs values, a [angles by wavenumbers] matrix
%                      For plotting you might need to take the transpose
%                      which is R_mat=R_mat';
%   theta1Range     Real external angles, in degrees
%   phiRange        Angles inside the prism, in degrees
%   wRange          Wavenumbers in 1/cm
%   Epsilon         Dielectric functions of each material
%   d               Layer thicknesses - first layer is bulk substrate
%
% This program will automatically determine the number of layers in your
% system from the number of dielectric functions in Epsilon you specify.
% For this reason it is very important to keep track of the layer index m.
%
% It computes the transfer matrix as in Knittl, "Optics of Thin
% Films," (Wiley, 1976).
%
% You can obtain dielectric function data for both dielectrics and
% conductors from e.g. the Sopra database or Palik's "Optical Constants of
% Solids."
%
% Requires the following file in the same folder: exp_xphase.m
%
% For academic use only
% Copyright 2013 Joshua Travis Guske 

clear;

%% Set angle and frequency ranges

% %Real external angle in deg, start:incr:end
% theta1Start=       55                  ;
% theta1Incr=        3                  ;
% theta1End=         79                  ;
% theta1Range=theta1Start:theta1Incr:theta1End;
% clear theta1Start theta1Incr theta1End;

%Stage index micrometer position, GWC NIR instrument
indStart=   2.00;
indIncr=    0.25;
indEnd=     9.50;
stageInd=indStart:indIncr:indEnd;
theta1Range = 2.681483*stageInd + 26.28216;
clear indStart indIncr indEnd;

% %Stage index micrometer position, GWC Mid-IR instrument
% indStart=   21.0;
% indIncr=     1.0;
% indEnd=     50.0;
% stageInd=indStart:indIncr:indEnd;
% theta1Range = -0.4921*stageInd + 61.24;
% clear indStart indIncr indEnd;

% %Real INTERNAL angle in deg, start:incr:end
% %TO USE THIS, you must comment out the "compute angles inside prism"
% % section below!
% %Default values: BK7 60deg in GWC NIR instrument
% phi1Start=       41.30                  ;
% phi1Incr=         0.35                  ;
% phi1End=         51.30                  ;
% phiRange=phi1Start:phi1Incr:phi1End;
% clear phi1Start phi1Incr phi1End;

%wavenumber in 1/cm, start:incr:end
wStart=          4196.41               ; 
wIncr=             15.428               ;
wEnd=           11001.15               ; 
wRange=wStart:wIncr:wEnd;
clear wStart wIncr wEnd;
%wcmSize=length(wRange);

%Preallocate memory and set empty values to zero 
Epsilon=zeros(1,length(wRange));


%% Choose substrate and prism
% If you need to add more substrates:
% First, find some dielectric function or refractive index data for your
% material. Arrange it like so:
%   Column 1 = Wavenumber in 1/cm
%   Column 2 = Relativse permittivity (n^2)
% Next, create a new variable in the Matlab workspace, and copy and paste
% from your spreadsheet. Rename this variable "GlassEpsilon," then
% right-click it, and save in the working folder with whatever name you
% choose. Finally, create a new line with "load <filename>" like the
% examples below.

m=1; %Layer index

%BK7 Glass
load BK7Esco;

% %SF10 Glass
% load SF10Schott;

% %Calcium Fluoride
% load CaF2;

% %Sapphire
% load Sapphire;

% Interpolate substrate dielectric function
Glassmdl = fit(GlassEpsilon(:,1),GlassEpsilon(:,2),'cubicspline');
Epsilon(m,:)=Glassmdl(wRange);
clear Glassmdl GlassEpsilon;


% Note that the following assumes your prism is made of the same material
% as the substrate.

% Choose prism geometry
prismAngle=60;
% prismAngle=90;

% Compute angles inside prism
thetaIndex=1;
for theta1=theta1Range
    faceangle = 90-prismAngle/2-theta1;
    phiRange(:,thetaIndex)=90-prismAngle/2-asind(sind(faceangle)./sqrt(Epsilon(m,:)));
    thetaIndex=thetaIndex+1;
end
clear theta1 thetaIndex faceangle prismAngle;

%% Define Films
% Dielectric functions here are usually either Drude, Simple, or Bulk. You
% must specify the layer index (m) and the layer thicknesses (d(m)) for
% each layer.
% Examples will follow.
%==========================================================================
% Definition of the Drude model. 
%   const(1) = epsilon_infinity (as relative permittivity)
%   const(2) = omega_p (1/cm)
%   const(3) = Gamma (1/cm)
% You can obtain these values from dielectric function data, e.g. the Sopra
% database or Palik's "Optical Constants of Solids." For best results use a
% multiple linear regression to the real and imaginary parts
% simultaneously.
% You can also obtain these values from the materials properties. See
% example ITO below.
Drudemdl = @(const,X)(const(1)+const(2).^2./(-1i.*const(3).*X-X.^2));

% Simple model. const = dielectric constant (as relative permittivity)
Simplemdl = @(const,X)(const);

% Bulk models-- there are several ways to do this.
%   1) Obtain an equation for the dielectric function in an external
%   program (like ZnO below). Should be ONLY a function of frequency. May
%   be complex.
%   2) Save dielectric function into a .mat data file, then load it and
%   interpolate in Matlab (like substrates above, or water below).

%==========================================================================

% % Silver
% m=2;                %Layer index
% d(m)=       31.1  ; %thickness in nm
% c_Ag(1)=    2.65 ; %high freq dielect const epsilon_inf
% c_Ag(2)=    70619 ; %plasma freq omega_p in 1/cm
% c_Ag(3)=    399 ; %damping const Gamma in 1/cm
% Epsilon(m,:)=Drudemdl(c_Ag,wRange);
% clear c_Ag;

% % Bulk Dielectric ZnO (linear NIR model)
% m=3;                %Layer index
% d(m)=       21.6  ; %Thickness in nm
% ZnOmdl= @(X)(1.92653E-05.*X+3.615050979);
% Epsilon(m,:)=ZnOmdl(wRange);

% ITO
m=2;                    %Layer index
d(m)=160;               %thickness in nm
n_cm=1.2E21;            %carrier concentration in /cm^3
mobility=30;            %mobility in cm^2/Vs
effectivemass = 0.4;    %effective mass
epsinf=3;               %epsilon_infinity
%=======================================
n = n_cm*1000000;
mu = mobility/10000;
m_e = effectivemass*9.11E-31;
q = 1.602E-19;
e_o = 8.854E-12;
w_p = sqrt(n*q^2/(m_e*e_o));
w_p_cm=w_p/(2*pi()*2.9979e10);
gamma = q/(mu*m_e);
gamma_cm=gamma/(2*pi()*2.9979e10);
c_ITO(1)=    epsinf ;
c_ITO(2)=    w_p_cm ;
c_ITO(3)=    gamma_cm ;
Epsilon(m,:)=Drudemdl(c_ITO,wRange);
clear n_cm mobility effectivemass epsinf n mu m_e q e_o w_p w_p_cm ...
    gamma gamma_cm c_ITO;


% % Dielectric AZO
% m=2;                %Layer index
% d(m)=       20.0  ; %Thickness in nm
% % c_AZO(1)=   1.8   ; %Bulk value estimation
% c_AZO(1)=   1.751 ; %Thin film value in AZO/Ag/AZO
% Epsilon(m,:)=Simplemdl(c_AZO,wRange);

% % Conductive AZO
% m=2;                %Layer index
% d(m)=       23  ; %thickness in nm
% c_AZO(1)=    1.3435 ; %high freq dielect const epsilon_inf
% c_AZO(2)=    3457.7 ; %plasma freq omega_p in 1/cm
% c_AZO(3)=    3457.7 ; %damping const Gamma in 1/cm
% Epsilon(m,:)=Drudemdl(c_AZO,wRange);
% clear c_AZO;

% % Another layer of conductive AZO
% m=4;                %Layer index
% d(m)=       23  ; %thickness in nm
% c_AZO(1)=    1.3435 ; %high freq dielect const epsilon_inf
% c_AZO(2)=    3457.7 ; %plasma freq omega_p in 1/cm
% c_AZO(3)=    3457.7 ; %damping const Gamma in 1/cm
% Epsilon(m,:)=Drudemdl(c_AZO,wRange);
% clear c_AZO;

% % Insulating AZO
% m=4;                %Layer index
% d(m)=       20.0  ; %Thickness in nm
% % keep c_AZO the same
% Epsilon(m,:)=Simplemdl(c_AZO,wRange);
% clear c_AZO;

% % "Biomolecules"
% m=5; %Layer index
% %d(m)=         29.36            ; %Virus not bound
% d(m)=         60.16            ; %Virus bound
% Epsilon(m,:)=Simplemdl(1.39^2,wRange);

%% Choose ambient material

% % Water
% m=size(Epsilon,1)+1; %Layer index
% % Water has an imaginary component epsilon_2 that is stored in column 3 of
% % the data file. Combine columns 2 and 3 into our dielectric function
% % Epsilon.
% load Water;
% Watermdl_re = fit(WaterEpsilon(:,1),WaterEpsilon(:,2),'cubicspline');
% Watermdl_im = fit(WaterEpsilon(:,1),WaterEpsilon(:,3),'cubicspline');
% Water_re=Watermdl_re(wRange);
% Water_im=Watermdl_im(wRange);
% Epsilon(m,:)=Water_re+1i*Water_im;
% clear WaterEpsilon Watermdl_re Watermdl_im Water_re Water_im;

% Air
m=size(Epsilon,1)+1; %Layer index
Epsilon(m,:)=Simplemdl(1.000569,wRange);

%% Run
clear m;
R_mat=exp_xphase(Epsilon,phiRange,wRange,d);
