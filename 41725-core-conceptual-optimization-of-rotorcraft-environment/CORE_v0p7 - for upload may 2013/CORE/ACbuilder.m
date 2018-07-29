function [AC] = ACbuilder(X, Spec)
%   Creates an aircraft from decision variables contained in X and the base
%   AC, which contains project-fixed parameters and function handles.

AC = Spec.baseAC;

%% Add decision variables
AC.Vars = cell2struct(num2cell(X),Spec.MyDesignXlabels);

%% Brute force loop method
%initial weight guess
AUMestimate = AC.Vars.Wpayload*1000; %can't be less than this!

changefactor = 0; %factor used for convergence
tol = 1e-7; %fraction equivalent to .1kg tolerance for a 10000kg helicopter
err = 1;
ii = 0;
while abs(err)>tol;
    ii = ii+1;
    AC.W.AUM = AUMestimate;
    AC = add_sized_parts(AC);
    [AUMestimatenew,AC] = AC.Ass.weightestimate(AC);
    err = AUMestimate - AUMestimatenew;
    AUMestimate = AUMestimatenew + err*changefactor;
    err = err/AUMestimatenew;
end

AC.W.fuel = AC.W.AUM*AC.Vars.FuelFrac;
AC.W.W = AC.W.AUM*g0;
end

function AC = add_sized_parts(AC)

AC.W.fuelfrac = AC.Vars.FuelFrac;
AC.W.W = AC.W.AUM*g0;

%% Build Rotor
AC.Rotor.R =    sqrt(AC.W.AUM/(pi*AC.Vars.DiscLoading));
AC.Rotor.TS =   AC.Vars.TipSpeed;
AC.Rotor.b =    round(AC.Vars.Blades);
AC.Rotor.c =    AC.Vars.Solidity*pi*AC.Rotor.R/AC.Rotor.b;
AC.Rotor.tw =   AC.Vars.Twist*pi/180;

AC.Rotor.D = AC.Rotor.R*2;
AC.Rotor.Omega = AC.Rotor.TS./AC.Rotor.R;
AC.Rotor.DA = pi*AC.Rotor.R.^2;
AC.Rotor.AR = AC.Rotor.R/AC.Rotor.c;
AC.Rotor.BA = AC.Rotor.b*AC.Rotor.c*AC.Rotor.R;
AC.Rotor.sigma = AC.Rotor.BA/AC.Rotor.DA;

%% Build Wing
AC.Wing.S =     AC.Vars.SpecificWingArea*AC.W.AUM/1000;
AC.Wing.AR =    AC.Vars.WingAR;

AC.Wing.b = sqrt(AC.Wing.S*AC.Wing.AR);

%% Build Power
AC.Power.P =    AC.Vars.P_to_W*AC.W.AUM*1000; %X in kW/kg
AC.Power.T =    AC.Vars.T_to_W*AC.W.W; %X in kN

%% Build Tail Rotor
AC = simpleTRsizing(AC);
% gives us R, sigma, c, Omega, TS, and b for tail rotor

end
