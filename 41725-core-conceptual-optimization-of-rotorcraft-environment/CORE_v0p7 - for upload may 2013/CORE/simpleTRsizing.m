function AC = simpleTRsizing(AC)
% gives us R, sigma, Omega, c, TS, and b for tail rotor

%% check TSoffset value
TSoffset = 7.5; %m/s slower than main rotor
ARgoal = 6;

AC.TRotor.TS = AC.Rotor.TS - TSoffset;

discarea = AC.Rotor.DA;
discloading = AC.W.AUM./discarea;
ratio = 1./(7.15-.0553*discloading);
AC.TRotor.R = AC.Rotor.R.*ratio;

AC.TRotor.DA = pi*AC.TRotor.R.^2;

sigma_mr = AC.Rotor.sigma;
AC.TRotor.sigma = 1.5277 * sigma_mr +.0461; % Trendline from historical aircraft

AC.TRotor.b = round(pi*AC.TRotor.sigma*ARgoal);

AC.TRotor.c = AC.TRotor.sigma*AC.TRotor.DA./(AC.TRotor.b*AC.TRotor.R);

AC.TRotor.Omega = AC.TRotor.TS/AC.TRotor.R;

AC.TRotor.X = AC.Rotor.R+1.1*AC.TRotor.R;

AC.TRotor.BA = AC.TRotor.sigma*AC.TRotor.DA;
end