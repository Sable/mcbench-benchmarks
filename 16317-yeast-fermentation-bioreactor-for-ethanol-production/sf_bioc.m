function [sys, x0] = sf_bioc(timp,stari,u,flag);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fermentation bioreactor model 
%% +++++ CONTINUous ++++++ 
%%
%% If you use this model please cite the following paper
%% 
%% Z. K. Nagy, Model Based Control of a Fermentation Bioreactor using
%% Optimally Designed Artificial Neural Networks, 
%% Chemical Engineering Journal, 127, 95-109, 2007.
%%
%% Copyright 2000-2007, Zoltan K. Nagy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Constants

  % Specific Ionic constants     (l/g_ion)

    HNa  = -0.550;
    HCa  = -0.303;
    HMg  = -0.314;
    HH   = -0.774;
    HCl  =  0.844;
    HCO3 =  0.485;
    HHO  =  0.941;

  % Molecular masses     (g/mol)

    MNaCl  = 58.5;
    MCaCO3 = 90;
    MMgCl2 = 95;
    MNa    = 23;
    MCa    = 40;
    MMg    = 24;
    MCl    = 35.5;
    MCO3   = 60; 

  % Kinetic constants

%    miu_X  = 0.556;      % [1/h]
    miu_P  = 1.790;      % [1/h]
    Ks     = 1.030;      % [g/l]
    Ks1    = 1.680;      % [g/l]      
    Kp     = 0.139;      % [g/l]
    Kp1    = 0.070;      % [g/l]
    Rsx    = 0.607;
    Rsp    = 0.435;
    YO2    = 0.970;      % [mg/mg]
    KO2    = 8.86;       % [mg/l]
    miu_O2 = 0.5;        % [1/h]
    A1     = 9.5e8;
    A2     = 2.55e33;
    Ea1    = 55000;      % J/mol
    Ea2    = 220000;     % J/mol
    R      = 8.31;       % J/(mol.K)

  % thermodynamic constants

    Kla0   = 38;        % [1/h]
    KT     = 100*3600;  % [J/hm2K]
    Vm     = 50;        % [l]
    AT     = 1;         % [m2]
    ro     = 1080;      % [g/l]
    ccal   = 4.18;      % [J/gK]         
    roag   = 1000;      % [g/l]
    ccalag = 4.18;      % [J/gK]
    deltaH = 518;       % [kJ/mol O2 consumat]

 
% Initial data

   mNaCl  = 500;        % [g]
   mCaCO3 = 100;        % [g]
   mMgCl2 = 100;        % [g]
   pH     = 6;
   Tiag   = 15;         % [°C]


if abs(flag == 1)

   V   = stari(1);
  cX   = stari(2);
  cP   = stari(3);
  cS   = stari(4);
  cO2  = stari(5);
  T    = stari(6);
  Tag  = stari(7);

  Fi    = u(1);   % l/h
  Fe    = u(2);   % l/h
  T_in  = u(3);   % K
  cS_in = u(4);   % g/l

  Fag   = u(5);   % l/h

  % 
 
    c0st = 14.16 - 0.3943 * T + 0.007714 * T^2 - 0.0000646 * T^3; % [mg/l]

    cNa  = mNaCl/MNaCl*MNa/V;
    cCa  = mCaCO3/MCaCO3*MCa/V;
    cMg  = mMgCl2/MMgCl2*MMg/V;
    cCl  = (mNaCl/MNaCl + 2*mMgCl2/MMgCl2)*MCl/V;
    cCO3 = mCaCO3/MCaCO3*MCO3/V;
    cH   = 10^(-pH);
    cOH  = 10^(-(14-pH));

    INa  = 0.5*cNa*((+1)^2);
    ICa  = 0.5*cCa*((+2)^2);
    IMg  = 0.5*cMg*((+2)^2);
    ICl  = 0.5*cCl*((-1)^2);
    ICO3 = 0.5*cCO3*((-2)^2);
    IH   = 0.5*cH*((+1)^2);
    IOH  = 0.5*cOH*((-1)^2);

    sumaHiIi = HNa*INa+HCa*ICa+HMg*IMg+HCl*ICl+HCO3*ICO3+HH*IH+HHO*IOH;
    cst  = c0st * 10^(-sumaHiIi);
    alfa = 0.8;
    Kla  = Kla0*(1.024^(T-20));

    rO2 = miu_O2 * cO2 * cX/YO2/(KO2 + cO2)*1000;  % mg/lh

    miu_X = A1*exp(-Ea1/R/(T+273)) - A2*exp(-Ea2/R/(T+273));

  % 

    dV   = Fi - Fe;
    dcX  = miu_X * cX * cS / (Ks + cS) * exp(-Kp * cP) - (Fe/V)*cX;     % g/(l.h)
    dcP  = miu_P * cX * cS / (Ks1 + cS) * exp(-Kp1 * cP) - (Fe/V)*cP;   % g/(l.h)
    dcS  = - miu_X * cX * cS / (Ks + cS) * exp(-Kp * cP) / Rsx -...
           miu_P * cX * cS / (Ks1 + cS) * exp(-Kp1 * cP) / Rsp +...
           (Fi/V)*cS_in - (Fe/V)*cS;                                    % g/(l.h)
    dcO2 = Kla * (cst - cO2) - rO2 - (Fe/V)*cO2;                        % mg/(l.h)
    dT   = (1/32*V*rO2*deltaH - KT*AT*(T - Tag) + ...
            Fi*ro*ccal*(T_in+273) - Fe*ro*ccal*(T+273))/(ro*ccal*V);    % J/h
    dTag = (Fag*ccalag*roag*(Tiag - Tag) + KT*AT*(T - Tag))/...
           (Vm * roag * ccalag);                                        % J/h

   stari = [V; cX; cP; cS; cO2; T; Tag];

   sys = [dV; dcX; dcP; dcS; dcO2; dT; dTag];

elseif flag == 0

    sys = [7 0 7 5 0 0];

%x0 = [1000;1.44461378090907;23.78910869842528;60.00000039531390;2.50097659210080;...
%     38.31746268952971;34.28656963626713];

%x0 = [1000; 0.93621067526648; 12.73796084598212; 29.17497442764656; 3.23190399625319;...
%      30.01113517655470; 27.41615812783681];

x0 = [1000; 0.90467678228155; 12.51524128083789; 29.73892382828279;3.10695341758232;...
29.57321214183856;  27.05393890970931];

elseif flag == 3

   V   = stari(1);
  cX   = stari(2);
  cP   = stari(3);
  cS   = stari(4);
  cO2  = stari(5);
  T    = stari(6);
  Tag  = stari(7);
  if timp == 0
     u(5)=18;
  end

   
   sys = [V; cX; cP; cS; cO2; Tag; T];


else

   sys = [];

end

